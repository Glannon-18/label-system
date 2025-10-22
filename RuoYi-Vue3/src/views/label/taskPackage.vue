<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2>项目：{{ projectName }}</h2>
      </el-col>
    </el-row>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="创建时间" style="width: 308px">
        <el-date-picker
          v-model="daterangeCreateTime"
          value-format="YYYY-MM-DD"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="任务包名" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入任务包名"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="任务包状态" label-width="auto" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择任务包状态" clearable style="width: 120px;">
          <el-option
            v-for="dict in package_status"
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
      <el-col :span="1.5">
        <el-button
            type="success"
            plain
            icon="Upload"
            @click="handleUpload"
            v-hasPermi="['label:project:add']"
        >上传任务包</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="primary"
            plain
            icon="Download"
            @click="handleDownload"
            v-hasPermi="['label:project:export']"
        >下载任务包</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="packageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="任务包名" align="center" prop="name" >
        <template #default="scope">
          <el-link type="primary" @click="goToTask(scope.row)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column label="语言" align="center" prop="status" >
        <template #default="scope">
          <dict-tag :options="language" :value="scope.row.language" />
        </template>
      </el-table-column>
      <el-table-column label="任务包状态" align="center" prop="status" >
        <template #default="scope">
          <dict-tag :options="package_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="任务包类型" align="center" prop="type">
        <template #default="scope">
          <dict-tag :options="package_type" :value="scope.row.type" />
        </template>
      </el-table-column>
      <el-table-column label="分配人" align="center" prop="assigner" />
      <el-table-column label="创建者" align="center" prop="createBy" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
<!--      <el-table-column label="任务包id" align="center" prop="taskPackageId" />-->


      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button 
            link 
            type="primary" 
            icon="Edit" 
            @click="handleUpdate(scope.row)" 
            v-hasPermi="['label:project:edit']"
            :disabled="scope.row.status !== 'unallocated'">
            修改
          </el-button>
          <el-button 
            link 
            type="primary" 
            icon="Delete" 
            @click="handleDelete(scope.row)" 
            v-hasPermi="['label:project:remove']"
            :disabled="scope.row.status !== 'unallocated'">
            删除
          </el-button>
          <el-button 
            link 
            type="primary"  
            @click="showUser(scope.row)" 
            v-hasPermi="['label:project:edit']"
            :disabled="scope.row.status !== 'unallocated'">
            分配人员
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
        <el-form-item label="任务包名" prop="name">
          <el-input v-model="form.name" placeholder="请输入任务包名" />
        </el-form-item>

        <el-form-item label="标注类型" prop="type">
          <el-select v-model="form.type" placeholder="选择标注类型">
            <el-option v-for="item in types" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>

        <el-form-item label="语言" prop="language">
          <el-select v-model="form.language" placeholder="请选择语言" clearable>
            <el-option
              v-for="item in language"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>

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
    
    <!-- 分配人员对话框 -->
    <el-dialog title="分配人员" v-model="assignUserOpen" width="500px" append-to-body>
      <el-form ref="assignUserRef" :model="assignUserForm" :rules="assignUserRules" label-width="80px">
        <el-form-item label="安排人员" prop="assigner">
          <el-select
            v-model="assignUserForm.assigner"
            placeholder="请选择安排人员"
            style="width: 100%">
            <el-option
              v-for="item in workerList"
              :key="item.userId"
              :label="item.userName + '(' + item.nickName + ')'"
              :value="item.userName">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审核人员" prop="auditor">
          <el-select
            v-model="assignUserForm.auditor"
            placeholder="请选择审核人员"
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
          <el-button type="primary" @click="submitAssignUser">确 定</el-button>
          <el-button @click="cancelAssignUser">取 消</el-button>
        </div>
      </template>
    </el-dialog>
    
    <!-- 上传任务包对话框 -->
    <el-dialog title="上传任务包" v-model="uploadOpen" width="500px" append-to-body>
      <el-form ref="uploadRef" :model="uploadForm" :rules="uploadRules" label-width="80px">
        <el-form-item label="ZIP文件" prop="file">
          <el-upload
            ref="uploadRef"
            :limit="1"
            :auto-upload="false"
            :on-change="handleFileChange"
            :on-exceed="handleFileExceed"
            accept=".zip"
          >
            <el-button type="primary">选择文件</el-button>
            <template #tip>
              <div class="el-upload__tip">
                请上传.zip格式文件，且文件中wav和TextGrid文件必须成对出现
              </div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item label="语言" prop="language">
          <el-select v-model="uploadForm.language" placeholder="请选择语言" clearable>
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
          <el-button type="primary" @click="submitUpload" :loading="uploadLoading">确 定</el-button>
          <el-button @click="cancelUpload">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Package">
import { listPackage, getPackage, delPackage, addPackage, updatePackage, getUserForPackage, assignPackageToUser, uploadPackage, downloadPackage } from "@/api/label/package"
import {listProject, getProject, delProject, addProject, updateProject} from "@/api/label/project"
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
const uploadFile = ref(null)

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
      { required: true, message: "任务包名不能为空", trigger: "blur" }
    ],
    type: [
      { required: true, message: "标注类型不能为空", trigger: "blur" }
    ],
    language: [
      { required: true, message: "语言不能为空", trigger: "change" }
    ]
  },
  assignUserForm: {

  },
  assignUserRules: {
    assigner: [{ required: true, message: "请选择安排人员", trigger: "change" }],
    auditor: [{ required: true, message: "请选择审核人员", trigger: "change" }]
  },
  uploadRules: {
    // file: [{ required: true, message: "请选择文件", trigger: "change" }],
    language: [{ required: true, message: "语言不能为空", trigger: "change" }]
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
  title.value = "添加任务包"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _taskPackageId = row.taskPackageId || ids.value
  getPackage(_taskPackageId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改任务包"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["packageRef"].validate(valid => {
    if (valid) {
      if (form.value.taskPackageId != null) {
        updatePackage(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addPackage({...form.value, projectId: projectId}).then(response => {
          proxy.$modal.msgSuccess("新增成功")
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
  proxy.$modal.confirm('是否确认删除任务包编号为"' + _taskPackageIds + '"的数据项？').then(function() {
    return delPackage(_taskPackageIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
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
    proxy.$modal.msgWarning("请选择一个任务包进行下载")
    return
  }
  
  if (ids.value.length > 1) {
    proxy.$modal.msgWarning("每次只能下载一个任务包")
    return
  }
  
  const taskPackageId = ids.value[0]
  downloadPackage(taskPackageId).then(response => {
    const blob = new Blob([response])
    const fileName = packageList.value.find(item => item.taskPackageId === taskPackageId)?.name || 'task_package.zip'
    proxy.$download.saveAs(blob, `${fileName}.zip`)
  }).catch(error => {
    console.error(error)
    proxy.$modal.msgError("下载失败：" + (error.message || "未知错误"))
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
      proxy.$modal.msgWarning("这个任务包没有任务")
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
    proxy.$modal.msgError("检查任务数量失败")
  })
}

// 加载安排人员（label_worker角色）选项
function loadWorkersByRoleAndLanguage(roleKey, language) {
  getUserForPackage({roleKey: roleKey, language: language}).then(response => {
    workerList.value = response.data || []
  }).catch(error => {
    console.error('获取安排人员列表失败:', error)
    proxy.$modal.msgError("获取安排人员列表失败")
  })
}

// 加载审核人员（label_auditor角色）选项
function loadAuditorsByRoleAndLanguage(roleKey, language) {
  getUserForPackage({roleKey: roleKey, language: language}).then(response => {
    auditorList.value = response.data || []
  }).catch(error => {
    console.error('获取审核人员列表失败:', error)
    proxy.$modal.msgError("获取审核人员列表失败")
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
        proxy.$modal.msgSuccess("分配成功");
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
  uploadFile.value = null
}

// 取消上传
function cancelUpload() {
  uploadOpen.value = false
  proxy.resetForm("uploadRef")
}

// 文件选择处理
function handleFileChange(file) {
  uploadFile.value = file.raw
}

// 文件超出限制处理
function handleFileExceed() {
  proxy.$modal.msgWarning("只能上传一个文件")
}

// 提交上传
function submitUpload() {
  proxy.$refs["uploadRef"].validate(valid => {
    if (valid) {
      if (!uploadFile.value) {
        proxy.$modal.msgWarning("请选择文件")
        return
      }
      
      uploadLoading.value = true
      
      const formData = new FormData()
      formData.append("file", uploadFile.value)
      formData.append("projectId", projectId)
      if (data.uploadForm.language) {
        formData.append("language", data.uploadForm.language)
      }
      
      uploadPackage(formData).then(response => {
        proxy.$modal.msgSuccess("上传成功")
        uploadOpen.value = false
        getList()
      }).catch(error => {
        console.error(error)
        proxy.$modal.msgError("上传失败：" + (error.message || "未知错误"))
      }).finally(() => {
        uploadLoading.value = false
      })
    }
  })
}

getList()
</script>