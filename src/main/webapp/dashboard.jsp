<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.helpdesk.bean.UserBean" %>
<%
UserBean loggedUser = (UserBean) session.getAttribute("loggedUser");
String message = request.getParameter("message");
if (loggedUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <div>
                    <h1 class="title">Welcome, <%=loggedUser.getName()%></h1>
                    <p class="subtitle">Role: <strong><%=loggedUser.getRole()%></strong></p>
                </div>
                <div>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/login?action=logout">Logout</a>
                </div>
            </div>
            <% if (message != null && !message.trim().isEmpty()) { %>
                <div class="alert alert-info"><%=message%></div>
            <% } %>

            <div class="grid-2">
                <% if ("USER".equals(loggedUser.getRole()) || "ADMIN".equals(loggedUser.getRole())) { %>
                    <div class="card">
                        <h3>Raise Ticket</h3>
                        <p class="small">Create a new support issue with category and description.</p>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/raiseTicket.jsp">New Ticket</a>
                    </div>
                <% } %>

                <div class="card">
                    <h3>My Tickets</h3>
                    <p class="small">View status updates and SLA progress of relevant tickets.</p>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/ticket?action=view">View Tickets</a>
                </div>

                <div class="card">
                    <h3>Knowledge Base</h3>
                    <p class="small">Search self-help solutions and frequently resolved issues.</p>
                    <a class="btn btn-primary" href="<%=request.getContextPath()%>/kb?action=list">Open KB</a>
                </div>

                <% if ("ADMIN".equals(loggedUser.getRole())) { %>
                    <div class="card">
                        <h3>Admin Console</h3>
                        <p class="small">Manage assignments, SLA policies and reports.</p>
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/admin?action=dashboard">Open Admin</a>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    <script>
        (function () {
            document.addEventListener("DOMContentLoaded", function () {
                var navbar = document.querySelector(".navbar, .home-header");
                if (navbar) {
                    var updateNavbarState = function () {
                        navbar.classList.toggle("scrolled", window.scrollY > 50);
                    };
                    updateNavbarState();
                    window.addEventListener("scroll", updateNavbarState);
                }

                var heroHeading = document.querySelector(".home-hero h1, .card .title, h1");
                if (heroHeading) {
                    heroHeading.classList.add("hero-text");
                }

                var revealTargets = document.querySelectorAll(".card, table, form");
                revealTargets.forEach(function (el) {
                    el.classList.add("hidden");
                });

                if ("IntersectionObserver" in window) {
                    var observer = new IntersectionObserver(function (entries) {
                        entries.forEach(function (entry) {
                            if (entry.isIntersecting) {
                                entry.target.classList.add("show");
                                observer.unobserve(entry.target);
                            }
                        });
                    }, { threshold: 0.12 });

                    revealTargets.forEach(function (el) {
                        observer.observe(el);
                    });
                } else {
                    revealTargets.forEach(function (el) {
                        el.classList.add("show");
                    });
                }
            });
        })();
    </script>
</body>
</html>
