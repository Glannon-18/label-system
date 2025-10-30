package com.ruoyi.web.controller.label;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.label.service.ISysTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 领导者任务统计Controller
 * 
 * @author ruoyi
 * @date 2025-10-30
 */
@RestController
@RequestMapping("/label/leader")
public class SysLeaderController extends BaseController
{
    @Autowired
    private ISysTaskService sysTaskService;

    /**
     * 统计label_worker角色用户各种状态的任务数量
     */
    @GetMapping("/taskStatistics")
    public AjaxResult getTaskStatistics() {

        Long deptId = getLoginUser().getDeptId();
        // 获取当前用户部门下label_worker用户创建的任务统计
        List<Map<String, Object>> taskStats = sysTaskService.getTaskStatisticsByDeptId(deptId);
        
        return AjaxResult.success(taskStats);
    }
}