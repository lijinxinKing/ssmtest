package crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import crud.bean.Employee;
import crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeMapper employeeMapper;

    @RequestMapping("/emps")
    public String test(@RequestParam(value = "pn", defaultValue = "1")Integer id, Model model){

        PageHelper.startPage(id,5);

        List<Employee> employeeList = employeeMapper.selectByExampleWithDeptId(null);
        model.addAttribute("empList",employeeList);
        PageInfo<Employee> pageInfo = new PageInfo(employeeList,5);
        for (int num:pageInfo.getNavigatepageNums()){
            System.out.println(num);
        }
        model.addAttribute("pageInfo",pageInfo);
        return "index";
    }

    @RequestMapping(value = "/delete/{id}",method = RequestMethod.DELETE)
    public String delEmployee(@PathVariable("id")Integer id){

        long result = employeeMapper.deleteByPrimaryKey(id);

        if(result == 1){
            System.out.println("删除成功");
        }else{
            System.out.println("删除失败");
        }
        return "index";
    }
}
