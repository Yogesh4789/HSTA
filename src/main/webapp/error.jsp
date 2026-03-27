<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String errorMessage = (String) request.getAttribute("errorMessage");
if (errorMessage == null || errorMessage.trim().isEmpty()) {
    errorMessage = "Something went wrong. Please try again.";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container" style="max-width: 700px; padding-top: 60px;">
        <div class="card">
            <h2 class="title">Oops, we hit an issue</h2>
            <div class="alert alert-error"><%=errorMessage%></div>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/dashboard.jsp">Back to Dashboard</a>
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login.jsp">Login Page</a>
        </div>
    </div>
</body>
</html>
