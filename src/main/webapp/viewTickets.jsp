<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.helpdesk.bean.UserBean" %>
<%@ page import="com.helpdesk.bean.TicketBean" %>
<%
UserBean loggedUser = (UserBean) session.getAttribute("loggedUser");
if (loggedUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
    return;
}
List<TicketBean> tickets = (List<TicketBean>) request.getAttribute("tickets");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Tickets - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <h2 class="title">Ticket List</h2>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/dashboard.jsp">Back</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>SLA Deadline</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (tickets == null || tickets.isEmpty()) { %>
                        <tr>
                            <td colspan="7">No tickets found.</td>
                        </tr>
                    <% } else {
                        for (TicketBean t : tickets) { %>
                        <tr>
                            <td><%=t.getTicketId()%></td>
                            <td><%=t.getTitle()%></td>
                            <td><%=t.getCategory()%></td>
                            <td><%=t.getPriority()%></td>
                            <td>
                                <% if ("IN_PROGRESS".equals(t.getStatus()) || "ASSIGNED".equals(t.getStatus())) { %>
                                    <span class="badge badge-progress"><%=t.getStatus()%></span>
                                <% } else if ("RESOLVED".equals(t.getStatus()) || "CLOSED".equals(t.getStatus())) { %>
                                    <span class="badge badge-resolved"><%=t.getStatus()%></span>
                                <% } else { %>
                                    <span class="badge badge-open"><%=t.getStatus()%></span>
                                <% } %>
                            </td>
                            <td><%=t.getSlaDeadline()%></td>
                            <td>
                                <a class="btn btn-primary" href="<%=request.getContextPath()%>/ticket?action=detail&ticketId=<%=t.getTicketId()%>">Details</a>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
