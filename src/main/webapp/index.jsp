<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<title>ssm_test1</title>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <meta charset="UTF-8">
    <%--引入bootstarp页面--%>
    <link rel="stylesheet" type="text/css" href="/static/bootstrap-3.3.7-dist/css/bootstrap.css">
    <%--引入jquery--%>
    <script type="text/javascript" src="/static/js/jquery-3.3.1.min.js" ></script>
    <script type="text/javascript" src="/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
</head>
<body>
<jsp:forward page="WEB-INF/views/index.jsp"/>
<h2>Hello World!</h2>
<table class="table table-stripedr">
    <tr>
        <td>#</td>
        <td>姓名</td>
        <td>性别</td>
        <td>邮箱</td>
        <td>部门</td>
    </tr>
    <tr>
        <td>#</td>
        <td>姓名</td>
        <td>性别</td>
        <td>邮箱</td>
        <td>部门</td>
    </tr>
</table>
</body>
</html>
