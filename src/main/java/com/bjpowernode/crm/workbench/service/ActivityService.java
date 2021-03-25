package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.ActivityVO;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {
    // 保存市场活动
    int saveActivity(Activity activity);
    // 获取市场活动列表
    ActivityVO<Activity> pageList(Map<String,Object> map);
}
