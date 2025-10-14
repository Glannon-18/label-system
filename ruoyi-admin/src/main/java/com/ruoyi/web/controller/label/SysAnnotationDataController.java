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
import com.ruoyi.label.domain.SysAnnotationData;
import com.ruoyi.label.service.ISysAnnotationDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 标注数据Controller
 * 
 * @author ruoyi
 * @date 2025-10-14
 */
@RestController
@RequestMapping("/label/data")
public class SysAnnotationDataController extends BaseController
{
    @Autowired
    private ISysAnnotationDataService sysAnnotationDataService;

    /**
     * 查询标注数据列表
     */
    @PreAuthorize("@ss.hasPermi('label:data:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysAnnotationData sysAnnotationData)
    {
        startPage();
        List<SysAnnotationData> list = sysAnnotationDataService.selectSysAnnotationDataList(sysAnnotationData);
        return getDataTable(list);
    }

    /**
     * 导出标注数据列表
     */
    @PreAuthorize("@ss.hasPermi('label:data:export')")
    @Log(title = "标注数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysAnnotationData sysAnnotationData)
    {
        List<SysAnnotationData> list = sysAnnotationDataService.selectSysAnnotationDataList(sysAnnotationData);
        ExcelUtil<SysAnnotationData> util = new ExcelUtil<SysAnnotationData>(SysAnnotationData.class);
        util.exportExcel(response, list, "标注数据数据");
    }

    /**
     * 获取标注数据详细信息
     */
    @PreAuthorize("@ss.hasPermi('label:data:query')")
    @GetMapping(value = "/{dataId}")
    public AjaxResult getInfo(@PathVariable("dataId") String dataId)
    {
        return success(sysAnnotationDataService.selectSysAnnotationDataByDataId(dataId));
    }

    /**
     * 新增标注数据
     */
    @PreAuthorize("@ss.hasPermi('label:data:add')")
    @Log(title = "标注数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysAnnotationData sysAnnotationData)
    {
        return toAjax(sysAnnotationDataService.insertSysAnnotationData(sysAnnotationData));
    }

    /**
     * 修改标注数据
     */
    @PreAuthorize("@ss.hasPermi('label:data:edit')")
    @Log(title = "标注数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysAnnotationData sysAnnotationData)
    {
        return toAjax(sysAnnotationDataService.updateSysAnnotationData(sysAnnotationData));
    }

    /**
     * 删除标注数据
     */
    @PreAuthorize("@ss.hasPermi('label:data:remove')")
    @Log(title = "标注数据", businessType = BusinessType.DELETE)
	@DeleteMapping("/{dataIds}")
    public AjaxResult remove(@PathVariable String[] dataIds)
    {
        return toAjax(sysAnnotationDataService.deleteSysAnnotationDataByDataIds(dataIds));
    }
}
