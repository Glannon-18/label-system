<template>
  <div class="app-container">
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
import { ref, onMounted } from 'vue'
import { getTaskStatistics } from '@/api/system/leader'

// 任务统计数据
const taskStats = ref([])

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