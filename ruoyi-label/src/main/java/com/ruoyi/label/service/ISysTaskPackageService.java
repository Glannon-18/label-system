package com.ruoyi.label.service;

import com.ruoyi.label.domain.SysTaskPackage;

import java.util.List;

/**
 * 任务包Service接口
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
public interface ISysTaskPackageService 
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
     * 分配任务包给用户
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    public int assignSysTaskPackageToUser(SysTaskPackage sysTaskPackage);

    /**
     * 批量删除任务包
     * 
     * @param taskPackageIds 需要删除的任务包主键集合
     * @return 结果
     */
    public int deleteSysTaskPackageByTaskPackageIds(Long[] taskPackageIds);

    /**
     * 删除任务包信息
     * 
     * @param taskPackageId 任务包主键
     * @return 结果
     */
    public int deleteSysTaskPackageByTaskPackageId(Long taskPackageId);
}