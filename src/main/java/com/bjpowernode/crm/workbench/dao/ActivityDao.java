package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    // 添加市场活动
    int saveActivity(Activity activity);

    // 获取符合查询条件的市场活动条数
    int getTotalByCondition(Map<String,Object> map);

    // 获取符合查询条件的市场活动条数
    List<Activity> getActivitiesByCondition(Map<String,Object> map);
}
