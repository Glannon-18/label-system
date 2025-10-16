import request from '@/utils/request'

// 查询任务列表
export function listTask(query) {
  return request({
    url: '/label/task/list',
    method: 'get',
    params: query
  })
}

// 查询任务详细
export function getTask(taskId) {
  return request({
    url: '/label/task/' + taskId,
    method: 'get'
  })
}

// 新增任务
export function addTask(data) {
  return request({
    url: '/label/task',
    method: 'post',
    data: data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 修改任务
export function updateTask(data) {
  return request({
    url: '/label/task',
    method: 'put',
    data: data,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除任务
export function delTask(taskId) {
  return request({
    url: '/label/task/' + taskId,
    method: 'delete'
  })
}

// 审核任务
export function auditTask(data) {
  return request({
    url: '/label/task/audit',
    method: 'put',
    data: data
  })
}