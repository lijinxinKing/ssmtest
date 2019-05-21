<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<title>欢迎使用企业级电商后台管理系统</title>
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
    <script type="text/javascript" src="/static/js/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script type="text/javascript" src="/static/js/vue.js"/>
    <script type="text/javascript">
        var app = new Vue({
           el:"#app",
           data:{
               message:"Hello Vue"
           }
        });
    </script>
</head>
<body>
<jsp:forward page="WEB-INF/views/vuetest.html"/>
</body>
</html>
