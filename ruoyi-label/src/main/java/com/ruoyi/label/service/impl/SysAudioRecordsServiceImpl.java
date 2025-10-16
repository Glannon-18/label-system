package com.ruoyi.label.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.label.mapper.SysAudioRecordsMapper;
import com.ruoyi.label.domain.SysAudioRecords;
import com.ruoyi.label.service.ISysAudioRecordsService;

/**
 * 文件录音Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-15
 */
@Service
public class SysAudioRecordsServiceImpl implements ISysAudioRecordsService 
{
    @Autowired
    private SysAudioRecordsMapper sysAudioRecordsMapper;

    /**
     * 查询文件录音
     * 
     * @param id 文件录音主键
     * @return 文件录音
     */
    @Override
    public SysAudioRecords selectSysAudioRecordsById(Long id)
    {
        return sysAudioRecordsMapper.selectSysAudioRecordsById(id);
    }

    /**
     * 查询文件录音列表
     * 
     * @param sysAudioRecords 文件录音
     * @return 文件录音
     */
    @Override
    public List<SysAudioRecords> selectSysAudioRecordsList(SysAudioRecords sysAudioRecords)
    {
        return sysAudioRecordsMapper.selectSysAudioRecordsList(sysAudioRecords);
    }

    /**
     * 新增文件录音
     * 
     * @param sysAudioRecords 文件录音
     * @return 结果
     */
    @Override
    public int insertSysAudioRecords(SysAudioRecords sysAudioRecords)
    {
        sysAudioRecords.setCreateTime(DateUtils.getNowDate());
        return sysAudioRecordsMapper.insertSysAudioRecords(sysAudioRecords);
    }

    @Override
    public int batchInsertSysAudioRecords(List<SysAudioRecords> sysAudioRecords) {
        return sysAudioRecordsMapper.batchInsertSysAudioRecords(sysAudioRecords);
    }


    /**
     * 修改文件录音
     * 
     * @param sysAudioRecords 文件录音
     * @return 结果
     */
    @Override
    public int updateSysAudioRecords(SysAudioRecords sysAudioRecords)
    {
        sysAudioRecords.setUpdateTime(DateUtils.getNowDate());
        return sysAudioRecordsMapper.updateSysAudioRecords(sysAudioRecords);
    }

    /**
     * 批量删除文件录音
     * 
     * @param ids 需要删除的文件录音主键
     * @return 结果
     */
    @Override
    public int deleteSysAudioRecordsByIds(Long[] ids)
    {
        return sysAudioRecordsMapper.deleteSysAudioRecordsByIds(ids);
    }

    /**
     * 删除文件录音信息
     * 
     * @param id 文件录音主键
     * @return 结果
     */
    @Override
    public int deleteSysAudioRecordsById(Long id)
    {
        return sysAudioRecordsMapper.deleteSysAudioRecordsById(id);
    }
}
