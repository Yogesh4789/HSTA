package com.helpdesk.controller;

import java.io.IOException;
import java.util.List;

import com.helpdesk.bean.CommentBean;
import com.helpdesk.bean.TicketBean;
import com.helpdesk.bean.UserBean;
import com.helpdesk.dao.CommentDAO;
import com.helpdesk.dao.TicketDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CommentDAO commentDAO = new CommentDAO();
    private final TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean loggedUser = getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
            return;
        }

        String action = request.getParameter("action");
        if (!"view".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/ticket?action=view");
            return;
        }

        int ticketId = parseInt(request.getParameter("ticketId"));
        if (ticketId <= 0) {
            response.sendRedirect(request.getContextPath() + "/ticket?action=view");
            return;
        }

        try {
            TicketBean ticket = ticketDAO.getTicketById(ticketId);
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/ticket?action=view");
                return;
            }

            List<CommentBean> comments = commentDAO.getCommentsByTicket(ticketId);
            request.setAttribute("ticket", ticket);
            request.setAttribute("comments", comments);
            request.getRequestDispatcher("ticketDetail.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to load comments.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean loggedUser = getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
            return;
        }

        String action = request.getParameter("action");
        if (!"add".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/ticket?action=view");
            return;
        }

        int ticketId = parseInt(request.getParameter("ticketId"));
        String commentText = request.getParameter("commentText");
        if (ticketId <= 0 || isBlank(commentText)) {
            response.sendRedirect(request.getContextPath() + "/ticket?action=detail&ticketId=" + ticketId);
            return;
        }

        try {
            TicketBean ticket = ticketDAO.getTicketById(ticketId);
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/ticket?action=view");
                return;
            }

            // Business rule: comments cannot be added to CLOSED tickets.
            if ("CLOSED".equals(ticket.getStatus())) {
                response.sendRedirect(request.getContextPath()
                        + "/ticket?action=detail&ticketId=" + ticketId + "&message=Cannot+comment+on+closed+ticket");
                return;
            }

            if ("USER".equals(loggedUser.getRole()) && ticket.getRaisedBy() != loggedUser.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
                return;
            }
            if ("AGENT".equals(loggedUser.getRole()) && ticket.getAssignedTo() != loggedUser.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
                return;
            }

            CommentBean comment = new CommentBean();
            comment.setTicketId(ticketId);
            comment.setCommentedBy(loggedUser.getUserId());
            comment.setCommentText(commentText.trim());
            commentDAO.addComment(comment);

            response.sendRedirect(request.getContextPath() + "/ticket?action=detail&ticketId=" + ticketId);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to add comment.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private UserBean getLoggedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("loggedUser");
        if (user instanceof UserBean) {
            return (UserBean) user;
        }
        return null;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
