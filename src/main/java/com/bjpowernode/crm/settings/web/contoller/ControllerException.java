package com.bjpowernode.crm.settings.web.contoller;

import com.bjpowernode.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

// 全局异常处理类
@ControllerAdvice
public class ControllerException{
    // 用户登录异常
    @ResponseBody
    @ExceptionHandler(LoginException.class)
    public Map<String,Object> loginException(Exception ex){
        System.out.println("进入异常处理");
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",ex.getMessage());
        System.out.println("异常处理完成");
        return map;
    }
}
