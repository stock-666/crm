package com.bjpowernode.crm.settings.service.Impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;
    public UserServiceImpl(UserDao userDao) {
        this.userDao = userDao;
    }
    public UserServiceImpl() {
    }
    // 验证登录
    public User verify(String loginAct,String loginPwd,String ip) throws LoginException {
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        // MD5转码
        loginPwd = MD5Util.getMD5(loginPwd);
        map.put("loginPwd",loginPwd);
        User user = userDao.getUser(map);
        // 验证用户是否存在
        if (user == null){
            throw new LoginException("用户名或密码不正确!");
        }
        // 验证用户是否过期
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("用户身份已过期，请联系管理员!");
        }
        // 验证用户ip是否合法
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("用户登录IP地址不合法!");
        }
        // 验证用户是否锁定
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账户已被锁定，请联系管理员!");
        }
        return user;
    }
}
