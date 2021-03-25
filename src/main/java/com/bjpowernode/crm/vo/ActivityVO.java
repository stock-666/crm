package com.bjpowernode.crm.vo;

import java.util.List;

public class ActivityVO<T> {
    private int total;
    private List<T> objList;

    public ActivityVO() {
    }

    public ActivityVO(int total, List<T> objList) {
        this.total = total;
        this.objList = objList;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getObjList() {
        return objList;
    }

    public void setObjList(List<T> objList) {
        this.objList = objList;
    }
}
