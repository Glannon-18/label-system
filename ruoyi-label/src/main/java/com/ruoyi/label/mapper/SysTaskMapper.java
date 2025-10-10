package com.ruoyi.label.mapper;

import com.ruoyi.label.domain.SysTask;

import java.util.List;

/**
 * 任务Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
public interface SysTaskMapper 
{
    /**
     * 查询任务
     * 
     * @param taskId 任务主键
     * @return 任务
     */
    public SysTask selectSysTaskByTaskId(Long taskId);

    /**
     * 查询任务列表
     * 
     * @param sysTask 任务
     * @return 任务集合
     */
    public List<SysTask> selectSysTaskList(SysTask sysTask);

    /**
     * 新增任务
     * 
     * @param sysTask 任务
     * @return 结果
     */
    public int insertSysTask(SysTask sysTask);

    /**
     * 修改任务
     * 
     * @param sysTask 任务
     * @return 结果
     */
    public int updateSysTask(SysTask sysTask);

    /**
     * 删除任务
     * 
     * @param taskId 任务主键
     * @return 结果
     */
    public int deleteSysTaskByTaskId(Long taskId);

    /**
     * 批量删除任务
     * 
     * @param taskIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysTaskByTaskIds(Long[] taskIds);
}
