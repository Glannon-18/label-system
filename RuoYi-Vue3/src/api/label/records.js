import request from '@/utils/request'

// 查询文件录音列表
export function listRecords(query) {
  return request({
    url: '/label/records/list',
    method: 'get',
    params: query
  })
}

// 查询文件录音详细
export function getRecords(id) {
  return request({
    url: '/label/records/' + id,
    method: 'get'
  })
}

// 新增文件录音
export function addRecords(data) {
  return request({
    url: '/label/records',
    method: 'post',
    data: data
  })
}

// 修改文件录音
export function updateRecords(data) {
  return request({
    url: '/label/records',
    method: 'put',
    data: data
  })
}

// 删除文件录音
export function delRecords(id) {
  return request({
    url: '/label/records/' + id,
    method: 'delete'
  })
}
