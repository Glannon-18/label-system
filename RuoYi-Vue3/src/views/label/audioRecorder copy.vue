<template>
    <div class="item-root">
        <div class="item-container" v-for="(record, index) in records" :key="index">
            <!-- 上部文本 -->
            <div style="display: flex;flex-direction: row;gap:15px;align-items: center;">
                <el-checkbox v-model="record.checked" :label="index + 1" size="large" />
                <div class="item-text">
                    {{ record.modifiedText != null ? record.modifiedText : record.text }}
                </div>
            </div>


            <!-- 下部操作按钮 -->
            <div class="item-actions">
                <span class="action-btn" @click="toggleRecording(index)">
                    {{ recordingStates[index] ? '停止' : '录音' }}
                </span>
                <span class="action-btn" @click="togglePlaying(index)">
                    {{ playingStates[index] ? '暂停' : '播放' }}
                </span>
                <span class="action-btn" @click="openDialog(index)">修改</span>
                <span class="action-btn" @click="openDeleteDialog(index)">删除</span>
            </div>
        </div>

        <!-- 修改文本对话框 -->
        <el-dialog v-model="dialogVisible" title="修改文本" width="500px">
            <el-input v-if="clickedRecord.modifiedText === null" type="textarea" v-model="clickedRecord.text"
                placeholder="请输入文本内容" :rows="8" class="fixed-textarea" />
            <el-input v-else type="textarea" v-model="clickedRecord.modifiedText" placeholder="请输入文本内容" :rows="8"
                class="fixed-textarea" />


            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="cancelEdit">取消</el-button>
                    <el-button type="primary" @click="confirmEdit">确定</el-button>
                </div>
            </template>
        </el-dialog>

        <!-- 删除确认对话框 -->
        <el-dialog v-model="deleteDialogVisible" title="确认删除" width="400px">
            <div class="delete-dialog-content">
                <p>确定要删除这条记录吗？</p>
                <p class="delete-text-preview">{{ clickedRecord.text || clickedRecord.modifiedText }}</p>
            </div>

            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="cancelDelete">取消</el-button>
                    <el-button type="danger" @click="confirmDelete">删除</el-button>
                </div>
            </template>
        </el-dialog>

    </div>
</template>

<script setup>
import { listTask, getTask, delTask, addTask, updateTask } from "@/api/label/task"
import { listRecords, getRecords, delRecords, addRecords, updateRecords } from "@/api/label/records"

import { nextTick, onMounted, onUnmounted, reactive, watch } from "vue"
import * as XLSX from "xlsx"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

var task = {}

const records = ref([])

// 对话框状态
const dialogVisible = ref(false)
const deleteDialogVisible = ref(false)
const modifyingIndex = ref(-1) // 当前修改的文本索引
const deletingIndex = ref(-1) // 当前修改的文本索引
const clickedRecord = ref("")   // 对话框中显示的文本
// 每行录音和播放状态
const recordingStates = ref(Array(records.value.length).fill(false))
const playingStates = ref(Array(records.value.length).fill(false))


function toggleRecording(index) {
    recordingStates.value[index] = !recordingStates.value[index]
    // 如果录音启动，播放状态自动停止
    if (recordingStates.value[index]) playingStates.value[index] = false
}


function togglePlaying(index) {
    playingStates.value[index] = !playingStates.value[index]
    // 如果播放启动，录音状态自动停止
    if (playingStates.value[index]) recordingStates.value[index] = false
}

function openDialog(index) {
    modifyingIndex.value = index
    clickedRecord.value = records.value[index]
    dialogVisible.value = true
}

// 确认修改
function confirmEdit() {
    if (modifyingIndex.value !== -1) {
        records.value[modifyingIndex.value] = clickedRecord.value
    }

    updateRecords(clickedRecord.value)
        .then((response) => {
            proxy.$modal.msgSuccess("修改成功")
        })
    dialogVisible.value = false
}

// 取消修改
function cancelEdit() {
    dialogVisible.value = false
}


function openDeleteDialog(index) {
    deletingIndex.value = index
    deleteDialogVisible.value = true
}

// 取消删除
function cancelDelete() {
    deletingIndex.value = -1
    deleteDialogVisible.value = false
}

// 确认删除
function confirmDelete() {

    delRecords([records.value[deletingIndex.value].id])
        .then((response) => {
            proxy.$modal.msgSuccess("删除成功")
            records.value.splice(deletingIndex.value, 1)
        })

    deleteDialogVisible.value = false
}

onMounted(async () => {
    const taskId = route.params.taskId


    try {
        const responseTask = await getTask(taskId)
        task = responseTask.data


        const responseRecords = await listRecords({ taskId: task.taskId })

        const url = `http://localhost:8081/dev-api${task.audioFileName}`
        if (responseRecords.total == 0) {
            try {


                // 通过 fetch 获取文件二进制
                const response = await fetch(url)
                if (!response.ok) throw new Error("下载失败")

                const arrayBuffer = await response.arrayBuffer()

                // 解析为 workbook
                const workbook = XLSX.read(arrayBuffer, { type: "array" })

                // 获取第一个工作表
                const sheetName = workbook.SheetNames[0]
                const sheet = workbook.Sheets[sheetName]

                // 以二维数组方式解析（每行一个数组）
                const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 })
                const newRecords = []

                // 按行处理
                rows.forEach((row, index) => {
                    const rowStr = row.join(", ")

                    // console.log(`第 ${index + 1} 行:`, row)
                    const record = {
                        taskId: task.taskId,
                        packageId: task.packageId,
                        itemOrder: index + 1,
                        text: rowStr
                    }

                    newRecords.push(record)

                })
                addRecords(newRecords).then(response => {
                    // this.$modal.msgSuccess("新增成功")
                    records.value = newRecords
                })

            } catch (error) {
                console.log(error)
            }
        } else {
            records.value = responseRecords.rows
        }

    } catch (error) {

    }


})

</script>

<style scoped>
.item-root {
    margin: 40px;
}

.item-container {
    width: 100%;
    background-color: #fff;


    padding: 20px;
    border-bottom: 1px solid rgb(241, 241, 241);
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    transition: box-shadow 0.3s;
}

.item-container:hover {
    /* box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); */
}

.item-text {
    font-size: 20px;
    color: #333;
    line-height: 1.6;
    word-wrap: break-word;
    margin-bottom: 0px;
}

.item-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 5px;
}

.action-btn {
    cursor: pointer;
    color: #409EFF;
    font-weight: 500;
    transition: color 0.2s;
}

.action-btn:hover {
    color: #66b1ff;
}

.fixed-textarea {

    font-size: 20px;
}
</style>