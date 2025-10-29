<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2>{{ $t('label.taskPackage.project') }}：{{ projectName }}</h2>
      </el-col>
    </el-row>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.taskPackage.create_time')" style="width: 308px" label-width="auto">
        <el-date-picker
          v-model="daterangeCreateTime"
          value-format="YYYY-MM-DD"
          type="daterange"
          range-separator="-"
          :start-placeholder="$t('label.project.start_date')"
          :end-placeholder="$t('label.project.end_date')"
        ></el-date-picker>
      </el-form-item>
      <el-form-item :label="$t('label.taskPackage.task_package_name')" prop="name" label-width="auto">
        <el-input
          v-model="queryParams.name"
          :placeholder="$t('label.taskPackage.enter_task_package_name')"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item :label="$t('label.taskPackage.task_package_status')" label-width="auto" prop="status">
        <el-select v-model="queryParams.status" :placeholder="$t('label.taskPackage.select_task_package_status')" clearable style="width: 120px;">
          <el-option
            v-for="dict in package_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.taskPackage.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.taskPackage.reset') }}</el-button>
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
        >{{ $t('label.taskPackage.add') }}</el-button>
      </el-col>

      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['label:project:edit']"
        >{{ $t('label.taskPackage.edit') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['label:project:remove']"
        >{{ $t('label.taskPackage.remove') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="success"
            plain
            icon="Upload"
            @click="handleUpload"
            v-hasPermi="['label:project:add']"
        >{{ $t('label.taskPackage.upload_task_package') }}</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="primary"
            plain
            icon="Download"
            @click="handleDownload"
            v-hasPermi="['label:project:export']"
        >{{ $t('label.taskPackage.download_task_package') }}</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="packageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column :label="$t('label.taskPackage.task_package_name_col')" align="center" prop="name" width="350">
        <template #default="scope">
          <el-link type="primary" @click="goToTask(scope.row)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.language')" align="center" prop="status" >
        <template #default="scope">
          <dict-tag :options="language" :value="scope.row.language" />
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.task_package_status')" align="center" prop="status" >
        <template #default="scope">
          <dict-tag :options="package_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.task_package_type')" align="center" prop="type">
        <template #default="scope">
          <dict-tag :options="package_type" :value="scope.row.type" />
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.assigner')" align="center" prop="assigner" >
        <template #default="scope">
          <span v-if="scope.row.assigner && scope.row.assignerNickName">
            ({{ scope.row.assigner }}){{ scope.row.assignerNickName }}
          </span>
          <span v-else-if="scope.row.assigner">
            {{ scope.row.assigner }}
          </span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.creator')" align="center" prop="createBy" />
      <el-table-column :label="$t('label.taskPackage.create_time')" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.taskPackage.remark')" align="center" prop="remark" />
<!--      <el-table-column label="任务包id" align="center" prop="taskPackageId" />-->


      <el-table-column :label="$t('label.taskPackage.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button 
            link 
            type="primary" 
            icon="Edit" 
            @click="handleUpdate(scope.row)" 
            v-hasPermi="['label:project:edit']"
            :disabled="scope.row.status == 'reception'">
            {{ $t('label.taskPackage.edit_btn') }}
          </el-button>
          <el-button 
            link 
            type="primary" 
            icon="Delete" 
            @click="handleDelete(scope.row)" 
            v-hasPermi="['label:project:remove']"
            :disabled="scope.row.status == 'reception'">
            {{ $t('label.taskPackage.delete_btn') }}
          </el-button>
          <el-button 
            link 
            type="primary"  
            @click="showUser(scope.row)" 
            v-hasPermi="['label:project:edit']"
            :disabled="scope.row.status == 'reception'">
            {{ $t('label.taskPackage.assign_user') }}
          </el-button>
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

    <!-- 添加或修改任务包对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="packageRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item :label="$t('label.taskPackage.task_package_name')" prop="name">
          <el-input v-model="form.name" :placeholder="$t('label.taskPackage.enter_task_package_name')" />
        </el-form-item>

        <el-form-item :label="$t('label.taskPackage.annotation_type')" prop="type">
          <el-select v-model="form.type" :placeholder="$t('label.taskPackage.select_annotation_type')">
            <el-option v-for="item in types" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>

        <el-form-item :label="$t('label.taskPackage.language')" prop="language">
          <el-select v-model="form.language" :placeholder="$t('label.taskPackage.select_language_placeholder')">
            <el-option
              v-for="item in language"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item :label="$t('label.taskPackage.remark')" prop="remark">
          <el-input v-model="form.remark" type="textarea" :placeholder="$t('label.taskPackage.enter_remark')" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">{{ $t('label.taskPackage.add') === title ? $t('label.taskPackage.add') : $t('label.taskPackage.edit') }}</el-button>
          <el-button @click="cancel">{{ $t('label.taskPackage.reset') }}</el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 分配人员对话框 -->
    <el-dialog :title="$t('label.taskPackage.assign_user_title')" v-model="assignUserOpen" width="500px" append-to-body>
      <el-form ref="assignUserRef" :model="assignUserForm" :rules="assignUserRules" label-width="80px">
        <el-form-item :label="$t('label.taskPackage.assign_worker')" prop="assigner">
          <el-select
            v-model="assignUserForm.assigner"
            :placeholder="$t('label.taskPackage.select_assign_worker')"
            style="width: 100%">
            <el-option
              v-for="item in workerList"
              :key="item.userId"
              :label="item.userName + '(' + item.nickName + ')'"
              :value="item.userName">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('label.taskPackage.auditor')" prop="auditor">
          <el-select
            v-model="assignUserForm.auditor"
            :placeholder="$t('label.taskPackage.select_auditor')"
            style="width: 100%">
            <el-option
              v-for="item in auditorList"
              :key="item.userId"
              :label="item.userName + '(' + item.nickName + ')'"
              :value="item.userName">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitAssignUser">{{ $t('label.taskPackage.add') }}</el-button>
          <el-button @click="cancelAssignUser">{{ $t('label.taskPackage.reset') }}</el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 上传任务包对话框 -->
    <el-dialog :title="$t('label.taskPackage.upload_task_package_title')" v-model="uploadOpen" width="500px" append-to-body>
      <el-form ref="uploadRef" :model="uploadForm" :rules="uploadRules" label-width="80px">
        <el-form-item :label="$t('label.taskPackage.zip_file')" prop="file">
          <el-upload
            ref="uploadRef"
            :limit="5"
            :auto-upload="false"
            :on-change="handleFileChange"
            :on-exceed="handleFileExceed"
            accept=".zip"
            multiple
          >
            <el-button type="primary">{{ $t('label.taskPackage.select_file') }}</el-button>
            <template #tip>
              <div class="el-upload__tip">
                {{ $t('label.taskPackage.upload_tip') }}
              </div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item :label="$t('label.taskPackage.language')" prop="language">
          <el-select v-model="uploadForm.language" :placeholder="$t('label.taskPackage.select_language_placeholder')">
            <el-option
              v-for="item in language"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitUpload" :loading="uploadLoading">{{ $t('label.taskPackage.add') }}</el-button>
          <el-button @click="cancelUpload">{{ $t('label.taskPackage.reset') }}</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="project-package">
import { listPackage, getPackage, delPackage, addPackage, updatePackage, getUserForPackage, assignPackageToUser, uploadPackage, downloadPackage } from "@/api/label/package"
import { listTask } from "@/api/label/task"

const { proxy } = getCurrentInstance()
const { package_status } = proxy.useDict('package_status')
const { package_type } = proxy.useDict('package_type')
const { language } = proxy.useDict('language')
const route = useRoute()
const router = useRouter()

const packageList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const daterangeCreateTime = ref([])
const assignUserOpen = ref(false)
const workerList = ref([])  // 安排人员列表
const auditorList = ref([])  // 审核人员列表
const currentRow = ref({})
const uploadOpen = ref(false)
const uploadLoading = ref(false)
const uploadFile = ref([])

const projectId = route.params.projectId
const projectName = route.params.projectName


const types = ref([])

watch(
  package_type,
  (newVal) => {
    if (newVal && newVal.length) {
      types.value = toRaw(newVal)
    }
  },
  { immediate: true }
)


const data = reactive({
  form: {
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null,
    taskPackageId: null,
    projectId: null,
    name: null,
    status: null,
    assigner: null,
    auditor: null,
    type: "文本标注",
    language: null
  },
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    createTime: null,
    name: null,
    status: null,
  },
  rules: {
    name: [
      { required: true, message: proxy.$t("label.taskPackage.task_package_name_not_empty"), trigger: "blur" }
    ],
    type: [
      { required: true, message: proxy.$t("label.taskPackage.annotation_type_not_empty"), trigger: "blur" }
    ],
    language: [
      { required: true, message: proxy.$t("label.taskPackage.language_not_empty"), trigger: "change" }
    ]
  },
  assignUserForm: {

  },
  assignUserRules: {
    assigner: [{ required: true, message: proxy.$t("label.taskPackage.select_worker"), trigger: "change" }],
    auditor: [{ required: true, message: proxy.$t("label.taskPackage.select_auditor_user"), trigger: "change" }]
  },
  uploadRules: {
    // file: [{ required: true, message: proxy.$t("label.taskPackage.select_file_to_upload"), trigger: "change" }],
    language: [{ required: true, message: proxy.$t("label.taskPackage.language_not_empty"), trigger: "change" }]
  },
  uploadForm: {
    file: null,
    language: null
  }
})

const { queryParams, form, rules, assignUserForm, assignUserRules, uploadRules ,uploadForm} = toRefs(data)

data.form.type = "文本标注"


/** 查询任务包列表 */
function getList() {
  loading.value = true
  queryParams.value.params = {}

  if (projectId) {
    queryParams.value.projectId = projectId
  }

  if (null != daterangeCreateTime && '' != daterangeCreateTime) {
    queryParams.value.params["beginCreateTime"] = daterangeCreateTime.value[0]
    queryParams.value.params["endCreateTime"] = daterangeCreateTime.value[1]
  }
  listPackage(queryParams.value).then(response => {
    packageList.value = response.rows
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
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null,
    taskPackageId: null,
    projectId: null,
    name: null,
    status: null,
    assigner: null,
    auditor: null,
    type: null
  }
  proxy.resetForm("packageRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  daterangeCreateTime.value = []
  proxy.resetForm("queryRef")
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.taskPackageId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = proxy.$t("label.taskPackage.add_task_package")
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _taskPackageId = row.taskPackageId || ids.value
  getPackage(_taskPackageId).then(response => {
    form.value = response.data
    open.value = true
    title.value = proxy.$t("label.taskPackage.edit_task_package")
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["packageRef"].validate(valid => {
    if (valid) {
      if (form.value.taskPackageId != null) {
        updatePackage(form.value).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.taskPackage.edit") + proxy.$t("common.success"))
          open.value = false
          getList()
        })
      } else {
        addPackage({...form.value, projectId: projectId}).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.taskPackage.add") + proxy.$t("common.success"))
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _taskPackageIds = row.taskPackageId || ids.value
  proxy.$modal.confirm(proxy.$t('label.taskPackage.confirm_remove', { id: _taskPackageIds })).then(function() {
    return delPackage(_taskPackageIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess(proxy.$t("label.taskPackage.remove") + proxy.$t("common.success"))
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/package/export', {
    ...queryParams.value
  }, `package_${new Date().getTime()}.xlsx`)
}

/** 下载任务包按钮操作 */
function handleDownload() {
  if (ids.value.length === 0) {
    proxy.$modal.msgWarning(proxy.$t("label.taskPackage.select_one_task_package_to_download"))
    return
  }
  
  if (ids.value.length > 1) {
    proxy.$modal.msgWarning(proxy.$t("label.taskPackage.only_one_task_package_can_download"))
    return
  }
  
  const taskPackageId = ids.value[0]
  downloadPackage(taskPackageId).then(response => {
    const blob = new Blob([response])
    const fileName = packageList.value.find(item => item.taskPackageId === taskPackageId)?.name || 'task_package.zip'
    proxy.$download.saveAs(blob, `${fileName}.zip`)
  }).catch(error => {
    console.error(error)
    proxy.$modal.msgError(proxy.$t("label.taskPackage.download_failed", { error: error.message || proxy.$t("common.unknown_error") }))
  })
}

function goToTask(row) {
  router.push({
    name: 'project-task',
    params: {
      taskPackageId: row.taskPackageId,
      taskPackageName: row.name
    }
  })
}

// 显示分配人员对话框
function showUser(row) {
  // 先检查任务包下是否有任务
  listTask({ packageId: row.taskPackageId }).then(response => {
    if (response.total === 0) {
      proxy.$modal.msgWarning(proxy.$t("label.taskPackage.task_package_has_no_task"))
      return
    }
    
    currentRow.value = row
    assignUserOpen.value = true
    assignUserForm.value.userId = null
    assignUserForm.value.assigner = null
    assignUserForm.value.auditor = null
    workerList.value = []
    auditorList.value = []
    // 加载安排人员（label_worker角色）选项
    loadWorkersByRoleAndLanguage('label_worker', row.language)
    // 加载审核人员（label_auditor角色）选项
    loadAuditorsByRoleAndLanguage('label_auditor', row.language)
  }).catch(error => {
    console.error('检查任务数量失败:', error)
    proxy.$modal.msgError(proxy.$t("label.taskPackage.failed_to_check_task_count"))
  })
}

// 加载安排人员（label_worker角色）选项
function loadWorkersByRoleAndLanguage(roleKey, language) {
  getUserForPackage({roleKey: roleKey, language: language}).then(response => {
    workerList.value = response.data || []
  }).catch(error => {
    console.error('获取安排人员列表失败:', error)
    proxy.$modal.msgError(proxy.$t("label.taskPackage.failed_to_load_workers"))
  })
}

// 加载审核人员（label_auditor角色）选项
function loadAuditorsByRoleAndLanguage(roleKey, language) {
  getUserForPackage({roleKey: roleKey, language: language}).then(response => {
    auditorList.value = response.data || []
  }).catch(error => {
    console.error('获取审核人员列表失败:', error)
    proxy.$modal.msgError(proxy.$t("label.taskPackage.failed_to_load_auditors"))
  })
}

// 取消分配人员
function cancelAssignUser() {
  assignUserOpen.value = false
  proxy.resetForm("assignUserRef")
}

// 提交分配用户
function submitAssignUser() {
  proxy.$refs["assignUserRef"].validate(valid => {
    if (valid) {

      
      // 直接执行分配，无需确认对话框
      const taskPackage = {
        taskPackageId: currentRow.value.taskPackageId,
        assigner: assignUserForm.value.assigner,
        auditor: assignUserForm.value.auditor ,
        status: "allocated" // 更新状态为已分配
      };
      
      assignPackageToUser(taskPackage).then(response => {
        proxy.$modal.msgSuccess(proxy.$t("label.taskPackage.assign_success"));
        assignUserOpen.value = false;
        getList(); // 重新加载任务包列表以显示更新后的状态
      }).catch(() => {});
    }
  });
}

// 显示上传对话框
function handleUpload() {
  uploadOpen.value = true
  uploadForm.value.file = null
  uploadFile.value = []
}

// 取消上传
function cancelUpload() {
  uploadOpen.value = false
  proxy.resetForm("uploadRef")
}

// 文件选择处理
function handleFileChange(file, fileList) {
  uploadFile.value = fileList.map(f => f.raw)
}

// 文件超出限制处理
function handleFileExceed() {
  proxy.$modal.msgWarning(proxy.$t("label.taskPackage.max_upload_count"))
}

// 提交上传
function submitUpload() {
  proxy.$refs["uploadRef"].validate(valid => {
    if (valid) {
      if (!uploadFile.value || uploadFile.value.length === 0) {
        proxy.$modal.msgWarning(proxy.$t("label.taskPackage.select_file_to_upload"))
        return
      }
      
      uploadLoading.value = true
      
      const formData = new FormData()
      // 添加所有选择的文件
      uploadFile.value.forEach((file, index) => {
        formData.append("files", file)
      })
      formData.append("projectId", projectId)
      if (data.uploadForm.language) {
        formData.append("language", data.uploadForm.language)
      }
      
      uploadPackage(formData).then(response => {
        proxy.$modal.msgSuccess(proxy.$t("label.taskPackage.upload_success"))
        uploadOpen.value = false
        getList()
      }).catch(error => {
        console.error(error)
        proxy.$modal.msgError(proxy.$t("label.taskPackage.upload_failed", { error: error.message || proxy.$t("common.unknown_error") }))
      }).finally(() => {
        uploadLoading.value = false
      })
    }
  })
}

getList()
</script>