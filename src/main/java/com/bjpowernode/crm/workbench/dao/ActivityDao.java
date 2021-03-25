package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

public interface ActivityDao {
    // 添加市场活动
    int saveActivity(Activity activity);
}
