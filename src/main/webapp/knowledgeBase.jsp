<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.helpdesk.bean.UserBean" %>
<%@ page import="com.helpdesk.bean.KnowledgeBaseBean" %>
<%
UserBean loggedUser = (UserBean) session.getAttribute("loggedUser");
if (loggedUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+login+first");
    return;
}
List<KnowledgeBaseBean> articles = (List<KnowledgeBaseBean>) request.getAttribute("articles");
String message = (String) request.getAttribute("message");
String errorMessage = (String) request.getAttribute("errorMessage");
String action = request.getParameter("action");
boolean shouldAutoScroll = "search".equalsIgnoreCase(action);
String keyword = request.getParameter("keyword");
if (keyword == null) {
    keyword = "";
}
String keywordEscaped = keyword.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Knowledge Base - HSTA</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="topbar">
                <h2 class="title">Knowledge Base</h2>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/dashboard.jsp">Back</a>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%=errorMessage%></div>
            <% } %>
            <% if (message != null) { %>
                <div class="alert alert-info"><%=message%></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/kb" method="get">
                <input type="hidden" name="action" value="search">
                <label>Search</label>
                <input type="text" name="keyword" value="<%=keywordEscaped%>" placeholder="Search by title, content, or category">
                <button class="btn btn-primary" type="submit">Search</button>
                <a class="btn btn-secondary" href="<%=request.getContextPath()%>/kb?action=list">Reset</a>
            </form>
        </div>

        <% if ("AGENT".equals(loggedUser.getRole()) || "ADMIN".equals(loggedUser.getRole())) { %>
        <div class="card">
            <h3>Add Article</h3>
            <form action="<%=request.getContextPath()%>/kb" method="post">
                <input type="hidden" name="action" value="add">
                <label>Title</label>
                <input type="text" name="title" required>
                <label>Category</label>
                <input type="text" name="category" required>
                <label>Content</label>
                <textarea name="content" required></textarea>
                <button class="btn btn-primary" type="submit">Add Article</button>
            </form>
        </div>
        <% } %>

        <div class="card" id="articlesSection">
            <h3>Articles</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Created By</th>
                        <th>Content</th>
                        <% if ("AGENT".equals(loggedUser.getRole()) || "ADMIN".equals(loggedUser.getRole())) { %>
                        <th>Action</th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <% if (articles == null || articles.isEmpty()) { %>
                        <tr><td colspan="6">No articles available.</td></tr>
                    <% } else {
                        for (KnowledgeBaseBean kb : articles) { %>
                        <tr>
                            <td><%=kb.getArticleId()%></td>
                            <td><%=kb.getTitle()%></td>
                            <td><%=kb.getCategory()%></td>
                            <td><%=kb.getCreatedBy()%></td>
                            <td><%=kb.getContent()%></td>
                            <% if ("AGENT".equals(loggedUser.getRole()) || "ADMIN".equals(loggedUser.getRole())) { %>
                            <td>
                                <form action="<%=request.getContextPath()%>/kb" method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="articleId" value="<%=kb.getArticleId()%>">
                                    <button class="btn btn-danger" type="submit">Delete</button>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
    <% if (shouldAutoScroll) { %>
    <script>
        window.addEventListener("load", function () {
            var section = document.getElementById("articlesSection");
            if (section) {
                section.scrollIntoView({ behavior: "smooth", block: "start" });
            }
        });
    </script>
    <% } %>
</body>
</html>
