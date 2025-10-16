package com.ruoyi.web.controller.label;

import java.util.List;

import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.mapper.SysTaskMapper;
import com.ruoyi.label.utils.SysTaskLogUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.label.domain.SysTaskLog;
import com.ruoyi.label.service.ISysTaskLogService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 任务日志Controller
 *
 * @author ruoyi
 * @date 2025-10-16
 */
@RestController
@RequestMapping("/label/log")
public class SysTaskLogController extends BaseController {
    @Autowired
    private ISysTaskLogService sysTaskLogService;

    /**
     * 查询任务日志列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysTaskLog sysTaskLog) {
        startPage();
        List<SysTaskLog> list = sysTaskLogService.selectSysTaskLogList(sysTaskLog);
        return getDataTable(list);
    }

}