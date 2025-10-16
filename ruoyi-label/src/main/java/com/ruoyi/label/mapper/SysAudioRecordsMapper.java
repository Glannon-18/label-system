package com.ruoyi.label.mapper;

import java.util.List;
import com.ruoyi.label.domain.SysAudioRecords;
import org.apache.ibatis.annotations.Param;

/**
 * 文件录音Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-15
 */
public interface SysAudioRecordsMapper 
{
    /**
     * 查询文件录音
     * 
     * @param id 文件录音主键
     * @return 文件录音
     */
    public SysAudioRecords selectSysAudioRecordsById(Long id);

    /**
     * 查询文件录音列表
     * 
     * @param sysAudioRecords 文件录音
     * @return 文件录音集合
     */
    public List<SysAudioRecords> selectSysAudioRecordsList(SysAudioRecords sysAudioRecords);

    /**
     * 新增文件录音
     * 
     * @param sysAudioRecords 文件录音
     * @return 结果
     */
    public int insertSysAudioRecords(SysAudioRecords sysAudioRecords);


    public int batchInsertSysAudioRecords(@Param("sysAudioRecords") List<SysAudioRecords> sysAudioRecords);
    /**
     * 修改文件录音
     * 
     * @param sysAudioRecords 文件录音
     * @return 结果
     */
    public int updateSysAudioRecords(SysAudioRecords sysAudioRecords);

    /**
     * 删除文件录音
     * 
     * @param id 文件录音主键
     * @return 结果
     */
    public int deleteSysAudioRecordsById(Long id);

    /**
     * 批量删除文件录音
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysAudioRecordsByIds(Long[] ids);
}
