package com.ruoyi.label.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 任务包对象 sys_task_package
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
public class SysTaskPackage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务包id */
    private Long taskPackageId;

    /** 关联的项目id */
    private Long projectId;

    /** 任务包名 */
    @Excel(name = "任务包名")
    private String name;

    @Excel(name = "任务包类型")
    private String type;

    /** 任务包状态 */
    @Excel(name = "任务包状态")
    private String status;

    /** 分配人账户名 */
    private String assigner;

    /** 审核人账户名 */
    private String auditor;

    private String language;

    /** 项目名 */
    private String projectName;

    public void setTaskPackageId(Long taskPackageId)
    {
        this.taskPackageId = taskPackageId;
    }

    public Long getTaskPackageId()
    {
        return taskPackageId;
    }

    public void setProjectId(Long projectId)
    {
        this.projectId = projectId;
    }

    public Long getProjectId()
    {
        return projectId;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getName()
    {
        return name;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus()
    {
        return status;
    }

    public void setAssigner(String assigner)
    {
        this.assigner = assigner;
    }

    public String getAssigner()
    {
        return assigner;
    }

    public void setAuditor(String auditor)
    {
        this.auditor = auditor;
    }

    public String getAuditor()
    {
        return auditor;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }


    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .append("taskPackageId", getTaskPackageId())
            .append("projectId", getProjectId())
            .append("name", getName())
            .append("status", getStatus())
            .append("assigner", getAssigner())
            .append("auditor", getAuditor())
            .append("type", getType())
                .append("language",getLanguage())
            .toString();
    }
}
