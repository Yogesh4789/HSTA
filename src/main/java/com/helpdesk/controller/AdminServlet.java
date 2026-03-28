package com.helpdesk.controller;

import java.io.IOException;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.helpdesk.bean.TicketBean;
import com.helpdesk.bean.UserBean;
import com.helpdesk.dao.TicketDAO;
import com.helpdesk.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final TicketDAO ticketDAO = new TicketDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean loggedUser = getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
            return;
        }
        if (!"ADMIN".equals(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
            return;
        }

        String action = request.getParameter("action");
        if ("reports".equalsIgnoreCase(action)) {
            loadReports(request, response);
            return;
        }
        loadDashboard(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserBean loggedUser = getLoggedUser(request);
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
            return;
        }
        if (!"ADMIN".equals(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
            return;
        }

        String action = request.getParameter("action");
        if ("assign".equalsIgnoreCase(action)) {
            assignTicket(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
    }

    private void loadDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("tickets", ticketDAO.getAllTickets());
            request.setAttribute("agents", userDAO.getAllAgents());
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to load admin dashboard.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void assignTicket(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int ticketId = parseInt(request.getParameter("ticketId"));
        int agentId = parseInt(request.getParameter("agentId"));
        if (ticketId <= 0 || agentId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
            return;
        }

        try {
            UserBean selectedAgent = userDAO.getUserById(agentId);
            if (selectedAgent == null || !"AGENT".equals(selectedAgent.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
                return;
            }
            ticketDAO.assignTicket(ticketId, agentId);
            response.sendRedirect(request.getContextPath() + "/admin?action=dashboard");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to assign ticket.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void loadReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<TicketBean> tickets = ticketDAO.getAllTickets();
            List<UserBean> agents = userDAO.getAllAgents();

            int totalTickets = tickets.size();
            int resolvedTickets = 0;
            int slaBreachedTickets = 0;
            Date now = new Date();

            Map<String, Integer> perAgentStats = new LinkedHashMap<String, Integer>();
            for (UserBean agent : agents) {
                perAgentStats.put(agent.getName(), Integer.valueOf(0));
            }

            for (TicketBean ticket : tickets) {
                if ("RESOLVED".equals(ticket.getStatus()) || "CLOSED".equals(ticket.getStatus())) {
                    resolvedTickets++;
                }
                if (ticket.getSlaDeadline() != null
                        && ticket.getSlaDeadline().before(now)
                        && !"RESOLVED".equals(ticket.getStatus())
                        && !"CLOSED".equals(ticket.getStatus())) {
                    slaBreachedTickets++;
                }

                if (ticket.getAssignedTo() > 0) {
                    for (UserBean agent : agents) {
                        if (agent.getUserId() == ticket.getAssignedTo()) {
                            String key = agent.getName();
                            Integer current = perAgentStats.get(key);
                            if (current == null) {
                                current = Integer.valueOf(0);
                            }
                            perAgentStats.put(key, Integer.valueOf(current.intValue() + 1));
                            break;
                        }
                    }
                }
            }

            request.setAttribute("totalTickets", Integer.valueOf(totalTickets));
            request.setAttribute("resolvedTickets", Integer.valueOf(resolvedTickets));
            request.setAttribute("slaBreachedTickets", Integer.valueOf(slaBreachedTickets));
            request.setAttribute("perAgentStats", perAgentStats);
            request.setAttribute("tickets", tickets);
            request.setAttribute("agents", agents);
            request.setAttribute("activeSection", "reports");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to generate reports.");
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
}
