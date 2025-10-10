package com.ruoyi.web.controller.label;

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
import com.ruoyi.label.domain.SysProject;
import com.ruoyi.label.service.ISysProjectService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/*
 * 项目Controller
 * 
 * @author ruoyi
 * @date 2025-09-30
 */
@RestController
@RequestMapping("/label/project")
public class SysProjectController extends BaseController
{
    @Autowired
    private ISysProjectService sysProjectService;

    /**
     * 查询项目列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysProject sysProject)
    {
        startPage();
        List<SysProject> list = sysProjectService.selectSysProjectList(sysProject);
        return getDataTable(list);
    }

    /**
     * 导出项目列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:export')")
    @Log(title = "项目", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysProject sysProject)
    {
        List<SysProject> list = sysProjectService.selectSysProjectList(sysProject);
        ExcelUtil<SysProject> util = new ExcelUtil<SysProject>(SysProject.class);
        util.exportExcel(response, list, "项目数据");
    }

    /**
     * 获取项目详细信息
     */
    @PreAuthorize("@ss.hasPermi('label:project:query')")
    @GetMapping(value = "/{projectId}")
    public AjaxResult getInfo(@PathVariable("projectId") Long projectId)
    {
        return success(sysProjectService.selectSysProjectByProjectId(projectId));
    }

    /**
     * 新增项目
     */
    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "项目", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysProject sysProject)
    {
        sysProject.setCreateBy(getUsername());
        return toAjax(sysProjectService.insertSysProject(sysProject));
    }

    /**
     * 修改项目
     */
    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "项目", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysProject sysProject)
    {
        sysProject.setUpdateBy(getUsername());
        return toAjax(sysProjectService.updateSysProject(sysProject));
    }

    /**
     * 删除项目
     */
    @PreAuthorize("@ss.hasPermi('label:project:remove')")
    @Log(title = "项目", businessType = BusinessType.DELETE)
	@DeleteMapping("/{projectIds}")
    public AjaxResult remove(@PathVariable Long[] projectIds)
    {
        return toAjax(sysProjectService.deleteSysProjectByProjectIds(projectIds));
    }
}
