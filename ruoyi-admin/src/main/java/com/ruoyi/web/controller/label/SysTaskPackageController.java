package com.ruoyi.web.controller.label;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import javax.servlet.http.HttpServletResponse;

import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.label.utils.SysTaskLogUtils;
import com.ruoyi.common.utils.audio.AudioUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.constant.TaskPackageStatus;
import com.ruoyi.common.constant.TaskStatus;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.label.domain.SysTask;
import com.ruoyi.label.domain.SysTaskPackage;
import com.ruoyi.label.service.ISysTaskPackageService;
import com.ruoyi.label.service.ISysTaskService;
import com.ruoyi.system.service.ISysUserService;

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
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @GetMapping("/users")
    public AjaxResult getUserForPackage(String userName, String nickName, String roleKey, String language) {
        List<SysUser> users = sysUserService.selectUserForPackage(userName, nickName, roleKey, language);
        return AjaxResult.success(users);
    }

    /**
     * 导出任务包列表
     */
//    @PreAuthorize("@ss.hasPermi('label:project:export')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:query')")
    @GetMapping(value = "/{taskPackageId}")
    public AjaxResult getInfo(@PathVariable("taskPackageId") Long taskPackageId)
    {
        return success(sysTaskPackageService.selectSysTaskPackageByTaskPackageId(taskPackageId));
    }

    /**
     * 新增任务包
     */
//    @PreAuthorize("@ss.hasPermi('label:project:add')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:edit')")
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
//    @PreAuthorize("@ss.hasPermi('label:project:remove')")
    @Log(title = "任务包", businessType = BusinessType.DELETE)
	@DeleteMapping("/{taskPackageIds}")
    public AjaxResult remove(@PathVariable Long[] taskPackageIds)
    {
        // 检查每个任务包是否包含任务
        for (Long taskPackageId : taskPackageIds) {
            if (sysTaskPackageService.hasTaskInPackage(taskPackageId)) {
                return AjaxResult.error("该任务包中含有任务，无法删除");
            }
        }
        return toAjax(sysTaskPackageService.deleteSysTaskPackageByTaskPackageIds(taskPackageIds));
    }

    /**
     * 分配任务包给用户
     */
//    @PreAuthorize("@ss.hasPermi('label:project:edit')")
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
     * 接收任务包
     */
//    @PreAuthorize("@ss.hasPermi('label:project:list')")
    @Log(title = "任务包", businessType = BusinessType.UPDATE)
    @PostMapping("/reception")
    public AjaxResult receptionPackage(@RequestBody SysTaskPackage sysTaskPackage)
    {
        // 设置更新者
        sysTaskPackage.setUpdateBy(getUsername());
        sysTaskPackage.setStatus(TaskPackageStatus.RECEPTION);
        // 更新任务包的状态为已接收
        int rows = sysTaskPackageService.updateSysTaskPackage(sysTaskPackage);
        
        // 将该任务包下的所有任务状态更新为进行中，并记录日志
        if (rows > 0) {
            // 获取该任务包下的所有任务
            List<SysTask> taskList = sysTaskService.selectSysTaskListByPackageId(sysTaskPackage.getTaskPackageId());
            
            // 更新每个任务的状态并记录日志
            SysTask updateTask = new SysTask();
            updateTask.setStatus(TaskStatus.UNDERWAY);
            updateTask.setUpdateBy(getUsername());
            
            for (SysTask task : taskList) {
                updateTask.setTaskId(task.getTaskId());
                sysTaskService.updateSysTask(updateTask);
                SysTaskLogUtils.insertSysTaskLog(task.getTaskId(), TaskStatus.UNDERWAY, getUsername(), null);
            }
        }
        
        return toAjax(rows);
    }
    
    /**
     * 上传任务包
     */
//    @PreAuthorize("@ss.hasPermi('label:project:add')")
    @Log(title = "任务包", businessType = BusinessType.IMPORT)
    @PostMapping("/upload")
    public AjaxResult uploadPackage(@RequestParam("files") MultipartFile[] files, Long projectId, String language) throws Exception
    {
        try {
            // 校验文件数组
            if (files == null || files.length == 0) {
                return AjaxResult.error("文件不能为空");
            }
            
            // 校验文件数量不超过5个
            if (files.length > 5) {
                return AjaxResult.error("最多只能上传5个文件");
            }
            
            // 第一步：预校验所有文件，确保全部符合要求
            Map<MultipartFile, Map<String, String>> validatedFiles = new HashMap<>();
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                
                // 校验单个文件是否为空
                if (file == null || file.isEmpty()) {
                    return AjaxResult.error("第" + (i + 1) + "个文件为空");
                }
                
                // 校验文件格式
                String extension = FileUploadUtils.getExtension(file);
                if (!"zip".equalsIgnoreCase(extension)) {
                    return AjaxResult.error("第" + (i + 1) + "个文件不是zip格式");
                }
                
                // 校验zip文件内容
                Map<String, String> filePairs = validateAndExtractZipFile(file);
                if (filePairs == null) {
                    return AjaxResult.error("第" + (i + 1) + "个zip文件内容不符合要求，请检查是否包含成对的wav和textgrid文件");
                }
                
                // 存储校验通过的文件及其内容映射
                validatedFiles.put(file, filePairs);
            }
            
            // 第二步：所有文件都校验通过后，逐个处理上传
            for (Map.Entry<MultipartFile, Map<String, String>> entry : validatedFiles.entrySet()) {
                MultipartFile file = entry.getKey();
                Map<String, String> filePairs = entry.getValue();
                
                // 创建任务包
                SysTaskPackage taskPackage = new SysTaskPackage();
                String originalFilename = file.getOriginalFilename();
                String packageFileName = originalFilename.substring(0, originalFilename.lastIndexOf("."));
                taskPackage.setName(packageFileName);
                taskPackage.setProjectId(projectId);
                taskPackage.setCreateBy(getUsername());
                taskPackage.setType("text");
                taskPackage.setStatus(TaskPackageStatus.UNALLOCATED);
                taskPackage.setLanguage(language);
                
                // 插入任务包
                sysTaskPackageService.insertSysTaskPackage(taskPackage);
                
                // 为每对文件创建任务
                for (Map.Entry<String, String> filePair : filePairs.entrySet()) {
                    String wavFileName = filePair.getKey();
                    String textGridContent = filePair.getValue();
                    
                    // 上传wav文件
                    String filePath = RuoYiConfig.getUploadPath();
                    // 从zip中提取wav文件内容并创建MultipartFile
                    MultipartFile wavFile = createMultipartFileFromZipEntry(wavFileName, file);
                    String uploadedFileName = FileUploadUtils.upload(filePath, wavFile);
                    
                    // 获取wav文件时长
                    String realPath = RuoYiConfig.getProfile() + uploadedFileName.replaceFirst("/profile", "");
                    Double duration = AudioUtils.getWavDuration(realPath);
                    
                    SysTask task = new SysTask();
                    task.setPackageId(taskPackage.getTaskPackageId());
                    task.setAudioFileName(wavFileName);
                    task.setAudioFilePath(uploadedFileName);
                    task.setTextGrid(textGridContent);
                    task.setOriginalTextGrid(textGridContent);
                    task.setStatus(TaskStatus.UNSTART);
                    task.setCreateBy(getUsername());
                    task.setDuration(duration);
                    
                    sysTaskService.insertSysTask(task);
                    SysTaskLogUtils.insertSysTaskLog(task.getTaskId(), TaskStatus.UNSTART, getUsername(), null);
                }
            }
            
            return AjaxResult.success("所有" + files.length + "个任务包上传成功");
        } catch (Exception e) {
            return AjaxResult.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 下载任务包
     */
    @Log(title = "任务包", businessType = BusinessType.EXPORT)
    @GetMapping("/download/{taskPackageId}")
    public void downloadPackage(@PathVariable Long taskPackageId, HttpServletResponse response) throws IOException {
        try {
            // 获取任务包信息
            SysTaskPackage taskPackage = sysTaskPackageService.selectSysTaskPackageByTaskPackageId(taskPackageId);
            if (taskPackage == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "任务包不存在");
                return;
            }
            
            // 获取任务包下的所有任务
            List<SysTask> taskList = sysTaskService.selectSysTaskListByPackageId(taskPackageId);
            
            // 创建zip文件
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ZipOutputStream zos = new ZipOutputStream(baos);
            
            // 将每个任务的文件添加到zip中
            for (SysTask task : taskList) {
                // 添加wav文件
                String audioFilePath = task.getAudioFilePath();
                if (audioFilePath != null && !audioFilePath.isEmpty()) {
                    // 获取文件实际路径
                    String realPath = RuoYiConfig.getProfile() + audioFilePath.substring(audioFilePath.indexOf("/upload"));
                    File audioFile = new File(realPath);
                    if (audioFile.exists()) {
                        // 添加到zip
                        ZipEntry wavEntry = new ZipEntry(task.getAudioFileName());
                        zos.putNextEntry(wavEntry);
                        
                        // 读取文件内容并写入zip
                        byte[] fileContent = java.nio.file.Files.readAllBytes(audioFile.toPath());
                        zos.write(fileContent, 0, fileContent.length);
                        zos.closeEntry();
                    }
                }
                
                // 添加TextGrid文件
                String textGridContent = task.getTextGrid();
                if (textGridContent != null && !textGridContent.isEmpty()) {
                    String textGridFileName = task.getAudioFileName().substring(0, task.getAudioFileName().lastIndexOf(".")) + ".TextGrid";
                    ZipEntry textGridEntry = new ZipEntry(textGridFileName);
                    zos.putNextEntry(textGridEntry);
                    
                    // 写入TextGrid内容
                    byte[] contentBytes = textGridContent.getBytes(StandardCharsets.UTF_8);
                    zos.write(contentBytes, 0, contentBytes.length);
                    zos.closeEntry();
                }
            }
            
            zos.close();
            
            // 设置响应头
            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment; filename=" + taskPackage.getName() + ".zip");
            
            // 写入响应
            response.getOutputStream().write(baos.toByteArray());
            response.getOutputStream().flush();
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "下载失败: " + e.getMessage());
        }
    }
    
    /**
     * 从ZIP文件中提取指定条目并创建MultipartFile
     * @param entryName 条目名称
     * @param zipFile ZIP文件
     * @return MultipartFile
     * @throws IOException
     */
    private MultipartFile createMultipartFileFromZipEntry(String entryName, MultipartFile zipFile) throws IOException {
        try (ZipInputStream zis = new ZipInputStream(zipFile.getInputStream())) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                if (!entry.isDirectory() && entry.getName().equals(entryName)) {
                    byte[] buffer = readZipEntry(zis);
                    return new InMemoryMultipartFile(entryName, entryName, "audio/wav", buffer);
                }
            }
        }
        throw new IOException("在ZIP文件中找不到条目: " + entryName);
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
    
    /**
     * 内存中的MultipartFile实现
     */
    private static class InMemoryMultipartFile implements MultipartFile {
        private final String name;
        private final String originalFilename;
        private final String contentType;
        private final byte[] content;
        
        public InMemoryMultipartFile(String name, String originalFilename, String contentType, byte[] content) {
            this.name = name;
            this.originalFilename = originalFilename;
            this.contentType = contentType;
            this.content = content;
        }
        
        @Override
        public String getName() {
            return name;
        }
        
        @Override
        public String getOriginalFilename() {
            return originalFilename;
        }
        
        @Override
        public String getContentType() {
            return contentType;
        }
        
        @Override
        public boolean isEmpty() {
            return content == null || content.length == 0;
        }
        
        @Override
        public long getSize() {
            return content.length;
        }
        
        @Override
        public byte[] getBytes() throws IOException {
            return content;
        }
        
        @Override
        public java.io.InputStream getInputStream() throws IOException {
            return new ByteArrayInputStream(content);
        }
        
        @Override
        public void transferTo(java.io.File dest) throws IOException, IllegalStateException {
            try (java.io.FileOutputStream fos = new java.io.FileOutputStream(dest)) {
                fos.write(content);
            }
        }
    }
}