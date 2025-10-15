package com.ruoyi.web.controller.label;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.constant.TaskPackageStatus;
import com.ruoyi.common.constant.TaskStatus;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.domain.SysTaskPackage;
import com.ruoyi.label.service.ISysTaskPackageService;
import com.ruoyi.label.service.ISysTaskService;
import com.ruoyi.system.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

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
    private ISysTaskService sysTaskService;
    
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
     * 导出任务包列表
     */
    @PreAuthorize("@ss.hasPermi('label:project:export')")
    @Log(title = "任务包", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysTaskPackage sysTaskPackage)
    {
        List<SysTaskPackage> list = sysTaskPackageService.selectSysTaskPackageList(sysTaskPackage);
        com.ruoyi.common.utils.poi.ExcelUtil<SysTaskPackage> util = new com.ruoyi.common.utils.poi.ExcelUtil<SysTaskPackage>(SysTaskPackage.class);
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
     * 上传任务包
     */
    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "任务包", businessType = BusinessType.IMPORT)
    @PostMapping("/upload")
    public AjaxResult uploadPackage(MultipartFile file, Long projectId) throws Exception
    {
        try {
            // 校验文件
            if (file == null || file.isEmpty()) {
                return AjaxResult.error("文件不能为空");
            }
            
            // 校验文件格式
            String extension = FileUploadUtils.getExtension(file);
            if (!"zip".equalsIgnoreCase(extension)) {
                return AjaxResult.error("只允许上传zip格式的文件");
            }
            
            // 校验zip文件内容
            Map<String, String> filePairs = validateAndExtractZipFile(file);
            if (filePairs == null) {
                return AjaxResult.error("文件校验失败，zip文件中wav和TextGrid文件必须成对出现");
            }
            
            // 创建任务包
            SysTaskPackage taskPackage = new SysTaskPackage();
            String originalFilename = file.getOriginalFilename();
            String packageFileName = originalFilename.substring(0, originalFilename.lastIndexOf("."));
            taskPackage.setName(packageFileName);
            taskPackage.setProjectId(projectId);
            taskPackage.setCreateBy(getUsername());
            taskPackage.setStatus(TaskPackageStatus.UNALLOCATED);
            
            // 插入任务包
            sysTaskPackageService.insertSysTaskPackage(taskPackage);
            
            // 为每对文件创建任务
            for (Map.Entry<String, String> entry : filePairs.entrySet()) {
                String wavFileName = entry.getKey();
                String textGridContent = entry.getValue();
                
                SysTask task = new SysTask();
                task.setPackageId(taskPackage.getTaskPackageId());
                task.setAudioFileName(wavFileName);
                task.setTextGrid(textGridContent);
                task.setStatus(TaskStatus.UNSTART);
                task.setCreateBy(getUsername());
                
                sysTaskService.insertSysTask(task);
            }
            
            return AjaxResult.success("上传成功");
        } catch (Exception e) {
            return AjaxResult.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 校验zip文件并提取文件对
     * @param file zip文件
     * @return wav文件名和对应TextGrid内容的映射，如果校验失败返回null
     * @throws IOException
     */
    private Map<String, String> validateAndExtractZipFile(MultipartFile file) throws IOException {
        Map<String, String> wavFiles = new HashMap<>();
        Map<String, String> textGridFiles = new HashMap<>();
        int totalFiles = 0;
        
        try (ZipInputStream zis = new ZipInputStream(file.getInputStream())) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                if (!entry.isDirectory()) {
                    String fileName = entry.getName();
                    String lowerFileName = fileName.toLowerCase();
                    totalFiles++;
                    
                    // 检查文件类型是否合法
                    if (lowerFileName.endsWith(".wav")) {
                        wavFiles.put(fileName, fileName); // 保存wav文件名
                    } else if (lowerFileName.endsWith(".textgrid")) {
                        // 读取TextGrid文件内容
                        byte[] buffer = readZipEntry(zis);
                        String content = new String(buffer, StandardCharsets.UTF_8);
                        textGridFiles.put(fileName, content);
                    } else {
                        // 包含了除wav和textgrid以外的文件，校验失败
                        return null;
                    }
                }
            }
        }
        
        // 检查文件数量是否为偶数
        if (totalFiles == 0 || totalFiles % 2 != 0) {
            return null;
        }
        
        // 检查文件是否成对
        if (wavFiles.size() != textGridFiles.size()) {
            return null;
        }
        
        // 检查每对文件是否匹配
        Map<String, String> filePairs = new HashMap<>();
        for (String wavFile : wavFiles.keySet()) {
            String wavBaseName = getBaseName(wavFile);
            boolean matched = false;
            
            for (String textGridFile : textGridFiles.keySet()) {
                String textGridBaseName = getBaseName(textGridFile);
                if (wavBaseName.equalsIgnoreCase(textGridBaseName)) {
                    filePairs.put(wavFile, textGridFiles.get(textGridFile));
                    matched = true;
                    break;
                }
            }
            
            if (!matched) {
                return null; // 有未匹配的wav文件
            }
        }
        
        return filePairs.size() == wavFiles.size() ? filePairs : null;
    }
    
    /**
     * 从ZipInputStream读取entry内容
     * @param zis ZipInputStream
     * @return entry内容字节数组
     * @throws IOException
     */
    private byte[] readZipEntry(ZipInputStream zis) throws IOException {
        byte[] buffer = new byte[1024];
        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
        int len;
        while ((len = zis.read(buffer)) > 0) {
            baos.write(buffer, 0, len);
        }
        return baos.toByteArray();
    }
    
    /**
     * 获取文件基础名（不包含扩展名）
     * @param fileName 文件名
     * @return 基础名
     */
    private String getBaseName(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(0, lastDotIndex) : fileName;
    }
}