import request from '@/utils/request'

// 获取任务统计数据
export function getTaskStatistics(keyword, orderByColumn, isAsc) {
  return request({
    url: '/label/leader/taskStatistics',
    method: 'get',
    params: { keyword, orderByColumn, isAsc }
  })
}