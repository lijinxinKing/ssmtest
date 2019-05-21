package crud.service;

import crud.bean.Employee;
import crud.bean.EmployeeExample;
import crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;
    public List<Employee> getEmps(){
        return employeeMapper.selectByExampleWithDeptId(null);
    }
    public int insertSelective(Employee employee){
        return employeeMapper.insertSelective(employee);
    }

    public Employee selectByEmpName(String name){
        return employeeMapper.selectByEmpName(name);
    }

    public void DeleteEmp(Integer id){

        employeeMapper.deleteByPrimaryKey(id);
    }

    public Boolean CheckUser(String empName){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }

    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    public int updateEmp(Employee employee){
        return employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**/
    public void deleteEmp(Integer id) {
       employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBatch(List<Integer> str_ids) {
        // 封装条件
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(str_ids);
        employeeMapper.deleteByExample(employeeExample);
    }
}
