<script setup>
import { listPackageByAssigner as listPackage, updatePackage } from "@/api/label/package"
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
      { required: true, message: "任务包名不能为空", trigger: "blur" }
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
  proxy.$modal.confirm('确认接收任务包之后，将无法修改任务包，确认要接收任务包"' + row.name + '"吗？').then(function () {
    // 更新任务包状态为已接收
    row.status = "reception"
    return updatePackage(row)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("接收成功")
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
      <el-form-item label="任务包名" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入任务包名" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="任务包状态" prop="status" label-width="auto">
        <el-select v-model="queryParams.status" placeholder="请选择任务包状态" clearable style="width: 120px;">
          <el-option v-for="dict in package_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="packageList">
      <el-table-column label="任务包名" align="center" prop="name">
        <template #default="scope">
          <el-link type="primary" @click="goToTask(scope.row)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column label="任务包状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="package_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="任务包类型" align="center" prop="type">
        <template #default="scope">
          <dict-tag :options="package_type" :value="scope.row.type" />
        </template>
      </el-table-column>
      <el-table-column label="项目名" align="center" prop="projectName" />
      <el-table-column label="分配人" align="center" prop="assigner" />
      <el-table-column label="创建者" align="center" prop="createBy" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ proxy.parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />

      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" @click="handleReception(scope.row)" v-if="scope.row.status !== 'reception'">
            接收
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize"
      @pagination="getList" />
  </div>
</template>

<style scoped lang="scss"></style>