package crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import crud.bean.Employee;
import crud.bean.Msg;
import crud.dao.EmployeeMapper;
import crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService emploeeService;

    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpWithJackson(@RequestParam(value = "pn", defaultValue = "1")Integer id, Model model){
        PageHelper.startPage(id,5);
        List<Employee> employeeList = emploeeService.getEmps();
        model.addAttribute("empList",employeeList);
        PageInfo<Employee> pageInfo = new PageInfo(employeeList,5);
        model.addAttribute("pageInfo",pageInfo);
        return Msg.success().add("pageInfo",pageInfo);
    }

    // post 保存，/emp/{id} put 修改，/emp/{id} delete 删除，
    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg saveEmployee(Employee employee){
        System.out.println(employee);
        int result = emploeeService.insertSelective(employee);
        if(result == 1){
            return Msg.success().add("employee",employee);
        }else {
            return Msg.fail().add("employee",employee);
        }
    }

    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.GET)
    public Msg getEmployee(@RequestParam("empName")String empName){
        System.out.println(empName);
        Employee emp =  emploeeService.selectByEmpName(empName);
        if (emp != null){
            return Msg.success().add("emp",emp);
        }else {
            return Msg.fail().add("emp", "empName is null");
        }

    }

    @RequestMapping(value = "/delete/{id}",method = RequestMethod.DELETE)
    public String delEmployee(@PathVariable("id")Integer id){
        emploeeService.DeleteEmp(id);
        return "index";
    }

    @RequestMapping("/checkuser")
    public Msg CheckUser(@RequestParam("empName") String empName){
        boolean b= emploeeService.CheckUser(empName);
        if(b){
            return Msg.success();
        }else{
            return Msg.fail();
        }
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
        Employee employee= emploeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }

    // 注意 empId 和数据库 里面的 对应， 才会访问
    // 发送 ajax put 形式的请求 全是null  问题 请求体中有数据，Employee 封装不上，
    // 封装不上的原因，tomcat 将请求体中的数据 封装成Map , 会从map中取值，
    @ResponseBody
    @RequestMapping(value = "/empput/{empId}",method = RequestMethod.POST)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        request.getParameter("gender");
        emploeeService.updateEmp(employee);
        System.out.println(employee);
        return Msg.success().add("saveEmp",employee);
    }

    // 单个批量 二合一
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("id")String ids){
        if(ids.contains("-")){
            List<Integer>del_ids = new ArrayList<>();
            String []str_ids = ids.split("-");
            for (String str:str_ids){
                del_ids.add(Integer.parseInt(str));
            }
            emploeeService.deleteBatch(del_ids);
        }else{
            emploeeService.deleteEmp(Integer.parseInt(ids));
        }
        return Msg.success().add("deleteEmp","");
    }
}
