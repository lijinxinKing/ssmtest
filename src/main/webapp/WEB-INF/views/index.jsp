<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<title>Lenovo Enterprise Automation Test System</title>
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
        $(function () {
            toPage(1);
        });
        var totalPages = 0,currentPage = 0;
        function build_emps_table(result) {
            // 先清空
            $("#emps_table tbody").empty();

            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkBox = $("<td><input type='checkbox' class='check_item'/></td>");

                var empIdTd = $("<td></td>").append(item.empId);
                var gender = item.empName=="M"?"男":"女";
                var empNameTd = $("<td></td>").append(item.empName);
                var empgenderTd = $("<td></td>").append(gender);
                var email = $("<td></td>").append(item.email);
                var departmentName = $("<td></td>").append(item.department.deptName);
                var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm").addClass("edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                    .append("编辑");
                editBtn.attr("empid",item.empId);

                var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm").addClass("del_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                deleteBtn.attr("empid",item.empId); // 添加自定义属性

                var btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);
                $("<tr></tr>").append(checkBox).append(empIdTd)
                    .append(empNameTd).append(empgenderTd).append(email).append(departmentName)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
            });
        }



        function build_page_info(result) {
            totalPages = result.extend.pageInfo.pages;
            $("#page_info_area").empty();
            currentPage = result.extend.pageInfo.pageNum;
            $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，共"+
                result.extend.pageInfo.pages+"页，总"+result.extend.pageInfo.total+"条记录")
        }

        function build_page_nav(result) {
            $("#page_info_nav").empty();
            var ul = $("<ul></ul>").addClass("pagination");

            var firstLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            firstLi.click(function () {
                toPage(1);
            })

            var preLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
            preLi.click(function () {
                if(result.extend.pageInfo.hasPreviousPage){
                    toPage(result.extend.pageInfo.pageNum-1);
                }
            })

            if(!result.extend.pageInfo.hasPreviousPage){
                firstLi.addClass("disable");
                preLi.addClass("disable");
            }

            var nextLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
            nextLi.click(function () {
                if(result.extend.pageInfo.hasNextPage){
                    toPage(result.extend.pageInfo.pageNum+1);
                }
            });
            var lastLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
            if(!result.extend.pageInfo.hasNextPage){
                nextLi.addClass("disable");
                lastLi.addClass("disable");
            }
            lastLi.click(function () {
                toPage(result.extend.pageInfo.pages)
            })
            ul.append(firstLi).append(preLi);
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var numLi=$("<li></li>").append($("<a></a>").append(item).attr("href","#"));
                numLi.click(function () {
                    toPage(item);
                });
                if(result.extend.pageInfo.pageNum == index){
                    ul.append(numLi).addClass("active");
                }else {
                    ul.append(numLi);
                }
            });
            ul.append(nextLi).append(lastLi);
            var navEle = $("<nav></nav>").addClass("aria-label=\"Page navigation\"").append(ul);
            navEle.appendTo("#page_info_nav");
        }

        function toPage(pageNum) {
            $.ajax({
                url:"/emps",
                data:"pn="+pageNum,
                type:"GET",
                success:function (result) {
                   //显示员工数据
                   build_emps_table(result);
                   // 显示分页信息
                   build_page_info(result);
                   //显示分页条数据
                   build_page_nav(result);
                }
            })
        }
        function getDepts(ele) {
            $.ajax({
                url:"/depts",
                type:"GET",
                success:function (result) {
                    $.each(result.extend.depts,function () {
                        var option = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        $(ele).append(option);
                    });
                }
            });
        }
        function launchModal(){
            $("#dept_add_select").empty();
            getDepts("#dept_add_select");
            $("#empadd_modal").modal({
                backdrop:"static",
                keyboard:true
            });
        }
        function saveEmployee() {
            //序列化 表单中字符串
            $("#empName_input").empty();

            $.ajax({
                url:"/emp",
                type:"POST",
                data:$("#empadd_modal form").serialize(),
                success:function (result) {
                    if(result.code==200){
                        $("#empadd_modal").modal('hide');
                        toPage(totalPages);
                    }
                }
            })
        }

        function check_email() {
            $("#emilHelper").empty();
            var regBox = {
                regEmail : /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/,//邮箱
                /*  regMobile : /^0?1[3|4|5|8][0-9]\d{8}$/,//手机 */
                /*  regTel : /^0[\d]{2,3}-[\d]{7,8}$/  */
            }
            var mail=$("#email").val();
            flag2=regBox.regEmail.test(mail);
            if(!flag2){
                //     	<span id="helpBlock2" class="help-block"></span>
                $("#emilHelper").text("邮箱格式不正确");
            }
        }
        function check_user() {
            $("#nameHelper").empty();
            var userName = $("#empName_input");
            var hashName = false;
            $.ajax({
                url:"/emp",
                data:"empName="+userName,
                type:"GET",
                success:function (result) {
                    if(result.code==100){
                        hashName = true;
                    }
                }
            });
            if(hashName == true){
                $("#nameHelper").text("此用户已经存在");
            }
        }
        // 检验用户名是否可用
        function empname_change(){
            $.ajax({
                url:"/checkuser",
                data:"empName="+this.value,
                type:"POST",
                success:function (result) {
                    if(resulr.code==100){
                        $("#nameHelper").text("");
                        $("#nameHelper").text("用户名可用");
                    }else{
                        $("#nameHelper").text("");
                        $("#nameHelper").text("用户名不可用");
                    }
                }
            });
        }
        $(document).on("click",".edit_btn",function () {
            // 准备数据显示到界面
            getDepts("#dept_update_select");
            // 员工信息
            getEmp($(this).attr("empid"));
            //传递id 到更新按钮
            $("#update_emp").attr("edit_id",$(this).attr("empid"));
            $("#update_emp_modal").modal({
                backdrop:"static",
                keyboard:true
            });

        });
        function getEmp(id) {
            $.ajax({
                url:"/emp/"+id,
                type:"GET",
                success:function (result) {
                    var empData = result.extend.emp;
                    console.log(result);
                    $("#emp_update_name").text(empData.empName);
                    $("#update_email").val(empData.email);
                    $("#update_emp_modal input[name=update_gender]").val([empData.gender]);
                    $("#update_emp_modal select").val([empData.dId]);

                }
            });
        }
        $(document).on("click","#update_emp",function () {
            $.ajax({
                url:"/empput/"+$(this).attr("edit_id"),
                type:"POST",
                data:$("#update_emp_modal form").serialize()+"&_method=post",
                success:function (result) {
                    $("#update_emp_modal").modal("hide");
                    toPage(currentPage);
                }
            })
        });
        // 删除功能 批量删除，和单个删除
        $(document).on("click",".del_btn",function () {
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            if(confirm("确认删除"+empName+"?")){
                //
                $.ajax({
                    url:"/emp/"+$(this).attr("empid"),
                    type:"DELETE",
                    success:function (result) {
                        console.log(result)
                        toPage(currentPage);
                    }
                });
            }
        });
        // 全选 attr 获取checked undefined; 原生属性，prop 获取到属性的值，attr自定义属性的值
        $(document).on("click","#check_all",function () {
            $(".check_item").prop("checked",$(this).prop("checked"));
        })
        $(document).on("click",".check_item",function () {
            // 当前选中的元素是不是五个
            var flag = $(".check_item:checked").length==$(".check_item").length;
            if(flag){
                $("#check_all").prop("checked",flag);
            }

        })
        //全不选 delete_all
        $(document).on("click","#delete_all",function () {
            // 所有被选中的
            var empNames;
            var str_list;
            $.each($(".check_item:checked"),function () {
                empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
                str_list+=$(this).parents("tr").find("td:eq(1)").text()+"-";
            });
            if(empNames!=null){
                empNames.substring(0,empNames.length-1);
                str_list.substring(0,str_list.length-1);
                if (confirm("确认删除"+empNames+"吗？")){
                    $.ajax({
                        url:"/emp/"+str_list,
                        type:"DELETE",
                        success:function (result) {
                        }
                    });
                }
            }
        });
    </script>
</head>
<body>

<div class="container">
    <!--标题-->
    <div class="row">
        <div class="col-md-12">
            <h1>Lenovo Enterprise Automation Test System</h1>
        </div>
    </div>
    <!--按钮-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button id="emp_modal_add_btn" type="button" class="btn btn-primary" onclick="launchModal()">新增</button>
            <button type="button"  class="btn btn-danger" id="delete_all">删除</button>
        </div>
    </div>
    <!--内容-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <td>
                        <input type="checkbox" id="check_all"/>
                    </td>
                    <td>#</td>
                    <td>姓名</td>
                    <td>性别</td>
                    <td>邮箱</td>
                    <td>部门</td>
                    <td>操作</td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <!--分页-->
    <div class="row">
        <div class="col-md-6" id="page_info_area"></div>
        <div class="col-md-6" id="page_info_nav"></div>
    </div>
</div>
<!--新增页面-->
<div class="modal fade" tabindex="-1" role="dialog" id="empadd_modal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <input type="text" onchange="empname_change()" class="form-control" name="empName" id="empName_input" placeholder="姓名">
                            <span id="nameHelper" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="email"  onblur="check_email()" class="form-control" name="email" id="email" placeholder="email@lenovo.com">
                            <span id="emilHelper" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="genderm" value="M" checked="checked">男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="genderf" value="F"> 女
                                </label>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-10">
                            <select class="form-control" name="dId" id="dept_add_select"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-10">
                            <select class="form-control"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="saveEmployee()">Save</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!--修改页面-->
<div class="modal fade" tabindex="-1" role="dialog" id="update_emp_modal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="emp_update_name"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" name="email" id="update_email" placeholder="email@lenovo.com">
                            <span id="update_emilHelper" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label>
                                <label class="radio-inline">
                                    <input type="radio" name="update_gender" id="update_genderm" value="M">男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="update_gender" id="update_genderf" value="F"> 女
                                </label>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-10">
                            <select class="form-control" name="dId" id="dept_update_select"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-10">
                            <select class="form-control"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="update_emp">更新</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</body>
</html>
