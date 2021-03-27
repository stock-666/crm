package com.bjpowernode.crm.controllerExceptionHandler;

import com.bjpowernode.crm.exception.ActivityDeleteException;
import com.bjpowernode.crm.exception.ActivitySaveException;
import com.bjpowernode.crm.exception.ActivityUpdateException;
import com.bjpowernode.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
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
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",ex.getMessage());
        return map;
    }

    // 市场活动添加异常
    @ResponseBody
    @ExceptionHandler(ActivitySaveException.class)
    public Map<String,Object> saveActivityEH(Exception ex){
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",ex.getMessage());
        return map;
    }

    // 市场活动删除异常
    @ResponseBody
    @ExceptionHandler(ActivityDeleteException.class)
    public Map<String,Object> activityDeleteEx(Exception ex){
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",ex.getMessage());
        return map;
    }
    // 市场活动修改异常
    @ResponseBody
    @ExceptionHandler(ActivityUpdateException.class)
    public Map<String,Object> editActivityEx(Exception ex){
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg",ex.getMessage());
        return map;
    }
}
