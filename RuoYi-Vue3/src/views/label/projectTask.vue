<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.auditTask.project_name')" prop="projectName" label-width="auto">
        <el-input
            v-model="queryParams.projectName"
            :placeholder="$t('label.auditTask.enter_project_name')"
            clearable
            @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item :label="$t('label.auditTask.task_status')" prop="status" label-width="auto">
        <el-select v-model="queryParams.status" :placeholder="$t('label.auditTask.select_task_status')" clearable style="width: 120px;">
          <el-option
              v-for="dict in task_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.auditTask.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.auditTask.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
            type="primary"
            plain
            icon="Download"
            size="default"
            :disabled="single"
            @click="handleDownload"
        >{{ $t('label.auditTask.download') }}</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column :label="$t('label.auditTask.project_name_col')" align="center" prop="projectName" />
      <el-table-column :label="$t('label.auditTask.task_package_name')" align="center" prop="packageName" />
      <el-table-column :label="$t('label.auditTask.audio_file_name')" align="center" prop="audioFileName" :show-overflow-tooltip="true">
        <template #default="scope">
          <el-link @click="handleViewDetail(scope.row)" type="primary">{{ scope.row.audioFileName }}</el-link>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.auditTask.task_status_col')" align="center" prop="status">
        <template #default="scope">
          <el-tag :type="getStatusTagType(scope.row.status)">{{ getStatusTagName(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.auditTask.annotator')" align="center" prop="packageAssigner" />
      <el-table-column :label="$t('label.auditTask.create_time')" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.auditTask.pass_time')" align="center" prop="passTime" width="180">
        <template #default="scope">
          <span>{{ scope.row.passTime ? parseTime(scope.row.passTime, '{y}-{m}-{d}') : '' }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.auditTask.remark')" align="center" prop="remark" />
      <el-table-column :label="$t('label.auditTask.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button 
            icon="View"
            size="default" 
            @click="handleShowProgress(scope.row)">
            {{ $t('label.auditTask.view_progress') }}
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

    <!-- 任务进度弹窗 -->
    <el-dialog :title="$t('label.auditTask.task_progress')" v-model="progressDialogVisible" width="600px" append-to-body>
      <div v-loading="progressLoading">
        <el-timeline>
          <el-timeline-item
            v-for="(log, index) in progressLogs"
            :key="index"
            :timestamp="parseTime(log.createTime)"
            placement="top">
            <div class="progress-item">
              <h4>{{ getStatusDescription(log.status) }}</h4>
              <p>{{ $t('label.auditTask.operator') }}: {{ log.createBy }}</p>
              <p v-if="log.remark">{{ $t('label.auditTask.remark') }}: {{ log.remark }}</p>
            </div>
          </el-timeline-item>
        </el-timeline>
        <div v-if="progressLogs.length === 0" class="empty-tips">{{ $t('label.auditTask.no_progress_records') }}</div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup name="ProjectTask">
import { getTaskProgress, listCreatorTask, downloadTasks } from "@/api/label/task"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

const taskList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
const uniqueId = ref("") // 添加唯一标识用于判断是否需要刷新
const ids = ref([])
const single = ref(true)

// 任务进度相关
const progressDialogVisible = ref(false)
const progressLoading = ref(false)
const progressLogs = ref([])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    status: null,
  }
})

const { queryParams } = toRefs(data)

/** 选中项发生变化时触发 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.taskId)
  single.value = selection.length === 0
}

/**
 * 根据任务状态获取标签类型
 */
function getStatusTagType(status) {
  switch (status) {
    case 'unstart': // 未开始
      return 'info'
    case 'underway': // 标注中
      return 'primary'
    case 'pending_review': // 待审核
      return 'warning'
    case 'reject': // 已驳回
      return 'danger'
    case 'pass': // 审核通过
      return 'success'
    default:
      return 'info'
  }
}

/**
 * 根据任务状态获取标签名称
 */
function getStatusTagName(status) {
  // task_status 是一个 ref 对象，需要通过 .value 访问实际数组
  const statusObj = task_status.value.find(item => item.value === status)
  
  // 如果在字典中找不到对应的状态，则根据状态代码返回国际化文本
  if (!statusObj) {
    switch (status) {
      case 'unstart':
        return proxy.$t('label.auditTask.unstart')
      case 'underway':
        return proxy.$t('label.auditTask.underway')
      case 'pending_review':
        return proxy.$t('label.auditTask.pending_review')
      case 'reject':
        return proxy.$t('label.auditTask.reject')
      case 'pass':
        return proxy.$t('label.auditTask.pass')
      default:
        return status
    }
  }
  
  return statusObj.label
}

/**
 * 根据任务状态获取描述
 */
function getStatusDescription(status) {
  const statusObj = task_status.value.find(item => item.value === status)
  
  // 如果在字典中找不到对应的状态，则根据状态代码返回国际化文本
  if (!statusObj) {
    switch (status) {
      case 'unstart':
        return proxy.$t('label.auditTask.unstart')
      case 'underway':
        return proxy.$t('label.auditTask.underway')
      case 'pending_review':
        return proxy.$t('label.auditTask.pending_review')
      case 'reject':
        return proxy.$t('label.auditTask.reject')
      case 'pass':
        return proxy.$t('label.auditTask.pass')
      default:
        return status
    }
  }
  
  return statusObj.label
}

/** 查询任务列表 */
function getList() {
  loading.value = true
  listCreatorTask(queryParams.value).then(response => {
    taskList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

// 添加onActivated钩子，当页面被激活时检查是否需要刷新数据
onActivated(() => {
  const time = route.query.t
  if (time != null && time != uniqueId.value) {
    uniqueId.value = time
    getList()
  }
})

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

/** 下载按钮操作 */
function handleDownload() {
  if (ids.value.length === 0) {
    proxy.$message.warning(proxy.$t('label.auditTask.select_at_least_one_task'))
    return
  }
  
  proxy.$modal.confirm(proxy.$t('label.auditTask.confirm_download')).then(function() {
    return downloadTasks(ids.value)
  }).then(response => {
    const blob = new Blob([response])
    const fileName = 'tasks.zip'
    const link = document.createElement('a')
    link.href = URL.createObjectURL(blob)
    link.download = fileName
    link.click()
    URL.revokeObjectURL(link.href)
    proxy.$modal.msgSuccess(proxy.$t('label.auditTask.download_success'))
  }).catch(function() {})
}

/** 查看详情 **/
function handleViewDetail(row) {
  const taskId = row.taskId
  const type = row.packageType
  if (type === "audio") {
    proxy.$router.push(`/label/audit-audio-recorder/index/${taskId}`)
  }else{
    proxy.$router.push(`/label/audit-label/index/${taskId}`)
  }
}

/** 显示任务进度 */
function handleShowProgress(row) {
  progressDialogVisible.value = true
  progressLoading.value = true
  progressLogs.value = []
  
  getTaskProgress(row.taskId).then(response => {
    progressLogs.value = response.rows || []
    progressLoading.value = false
  }).catch(() => {
    progressLoading.value = false
    proxy.$message.error(proxy.$t("label.auditTask.failed_to_get_progress"))
  })
}

getList()
</script>

<style scoped>
.empty-tips {
  text-align: center;
  color: #999;
  padding: 20px;
}

.progress-item {
  padding: 10px;
  border-left: 2px solid #e4e7ed;
  margin-left: 5px;
}
</style>