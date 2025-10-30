package com.ruoyi.label.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

/**
 * 任务对象 sys_task
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
public class SysTask extends BaseEntity {
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

    /** 标注人员的textGrid文件内容 */
    private String textGrid;

    /** 审核人员的textGrid文件内容 */
    private String auditTextGrid;

    /** 保存原始的textGrid文件内容 */
    private String originalTextGrid;

    /** 任务包分配人 */
    private String packageAssigner;

    /** 任务包类型 */
    private String packageType;

    /** 任务包名称 */
    private String packageName;

    /** 项目名称 */
    private String projectName;

    /** 审核通过时间 **/
    private Date passTime;

    /** 音频时长 */
    private Double duration;

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setPackageId(Long packageId) {
        this.packageId = packageId;
    }

    public Long getPackageId() {
        return packageId;
    }

    public void setAudioFileName(String audioFileName) {
        this.audioFileName = audioFileName;
    }

    public String getAudioFileName() {
        return audioFileName;
    }

    public void setAudioFilePath(String audioFilePath) {
        this.audioFilePath = audioFilePath;
    }

    public String getAudioFilePath() {
        return audioFilePath;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setTextGrid(String textGrid) {
        this.textGrid = textGrid;
    }

    public String getTextGrid() {
        return textGrid;
    }

    public void setOriginalTextGrid(String originalTextGrid) {
        this.originalTextGrid = originalTextGrid;
    }

    public String getOriginalTextGrid() {
        return originalTextGrid;
    }

    public void setAuditTextGrid(String auditTextGrid) {
        this.auditTextGrid = auditTextGrid;
    }

    public String getAuditTextGrid() {
        return auditTextGrid;
    }

    public String getPackageAssigner() {
        return packageAssigner;
    }

    public void setPackageAssigner(String packageAssigner) {
        this.packageAssigner = packageAssigner;
    }

    public String getPackageType() {
        return packageType;
    }

    public void setPackageType(String packageType) {
        this.packageType = packageType;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public Date getPassTime() {
        return passTime;
    }

    public void setPassTime(Date passTime) {
        this.passTime = passTime;
    }

    public Double getDuration() {
        return duration;
    }

    public void setDuration(Double duration) {
        this.duration = duration;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("taskId", getTaskId())
                .append("packageId", getPackageId())
                .append("audioFileName", getAudioFileName())
                .append("audioFilePath", getAudioFilePath())
                .append("status", getStatus())
                .append("createBy", getCreateBy())
                .append("createTime", getCreateTime())
                .append("updateBy", getUpdateBy())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .append("textGrid", getTextGrid())
                .append("auditTextGrid", getAuditTextGrid())
                .append("originalTextGrid", getOriginalTextGrid())
                .append("packageAssigner", getPackageAssigner())
                .append("packageType", getPackageType())
                .append("packageName", getPackageName())
                .append("passTime", getPassTime())
                .append("duration", getDuration().toString())
                .toString();
    }
}
