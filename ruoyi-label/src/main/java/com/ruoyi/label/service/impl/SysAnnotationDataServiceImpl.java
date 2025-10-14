package com.ruoyi.label.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.label.mapper.SysAnnotationDataMapper;
import com.ruoyi.label.domain.SysAnnotationData;
import com.ruoyi.label.service.ISysAnnotationDataService;

/**
 * 标注数据Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-14
 */
@Service
public class SysAnnotationDataServiceImpl implements ISysAnnotationDataService 
{
    @Autowired
    private SysAnnotationDataMapper sysAnnotationDataMapper;

    /**
     * 查询标注数据
     * 
     * @param dataId 标注数据主键
     * @return 标注数据
     */
    @Override
    public SysAnnotationData selectSysAnnotationDataByDataId(String dataId)
    {
        return sysAnnotationDataMapper.selectSysAnnotationDataByDataId(dataId);
    }

    /**
     * 查询标注数据列表
     * 
     * @param sysAnnotationData 标注数据
     * @return 标注数据
     */
    @Override
    public List<SysAnnotationData> selectSysAnnotationDataList(SysAnnotationData sysAnnotationData)
    {
        return sysAnnotationDataMapper.selectSysAnnotationDataList(sysAnnotationData);
    }

    /**
     * 新增标注数据
     * 
     * @param sysAnnotationData 标注数据
     * @return 结果
     */
    @Override
    public int insertSysAnnotationData(SysAnnotationData sysAnnotationData)
    {
        sysAnnotationData.setCreateTime(DateUtils.getNowDate());
        return sysAnnotationDataMapper.insertSysAnnotationData(sysAnnotationData);
    }

    /**
     * 修改标注数据
     * 
     * @param sysAnnotationData 标注数据
     * @return 结果
     */
    @Override
    public int updateSysAnnotationData(SysAnnotationData sysAnnotationData)
    {
        sysAnnotationData.setUpdateTime(DateUtils.getNowDate());
        return sysAnnotationDataMapper.updateSysAnnotationData(sysAnnotationData);
    }

    /**
     * 批量删除标注数据
     * 
     * @param dataIds 需要删除的标注数据主键
     * @return 结果
     */
    @Override
    public int deleteSysAnnotationDataByDataIds(String[] dataIds)
    {
        return sysAnnotationDataMapper.deleteSysAnnotationDataByDataIds(dataIds);
    }

    /**
     * 删除标注数据信息
     * 
     * @param dataId 标注数据主键
     * @return 结果
     */
    @Override
    public int deleteSysAnnotationDataByDataId(String dataId)
    {
        return sysAnnotationDataMapper.deleteSysAnnotationDataByDataId(dataId);
    }
}
