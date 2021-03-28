package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.ActivityDeleteException;
import com.bjpowernode.crm.exception.ActivityRemarkException;
import com.bjpowernode.crm.exception.ActivityUpdateException;
import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    // 保存市场活动
    int saveActivity(Activity activity);
    // 获取市场活动列表
    ActivityVO<Activity> pageList(Map<String,Object> map);
    // 删除市场活动及相关联备注
    Boolean deleteByIds(String[] ids) throws ActivityDeleteException;

    // 获取用户信息和指定市场活动对象
    Map<String, Object> edit(String id);

    // 更新市场活动
    int updateActivity(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRmList(String activityId);

    int deleteARemark(String id) throws ActivityRemarkException;

    Map<String, Object> updateRemark(ActivityRemark inRemark);

    Map<String, Object> saveRemark(ActivityRemark ar);

    Map<String, Object> updateAndActivity(Activity activity) throws ActivityUpdateException;

    Boolean delete(String id) throws ActivityDeleteException;
}
