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
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="音频文件名" align="center" prop="audioFileName" />
      <el-table-column label="任务状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="task_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="标注人员" align="center" prop="packageAssigner" />
      <el-table-column label="创建者" align="center" prop="createBy" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button 
            type="primary" 
            icon="Edit" 
            size="default" 
            @click="handleAudit(scope.row)">
<!--            v-if="scope.row.status === 'pending_review'"-->
<!--          >-->
            审核
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

    <!-- 审核任务对话框 -->
    <el-dialog :title="auditTitle" v-model="auditOpen" width="500px" append-to-body>
      <el-form ref="auditRef" :model="auditForm" :rules="auditRules" label-width="80px">
        <el-form-item label="审核结果" prop="status">
          <el-select v-model="auditForm.status" placeholder="请选择审核结果">
            <el-option label="审核通过" value="pass"></el-option>
            <el-option label="审核不通过" value="reject"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitAudit">确 定</el-button>
          <el-button @click="cancelAudit">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AuditTask">
import { listTask, auditTask } from "@/api/label/task"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

const taskList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const auditOpen = ref(false)
const auditTitle = ref("")

// 获取路由参数
const taskPackageId = route.params.taskPackageId
const taskPackageName = route.params.taskPackageName

// 审核表单
const auditForm = ref({
  taskId: undefined,
  status: ""
})

// 审核表单校验规则
const auditRules = ref({
  status: [{ required: true, message: "审核结果不能为空", trigger: "change" }]
})

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    status: null,
    packageId: route.params.taskPackageId  // 添加任务包ID作为查询条件
  }
})

const { queryParams } = toRefs(data)

/** 查询任务列表 */
function getList() {
  loading.value = true
  listTask(queryParams.value).then(response => {
    taskList.value = response.rows
    total.value = response.total
    loading.value = false
  })
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

/** 审核按钮操作 */
function handleAudit(row) {
  auditForm.value = {
    taskId: row.taskId,
    status: ""
  }
  auditTitle.value = "审核任务"
  auditOpen.value = true
}

/** 提交审核 */
function submitAudit() {
  proxy.$refs.auditRef.validate(valid => {
    if (valid) {
      const formData = { ...auditForm.value }
      // 根据审核结果设置状态
      if (formData.status === "pass") {
        formData.status = "pass"
      } else if (formData.status === "reject") {
        formData.status = "reject"
      }
      
      auditTask(formData).then(response => {
        proxy.$modal.msgSuccess("审核成功")
        auditOpen.value = false
        getList()
      })
    }
  })
}

/** 取消审核 */
function cancelAudit() {
  auditOpen.value = false
  resetAuditForm()
}

/** 重置审核表单 */
function resetAuditForm() {
  auditForm.value = {
    taskId: undefined,
    status: ""
  }
  proxy.resetForm("auditRef")
}

getList()
</script>