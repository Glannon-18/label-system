package com.ruoyi.label.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 文件录音对象 sys_audio_records
 * 
 * @author ruoyi
 * @date 2025-10-15
 */
public class SysAudioRecords extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    private Long id;

    /** 任务id */
    @Excel(name = "任务id")
    private Long taskId;

    /** 任务包id */
    @Excel(name = "任务包id")
    private Long packageId;

    /** 在excel中的顺序 */
    @Excel(name = "在excel中的顺序")
    private Long itemOrder;

    /** excel中每行文本 */
    @Excel(name = "excel中每行文本")
    private String text;

    /** 修改后的文本 */
    @Excel(name = "修改后的文本")
    private String modifiedText;

    /** 录音文件路径 */
    @Excel(name = "录音文件路径")
    private String audioFilePath;

    /** 录音文件路径 */
    @Excel(name = "录音文件时长")
    private String audioDuration;

    /** 标注员 */
    @Excel(name = "标注员")
    private String annotator;

    /** 审计人 */
    @Excel(name = "审计人")
    private String auditor;

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return id;
    }

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

    public void setItemOrder(Long itemOrder)
    {
        this.itemOrder = itemOrder;
    }

    public Long getItemOrder()
    {
        return itemOrder;
    }

    public void setText(String text)
    {
        this.text = text;
    }

    public String getText()
    {
        return text;
    }

    public void setModifiedText(String modifiedText)
    {
        this.modifiedText = modifiedText;
    }

    public String getModifiedText()
    {
        return modifiedText;
    }

    public void setAudioFilePath(String audioFilePath)
    {
        this.audioFilePath = audioFilePath;
    }

    public String getAudioFilePath()
    {
        return audioFilePath;
    }

    public String getAudioDuration() {
        return audioDuration;
    }

    public void setAudioDuration(String audioDuration) {
        this.audioDuration = audioDuration;
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
            .append("id", getId())
            .append("taskId", getTaskId())
            .append("packageId", getPackageId())
            .append("itemOrder", getItemOrder())
            .append("text", getText())
            .append("modifiedText", getModifiedText())
            .append("audioFilePath", getAudioFilePath())
            .append("audioDuration", getAudioDuration())
            .append("annotator", getAnnotator())
            .append("auditor", getAuditor())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
