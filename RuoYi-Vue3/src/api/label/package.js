import request from '@/utils/request.js'

// 查询任务包列表
export function listPackage(query) {
  return request({
    url: '/label/package/list',
    method: 'get',
    params: query
  })
}

// 查询任务包详细
export function getPackage(taskPackageId) {
  return request({
    url: '/label/package/' + taskPackageId,
    method: 'get'
  })
}

// 新增任务包
export function addPackage(data) {
  return request({
    url: '/label/package',
    method: 'post',
    data: data
  })
}

// 修改任务包
export function updatePackage(data) {
  return request({
    url: '/label/package',
    method: 'put',
    data: data
  })
}

// 删除任务包
export function delPackage(taskPackageId) {
  return request({
    url: '/label/package/' + taskPackageId,
    method: 'delete'
  })
}

// 查询可用于任务包分配的用户列表
export function getUserForPackage(query) {
  return request({
    url: '/label/package/users',
    method: 'get',
    params: query
  })
}

// 分配任务包给用户
export function assignPackageToUser(data) {
  return request({
    url: '/label/package/assign',
    method: 'post',
    data: data
  })
}