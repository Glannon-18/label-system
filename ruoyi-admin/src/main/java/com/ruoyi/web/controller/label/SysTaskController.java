package com.ruoyi.web.controller.label;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.sound.sampled.UnsupportedAudioFileException;

import com.ruoyi.common.constant.TaskStatus;
import com.ruoyi.common.utils.DateUtils;
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
     * 批量下载任务文件
     */
    @Log(title = "任务", businessType = BusinessType.EXPORT)
    @PostMapping("/download")
    public void downloadTasks(@RequestBody Long[] taskIds, HttpServletResponse response) throws IOException {
        List<SysTask> tasks = sysTaskService.selectSysTaskListByTaskIds(taskIds);
        
        response.setContentType("application/zip");
        response.setHeader("Content-Disposition", "attachment; filename=tasks.zip");
        
        try (ZipOutputStream zipOut = new ZipOutputStream(response.getOutputStream())) {
            for (SysTask task : tasks) {
                // 添加WAV文件到ZIP
                if (task.getAudioFilePath() != null && !task.getAudioFilePath().isEmpty()) {
                    File wavFile = new File(RuoYiConfig.getProfile(), task.getAudioFilePath().replaceFirst("/profile",""));
                    if (wavFile.exists()) {
                        // 为避免文件名冲突，添加任务ID作为前缀
                        String uniqueAudioFileName = task.getTaskId() + "_" + task.getAudioFileName();
                        zipOut.putNextEntry(new ZipEntry(uniqueAudioFileName));
                        java.nio.file.Files.copy(wavFile.toPath(), zipOut);
                        zipOut.closeEntry();
                    }
                }
                
                // 添加TextGrid文件到ZIP
                if (task.getTextGrid() != null && !task.getTextGrid().isEmpty()) {
                    // 为避免文件名冲突，添加任务ID作为前缀
                    String textGridFileName = task.getTaskId() + "_" + task.getAudioFileName().replaceAll("\\.wav$", ".TextGrid");
                    zipOut.putNextEntry(new ZipEntry(textGridFileName));
                    zipOut.write(task.getTextGrid().getBytes(StandardCharsets.UTF_8));
                    zipOut.closeEntry();
                }
            }
        }
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
    public AjaxResult add(@RequestPart("sysTask") SysTask sysTask, 
                          @RequestPart("wavFile") MultipartFile wavFile, 
                          @RequestPart("textGridFile") MultipartFile textGridFile) throws IOException
    {
        if (wavFile != null) {
            // 保存WAV文件并获取访问路径
            String filePath = FileUploadUtils.upload(RuoYiConfig.getUploadPath(), wavFile);
            
            // 设置任务属性
            sysTask.setAudioFileName(wavFile.getOriginalFilename());
            sysTask.setAudioFilePath(filePath);
        }
        
        if (textGridFile != null) {
            // 读取TextGrid文件内容
            StringBuilder textGridContent = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(textGridFile.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    textGridContent.append(line).append("\n");
                }
            }
            
            // 设置TextGrid内容
            sysTask.setTextGrid(textGridContent.toString());
            sysTask.setOriginalTextGrid(textGridContent.toString());
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
    public AjaxResult edit(@RequestPart("sysTask") SysTask sysTask, 
                          @RequestPart(value = "wavFile", required = false) MultipartFile wavFile, 
                          @RequestPart(value = "textGridFile", required = false) MultipartFile textGridFile) throws IOException
    {
        // 获取更新前的任务信息
        SysTask oldTask = sysTaskService.selectSysTaskByTaskId(sysTask.getTaskId());
        
        if (wavFile != null) {
            // 保存WAV文件并获取访问路径
            String filePath = FileUploadUtils.upload(RuoYiConfig.getUploadPath(), wavFile);
            
            // 设置任务属性
            sysTask.setAudioFileName(wavFile.getOriginalFilename());
            sysTask.setAudioFilePath(filePath);
        }
        
        if (textGridFile != null) {
            // 读取TextGrid文件内容
            StringBuilder textGridContent = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(textGridFile.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    textGridContent.append(line).append("\n");
                }
            }
            
            // 设置TextGrid内容
            sysTask.setTextGrid(textGridContent.toString());
            sysTask.setOriginalTextGrid(textGridContent.toString());
        }
        
        sysTask.setUpdateBy(getUsername());
        
        // 检查状态是否发生变化，如果变化则记录日志
        if (sysTask.getStatus() != null && !sysTask.getStatus().equals(oldTask.getStatus())) {
            SysTaskLogUtils.insertSysTaskLog(sysTask.getTaskId(), sysTask.getStatus(), getUsername(), null);
        }
        //如果审核通过，则设置通过时间
        if (sysTask.getStatus() != null && sysTask.getStatus().equals(TaskStatus.PASS)) {
            sysTask.setPassTime(DateUtils.getNowDate());
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
        // 获取审计员为当前登录用户
        String auditor = getUsername();
        List<SysTask> list = sysTaskService.selectAuditorTaskList(sysTask, auditor);
        return getDataTable(list);
    }
    
    /**
     * 查询当前用户创建的任务列表
     */
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/creator/list")
    public TableDataInfo creatorList(SysTask sysTask)
    {
        startPage();
        // 获取创建者为当前登录用户
        sysTask.setCreateBy(getUsername());
        List<SysTask> list = sysTaskService.selectSysTaskList(sysTask);
        return getDataTable(list);
    }
}