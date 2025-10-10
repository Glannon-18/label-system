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
      <el-form-item label="任务包状态" prop="status">
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
      <el-table-column label="任务包状态" align="center" prop="status" >
        <template #default="scope">
          <dict-tag :options="package_status" :value="scope.row.status"/>
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
            :disabled="scope.row.status === 'allocated'">
            修改
          </el-button>
          <el-button 
            link 
            type="primary" 
            icon="Delete" 
            @click="handleDelete(scope.row)" 
            v-hasPermi="['label:project:remove']"
            :disabled="scope.row.status === 'allocated'">
            删除
          </el-button>
          <el-button 
            link 
            type="primary"  
            @click="showUser(scope.row)" 
            v-hasPermi="['label:project:edit']"
            :disabled="scope.row.status === 'allocated'">
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
        <el-form-item label="用户名" prop="userId">
          <el-select 
            v-model="assignUserForm.userId" 
            placeholder="请选择用户" 
            style="width: 100%">
            <el-option
              v-for="item in userList"
              :key="item.userId"
              :label="item.nickName + '(' + item.userName + ')'"
              :value="item.userId">
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
  </div>
</template>

<script setup name="Package">
import { listPackage, getPackage, delPackage, addPackage, updatePackage, getUserForPackage, assignPackageToUser } from "@/api/label/package"

const { proxy } = getCurrentInstance()
const { package_status } = proxy.useDict('package_status')
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
const userList = ref([])
const currentRow = ref({})

const projectId = route.params.projectId
const projectName = route.params.projectName

const data = reactive({
  form: {},
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
  },
  assignUserForm: {
    userId: null
  },
  assignUserRules: {
    userId: [{ required: true, message: "请选择用户", trigger: "change" }]
  }
})

const { queryParams, form, rules, assignUserForm, assignUserRules } = toRefs(data)

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
    auditor: null
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
  currentRow.value = row
  assignUserOpen.value = true
  assignUserForm.value.userId = null
  // 加载所有用户
  loadAllUsers()
}

// 取消分配人员
function cancelAssignUser() {
  assignUserOpen.value = false
  proxy.resetForm("assignUserRef")
}

// 加载所有用户
function loadAllUsers() {
  getUserForPackage().then(response => {
    userList.value = response.data
  })
}

// 提交分配用户
function submitAssignUser() {
  proxy.$refs["assignUserRef"].validate(valid => {
    if (valid) {
      // 查找选中的用户
      const selectedUser = userList.value.find(user => user.userId === assignUserForm.value.userId);
      
      // 显示确认对话框
      proxy.$modal.confirm("指派人员之后将无法修改任务包，你确定要指派人员吗？").then(function() {
        const taskPackage = {
          taskPackageId: currentRow.value.taskPackageId,
          assigner: selectedUser.userName, // 使用选中用户的用户名作为分配者
          status: "ALLOCATED" // 更新状态为已分配
        };
        
        return assignPackageToUser(taskPackage);
      }).then(response => {
        proxy.$modal.msgSuccess("分配成功");
        assignUserOpen.value = false;
        getList(); // 重新加载任务包列表以显示更新后的状态
      }).catch(() => {});
    }
  });
}

getList()
</script>