package com.ruoyi.label.mapper;

import com.ruoyi.label.domain.SysTaskPackage;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

/**
 * 任务包Mapper接口
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@Mapper
public interface SysTaskPackageMapper 
{
    /**
     * 查询任务包
     * 
     * @param taskPackageId 任务包主键
     * @return 任务包
     */
    public SysTaskPackage selectSysTaskPackageByTaskPackageId(Long taskPackageId);

    /**
     * 查询任务包列表
     * 
     * @param sysTaskPackage 任务包
     * @return 任务包集合
     */
    public List<SysTaskPackage> selectSysTaskPackageList(SysTaskPackage sysTaskPackage);

    /**
     * 新增任务包
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    public int insertSysTaskPackage(SysTaskPackage sysTaskPackage);

    /**
     * 修改任务包
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    public int updateSysTaskPackage(SysTaskPackage sysTaskPackage);

    /**
     * 删除任务包
     * 
     * @param taskPackageId 任务包主键
     * @return 结果
     */
    public int deleteSysTaskPackageByTaskPackageId(Long taskPackageId);

    /**
     * 批量删除任务包
     * 
     * @param taskPackageIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSysTaskPackageByTaskPackageIds(Long[] taskPackageIds);
}