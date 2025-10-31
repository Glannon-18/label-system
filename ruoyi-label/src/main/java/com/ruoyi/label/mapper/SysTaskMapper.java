package com.ruoyi.label.mapper;

import com.ruoyi.label.domain.SysTask;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

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
     * 根据任务包ID查询任务数量
     * 
     * @param packageId 任务包ID
     * @return 任务数量
     */
    public int countTaskByPackageId(Long packageId);
    
    /**
     * 删除任务
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
     * 批量删除任务
     * 
     * @param taskIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysTaskByTaskIds(Long[] taskIds);
    
    /**
     * 根据任务包ID更新任务状态
     * 
     * @param sysTask 任务信息
     * @return 结果
     */
    public int updateSysTaskStatusByPackageId(SysTask sysTask);
    
    /**
     * 查询审核员任务列表
     * 
     * @param sysTask 任务
     * @param auditor 审核员
     * @return 任务集合
     */
    public List<SysTask> selectAuditorTaskList(@Param("sysTask") SysTask sysTask, @Param("auditor") String auditor);

    /**
     * 查询创建者任务列表
     * 
     * @param projectName 项目名称
     * @param task_status 任务状态
     * @return 任务集合
     */
    public List<SysTask> selectCreatorTaskList(@Param("projectName") String projectName, @Param("task_status") String task_status, @Param("creator") String creator);
    
    /**
     * 根据部门ID统计label_worker用户的任务
     * 
     * @param deptId 部门ID
     * @param keyword 用户名或昵称查询关键字
     * @param orderByColumn 排序字段
     * @param isAsc 排序方式
     * @return 任务统计结果
     */
    public List<Map<String, Object>> getTaskStatisticsByDeptId(
            @Param("deptId") Long deptId,
            @Param("keyword") String keyword,
            @Param("orderByColumn") String orderByColumn,
            @Param("isAsc") String isAsc);
}