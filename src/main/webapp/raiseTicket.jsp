<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.helpdesk.bean.UserBean" %>
<%
UserBean loggedUser = (UserBean) session.getAttribute("loggedUser");
if (loggedUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
    return;
}
if (!"USER".equals(loggedUser.getRole()) && !"ADMIN".equals(loggedUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Unauthorized+access");
    return;
}
String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Raise Ticket - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <h2 class="title">Raise New Ticket</h2>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/dashboard.jsp">Back</a>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%=errorMessage%></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/ticket" method="post">
                <input type="hidden" name="action" value="create">

                <label>Title</label>
                <input type="text" name="title" maxlength="200" required>

                <label>Description</label>
                <textarea name="description" required></textarea>

                <label>Category</label>
                <select name="category" required>
                    <option value="">Select category</option>
                    <option value="Authentication">Authentication</option>
                    <option value="Network">Network</option>
                    <option value="Software">Software</option>
                    <option value="Hardware">Hardware</option>
                    <option value="Database">Database</option>
                    <option value="Other">Other</option>
                </select>

                <button class="btn btn-primary" type="submit">Submit Ticket</button>
            </form>
        </div>
    </div>
</body>
</html>
