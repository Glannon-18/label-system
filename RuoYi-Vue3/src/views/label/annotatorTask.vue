<template>
  <div class="app-container">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2>{{ $t('label.annotatorTask.task_package_name') }}：{{ taskPackageName }}</h2>
      </el-col>
    </el-row>
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.annotatorTask.task_status')" prop="status">
        <el-select v-model="queryParams.status" :placeholder="$t('label.annotatorTask.select_task_status')" clearable style="width: 120px;">
          <el-option v-for="dict in task_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.annotatorTask.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.annotatorTask.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <!--      <el-table-column label="任务ID" align="center" prop="taskId" />-->
      <el-table-column :label="$t('label.annotatorTask.audio_file_name')" align="center" prop="audioFileName" :show-overflow-tooltip="true">
        <template #default="scope">
          <!-- 不给标注员进去看待审核和审核通过的 -->
          <view v-if="['pending_review','pass'].includes(scope.row.status)">
            {{ scope.row.audioFileName }}
          </view>
          <view v-else>
            <el-link @click="handleToAnnotator(scope.row)" type="primary">{{ scope.row.audioFileName }}</el-link>
          </view>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotatorTask.task_status_col')" align="center" prop="status">
        <template #default="scope">
          <el-tag :type="getStatusTagType(scope.row.status)">{{ getStatusTagName(scope.row.status) }}</el-tag>
        </template>
      </el-table-column>
      <!--      <el-table-column label="分配人账户名" align="center" prop="annotator" />-->
      <!--      <el-table-column label="审核人员账户名" align="center" prop="auditor" />-->
      <el-table-column :label="$t('label.annotatorTask.creator')" align="center" prop="createBy" />
      <el-table-column :label="$t('label.annotatorTask.create_time')" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotatorTask.remark')" align="center" prop="remark" />
      <el-table-column :label="$t('label.annotatorTask.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button v-if="['underway','reject'].includes(scope.row.status)"  
          type="primary" icon="Edit" size="default" 
          @click="handleToAnnotator(scope.row)">{{ $t('label.annotatorTask.annotate') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />
  </div>
</template>

<script setup name="Task">
import { listTask } from "@/api/label/task"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

const taskList = ref([])
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

// 获取路由参数
const taskPackageId = route.params.taskPackageId
const taskPackageName = route.params.taskPackageName

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    status: null,
    taskPackageId: route.params.taskPackageId  // 添加任务包ID作为查询条件
  }
})

const { queryParams } = toRefs(data)

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
  return proxy.$t(`label.annotatorTask.${status}`)
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

/** 跳转到标注/录音页面 **/
function handleToAnnotator(row) {
  const taskId = row.taskId
  const type = row.packageType
  if (type === "audio") {
    proxy.$router.push(`/label/audio-recorder/index/${taskId}`)
  }else{
    // 修改跳转路径，使其与路由配置匹配
    proxy.$router.push(`/label/label-editor/index/${taskPackageId}/${ encodeURIComponent(taskPackageName) }/${taskId}`)
  }
}

getList()
</script>