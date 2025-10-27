<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2>{{ $t('label.task.task_package_name') }}：{{ taskPackageName }}</h2>
      </el-col>
    </el-row>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.task.task_status')" prop="status" label-width="auto">
        <el-select v-model="queryParams.status" :placeholder="$t('label.task.select_task_package_status')" clearable style="width: 120px;">
          <el-option
            v-for="dict in task_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.task.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.task.reset') }}</el-button>
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
        >{{ $t('label.task.add') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['label:project:edit']"
        >{{ $t('label.task.edit') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['label:project:remove']"
        >{{ $t('label.task.remove') }}</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
<!--      <el-table-column label="任务ID" align="center" prop="taskId" />-->
      <el-table-column :label="$t('label.task.audio_file_name')" align="center" prop="audioFileName">
        <template #default="scope">
          <el-link @click="handleToAnnotator(scope.row)" type="primary">{{ scope.row.audioFileName }}</el-link>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.task.task_status_col')" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="task_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
<!--      <el-table-column label="分配人账户名" align="center" prop="annotator" />-->
<!--      <el-table-column label="审核人员账户名" align="center" prop="auditor" />-->
      <el-table-column :label="$t('label.task.creator')" align="center" prop="createBy" />
      <el-table-column :label="$t('label.task.create_time')" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.task.remark')" align="center" prop="remark" />
      <el-table-column :label="$t('label.task.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['label:project:edit']">{{ $t('label.task.edit_btn') }}</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['label:project:remove']">{{ $t('label.task.delete_btn') }}</el-button>
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
        <el-form-item :label="$t('label.task.audio_file_name_label')" prop="audioFileName">
          <el-upload
            ref="wavUploadRef"
            :limit="1"
            :auto-upload="false"
            :on-change="(file, fileList) => handleFileChange(file, fileList, 'wav')"
            :on-exceed="handleFileExceed"
            :file-list="wavFileList"
            accept=".wav,.WAV"
          >
            <el-button type="primary">{{ $t('label.task.select_wav_file') }}</el-button>
            <template #tip>
              <div class="el-upload__tip">
                {{ $t('label.task.wav_file_tip') }}
              </div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item :label="$t('label.task.textgrid_file_label')" prop="textGridFileName">
          <el-upload
            ref="textGridUploadRef"
            :limit="1"
            :auto-upload="false"
            :on-change="(file, fileList) => handleFileChange(file, fileList, 'textGrid')"
            :on-exceed="handleFileExceed"
            :file-list="textGridFileList"
            accept=".TextGrid,.textgrid"
          >
            <el-button type="primary">{{ $t('label.task.select_textgrid_file') }}</el-button>
            <template #tip>
              <div class="el-upload__tip">
                {{ $t('label.task.textgrid_file_tip') }}
              </div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item :label="$t('label.task.remark')" prop="remark">
          <el-input v-model="form.remark" type="textarea" :placeholder="$t('label.task.enter_remark')" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">{{ $t('label.task.add') === title ? $t('label.task.add') : $t('label.task.edit') }}</el-button>
          <el-button @click="cancel">{{ $t('label.task.reset') }}</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Task">
import { listTask, getTask, delTask, addTask, updateTask } from "@/api/label/task"
import { getPackage } from "@/api/label/package"
import { computed } from 'vue'
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
    taskPackageId: taskPackageId  // 添加任务包ID作为查询条件
  },
  rules: {

  }
})

const { queryParams, form, rules } = toRefs(data)
const wavFile = ref(null)
const textGridFile = ref(null)
const wavFileList = ref([]) // 用于存储WAV文件列表
const textGridFileList = ref([]) // 用于存储TextGrid文件列表
const taskPackage = ref(null)
const fileSuffix = computed(() => {
  return taskPackage.value && taskPackage.value.type === 'audio' ? '.xlsx' : '.wav'
})

// 文件选择处理
function handleFileChange(file, fileList, type) {
  if (type === 'wav') {
    wavFile.value = file.raw
    // 确保WAV文件后缀名兼容大小写
    let fileName = file.raw.name
    if (fileName.toLowerCase().endsWith('.wav')) {
      // 如果是WAV文件，保持原文件名不变
      form.value.audioFileName = fileName
    } else {
      // 不是WAV文件的情况已经在文件选择器中被过滤，这里只是额外的安全检查
      form.value.audioFileName = fileName
    }
    wavFileList.value = fileList
  } else if (type === 'textGrid') {
    textGridFile.value = file.raw
    // 确保TextGrid文件后缀名兼容大小写
    let fileName = file.raw.name
    if (fileName.toLowerCase().endsWith('.textgrid')) {
      // 如果是TextGrid文件，保持原文件名不变
      form.value.textGridFileName = fileName
    } else {
      // 不是TextGrid文件的情况已经在文件选择器中被过滤，这里只是额外的安全检查
      form.value.textGridFileName = fileName
    }
    textGridFileList.value = fileList
  }
}

// 文件超出限制处理
function handleFileExceed(files, fileList) {
  proxy.$modal.msgWarning(proxy.$t("label.task.only_one_file_allowed"))
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
    textGridFileName: null,
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
  wavFile.value = null
  textGridFile.value = null
  wavFileList.value = []
  textGridFileList.value = []
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
  title.value = proxy.$t("label.task.add_task")
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
      wavFileList.value = [{
        name: response.data.audioFileName,
        url: response.data.audioFilePath
      }]
    }
    open.value = true
    title.value = proxy.$t("label.task.edit_task")
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["taskRef"].validate(valid => {
    if (valid) {
      if (form.value.taskId != null) {
        // 更新操作
        // 如果没有新文件但有原文件，则允许更新
        if (!wavFile.value && wavFileList.value.length === 0) {
          proxy.$modal.msgWarning(proxy.$t("label.task.select_wav_file_warning"));
          return;
        }
        
        // 构造FormData对象，确保总是发送multipart/form-data请求
        const formData = new FormData();
        // 添加sysTask部分（JSON字符串）
        formData.append("sysTask", new Blob([JSON.stringify(form.value)], { type: "application/json" }));
        
        // 如果有新文件则添加文件部分
        if (wavFile.value) {
          formData.append("wavFile", wavFile.value);
        }
        
        if (textGridFile.value) {
          formData.append("textGridFile", textGridFile.value);
        }
        
        // 使用修改后的API接口上传任务和文件
        updateTask(formData).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.task.update_success"));
          open.value = false;
          getList();
        }).catch(error => {
          console.error(error);
          proxy.$modal.msgError(proxy.$t("label.task.update_failed", { error: error.message || proxy.$t("common.unknown_error") }));
        });
      } else {
        // 新增操作
        if (!wavFile.value) {
          proxy.$modal.msgWarning(proxy.$t("label.task.select_wav_file_warning"));
          return;
        }
        
        if (!textGridFile.value) {
          proxy.$modal.msgWarning(proxy.$t("label.task.select_textgrid_file_warning"));
          return;
        }
        
        // 创建FormData对象用于文件上传
        const formData = new FormData();
        formData.append("wavFile", wavFile.value);
        formData.append("textGridFile", textGridFile.value);
        // 添加sysTask部分（JSON字符串）
        formData.append("sysTask", new Blob([JSON.stringify({...form.value, packageId: taskPackageId})], { type: "application/json" }));
        
        // 使用修改后的API接口上传任务和文件
        addTask(formData).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.task.add_success"));
          open.value = false;
          getList();
        }).catch(error => {
          console.error(error);
          proxy.$modal.msgError(proxy.$t("label.task.add_failed", { error: error.message || proxy.$t("common.unknown_error") }));
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _taskIds = row.taskId || ids.value
  proxy.$modal.confirm(proxy.$t('label.task.confirm_remove', { id: _taskIds })).then(function() {
    return delTask(_taskIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess(proxy.$t("label.task.remove_success"))
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
    proxy.$router.push(`/label/view-audio-recorder/index/${taskPackageId}/${taskPackageName}/${taskId}`)
  }else{
    proxy.$router.push(`/label/view-label/index/${taskPackageId}/${taskPackageName}/${taskId}`)
  }
}

getPackage(taskPackageId).then(response => {
  taskPackage.value = response.data
})
getList()


</script>