<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.helpdesk.bean.UserBean" %>
<%@ page import="com.helpdesk.bean.TicketBean" %>
<%@ page import="com.helpdesk.bean.SLAPolicyBean" %>
<%
UserBean loggedUser = (UserBean) session.getAttribute("loggedUser");
if (loggedUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
    return;
}
if (!"ADMIN".equals(loggedUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
    return;
}
List<TicketBean> tickets = (List<TicketBean>) request.getAttribute("tickets");
List<UserBean> agents = (List<UserBean>) request.getAttribute("agents");
List<SLAPolicyBean> slaPolicies = (List<SLAPolicyBean>) request.getAttribute("slaPolicies");
Integer totalTickets = (Integer) request.getAttribute("totalTickets");
Integer resolvedTickets = (Integer) request.getAttribute("resolvedTickets");
Integer slaBreachedTickets = (Integer) request.getAttribute("slaBreachedTickets");
Map<String, Integer> perAgentStats = (Map<String, Integer>) request.getAttribute("perAgentStats");
String activeSection = (String) request.getAttribute("activeSection");
if (activeSection == null || activeSection.trim().isEmpty()) {
    activeSection = request.getParameter("section");
}
boolean showSlaSection = slaPolicies != null;
boolean showReportsSection = totalTickets != null || resolvedTickets != null || slaBreachedTickets != null || perAgentStats != null;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <h2 class="title">Admin Dashboard</h2>
                <div>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/dashboard.jsp">Back</a>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login?action=logout">Logout</a>
                </div>
            </div>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin?action=dashboard">Refresh Dashboard</a>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/sla?section=sla">Load SLA Policies</a>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin?action=reports&section=reports">Generate Reports</a>
        </div>

        <div class="card" id="ticketAssignmentSection">
            <h3>Ticket Assignment</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Current Agent</th>
                        <th>Assign/Reassign</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (tickets == null || tickets.isEmpty()) { %>
                        <tr><td colspan="5">No tickets found.</td></tr>
                    <% } else {
                        for (TicketBean t : tickets) { %>
                        <tr>
                            <td><%=t.getTicketId()%></td>
                            <td><%=t.getTitle()%></td>
                            <td><%=t.getStatus()%></td>
                            <td><%=t.getAssignedTo()%></td>
                            <td>
                                <form action="<%=request.getContextPath()%>/admin" method="post">
                                    <input type="hidden" name="action" value="assign">
                                    <input type="hidden" name="ticketId" value="<%=t.getTicketId()%>">
                                    <select name="agentId" required>
                                        <option value="">Select agent</option>
                                        <% if (agents != null) {
                                            for (UserBean a : agents) { %>
                                            <option value="<%=a.getUserId()%>"><%=a.getName()%> (#<%=a.getUserId()%>)</option>
                                        <% } } %>
                                    </select>
                                    <button class="btn btn-primary" type="submit">Assign</button>
                                </form>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <% if (showSlaSection) { %>
            <div class="card" id="slaSection">
                <h3>SLA Policies</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Priority</th>
                            <th>Response Hours</th>
                            <th>Resolution Hours</th>
                            <th>Update</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (slaPolicies == null || slaPolicies.isEmpty()) { %>
                            <tr><td colspan="4">No SLA policies found.</td></tr>
                        <% } else {
                            for (SLAPolicyBean p : slaPolicies) { %>
                            <tr>
                                <td><%=p.getPriority()%></td>
                                <td><%=p.getResponseTimeHours()%></td>
                                <td><%=p.getResolutionTimeHours()%></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/sla" method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="priority" value="<%=p.getPriority()%>">
                                        <input type="number" name="responseTimeHours" value="<%=p.getResponseTimeHours()%>" min="1" required>
                                        <input type="number" name="resolutionTimeHours" value="<%=p.getResolutionTimeHours()%>" min="1" required>
                                        <button class="btn btn-primary" type="submit">Save</button>
                                    </form>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        <% } %>

        <% if (showReportsSection) { %>
            <div class="card" id="reportsSection">
                <h3>Reports</h3>
                <p><strong>Total Tickets:</strong> <%= totalTickets == null ? 0 : totalTickets.intValue() %></p>
                <p><strong>Resolved Tickets:</strong> <%= resolvedTickets == null ? 0 : resolvedTickets.intValue() %></p>
                <p><strong>SLA Breaches:</strong> <%= slaBreachedTickets == null ? 0 : slaBreachedTickets.intValue() %></p>
                <h4>Per-Agent Ticket Count</h4>
                <table>
                    <thead><tr><th>Agent</th><th>Assigned Tickets</th></tr></thead>
                    <tbody>
                        <% if (perAgentStats == null || perAgentStats.isEmpty()) { %>
                            <tr><td colspan="2">No report data available.</td></tr>
                        <% } else {
                            for (Map.Entry<String, Integer> e : perAgentStats.entrySet()) { %>
                            <tr>
                                <td><%=e.getKey()%></td>
                                <td><%=e.getValue()%></td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    <% if ("sla".equalsIgnoreCase(activeSection) || "reports".equalsIgnoreCase(activeSection)) { %>
    <script>
        window.addEventListener("load", function () {
            var targetId = "<%= "reports".equalsIgnoreCase(activeSection) ? "reportsSection" : "slaSection" %>";
            var section = document.getElementById(targetId);
            if (section) {
                section.scrollIntoView({ behavior: "smooth", block: "start" });
            }
        });
    </script>
    <% } %>
</body>
</html>
