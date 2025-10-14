package com.ruoyi.label.service;

import java.util.List;
import com.ruoyi.label.domain.SysAnnotationData;

/**
 * 标注数据Service接口
 * 
 * @author ruoyi
 * @date 2025-10-14
 */
public interface ISysAnnotationDataService 
{
    /**
     * 查询标注数据
     * 
     * @param dataId 标注数据主键
     * @return 标注数据
     */
    public SysAnnotationData selectSysAnnotationDataByDataId(String dataId);

    /**
     * 查询标注数据列表
     * 
     * @param sysAnnotationData 标注数据
     * @return 标注数据集合
     */
    public List<SysAnnotationData> selectSysAnnotationDataList(SysAnnotationData sysAnnotationData);

    /**
     * 新增标注数据
     * 
     * @param sysAnnotationData 标注数据
     * @return 结果
     */
    public int insertSysAnnotationData(SysAnnotationData sysAnnotationData);

    /**
     * 修改标注数据
     * 
     * @param sysAnnotationData 标注数据
     * @return 结果
     */
    public int updateSysAnnotationData(SysAnnotationData sysAnnotationData);

    /**
     * 批量删除标注数据
     * 
     * @param dataIds 需要删除的标注数据主键集合
     * @return 结果
     */
    public int deleteSysAnnotationDataByDataIds(String[] dataIds);

    /**
     * 删除标注数据信息
     * 
     * @param dataId 标注数据主键
     * @return 结果
     */
    public int deleteSysAnnotationDataByDataId(String dataId);
}
