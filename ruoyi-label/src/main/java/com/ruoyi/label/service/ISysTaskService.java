package com.ruoyi.label.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.label.domain.SysTask;

/**
 * 任务Service接口
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
public interface ISysTaskService 
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
     * 批量删除任务
     * 
     * @param taskIds 需要删除的任务主键集合
     * @return 结果
     */
    public int deleteSysTaskByTaskIds(Long[] taskIds);

    /**
     * 删除任务信息
     * 
     * @param taskId 任务主键
     * @return 结果
     */
    public int deleteSysTaskByTaskId(Long taskId);
    
    /**
     * 根据任务ID列表查询任务列表
     * 
     * @param taskIds 任务ID数组
     * @return 任务集合
     */
    public List<SysTask> selectSysTaskListByTaskIds(Long[] taskIds);
    
    /**
     * 审核任务
     * 
     * @param sysTask 任务信息
     * @return 结果
     */
    public int auditTask(SysTask sysTask);
    
    /**
     * 根据任务包ID更新任务状态
     * 
     * @param sysTask 任务信息
     * @return 结果
     */
    public int updateSysTaskStatusByPackageId(SysTask sysTask);
    
    /**
     * 根据任务包ID查询任务列表
     * 
     * @param packageId 任务包ID
     * @return 任务集合
     */
    public List<SysTask> selectSysTaskListByPackageId(Long packageId);
    
    /**
     * 查询审核员任务列表
     * 
     * @param sysTask 任务
     * @param auditor 审核员
     * @return 任务集合
     */
    public List<SysTask> selectAuditorTaskList(SysTask sysTask, String auditor);
    
    /**
     * 查询创建者任务列表
     * 
     * @param projectName 项目名称
     * @param task_status 任务状态
     * @return 任务集合
     */
    public List<SysTask> selectCreatorTaskList(String projectName, String task_status, String creator);
    
    /**
     * 根据部门ID统计label_worker用户的任务
     * 
     * @param deptId 部门ID
     * @param keyword 用户名或昵称查询关键字
     * @return 任务统计结果
     */
    public List<Map<String, Object>> getTaskStatisticsByDeptId(Long deptId, String keyword);
}