package com.ruoyi.label.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.label.mapper.SysTaskMapper;
import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.service.ISysTaskService;
import com.ruoyi.common.utils.DateUtils;

/**
 * 任务Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
@Service
public class SysTaskServiceImpl implements ISysTaskService 
{
    @Autowired
    private SysTaskMapper sysTaskMapper;

    /**
     * 查询任务
     * 
     * @param taskId 任务主键
     * @return 任务
     */
    @Override
    public SysTask selectSysTaskByTaskId(Long taskId)
    {
        return sysTaskMapper.selectSysTaskByTaskId(taskId);
    }

    /**
     * 查询任务列表
     * 
     * @param sysTask 任务
     * @return 任务
     */
    @Override
    public List<SysTask> selectSysTaskList(SysTask sysTask)
    {
        return sysTaskMapper.selectSysTaskList(sysTask);
    }

    /**
     * 新增任务
     * 
     * @param sysTask 任务
     * @return 结果
     */
    @Override
    public int insertSysTask(SysTask sysTask)
    {
        sysTask.setCreateTime(DateUtils.getNowDate());
        return sysTaskMapper.insertSysTask(sysTask);
    }

    /**
     * 修改任务
     * 
     * @param sysTask 任务
     * @return 结果
     */
    @Override
    public int updateSysTask(SysTask sysTask)
    {
        sysTask.setUpdateTime(DateUtils.getNowDate());
        return sysTaskMapper.updateSysTask(sysTask);
    }

    /**
     * 批量删除任务
     * 
     * @param taskIds 需要删除的任务主键
     * @return 结果
     */
    @Override
    public int deleteSysTaskByTaskIds(Long[] taskIds)
    {
        return sysTaskMapper.deleteSysTaskByTaskIds(taskIds);
    }

    /**
     * 删除任务信息
     * 
     * @param taskId 任务主键
     * @return 结果
     */
    @Override
    public int deleteSysTaskByTaskId(Long taskId)
    {
        return sysTaskMapper.deleteSysTaskByTaskId(taskId);
    }
    
    /**
     * 根据任务ID列表查询任务列表
     * 
     * @param taskIds 任务ID数组
     * @return 任务集合
     */
    @Override
    public List<SysTask> selectSysTaskListByTaskIds(Long[] taskIds)
    {
        return sysTaskMapper.selectSysTaskListByTaskIds(taskIds);
    }
    
    /**
     * 审核任务
     * 
     * @param sysTask 任务信息
     * @return 结果
     */
    @Override
    public int auditTask(SysTask sysTask)
    {
        sysTask.setUpdateTime(DateUtils.getNowDate());
        return sysTaskMapper.updateSysTask(sysTask);
    }
    
    /**
     * 根据任务包ID更新任务状态
     * 
     * @param sysTask 任务信息
     * @return 结果
     */
    @Override
    public int updateSysTaskStatusByPackageId(SysTask sysTask)
    {
        sysTask.setUpdateTime(DateUtils.getNowDate());
        return sysTaskMapper.updateSysTaskStatusByPackageId(sysTask);
    }
    
    /**
     * 根据任务包ID查询任务列表
     * 
     * @param packageId 任务包ID
     * @return 任务集合
     */
    @Override
    public List<SysTask> selectSysTaskListByPackageId(Long packageId)
    {
        SysTask sysTask = new SysTask();
        sysTask.setPackageId(packageId);
        return sysTaskMapper.selectSysTaskList(sysTask);
    }
    
    /**
     * 查询审核员任务列表
     * 
     * @param sysTask 任务
     * @param auditor 审核员
     * @return 任务集合
     */
    @Override
    public List<SysTask> selectAuditorTaskList(SysTask sysTask, String auditor)
    {
        return sysTaskMapper.selectAuditorTaskList(sysTask, auditor);
    }
    
    /**
     * 查询创建者任务列表
     * 
     * @param projectName 项目名称
     * @param task_status 任务状态
     * @return 任务集合
     */
    @Override
    public List<SysTask> selectCreatorTaskList(String projectName, String task_status, String creator)
    {
        return sysTaskMapper.selectCreatorTaskList(projectName, task_status, creator);
    }
    
    /**
     * 根据部门ID统计label_worker用户的任务
     * 
     * @param deptId 部门ID
     * @return 任务统计结果
     */
    @Override
    public List<Map<String, Object>> getTaskStatisticsByDeptId(Long deptId) {
        return sysTaskMapper.getTaskStatisticsByDeptId(deptId);
    }
}