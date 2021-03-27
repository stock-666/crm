package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.exception.ActivityDeleteException;
import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.Arrays;
import java.util.Map;

public interface ActivityService {
    // 保存市场活动
    int saveActivity(Activity activity);
    // 获取市场活动列表
    ActivityVO<Activity> pageList(Map<String,Object> map);
    // 删除市场活动及相关联备注
    Boolean delete(String[] ids) throws ActivityDeleteException;

    // 获取用户信息和指定市场活动对象
    Map<String, Object> edit(String id);

    // 更新市场活动
    int updateActivity(Activity activity);
}
