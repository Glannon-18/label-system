package com.ruoyi.label.mapper;

import java.util.List;
import com.ruoyi.label.domain.SysTaskLog;

/**
 * 任务日志Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-16
 */
public interface SysTaskLogMapper 
{
    /**
     * 查询任务日志
     * 
     * @param logId 任务日志主键
     * @return 任务日志
     */
    public SysTaskLog selectSysTaskLogByLogId(Long logId);

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

    /**
     * 修改任务日志
     * 
     * @param sysTaskLog 任务日志
     * @return 结果
     */
    public int updateSysTaskLog(SysTaskLog sysTaskLog);

    /**
     * 删除任务日志
     * 
     * @param logId 任务日志主键
     * @return 结果
     */
    public int deleteSysTaskLogByLogId(Long logId);

    /**
     * 批量删除任务日志
     * 
     * @param logIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysTaskLogByLogIds(Long[] logIds);
}