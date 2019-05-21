<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<title>李金鑫SSMTest</title>
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
    <script type="text/javascript">
        $("#showDepts").click(function () {
            var request = null;
            if (window.XMLHttpRequest){
                request = new XMLHttpRequest();
            }
            request.open("get","depts");
            request.send();
        });
    </script>
</head>
<body>

<div class="container">
    <!--标题-->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!--按钮-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary" href="#">新增</button>
            <button type="button"  class="btn btn-danger" href="#">删除</button>
        </div>
    </div>
    <!--内容-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <td>#</td>
                    <td>姓名</td>
                    <td>性别</td>
                    <td>邮箱</td>
                    <td>部门</td>
                    <td>操作</td>
                </tr>
                <c:forEach items="${empList}" var="employee">
                <tr>
                    <td>${employee.empId}</td>
                    <td>${employee.empName}</td>
                    <td>${employee.gender=="M"?"男":"女"}</td>
                    <td>${employee.email}</td>
                    <td>${employee.department.deptName}</td>
                    <td>
                        <button type="button" class="btn btn-danger btn-sm" href="#">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true">删除</span></button>
                        <button type="button" class="btn btn-primary btn-sm" href="#">
                            <span class="glyphicon glyphicon-pencil" aria-hidden="true">编辑</span></button>
                    </td>
                </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <!--分页-->
    <div class="row">
        <div class="col-md-6">
            当前页${pageInfo.getPageNum()},共${pageInfo.getPages()}页,总记录数${pageInfo.getTotal()}
        </div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="/emps?pn=1"><span>首页</span></a></li>
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
                    <li><a href="/emps?pn=${pageInfo.getPages()}"><span>末页</span></a></li>
                </ul>
            </nav>
        </div>

    </div>
</div>
</body>
</html>
