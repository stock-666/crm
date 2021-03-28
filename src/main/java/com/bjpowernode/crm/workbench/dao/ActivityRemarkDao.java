package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int remarkDeleteById(String[] ids);

    int remarkCountById(String[] ids);

    List<ActivityRemark> getList(String activityId);

    int delete(String id);

    int update(ActivityRemark inRemark);

    ActivityRemark getRemark(String id);

    int save(ActivityRemark ar);
}
