<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HSTA Home</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <div>
                    <h1 class="title">Helpdesk Support Ticket Automation (HSTA)</h1>
                    <p class="subtitle">NITTE MEENAKSHI INSTITUTE OF TECHNOLOGY - Dept. of Artificial Intelligence and Machine Learning</p>
                </div>
                <div>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/login.jsp">Login</a>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login.jsp#registerSection">Create Account</a>
                </div>
            </div>

            <p>
                A centralized platform to raise, route, resolve, and monitor support tickets with SLA tracking,
                role-based workflows, and knowledge-base driven self-service.
            </p>
        </div>

        <div class="grid-2">
            <div class="card">
                <h3>User / Requester</h3>
                <p class="small">Raise issues, track live status, reopen resolved tickets, and find quick self-help articles.</p>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login.jsp">Raise & Track Tickets</a>
            </div>

            <div class="card">
                <h3>Support Agent</h3>
                <p class="small">Manage assigned tickets, update progress, add comments, and contribute to knowledge base.</p>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login.jsp">Handle Assigned Tickets</a>
            </div>

            <div class="card">
                <h3>Admin</h3>
                <p class="small">Control SLA policies, assign/reassign tickets, and monitor compliance reports.</p>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login.jsp">Open Admin Workflow</a>
            </div>

            <div class="card">
                <h3>Key Features</h3>
                <p class="small">Priority routing, SLA deadline management, role-based access, comments, and analytics.</p>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/kb?action=list">Explore Knowledge Base</a>
            </div>
        </div>

        <div class="card">
            <h3>Project Flow</h3>
            <p class="small">
                JSP (View) → Servlet (Controller) → Service (Business Rules) → DAO (Data Access) → MySQL Database
            </p>
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/login.jsp">Get Started</a>
        </div>
    </div>
</body>
</html>
