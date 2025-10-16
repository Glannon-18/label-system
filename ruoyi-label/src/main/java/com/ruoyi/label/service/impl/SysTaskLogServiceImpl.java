package com.ruoyi.label.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.label.mapper.SysTaskLogMapper;
import com.ruoyi.label.domain.SysTaskLog;
import com.ruoyi.label.service.ISysTaskLogService;

/**
 * 任务日志Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-16
 */
@Service
public class SysTaskLogServiceImpl implements ISysTaskLogService 
{
    @Autowired
    private SysTaskLogMapper sysTaskLogMapper;

    /**
     * 查询任务日志列表
     * 
     * @param sysTaskLog 任务日志
     * @return 任务日志
     */
    @Override
    public List<SysTaskLog> selectSysTaskLogList(SysTaskLog sysTaskLog)
    {
        return sysTaskLogMapper.selectSysTaskLogList(sysTaskLog);
    }

    /**
     * 新增任务日志
     * 
     * @param sysTaskLog 任务日志
     * @return 结果
     */
    @Override
    public int insertSysTaskLog(SysTaskLog sysTaskLog)
    {
        sysTaskLog.setCreateTime(DateUtils.getNowDate());
        return sysTaskLogMapper.insertSysTaskLog(sysTaskLog);
    }
}