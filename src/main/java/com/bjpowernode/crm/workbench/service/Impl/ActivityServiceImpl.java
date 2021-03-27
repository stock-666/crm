package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.exception.ActivityDeleteException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;
    @Resource
    private UserDao userDao;
    // 添加市场活动
    @Override
    public int saveActivity(Activity activity) {
        // 获取id和创建时间
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        activity.setId(id);
        activity.setCreateTime(createTime);
        // 执行保存操作
        return activityDao.saveActivity(activity);
    }
    // 刷新市场活动列表
    @Override
    public ActivityVO<Activity> pageList(Map<String, Object> map) {
        int total = activityDao.getTotalByCondition(map);
        List<Activity> activities = activityDao.getActivitiesByCondition(map);
        ActivityVO<Activity> vo = new ActivityVO(total,activities);
        return vo;
    }

    // 删除市场活动及相关联备注
    @Override
    @Transactional(rollbackFor = ActivityDeleteException.class)
    public Boolean delete(String[] ids) throws ActivityDeleteException {
        // 获取需要删除的备注条数
        int remarkCount = activityRemarkDao.remarkCountById(ids);
        System.out.println(remarkCount);
        int remarkDC =0;
        if (remarkCount!=0){
            // 删除关联的备注信息
            remarkDC =activityRemarkDao.remarkDeleteById(ids);
        }
        // 删除市场活动
        int activityDC = activityDao.activityDeleteById(ids);
        if (remarkCount==remarkDC && ids.length==activityDC){
            return true;
        }else {
            throw new ActivityDeleteException("市场信息删除失败！");
        }
    }

    // 获取user和选中的市场活动对象
    @Override
    public Map<String, Object> edit(String id) {
        // 获取市场活动对象
        Activity activity = activityDao.getActivityById(id);
        // 获取用户
        List<User> ulist = userDao.getUserList();
        Map<String,Object> map = new HashMap<>();
        map.put("activity",activity);
        map.put("ulist",ulist);
        return map;
    }

    // 更新市场活动
    @Override
    public int updateActivity(Activity activity) {
        String editTime = DateTimeUtil.getSysTime();
        activity.setEditTime(editTime);
        int result = activityDao.update(activity);
        return result;
    }
}
