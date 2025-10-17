<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2> 任务包名称：{{ taskPackageName }}</h2>
      </el-col>
    </el-row>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="任务状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择任务状态" clearable style="width: 120px;">
          <el-option
            v-for="dict in task_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['label:project:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['label:project:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['label:project:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['label:project:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
<!--      <el-table-column label="任务ID" align="center" prop="taskId" />-->
      <el-table-column label="音频文件名" align="center" prop="audioFileName">
        <template #default="scope">
          <el-link @click="handleToAnnotator(scope.row)" type="primary">{{ scope.row.audioFileName }}</el-link>
        </template>
      </el-table-column>
      <el-table-column label="任务状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="task_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
<!--      <el-table-column label="分配人账户名" align="center" prop="annotator" />-->
<!--      <el-table-column label="审核人员账户名" align="center" prop="auditor" />-->
      <el-table-column label="创建者" align="center" prop="createBy" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['label:project:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['label:project:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改任务对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="taskRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="音频文件名" prop="audioFileName">
          <el-upload
            ref="uploadRef"
            :limit="1"
            :auto-upload="false"
            :on-change="handleFileChange"
            :on-exceed="handleFileExceed"
            :file-list="fileList"
            accept=".wav"
          >
            <el-button type="primary">选择文件</el-button>
            <template #tip>
              <div class="el-upload__tip">
                请选择.wav格式的音频文件
              </div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item label="任务状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择任务状态">
            <el-option
              v-for="dict in task_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
<!--        <el-form-item label="分配人账户名" prop="annotator">-->
<!--          <el-input v-model="form.annotator" placeholder="请输入分配人账户名" />-->
<!--        </el-form-item>-->
<!--        <el-form-item label="审核人员账户名" prop="auditor">-->
<!--          <el-input v-model="form.auditor" placeholder="请输入审核人员账户名" />-->
<!--        </el-form-item>-->
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Task">
import { listTask, getTask, delTask, addTask, updateTask } from "@/api/label/task"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

const taskList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

// 获取路由参数
const taskPackageId = route.params.taskPackageId
const taskPackageName = route.params.taskPackageName

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    audioFileName: null,
    status: null,
    annotator: null,
    auditor: null,
    createBy: null,
    taskPackageId: taskPackageId  // 添加任务包ID作为查询条件
  },
  rules: {
    packageId: [
      { required: true, message: "所属包的ID不能为空", trigger: "blur" }
    ],
    audioFileName: [
      { required: true, message: "音频文件不能为空", trigger: "change" }
    ],
    audioFilePath: [
      { required: true, message: "音频文件在服务器的路径不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)
const uploadFile = ref(null)
const fileList = ref([]) // 用于存储el-upload的文件列表

// 文件选择处理
function handleFileChange(file, fileList) {
  uploadFile.value = file.raw
  form.value.audioFileName = file.raw.name
  // 更新文件列表
  fileList.value = fileList
}

// 文件超出限制处理
function handleFileExceed(files, fileList) {
  proxy.$modal.msgWarning("只能上传一个文件")
}

/** 查询任务列表 */
function getList() {
  loading.value = true
  // 设置查询条件，根据任务包ID查询任务
  if (taskPackageId) {
    queryParams.value.packageId = taskPackageId
  }
  listTask(queryParams.value).then(response => {
    taskList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

// 取消按钮
function cancel() {
  open.value = false
  reset()
}

// 表单重置
function reset() {
  form.value = {
    taskId: null,
    packageId: null,
    audioFileName: null,
    audioFilePath: null,
    status: null,
    annotator: null,
    auditor: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("taskRef")
  uploadFile.value = null
  fileList.value = []
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.taskId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加任务"
  uploadFile.value = null
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _taskId = row.taskId || ids.value
  getTask(_taskId).then(response => {
    form.value = response.data
    // 如果已有文件，则设置文件列表显示原文件
    if (response.data.audioFileName) {
      fileList.value = [{
        name: response.data.audioFileName,
        url: response.data.audioFilePath
      }]
    }
    open.value = true
    title.value = "修改任务"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["taskRef"].validate(valid => {
    if (valid) {
      if (form.value.taskId != null) {
        // 更新操作
        // 如果没有新文件但有原文件，则允许更新
        if (!uploadFile.value && fileList.value.length === 0) {
          proxy.$modal.msgWarning("请选择音频文件");
          return;
        }
        
        // 构造FormData对象，确保总是发送multipart/form-data请求
        const formData = new FormData();
        // 添加sysTask部分（JSON字符串）
        formData.append("sysTask", new Blob([JSON.stringify(form.value)], { type: "application/json" }));
        
        // 如果有新文件则添加文件部分
        if (uploadFile.value) {
          formData.append("file", uploadFile.value);
        }
        
        // 使用修改后的API接口上传任务和文件
        updateTask(formData).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        }).catch(error => {
          console.error(error);
          proxy.$modal.msgError("更新失败：" + (error.message || "未知错误"));
        });
      } else {
        // 新增操作
        if (!uploadFile.value) {
          proxy.$modal.msgWarning("请选择音频文件");
          return;
        }
        
        // 创建FormData对象用于文件上传
        const formData = new FormData();
        formData.append("file", uploadFile.value);
        // 添加sysTask部分（JSON字符串）
        formData.append("sysTask", new Blob([JSON.stringify({...form.value, packageId: taskPackageId})], { type: "application/json" }));
        
        // 使用修改后的API接口上传任务和文件
        addTask(formData).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        }).catch(error => {
          console.error(error);
          proxy.$modal.msgError("上传失败：" + (error.message || "未知错误"));
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _taskIds = row.taskId || ids.value
  proxy.$modal.confirm('是否确认删除任务编号为"' + _taskIds + '"的数据项？').then(function() {
    return delTask(_taskIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/task/export', {
    ...queryParams.value
  }, `task_${new Date().getTime()}.xlsx`)
}

/** 跳转到标注/录音页面 **/
function handleToAnnotator(row) {
  const taskId = row.taskId
  const type = row.packageType
  if (type === "audio") {
    proxy.$router.push(`/label/audio-recorder/index/${taskId}`)
  }else{
    proxy.$router.push(`/label/audio-annotator/index/${taskId}`)
  }
}
getList()
</script>