import request from '@/utils/request'

// 获取任务统计信息
export function getTaskStatistics(keyword) {
  return request({
    url: '/label/leader/taskStatistics',
    method: 'get',
    params: { keyword }
  })
}