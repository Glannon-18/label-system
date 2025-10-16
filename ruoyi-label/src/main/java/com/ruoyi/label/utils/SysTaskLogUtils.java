package com.ruoyi.label.utils;

import com.ruoyi.label.domain.SysTaskLog;
import com.ruoyi.label.service.ISysTaskLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class SysTaskLogUtils {

    private static ISysTaskLogService sysTaskLogService;

    @Autowired
    public void setSysTaskLogService(ISysTaskLogService sysTaskLogService) {
        SysTaskLogUtils.sysTaskLogService = sysTaskLogService;
    }

    /**
     * 插入任务日志记录
     *
     * @param taskId   任务ID
     * @param status   状态
     * @param createBy 创建人
     * @param remark   备注
     */
    public static void insertSysTaskLog(Long taskId, String status, String createBy, String remark) {
        SysTaskLog sysTaskLog = new SysTaskLog();
        sysTaskLog.setTaskId(taskId);
        sysTaskLog.setStatus(status);
        sysTaskLog.setCreateBy(createBy);
        sysTaskLog.setRemark(remark);
        // createTime会由service层自动设置
        sysTaskLogService.insertSysTaskLog(sysTaskLog);
    }
}