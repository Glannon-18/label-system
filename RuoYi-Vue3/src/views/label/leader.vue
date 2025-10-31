<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="68px">
      <el-form-item label="用户名/昵称" prop="keyword" label-width="auto">
        <el-input
          v-model="queryParams.keyword"
          placeholder="请输入用户名或昵称进行搜索"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <el-table :data="taskStats" border>
      <el-table-column 
        :formatter="formatUserName"
        label="用户名"
        align="center"
      />
      <el-table-column 
        v-for="col in columns.slice(1)" 
        :key="col.prop" 
        :prop="col.prop" 
        :label="col.label"
        align="center"
      />
    </el-table>
  </div>
</template>

<script setup name="Leader">
import { ref, onMounted, reactive, toRefs } from 'vue'
import { getTaskStatistics } from '@/api/system/leader'
import { useRouter } from 'vue-router'

const router = useRouter()

// 任务统计数据
const taskStats = ref([])

// 查询参数
const data = reactive({
  queryParams: {
    keyword: ''
  }
})

const { queryParams } = toRefs(data)

// 表格列定义
const columns = ref([
  {
    label: '用户名',
    prop: 'userName'
  },
  {
    label: '未开始',
    prop: 'unstartCount'
  },
  {
    label: '标注中',
    prop: 'underwayCount'
  },
  {
    label: '待审核',
    prop: 'pendingReviewCount'
  },
  {
    label: '已驳回',
    prop: 'rejectCount'
  },
  {
    label: '审核通过',
    prop: 'passCount'
  },
  {
    label: '审核通过音频总时长(秒)',
    prop: 'passDuration'
  }
])

// 获取任务统计数据
const fetchTaskStats = () => {
  getTaskStatistics().then(response => {
    taskStats.value = response.data
  })
}

// 搜索处理
const handleQuery = () => {
  getTaskStatistics(queryParams.value.keyword).then(response => {
    taskStats.value = response.data
  })
}

// 重置搜索
const resetQuery = () => {
  queryParams.value.keyword = ''
  fetchTaskStats()
}

// 格式化用户名显示
const formatUserName = (row) => {
  return row.nickName ? `${row.userName}(${row.nickName})` : row.userName
}

onMounted(() => {
  fetchTaskStats()
})
</script>

<style scoped lang="scss">

</style>