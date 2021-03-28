package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.exception.ActivityDeleteException;
import com.bjpowernode.crm.exception.ActivityRemarkException;
import com.bjpowernode.crm.exception.ActivitySaveException;
import com.bjpowernode.crm.exception.ActivityUpdateException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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

    // 删除1~n个市场活动
    @RequestMapping("deleteByIds")
    @ResponseBody
    public Map<String,Object> deleteByIds(String[] ids) throws ActivityDeleteException {
        Boolean success = activityService.deleteByIds(ids);
        Map<String,Object> map = new HashMap<>();
        map.put("success",success);
        return map;
    }

    // 删除当前市场活动
    @RequestMapping("delete")
    @ResponseBody
    public Map<String,Object> delete(String id) throws ActivityDeleteException {
        System.out.println("进入删除");
        Boolean success = activityService.delete(id);
        Map<String,Object> map = new HashMap<>();
        map.put("success",success);
        return map;
    }

    // 获取选中市场活动信息以及用户列表
    @RequestMapping("edit")
    @ResponseBody
    public Map<String,Object> edit(String id){
        return activityService.edit(id);
    }

    // 更新市场活动的修改操作
    @ResponseBody
    @RequestMapping("update")
    public Map<String,Object> update(Activity activity,HttpServletRequest request) throws ActivityUpdateException {
        Map<String,Object> map = new HashMap<>();
        // 获取修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        activity.setEditBy(editBy);
        // 执行修改操作
        int result= activityService.updateActivity(activity);
        // 判断执行结果
        if (result<=0){
            // 失败则弹窗提示
            throw new ActivityUpdateException("市场活动修改失败！");
        }else{
            // 成功则返回true
            map.put("success",true);
            return map;
        }
    }

    // 展示市场活动详情
    @RequestMapping("detail")
    public ModelAndView detail(String id){
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.detail(id);
        mv.addObject("activity",activity);
        mv.setViewName("forward:/workbench/activity/detail.jsp");
        return mv;
    }

    // 获取备注信息列表
    @RequestMapping("getRmList")
    @ResponseBody
    public Map<String,Object> getRmList(String activityId){
        List<ActivityRemark> rmList = activityService.getRmList(activityId);
        Map<String,Object> map = new HashMap<>();
        map.put("rmList",rmList);
        map.put("success",true);
        return map;
    }

    // 删除备注信息
    @RequestMapping("deleteRemark")
    @ResponseBody
    public Boolean deleteARemark(String id) throws ActivityRemarkException {
        int result = activityService.deleteARemark(id);
        if (result!=1){
            return false;
        }
        return true;
    }

    //更新备注信息
    @ResponseBody
    @RequestMapping("updateRemark")
    public Map<String,Object> updateRemark(String id,String noteContent,HttpServletRequest request){
        ActivityRemark ar = new ActivityRemark();
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();
        ar.setEditBy(editBy);
        ar.setId(id);
        ar.setNoteContent(noteContent);
        return activityService.updateRemark(ar);
    }

    // 添加备注信息
    @RequestMapping("saveRemark")
    @ResponseBody
    public Map<String,Object> saveRemark(String noteContent,String activityId,HttpServletRequest request){
        ActivityRemark ar = new ActivityRemark();
        User user = (User) request.getSession().getAttribute("user");
        String createBy = user.getName();
        ar.setActivityId(activityId);
        ar.setNoteContent(noteContent);
        ar.setCreateBy(createBy);
        return activityService.saveRemark(ar);
    }

    // 修改市场活动信息及获取修改后的市场活动对象
    @ResponseBody
    @RequestMapping("updateAndGet")
    public Map<String,Object> updateAndGet(Activity activity,HttpServletRequest request) throws ActivityUpdateException {
        // 获取修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        activity.setEditBy(editBy);

        return activityService.updateAndActivity(activity);
    }
}

