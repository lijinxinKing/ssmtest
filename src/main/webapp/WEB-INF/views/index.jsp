<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
<h2>Hello World!</h2>
<form>
    <table class="table table-striped">
        <tr>
            <td>#</td>
            <td>姓名</td>
            <td>性别</td>
            <td>邮箱</td>
            <td>部门</td>
            <td>操作</td>
        </tr>
        <tr>
            <c:forEach items="${empList}" var="employee">
        <tr>
            <td>${employee.empId}</td>
            <td>${employee.empName}</td>
            <td>${employee.gender=="M"?"男":"女"}</td>
            <td>${employee.email}</td>
            <td>${employee.department.deptName}</td>
            <td>
                <button class="btn-danger" href="${APP_PATH}/delete/${employee.empId}">
                <span class="glyphicon glyphicon-remove" aria-hidden="true">删除</span></button>
                <button  href="#">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true">编辑</span></button>
            </td>
        </tr>
        </c:forEach>
        </tr>
        <tr>
            <td>当前页${pageInfo.getPageNum()}
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="/emps?pn=${pageInfo.getPageNum()==1?1:pageInfo.getPageNum()-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <c:forEach items="${pageInfo.getNavigatepageNums()}" var="items">
                            <li> <a href="/emps?pn=${items}">${items}</a></li>
                        </c:forEach>
                        <li>
                            <a href="/emps?pn=${pageInfo.getPageNum()==pageInfo.getPages()?pageInfo.getPages():pageInfo.getPageNum()+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </td>
        </tr>
    </table>

</form>

</body>
</html>
