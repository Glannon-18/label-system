<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item :label="$t('label.project.project_name')" prop="name" label-width="auto">
        <el-input
            v-model="queryParams.name"
            :placeholder="$t('label.project.enter_project_name')"
            clearable
            @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item :label="$t('label.project.create_time')" label-width="auto">
        <el-date-picker
            v-model="dateRange"
            style="width: 240px"
            value-format="YYYY-MM-DD"
            type="daterange"
            range-separator="-"
            :start-placeholder="$t('label.project.start_date')"
            :end-placeholder="$t('label.project.end_date')"
        ></el-date-picker>
      </el-form-item>
      <el-form-item :label="$t('label.project.status')" prop="status">
        <el-select v-model="queryParams.status" :placeholder="$t('label.project.select_status')" clearable style="width: 120px;">
          <el-option
              v-for="dict in project_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.project.search') }}</el-button>
        <el-button icon="Refresh" @click="resetQuery">{{ $t('label.project.reset') }}</el-button>
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
        >{{ $t('label.project.add') }}
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="success"
            plain
            icon="Edit"
            :disabled="single"
            @click="handleUpdate"
            v-hasPermi="['label:project:edit']"
        >{{ $t('label.project.edit') }}
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="danger"
            plain
            icon="Delete"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['label:project:remove']"
        >{{ $t('label.project.remove') }}
        </el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="projectList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center"/>

      <!--      <el-table-column label="项目ID" align="center" prop="projectId" />-->
      <el-table-column :label="$t('label.project.project_name')" align="center" prop="name">
        <template #default="scope">
          <el-link type="primary" @click="goToTaskPackages(scope.row)">
            {{ scope.row.name }}
          </el-link>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.project.status')" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="project_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.project.create_time')" align="center" width="160" prop="createTime">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('label.project.remark')" align="center" prop="remark"/>

      <el-table-column :label="$t('label.project.operation')" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
                     v-hasPermi="['label:project:edit']">{{ $t('label.project.edit') }}
          </el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
                     v-hasPermi="['label:project:remove']">{{ $t('label.project.remove') }}
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

    <!-- 添加或修改项目对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="projectRef" :model="form" :rules="rules" label-width="80px">

        <el-form-item :label="$t('label.project.project_name')" prop="name">
          <el-input v-model="form.name" :placeholder="$t('label.project.enter_project_name')"/>
        </el-form-item>
        <el-form-item :label="$t('label.project.status')" prop="status">
          <el-select v-model="form.status" :placeholder="$t('label.project.select_status')">
            <el-option
                v-for="dict in project_status"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('label.project.remark')" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容"/>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">{{ $t('label.project.add') === title ? $t('label.project.add') : $t('label.project.edit') }}</el-button>
          <el-button @click="cancel">{{ $t('label.project.reset') }}</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Project">
import {listProject, getProject, delProject, addProject, updateProject} from "@/api/label/project.js"

const {proxy} = getCurrentInstance()
const {project_status} = proxy.useDict('project_status')

const projectList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const dateRange = ref([])

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    status: null
  },
  rules: {
    name: [
      {required: true, message: proxy.$t("label.project.project_name_not_empty"), trigger: "blur"}
    ],
  }
})

const {queryParams, form, rules} = toRefs(data)

function goToTaskPackages(row) {
  proxy.$router.push({
    name: 'project-package',
    params: { projectId: row.projectId ,projectName: row.name}
  })
}

/** 查询项目列表 */
function getList() {
  loading.value = true
  listProject(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    projectList.value = response.rows
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
    projectId: null,
    name: null,
    status: null
  }
  proxy.resetForm("projectRef")
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
  ids.value = selection.map(item => item.projectId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = proxy.$t("label.project.add_project")
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _projectId = row.projectId || ids.value
  getProject(_projectId).then(response => {
    form.value = response.data
    open.value = true
    title.value = proxy.$t("label.project.edit_project")
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["projectRef"].validate(valid => {
    if (valid) {
      if (form.value.projectId != null) {
        updateProject(form.value).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.project.edit") + proxy.$t("common.success"))
          open.value = false
          getList()
        })
      } else {
        form.value.status = form.value.status?form.value.status:'underway';
        addProject(form.value).then(response => {
          proxy.$modal.msgSuccess(proxy.$t("label.project.add") + proxy.$t("common.success"))
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _projectIds = row.projectId || ids.value
  proxy.$modal.confirm(proxy.$t('label.project.confirm_remove')).then(function () {
    return delProject(_projectIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess(proxy.$t("label.project.remove") + proxy.$t("common.success"))
  }).catch(() => {
  })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/project/export', {
    ...queryParams.value
  }, `project_${new Date().getTime()}.xlsx`)
}

getList()
</script>