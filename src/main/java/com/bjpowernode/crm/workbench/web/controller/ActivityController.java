package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.exception.ActivitySaveException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("workbench/Activity")
public class ActivityController {
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;


    // 获取所有者
    @RequestMapping("getUserList")
    @ResponseBody
    public List<User> getUserList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    // 添加市场活动
    @RequestMapping("saveActivity")
    @ResponseBody
    public Map<String,Object> saveActivity(Activity activity, HttpServletRequest request) throws ActivitySaveException {
        Map<String,Object> map = new HashMap<>();
        // 获取创建人
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        activity.setCreateBy(createBy);
        // 执行插入操作
        int result= activityService.saveActivity(activity);
        // 判断执行结果
        if (result<=0){
            // 失败则弹窗提示
            throw new ActivitySaveException("市场活动添加失败！");
        }else{
            // 成功则返回true
            map.put("success",true);
            return map;
        }
    }


    // 获取市场活动列表
    @RequestMapping("pageList")
    @ResponseBody
    public ActivityVO<Activity> pageList(String pageNo,String pageSize,String searchName,
                                         String searchOwner,String searchStartTime,String searchEndTime){
        Map<String,Object> map = new HashMap<>();
        int pageN = Integer.valueOf(pageNo);
        int pageS = Integer.valueOf(pageSize);
        // 略过条数放入map中
        int skipNo = (pageN-1)*pageS;
        map.put("skipNo",skipNo);
        map.put("pageSize",pageS);
        map.put("searchName",searchName);
        map.put("searchOwner",searchOwner);
        map.put("searchStartTime",searchStartTime);
        map.put("searchEndTime",searchEndTime);

        ActivityVO<Activity> vo = activityService.pageList(map);
        return vo;
    }
}
