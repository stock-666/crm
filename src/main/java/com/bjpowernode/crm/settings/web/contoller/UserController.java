package com.bjpowernode.crm.settings.web.contoller;


import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.omg.CORBA.ObjectHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("settings/user")
public class UserController {
    @Resource
    private UserService userService;
    /*@RequestMapping("/login")
    public String login(){
        return "/mv.jsp";
    }*/

    // 登录验证
    @RequestMapping("/login")
    @ResponseBody
    public Map<String, Object> login(String loginAct, String loginPwd, HttpServletRequest request) throws LoginException {
        // 获取请求IP地址
        System.out.println("获取请求");
        String ip = request.getRemoteAddr();
        System.out.println(ip);
        User user = userService.verify(loginAct,loginPwd,ip);
        request.getSession().setAttribute("user",user);
        Map<String, Object> map = new HashMap<>();
        map.put("success",true);
        return map;
    }
}
