package com.ruoyi.web.controller.label;

import java.util.List;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.utils.DateUtils;
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
import com.ruoyi.label.domain.SysAudioRecords;
import com.ruoyi.label.service.ISysAudioRecordsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 文件录音Controller
 * 
 * @author ruoyi
 * @date 2025-10-15
 */
@RestController
@RequestMapping("/label/records")
public class SysAudioRecordsController extends BaseController
{
    @Autowired
    private ISysAudioRecordsService sysAudioRecordsService;

    /**
     * 查询文件录音列表
     */
    @PreAuthorize("@ss.hasPermi('system:records:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysAudioRecords sysAudioRecords)
    {
        startPage();
        List<SysAudioRecords> list = sysAudioRecordsService.selectSysAudioRecordsList(sysAudioRecords);
        return getDataTable(list);
    }

    /**
     * 导出文件录音列表
     */
    @PreAuthorize("@ss.hasPermi('system:records:export')")
    @Log(title = "文件录音", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysAudioRecords sysAudioRecords)
    {
        List<SysAudioRecords> list = sysAudioRecordsService.selectSysAudioRecordsList(sysAudioRecords);
        ExcelUtil<SysAudioRecords> util = new ExcelUtil<SysAudioRecords>(SysAudioRecords.class);
        util.exportExcel(response, list, "文件录音数据");
    }

    /**
     * 获取文件录音详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:records:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(sysAudioRecordsService.selectSysAudioRecordsById(id));
    }

    /**
     * 新增文件录音
     */
    @PreAuthorize("@ss.hasPermi('system:records:add')")
    @Log(title = "文件录音", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody List<SysAudioRecords> sysAudioRecords)
    {
        sysAudioRecords.forEach(item -> {
            item.setCreateTime(DateUtils.getNowDate());
            item.setCreateBy(getUsername());

        });

        return toAjax(sysAudioRecordsService.batchInsertSysAudioRecords(sysAudioRecords));
    }

    /**
     * 修改文件录音
     */
    @PreAuthorize("@ss.hasPermi('system:records:edit')")
    @Log(title = "文件录音", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysAudioRecords sysAudioRecords)
    {
        return toAjax(sysAudioRecordsService.updateSysAudioRecords(sysAudioRecords));
    }

    /**
     * 删除文件录音
     */
    @PreAuthorize("@ss.hasPermi('system:records:remove')")
    @Log(title = "文件录音", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(sysAudioRecordsService.deleteSysAudioRecordsByIds(ids));
    }
}
