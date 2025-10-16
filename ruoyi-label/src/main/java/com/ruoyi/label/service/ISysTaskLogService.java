package com.ruoyi.label.service;

import java.util.List;
import com.ruoyi.label.domain.SysTaskLog;

/**
 * 任务日志Service接口
 * 
 * @author ruoyi
 * @date 2025-10-16
 */
public interface ISysTaskLogService 
{
    /**
     * 查询任务日志列表
     * 
     * @param sysTaskLog 任务日志
     * @return 任务日志集合
     */
    public List<SysTaskLog> selectSysTaskLogList(SysTaskLog sysTaskLog);

    /**
     * 新增任务日志
     * 
     * @param sysTaskLog 任务日志
     * @return 结果
     */
    public int insertSysTaskLog(SysTaskLog sysTaskLog);
}