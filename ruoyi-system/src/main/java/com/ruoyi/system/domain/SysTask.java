package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 任务对象 sys_task
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
public class SysTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    private Long taskId;

    /** 所属包的ID */
    private Long packageId;

    /** 音频文件名 */
    @Excel(name = "音频文件名")
    private String audioFileName;

    /** 音频文件在服务器的路径 */
    private String audioFilePath;

    /** 任务状态 */
    @Excel(name = "任务状态")
    private String status;

    /** 分配人账户名 */
    @Excel(name = "分配人账户名")
    private String annotator;

    /** 审核人员账户名 */
    @Excel(name = "审核人员账户名")
    private String auditor;

    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }

    public void setPackageId(Long packageId) 
    {
        this.packageId = packageId;
    }

    public Long getPackageId() 
    {
        return packageId;
    }

    public void setAudioFileName(String audioFileName) 
    {
        this.audioFileName = audioFileName;
    }

    public String getAudioFileName() 
    {
        return audioFileName;
    }

    public void setAudioFilePath(String audioFilePath) 
    {
        this.audioFilePath = audioFilePath;
    }

    public String getAudioFilePath() 
    {
        return audioFilePath;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setAnnotator(String annotator) 
    {
        this.annotator = annotator;
    }

    public String getAnnotator() 
    {
        return annotator;
    }

    public void setAuditor(String auditor) 
    {
        this.auditor = auditor;
    }

    public String getAuditor() 
    {
        return auditor;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("taskId", getTaskId())
            .append("packageId", getPackageId())
            .append("audioFileName", getAudioFileName())
            .append("audioFilePath", getAudioFilePath())
            .append("status", getStatus())
            .append("annotator", getAnnotator())
            .append("auditor", getAuditor())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
