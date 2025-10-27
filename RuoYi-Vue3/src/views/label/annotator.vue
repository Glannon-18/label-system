<script setup>
import { listPackageByAssigner as listPackage, getPackage, updatePackage, receptionPackage } from "@/api/label/package"
import { getCurrentInstance, reactive, ref, toRefs } from "vue"
import { useRouter } from "vue-router"

const { proxy } = getCurrentInstance()
const { package_status } = proxy.useDict('package_status')
const { package_type } = proxy.useDict('package_type')
const router = useRouter()

const packageList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    status: null,
  },
  rules: {
    name: [
      { required: true, message: proxy.$t("label.taskPackage.task_package_name_not_empty"), trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询任务包列表 */
function getList() {
  loading.value = true
  listPackage(queryParams.value).then(response => {
    packageList.value = response.rows
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

/** 接收按钮操作 */
function handleReception(row) {
  proxy.$modal.confirm(proxy.$t('label.annotator.confirm_reception', { name: row.name })).then(function () {
    // 更新任务包状态为已接收
    const taskPackage = {
      taskPackageId: row.taskPackageId,
      status: "reception"
    };
    return receptionPackage(taskPackage)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess(proxy.$t("label.annotator.reception_success"))
  }).catch(() => { })
}

/** 跳转到任务详情页面 */
function goToTask(row) {
  router.push({
    name: 'my-task',
    params: {
      taskPackageId: row.taskPackageId,
      taskPackageName: row.name
    }
  })
}

getList()
</script>

<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.annotator.task_package_name')" prop="name" label-width="auto">
        <el-input v-model="queryParams.name" :placeholder="$t('label.annotator.enter_task_package_name')" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item :label="$t('label.annotator.task_package_status')" prop="status" label-width="auto">
        <el-select v-model="queryParams.status" :placeholder="$t('label.annotator.select_task_package_status')" clearable style="width: 120px;">
          <el-option v-for="dict in package_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.annotator.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.annotator.reset') }}</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="packageList">
      <el-table-column :label="$t('label.annotator.task_package_name_col')" align="center" prop="name">
        <template #default="scope">
          <el-link type="primary" @click="goToTask(scope.row)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotator.task_package_status_col')" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="package_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotator.task_package_type')" align="center" prop="type">
        <template #default="scope">
          <dict-tag :options="package_type" :value="scope.row.type" />
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotator.project_name')" align="center" prop="projectName" />
      <el-table-column :label="$t('label.annotator.assigner')" align="center" prop="assigner" />
      <el-table-column :label="$t('label.annotator.creator')" align="center" prop="createBy" />
      <el-table-column :label="$t('label.annotator.create_time')" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ proxy.parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.annotator.remark')" align="center" prop="remark" />

      <el-table-column :label="$t('label.annotator.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" @click="handleReception(scope.row)" v-if="scope.row.status !== 'reception'">
            {{ $t('label.annotator.reception') }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize"
      @pagination="getList" />
  </div>
</template>

<style scoped lang="scss"></style>