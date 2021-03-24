package com.bjpowernode.crm.interceptor;

import com.bjpowernode.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
// 用户登录验证拦截器
public class UserInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("拦截器运行");
        User user = (User) request.getSession().getAttribute("user");
        String uri = request.getRequestURI();
        if (uri.contains("login")){
            return true;
        }
        if (user!=null){
            return true;
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
//        request.getRequestDispatcher("/login.jsp").forward(request,response);
        return false;
    }
}
