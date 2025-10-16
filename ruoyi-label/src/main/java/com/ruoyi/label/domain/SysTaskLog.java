package com.ruoyi.label.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 任务日志对象 sys_task_log
 * 
 * @author ruoyi
 * @date 2025-10-16
 */
public class SysTaskLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务日志ID */
    private Long logId;

    /** 关联的任务ID */
    @Excel(name = "关联的任务ID")
    private Long taskId;

    /** 任务状态 */
    @Excel(name = "任务状态")
    private String status;

    /** 创建者 */
    @Excel(name = "创建者")
    private String createBy;

    /** 备注 */
    @Excel(name = "备注")
    private String remark;

    public void setLogId(Long logId) 
    {
        this.logId = logId;
    }

    public Long getLogId() 
    {
        return logId;
    }

    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setCreateBy(String createBy) 
    {
        this.createBy = createBy;
    }

    public String getCreateBy() 
    {
        return createBy;
    }

    public void setRemark(String remark) 
    {
        this.remark = remark;
    }

    public String getRemark() 
    {
        return remark;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", getLogId())
            .append("taskId", getTaskId())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("remark", getRemark())
            .toString();
    }
}