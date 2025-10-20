package com.ruoyi.web.controller.label;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import javax.sound.sampled.UnsupportedAudioFileException;

import com.ruoyi.common.constant.TaskStatus;
import com.ruoyi.label.utils.SysTaskLogUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.service.ISysTaskService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.audio.AudioUtils;

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
    

    private static final String INIT_TEXTGRID="File type = \"ooTextFile\"\n" +
            "Object class = \"TextGrid\"\n" +
            "\n" +
            "xmin = 0.0\n" +
            "xmax = %s\n" +
            "tiers? <exists>\n" +
            "size = 1\n" +
            "item []:\n" +
            "    item[1]:\n" +
            "        class = \"IntervalTier\"\n" +
            "        name = \"Subtitle-Tier\"\n" +
            "        xmin = 0.0\n" +
            "        xmax = %s\n" +
            "        intervals: size = 1\n" +
            "        intervals [1]\n" +
            "            xmin = 0.0\n" +
            "            xmax = %s\n" +
            "            text = \"\"";

    /**
     * 查询任务列表
     */
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:export')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:query')")
    @GetMapping(value = "/{taskId}")
    public AjaxResult getInfo(@PathVariable("taskId") Long taskId)
    {
        return success(sysTaskService.selectSysTaskByTaskId(taskId));
    }

    /**
     * 新增任务
     */
//    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestPart("sysTask") SysTask sysTask, @RequestPart(value = "file", required = false) MultipartFile file) throws IOException
    {
        if (file != null) {
            // 保存文件并获取访问路径
            String filePath = FileUploadUtils.upload(RuoYiConfig.getUploadPath(), file);
            
            // 设置任务属性
            sysTask.setAudioFileName(file.getOriginalFilename());
            sysTask.setAudioFilePath(filePath);
            
            // 获取音频时长并格式化TextGrid
            try {
                String absolutePath = RuoYiConfig.getProfile() + filePath.substring(filePath.indexOf("/upload"));
                double duration = AudioUtils.getWavDuration(absolutePath);
                String formattedDuration = String.format("%.3f", duration);
                String textGridContent = String.format(INIT_TEXTGRID, formattedDuration, formattedDuration, formattedDuration);
                sysTask.setTextGrid(textGridContent);
                sysTask.setOriginalTextGrid(textGridContent);
            } catch (UnsupportedAudioFileException e) {
                logger.error("不支持的音频文件格式: {}", file.getOriginalFilename(), e);
                return AjaxResult.error("不支持的音频文件格式");
            }
        }
        sysTask.setCreateBy(getUsername());
        sysTask.setStatus(TaskStatus.UNSTART);
        int rows = sysTaskService.insertSysTask(sysTask);
        SysTaskLogUtils.insertSysTaskLog(sysTask.getTaskId(), TaskStatus.UNSTART, getUsername(), null);
        return toAjax(rows);
    }

    /**
     * 修改任务
     */
//    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestPart("sysTask") SysTask sysTask, @RequestPart(value = "file", required = false) MultipartFile file) throws IOException
    {
        // 获取更新前的任务信息
        SysTask oldTask = sysTaskService.selectSysTaskByTaskId(sysTask.getTaskId());
        
        if (file != null) {
            // 保存文件并获取访问路径
            String filePath = FileUploadUtils.upload(RuoYiConfig.getUploadPath(), file);
            
            // 设置任务属性
            sysTask.setAudioFileName(file.getOriginalFilename());
            sysTask.setAudioFilePath(filePath);
            
            // 获取音频时长并格式化TextGrid
            try {
                String absolutePath = RuoYiConfig.getProfile() + filePath.substring(filePath.indexOf("/upload"));
                double duration = AudioUtils.getWavDuration(absolutePath);
                String formattedDuration = String.format("%.3f", duration);
                String textGridContent = String.format(INIT_TEXTGRID, formattedDuration, formattedDuration, formattedDuration);
                sysTask.setTextGrid(textGridContent);
                sysTask.setOriginalTextGrid(textGridContent);
            } catch (UnsupportedAudioFileException e) {
                logger.error("不支持的音频文件格式: {}", file.getOriginalFilename(), e);
                return AjaxResult.error("不支持的音频文件格式");
            }
        }
        sysTask.setUpdateBy(getUsername());
        
        // 检查状态是否发生变化，如果变化则记录日志
        if (sysTask.getStatus() != null && !sysTask.getStatus().equals(oldTask.getStatus())) {
            SysTaskLogUtils.insertSysTaskLog(sysTask.getTaskId(), sysTask.getStatus(), getUsername(), null);
        }
        
        return toAjax(sysTaskService.updateSysTask(sysTask));
    }

    /**
     * 删除任务
     */
//    @PreAuthorize("@ss.hasPermi('label:project:remove')")
    @Log(title = "任务", businessType = BusinessType.DELETE)
	@DeleteMapping("/{taskIds}")
    public AjaxResult remove(@PathVariable Long[] taskIds)
    {
        return toAjax(sysTaskService.deleteSysTaskByTaskIds(taskIds));
    }
    
    /**
     * 审核任务
     */
//    @PreAuthorize("@ss.hasPermi('label:project:edit')")
    @Log(title = "任务", businessType = BusinessType.UPDATE)
    @PutMapping("/audit")
    public AjaxResult audit(@RequestBody SysTask sysTask)
    {
        sysTask.setUpdateBy(getUsername());
        return toAjax(sysTaskService.auditTask(sysTask));
    }
    
    /**
     * 查询审核员任务列表
     */
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/auditor/list")
    public TableDataInfo auditorList(SysTask sysTask)
    {
        startPage();
        // 设置审计员为当前登录用户
        sysTask.setAuditor(getUsername());
        List<SysTask> list = sysTaskService.selectAuditorTaskList(sysTask);
        return getDataTable(list);
    }
}