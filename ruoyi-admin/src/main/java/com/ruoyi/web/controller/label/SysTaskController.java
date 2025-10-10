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
import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.service.ISysTaskService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 任务Controller
 * 
 * @author ruoyi
 * @date 2025-10-04
 */
@RestController
@RequestMapping("/label/task")
public class SysTaskController extends BaseController
{
    @Autowired
    private ISysTaskService sysTaskService;

    /**
     * 查询任务列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysTask sysTask)
    {
        startPage();
        List<SysTask> list = sysTaskService.selectSysTaskList(sysTask);
        return getDataTable(list);
    }

    /**
     * 导出任务列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:export')")
    @Log(title = "任务", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysTask sysTask)
    {
        List<SysTask> list = sysTaskService.selectSysTaskList(sysTask);
        ExcelUtil<SysTask> util = new ExcelUtil<SysTask>(SysTask.class);
        util.exportExcel(response, list, "任务数据");
    }

    /**
     * 获取任务详细信息
     */
    @PreAuthorize("@ss.hasPermi('label:project:query')")
    @GetMapping(value = "/{taskId}")
    public AjaxResult getInfo(@PathVariable("taskId") Long taskId)
    {
        return success(sysTaskService.selectSysTaskByTaskId(taskId));
    }

    /**
     * 新增任务
     */
    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysTask sysTask)
    {
        sysTask.setCreateBy(getUsername());
        return toAjax(sysTaskService.insertSysTask(sysTask));
    }

    /**
     * 修改任务
     */
    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysTask sysTask)
    {
        sysTask.setUpdateBy(getUsername());
        return toAjax(sysTaskService.updateSysTask(sysTask));
    }

    /**
     * 删除任务
     */
    @PreAuthorize("@ss.hasPermi('label:project:remove')")
    @Log(title = "任务", businessType = BusinessType.DELETE)
	@DeleteMapping("/{taskIds}")
    public AjaxResult remove(@PathVariable Long[] taskIds)
    {
        return toAjax(sysTaskService.deleteSysTaskByTaskIds(taskIds));
    }
}
