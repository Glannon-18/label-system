package com.ruoyi.web.controller.system;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.ruoyi.system.domain.SysTaskPackage;
import com.ruoyi.system.service.ISysTaskPackageService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 任务包Controller
 * 
 * @author ruoyi
 * @date 2025-10-02
 */
@RestController
@RequestMapping("/system/package")
public class SysTaskPackageController extends BaseController
{
    @Autowired
    private ISysTaskPackageService sysTaskPackageService;

    /**
     * 查询任务包列表
     */
    @PreAuthorize("@ss.hasPermi('system:package:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysTaskPackage sysTaskPackage)
    {
        startPage();
        List<SysTaskPackage> list = sysTaskPackageService.selectSysTaskPackageList(sysTaskPackage);
        return getDataTable(list);
    }

    /**
     * 导出任务包列表
     */
    @PreAuthorize("@ss.hasPermi('system:package:export')")
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
    @PreAuthorize("@ss.hasPermi('system:package:query')")
    @GetMapping(value = "/{taskPackageId}")
    public AjaxResult getInfo(@PathVariable("taskPackageId") Long taskPackageId)
    {
        return success(sysTaskPackageService.selectSysTaskPackageByTaskPackageId(taskPackageId));
    }

    /**
     * 新增任务包
     */
    @PreAuthorize("@ss.hasPermi('system:package:add')")
    @Log(title = "任务包", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysTaskPackage sysTaskPackage)
    {
        sysTaskPackage.setCreateBy(getUsername());
        return toAjax(sysTaskPackageService.insertSysTaskPackage(sysTaskPackage));
    }

    /**
     * 修改任务包
     */
    @PreAuthorize("@ss.hasPermi('system:package:edit')")
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
    @PreAuthorize("@ss.hasPermi('system:package:remove')")
    @Log(title = "任务包", businessType = BusinessType.DELETE)
	@DeleteMapping("/{taskPackageIds}")
    public AjaxResult remove(@PathVariable Long[] taskPackageIds)
    {
        return toAjax(sysTaskPackageService.deleteSysTaskPackageByTaskPackageIds(taskPackageIds));
    }
}
