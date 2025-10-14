package com.ruoyi.label.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 标注数据对象 sys_annotation_data
 * 
 * @author ruoyi
 * @date 2025-10-14
 */
public class SysAnnotationData extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id主键 */
    private String dataId;

    /** 关联的task id */
    @Excel(name = "关联的task id")
    private String taskId;

    /** 标注数据（类型longtext） */
    @Excel(name = "标注数据", readConverterExp = "类=型longtext")
    private String data;

    /** 数据版本号，每次保存递增 */
    @Excel(name = "数据版本号，每次保存递增")
    private String version;

    public void setDataId(String dataId) 
    {
        this.dataId = dataId;
    }

    public String getDataId() 
    {
        return dataId;
    }

    public void setTaskId(String taskId) 
    {
        this.taskId = taskId;
    }

    public String getTaskId() 
    {
        return taskId;
    }

    public void setData(String data) 
    {
        this.data = data;
    }

    public String getData() 
    {
        return data;
    }

    public void setVersion(String version) 
    {
        this.version = version;
    }

    public String getVersion() 
    {
        return version;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("dataId", getDataId())
            .append("taskId", getTaskId())
            .append("data", getData())
            .append("version", getVersion())
            .append("createTime", getCreateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
