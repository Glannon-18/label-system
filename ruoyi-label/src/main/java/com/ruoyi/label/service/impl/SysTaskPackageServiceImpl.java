package com.ruoyi.label.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.label.mapper.SysTaskPackageMapper;
import com.ruoyi.label.domain.SysTaskPackage;
import com.ruoyi.label.service.ISysTaskPackageService;

/**
 * 任务包Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@Service
public class SysTaskPackageServiceImpl implements ISysTaskPackageService 
{
    @Autowired
    private SysTaskPackageMapper sysTaskPackageMapper;

    /**
     * 查询任务包
     * 
     * @param taskPackageId 任务包主键
     * @return 任务包
     */
    @Override
    public SysTaskPackage selectSysTaskPackageByTaskPackageId(Long taskPackageId)
    {
        return sysTaskPackageMapper.selectSysTaskPackageByTaskPackageId(taskPackageId);
    }

    /**
     * 查询任务包列表
     * 
     * @param sysTaskPackage 任务包
     * @return 任务包
     */
    @Override
    public List<SysTaskPackage> selectSysTaskPackageList(SysTaskPackage sysTaskPackage)
    {
        return sysTaskPackageMapper.selectSysTaskPackageList(sysTaskPackage);
    }

    /**
     * 新增任务包
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    @Override
    public int insertSysTaskPackage(SysTaskPackage sysTaskPackage)
    {
        sysTaskPackage.setCreateTime(DateUtils.getNowDate());
        return sysTaskPackageMapper.insertSysTaskPackage(sysTaskPackage);
    }

    /**
     * 修改任务包
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    @Override
    public int updateSysTaskPackage(SysTaskPackage sysTaskPackage)
    {
        sysTaskPackage.setUpdateTime(DateUtils.getNowDate());
        return sysTaskPackageMapper.updateSysTaskPackage(sysTaskPackage);
    }
    
    /**
     * 分配任务包给用户
     * 
     * @param sysTaskPackage 任务包
     * @return 结果
     */
    @Override
    public int assignSysTaskPackageToUser(SysTaskPackage sysTaskPackage)
    {
        // 设置更新时间
        sysTaskPackage.setUpdateTime(DateUtils.getNowDate());
        // 更新任务包的分配者和状态
        return sysTaskPackageMapper.updateSysTaskPackage(sysTaskPackage);
    }

    /**
     * 批量删除任务包
     * 
     * @param taskPackageIds 需要删除的任务包主键
     * @return 结果
     */
    @Override
    public int deleteSysTaskPackageByTaskPackageIds(Long[] taskPackageIds)
    {
        return sysTaskPackageMapper.deleteSysTaskPackageByTaskPackageIds(taskPackageIds);
    }

    /**
     * 删除任务包信息
     * 
     * @param taskPackageId 任务包主键
     * @return 结果
     */
    @Override
    public int deleteSysTaskPackageByTaskPackageId(Long taskPackageId)
    {
        return sysTaskPackageMapper.deleteSysTaskPackageByTaskPackageId(taskPackageId);
    }
}