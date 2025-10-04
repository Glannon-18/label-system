package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SysTaskMapper;
import com.ruoyi.system.domain.SysTask;
import com.ruoyi.system.service.ISysTaskService;

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
}
