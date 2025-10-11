package com.ruoyi.web.controller.label;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.constant.TaskPackageStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.label.domain.SysTaskPackage;
import com.ruoyi.label.service.ISysTaskPackageService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.common.core.domain.entity.SysUser;

/**
 * 任务包Controller
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@RestController
@RequestMapping("/label/package")
public class SysTaskPackageController extends BaseController
{
    @Autowired
    private ISysTaskPackageService sysTaskPackageService;
    
    @Autowired
    private ISysUserService sysUserService;

    /**
     * 查询任务包列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysTaskPackage sysTaskPackage)
    {
        startPage();
        List<SysTaskPackage> list = sysTaskPackageService.selectSysTaskPackageList(sysTaskPackage);
        return getDataTable(list);
    }
    
    /**
     * 查询分配给当前用户的所有任务包列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/assigner/list")
    public TableDataInfo listByAssigner(SysTaskPackage sysTaskPackage)
    {
        startPage();
        // 设置查询条件为当前登录用户
        sysTaskPackage.setAssigner(getUsername());
        List<SysTaskPackage> list = sysTaskPackageService.selectSysTaskPackageListByAssigner(sysTaskPackage);
        return getDataTable(list);
    }
    
    /**
     * 查询可用于任务包分配的用户列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/users")
    public AjaxResult getUserForPackage(String userName, String nickName)
    {
        List<SysUser> users = sysUserService.selectUserForPackage(userName, nickName);
        return AjaxResult.success(users);
    }
    
    /**
     * 分配任务包给用户
     */
    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "任务包", businessType = BusinessType.UPDATE)
    @PostMapping("/assign")
    public AjaxResult assignPackageToUser(@RequestBody SysTaskPackage sysTaskPackage)
    {
        // 设置更新者
        sysTaskPackage.setUpdateBy(getUsername());
        sysTaskPackage.setStatus(TaskPackageStatus.ALLOCATED);
        // 更新任务包的分配者和状态
        return toAjax(sysTaskPackageService.assignSysTaskPackageToUser(sysTaskPackage));
    }

    /**
     * 导出任务包列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:export')")
    @Log(title = "任务包", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysTaskPackage sysTaskPackage)
    {
        List<SysTaskPackage> list = sysTaskPackageService.selectSysTaskPackageList(sysTaskPackage);
        ExcelUtil<SysTaskPackage> util = new ExcelUtil<SysTaskPackage>(SysTaskPackage.class);
        util.exportExcel(response, list, "任务包数据");
    }

    /**
     * 获取任务包详细信息
     */
    @PreAuthorize("@ss.hasPermi('label:project:query')")
    @GetMapping(value = "/{taskPackageId}")
    public AjaxResult getInfo(@PathVariable("taskPackageId") Long taskPackageId)
    {
        return success(sysTaskPackageService.selectSysTaskPackageByTaskPackageId(taskPackageId));
    }

    /**
     * 新增任务包
     */
    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "任务包", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysTaskPackage sysTaskPackage)
    {
        sysTaskPackage.setCreateBy(getUsername());
        sysTaskPackage.setStatus(TaskPackageStatus.UNALLOCATED);
        return toAjax(sysTaskPackageService.insertSysTaskPackage(sysTaskPackage));
    }

    /**
     * 修改任务包
     */
    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "任务包", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysTaskPackage sysTaskPackage)
    {
        sysTaskPackage.setUpdateBy(getUsername());
        return toAjax(sysTaskPackageService.updateSysTaskPackage(sysTaskPackage));
    }

    /**
     * 删除任务包
     */
    @PreAuthorize("@ss.hasPermi('label:project:remove')")
    @Log(title = "任务包", businessType = BusinessType.DELETE)
	@DeleteMapping("/{taskPackageIds}")
    public AjaxResult remove(@PathVariable Long[] taskPackageIds)
    {
        return toAjax(sysTaskPackageService.deleteSysTaskPackageByTaskPackageIds(taskPackageIds));
    }
}