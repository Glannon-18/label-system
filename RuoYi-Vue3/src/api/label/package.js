import request from '@/utils/request.js'

// 查询任务包列表
export function listPackage(query) {
  return request({
    url: '/system/package/list',
    method: 'get',
    params: query
  })
}

// 查询任务包详细
export function getPackage(taskPackageId) {
  return request({
    url: '/system/package/' + taskPackageId,
    method: 'get'
  })
}

// 新增任务包
export function addPackage(data) {
  return request({
    url: '/system/package',
    method: 'post',
    data: data
  })
}

// 修改任务包
export function updatePackage(data) {
  return request({
    url: '/system/package',
    method: 'put',
    data: data
  })
}

// 删除任务包
export function delPackage(taskPackageId) {
  return request({
    url: '/system/package/' + taskPackageId,
    method: 'delete'
  })
}
