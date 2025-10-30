import request from '@/utils/request'

// 获取任务统计信息
export function getTaskStatistics() {
  return request({
    url: '/label/leader/taskStatistics',
    method: 'get'
  })
}