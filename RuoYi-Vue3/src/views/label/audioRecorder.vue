<template>
    <div class="app-container">
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
            <el-form-item :label="$t('label.audioRecorder.task_id')" prop="taskId">
                <el-input v-model="queryParams.taskId" :placeholder="$t('label.audioRecorder.enter_task_id')" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item :label="$t('label.audioRecorder.task_package_id')" prop="packageId">
                <el-input v-model="queryParams.packageId" :placeholder="$t('label.audioRecorder.enter_task_package_id')" clearable @keyup.enter="handleQuery" />
            </el-form-item>

            <el-form-item :label="$t('label.audioRecorder.annotator')" prop="annotator">
                <el-input v-model="queryParams.annotator" :placeholder="$t('label.audioRecorder.enter_annotator')" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item :label="$t('label.audioRecorder.auditor')" prop="auditor">
                <el-input v-model="queryParams.auditor" :placeholder="$t('label.audioRecorder.enter_auditor')" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">{{ $t('label.audioRecorder.search') }}</el-button>
                <el-button icon="Refresh" @click="resetQuery">{{ $t('label.audioRecorder.reset') }}</el-button>
            </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
            <el-col :span="1.5" style="display: none;">
                <el-button type="primary" plain icon="Plus" @click="handleAdd"
                    v-hasPermi="['label:records:add']">{{ $t('label.audioRecorder.add') }}</el-button>
            </el-col>
 
            <el-col :span="1.5">
                <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
                    v-hasPermi="['label:records:remove']">{{ $t('label.audioRecorder.remove') }}</el-button>
            </el-col>
          
            <!-- <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar> -->
             <div class="top-right-btn" style="display: flex;flex-direction: row;gap: 0px;"> 
                
                <template v-if="['unstart','underway','reject','pass'].includes(task.status)">                
                    <el-col :span="1.5">
                        <el-button type="success" plain icon=""  @click="clickSummitTask()"
                            >{{ $t('label.audioRecorder.submit_review') }}</el-button>
                    </el-col>
                </template>

                <template v-else-if="['pending_review'].includes(task.status)">
                    <el-col :span="1.5">
                        <el-button type="danger" plain @click="dialogFormVisible = true" vhasPermi="['label:task:audit']">{{ $t('label.audioRecorder.reject_task') }}</el-button>
                    </el-col>
                    <el-col :span="1.5">
                        <el-button type="success" plain @click="auditTask('pass')" vhasPermi="['label:task:audit']">{{ $t('label.audioRecorder.approve_task') }}</el-button>
                    </el-col>
                </template>

            </div>
        </el-row>

        <el-table 
        v-loading="loading" 
        :data="recordsList" 
        @selection-change="handleSelectionChange"
        :row-class-name="recording"
        >
            <el-table-column type="selection" width="50" align="center" />
            <el-table-column :label="$t('label.audioRecorder.serial_number')" align="center" width="50">
                <template #default="{ $index }">
                    {{ ($index + 1) + (queryParams.pageNum - 1) * queryParams.pageSize }}
                </template>
            </el-table-column>

            <el-table-column :label="$t('label.audioRecorder.keyword')" width="200"  >
                <template #default="{ row, $index }">
                    
                    <el-input
                        v-if="$index==editingKeywordsIndex"
                        ref="editKeywordsInput"
                        class="item-keywords__edit"
                        style="color: #333 !important;"
                        v-model="row.keywords"                                
                        autosize
                        type="textarea"
                        @keydown.enter.prevent="keyEnterConfirmEditKeywords(row, $index)"
                        @keydown.esc="keyEscCancelEditKeywords()"
                        @blur="blurKeyword(row, $index)"
                    />

                    <div v-else @click="clickStartEditKeywords($index)" class="item-keywords" style="text-align: left;">
                        {{ row.keywords }}
                    </div>

                </template>
            </el-table-column>

            <!-- <el-table-column label="" align="center" prop="text" /> -->
            <el-table-column :label="$t('label.audioRecorder.text_content')" align="left">
                <template #default="{ row, $index }">
                    <!-- <div style="display: flex;flex-direction: row;gap:15px;align-items: center;">

                        <div class="item-text">
                            {{ row.modifiedText != null ? row.modifiedText : row.text }}
                        </div>
                    </div> -->
                    <div class="item-container">
                        <!-- 上部文本 -->
                        <div style="display: flex;flex-direction: row;gap:15px;align-items: center;">

                            <el-input
                                v-if="$index==editingIndex"
                                ref="editInput"
                                class="item-text__edit"
                                style="color: #333 !important;"
                                v-model="row.text"                                
                                autosize
                                type="textarea"
                                @keydown.enter.prevent="keyEnterConfirmEdit(row, $index)"
                                @keydown.esc="keyEscCancelEdit()"
                                @blur="blurText(row, $index)"
                            />

                            <div v-else @click="clickStartEdit($index)" class="item-text" style="text-align: left !important;">
                                {{ row.modifiedText != null ? row.modifiedText : row.text }}
                            </div>

                        </div>


                        <!-- 下部操作按钮 -->
                        <div class="item-actions">

                            <span v-if="row.audioFilePath != null && recordingRecordIndex != $index" class="action-btn"
                                style="display: flex; flex-direction: row;gap: 5px;">

                                <el-icon size="22" color="green">
                                    <Paperclip />
                                </el-icon>
                                <span style="color: #5c5c5c;">
                                    {{ row.audioDuration }} s
                                </span>
                            </span>

                            <span v-else-if="recordingRecordIndex == $index" class="action-btn"
                                style="display: flex; flex-direction: row;gap: 5px;">

                                <el-icon size="22">
                                    <AlarmClock />
                                </el-icon>
                                <span style="color: green;">
                                    {{ row.audioDuration ? row.audioDuration + ' s' : '00.00 s' }}
                                </span>
                            </span>


                            <span class="action-btn" @click="toggleRecordingWithConfirmation($index)">

                                <el-tooltip
                                    class="box-item"
                                    effect="dark"
                                    :content="$t('label.audioRecorder.recording')"
                                    placement="bottom"
                                    v-if="!recordingStates[$index]" 
                                >
                                    <el-icon size="22">
                                        <Microphone />
                                    </el-icon>
                                </el-tooltip>

                                <el-tooltip
                                    class="box-item"
                                    effect="dark"
                                    :content="$t('label.audioRecorder.finish')"
                                    placement="bottom"
                                    v-else 
                                >
                                    <el-icon size="22" color="#ff3939">
                                        <Mute />
                                    </el-icon>
                                </el-tooltip>

                            </span>

                            <span class="action-btn" @click="togglePlaying($index)">
                                <el-tooltip
                                    class="box-item"
                                    effect="dark"
                                    :content="$t('label.audioRecorder.play')"
                                    placement="bottom"
                                    v-if="!playingStates[$index]">

                                    <el-icon  size="22">
                                        <VideoPlay />
                                    </el-icon>
                                </el-tooltip>
                                
                                <el-tooltip
                                    class="box-item"
                                    effect="dark"
                                    :content="$t('label.audioRecorder.pause')"
                                    placement="bottom"
                                    v-else>

                                    <el-icon size="22">
                                        <VideoPause />
                                    </el-icon>

                                </el-tooltip>
                            </span>


                            <span class="action-btn" @click="handleUpdate(row)" style="display:none">
                                <el-tooltip
                                    class="box-item"
                                    effect="dark"
                                    :content="$t('label.audioRecorder.edit')"
                                    placement="bottom">
                                
                                    <el-icon size="22" color="orange">
                                        <Edit />
                                    </el-icon>
                                </el-tooltip>                                
                            </span>

                            <span class="action-btn" @click="openDeleteDialog($index)">
                                <el-icon size="22" color="#575757">
                                    <Delete />
                                </el-icon>
                            </span>
                        </div>
                    </div>
                </template>
            </el-table-column>

            <!-- <el-table-column label="" align="center" class-name="small-padding fixed-width">
                <template #default="scope">
                    <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
                        v-hasPermi="['label:records:edit']">{{ $t('label.audioRecorder.edit') }}</el-button>
                    <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
                        v-hasPermi="['label:records:remove']">{{ $t('label.audioRecorder.delete') }}</el-button>
                </template>
            </el-table-column> -->
        </el-table>

        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
            v-model:limit="queryParams.pageSize" @pagination="getList" />

        <!-- 添加或修改文件录音对话框 -->
        <el-dialog :title="title" v-model="open" width="500px" append-to-body>
            <el-form ref="recordsRef" :model="form" :rules="rules" label-width="80px">

                <el-form-item :label="$t('label.audioRecorder.text_content')" prop="text">
                    <el-input v-model="form.text" type="textarea" rows="8" :placeholder="$t('label.audioRecorder.text_content')"
                        style="font-size: 18px;" />
                </el-form-item>


            </el-form>
            <template #footer>
                <div class="dialog-footer">
                    <el-button type="primary" @click="submitForm">{{ $t('label.audioRecorder.confirm') }}</el-button>
                    <el-button @click="cancel">{{ $t('label.audioRecorder.cancel') }}</el-button>
                </div>
            </template>
        </el-dialog>

        <!-- 删除确认对话框 -->
        <el-dialog v-model="deleteDialogVisible" :title="$t('label.audioRecorder.confirm_delete')" width="400px">
            <div class="delete-dialog-content">
                <p>{{ $t('label.audioRecorder.confirm_delete_record') }}</p>
                <p class="delete-text-preview">{{ clickedRecord.text || clickedRecord.modifiedText }}</p>
            </div>

            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="cancelDelete">{{ $t('label.audioRecorder.cancel') }}</el-button>
                    <el-button type="danger" @click="confirmDelete">{{ $t('label.audioRecorder.remove') }}</el-button>
                </div>
            </template>
        </el-dialog>

        <!-- 覆盖录音对话框 -->
        <el-dialog v-model="overwriteRecordDialogVisible" :title="$t('label.audioRecorder.confirm_overwrite')" width="400px">
            <div class="delete-dialog-content">
                <p>{{ $t('label.audioRecorder.confirm_overwrite_record') }}</p>
            </div>

            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="cancelOverwriteRecord">{{ $t('label.audioRecorder.cancel') }}</el-button>
                    <el-button type="danger" @click="confirmOverwriteRecord">{{ $t('label.audioRecorder.confirm') }}</el-button>
                </div>
            </template>
        </el-dialog>

        <!-- 审核驳回对话框 -->
        <el-dialog v-model="dialogFormVisible" :title="$t('label.audioRecorder.reject_task')" width="500">
          <el-input v-model="dialogFormRemark" type="textarea" :rows="3" :placeholder="$t('label.audioRecorder.reject_reason')" style="width: 100%;" />
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="dialogFormVisible = false">{{ $t('label.audioRecorder.cancel') }}</el-button>
              <el-button type="primary" @click="rejectTask()">{{ $t('label.audioRecorder.confirm') }}</el-button>
            </div>
          </template>
        </el-dialog>
    </div>
</template>

<script setup name="Records">

import { listTask, getTask, delTask, addTask, updateTask } from "@/api/label/task"
import { listRecords, getRecords, delRecords, addRecords, updateRecords } from "@/api/label/records"
import * as XLSX from "xlsx"
import { getToken } from "@/utils/auth"

const { proxy } = getCurrentInstance()
const route = useRoute()


const recordsList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(false)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")


const data = reactive({
    form: {},
    queryParams: {
        pageNum: 1,
        pageSize: 10,
        taskId: route.params.taskId,
        packageId: null,
        itemOrder: null,
        text: null,
        modifiedText: null,
        audioFilePath: null,
        annotator: null,
        auditor: null,
    },
    rules: {
        packageId: [
            { required: true, message: proxy.$t('label.taskPackage.packageIdNotBlank'), trigger: "blur" }
        ],
        itemOrder: [
            { required: true, message: proxy.$t('label.records.itemOrderNotBlank'), trigger: "blur" }
        ],
        text: [
            { required: true, message: proxy.$t('label.records.textNotBlank'), trigger: "blur" }
        ],
    }
})

const { queryParams, form, rules } = toRefs(data)

const task = ref({status:"?"})
let dialogFormVisible = ref(false)
let dialogFormRemark = ref('')

/** 审核任务 */
function auditTask(status) {
  let confirmTxt = proxy.$t('label.audioRecorder.review_approved') + '？'
  if(status == 'reject'){
    confirmTxt = proxy.$t('label.audioRecorder.review_rejected') + '？'
  }
  proxy.$modal.confirm(confirmTxt).then(function () {
    let sysTask = {
        taskId: task.value.taskId,
        status: status,
        remark: proxy.$t('label.audioRecorder.review_approved')
      }
    const formData = new FormData();
    formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
    updateTask(formData).then(response => {
      proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.review_approved'))

      setTimeout(() => {
        proxy.$tab.closePage()
        proxy.$tab.closeOpenPage(`/label/my-task/index/${task.value.taskId}/`)
      }, 1000)
      
    })
  })
}

/** 查询文件录音列表 */
function getList() {
    loading.value = true
    if (_responseRecords != null) {
        if (_responseRecords.total > 0) {
            recordsList.value = _responseRecords.rows
            total.value = _responseRecords.total
            
            loading.value = false
            _responseRecords = null
        }
    } else {
        listRecords(queryParams.value)
        .then(response => {
            recordsList.value = response.rows
            total.value = response.total
            loading.value = false
        })
        .catch(() => {
            loading.value = false
        })
    }
}

// 取消按钮
function cancel() {
    open.value = false
    reset()
}

// 表单重置
function reset() {
    form.value = {
        id: null,
        taskId: null,
        packageId: null,
        itemOrder: null,
        text: null,
        modifiedText: null,
        audioFilePath: null,
        annotator: null,
        auditor: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
    }
    proxy.resetForm("recordsRef")
}

/** 搜索按钮操作 */
function handleQuery() {
    queryParams.value.pageNum = 1
    getList()
}

/** 重置按钮操作 */
function resetQuery() {
    proxy.resetForm("queryRef")
    handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
    ids.value = selection.map(item => item.id)
    single.value = selection.length != 1
    multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
    reset()
    open.value = true
    title.value = proxy.$t('label.audioRecorder.add')
}

/** 修改按钮操作 */
function handleUpdate(row) {
    reset()
    const _id = row.id || ids.value
    getRecords(_id).then(response => {
        form.value = response.data
        open.value = true
        title.value = proxy.$t('label.audioRecorder.edit')
    })
}

/** 提交按钮 */
function submitForm() {
    proxy.$refs["recordsRef"].validate(valid => {
        if (valid) {
            if (form.value.id != null) {
                updateRecords(form.value).then(response => {
                    proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.modify_success'))
                    open.value = false
                    getList()
                })
            } else {
                addRecords(form.value).then(response => {
                    proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.add_success'))
                    open.value = false
                    getList()
                })
            }
        }
    })
}

/** 删除按钮操作 */
function handleDelete(row) {
    const _ids = row.id || ids.value
    proxy.$modal.confirm(proxy.$t('label.records.confirm_delete') + '"' + _ids + '"？').then(function () {
        return delRecords(_ids)
    }).then(() => {
        getList()
        proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.delete_success'))
    }).catch(() => { })
}

const editingKeywordsIndex = ref(-1)
const editKeywordsInput = ref(null)
var modifiedKeywords = false
var editingKeywords = ""

function clickStartEditKeywords(index) {

    if(!modifiedKeywords && editingKeywordsIndex.value != -1){
        if(recordsList.value[editingKeywordsIndex.value].keywords != editingKeywords){
            recordsList.value[editingKeywordsIndex.value].keywords = editingKeywords
        }
    }

    modifiedKeywords = false
    editingKeywordsIndex.value = index
    editingKeywords = recordsList.value[editingKeywordsIndex.value].keywords
    nextTick(() => {
        editKeywordsInput.value?.focus()
    })
}

function keyEscCancelEditKeywords() {
    recordsList.value[editingKeywordsIndex.value].keywords = editingKeywords
    editingKeywordsIndex.value = -1
}


function keyEnterConfirmEditKeywords(row, index) {
    editingKeywordsIndex.value = -1
    if(editingKeywords != row.keywords){
        updateRecords(row).then((response) => {
            proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.modify_success'))
            modifiedKeywords = true
        })
    }
}


function blurKeyword(row, index) {
    if(editingKeywordsIndex.value != -1){
        recordsList.value[editingKeywordsIndex.value].keywords = editingKeywords
        editingKeywordsIndex.value = -1
    }
}

const editingIndex = ref(-1)
const editInput = ref(null)
var modified = false
var editingText = ""

function clickStartEdit(index) {

    if(!modified && editingIndex.value != -1){
        if(recordsList.value[editingIndex.value].text != editingText){
            recordsList.value[editingIndex.value].text = editingText
        }
    }

    modified = false
    editingIndex.value = index
    editingText = recordsList.value[index].text
    nextTick(() => {
        editInput.value?.focus()
    })
}

function keyEscCancelEdit(){
    recordsList.value[editingIndex.value].text = editingText    
    editingIndex.value = -1
}

function keyEnterConfirmEdit(row, index) {

    editingIndex.value = -1
    if(editingText != row.text){
        updateRecords(row).then((response) => {
            proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.modify_success'))
            modified = true
        })
    }
  
}

function blurText(row, index) {
    if(editingIndex.value != -1){
        recordsList.value[editingIndex.value].text = editingText
        editingIndex.value = -1
    }
}


function clickSummitTask() {
    proxy.$modal.confirm(proxy.$t('label.audioRecorder.submit_review_confirm')).then(function () {
        const formData = new FormData();
        let sysTask = {
            taskId: task.value.taskId,            
            status: 'pending_review',
        }
        formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));

        updateTask(formData).then(response => {
            proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.task_closed'))
            setTimeout(() => {
                proxy.$tab.closePage()
                proxy.$tab.closeOpenPage(`/label/my-task/index/${task.value.taskId}/`)
            }, 1000)
        })
    })
}

const overwriteRecordDialogVisible = ref(false)
const overwriteRecordIndex = ref(-1)

function cancelOverwriteRecord() {
    overwriteRecordDialogVisible.value = false
    overwriteRecordIndex.value = -1
}

function confirmOverwriteRecord() { 
    overwriteRecordDialogVisible.value = false
    toggleRecording(overwriteRecordIndex.value)
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

    delRecords([recordsList.value[deletingIndex.value].id])
        .then((response) => {
            proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.delete_success'))
            recordsList.value.splice(deletingIndex.value, 1)
        })

    deleteDialogVisible.value = false
}


const dialogVisible = ref(false)
const deleteDialogVisible = ref(false)
const modifyingIndex = ref(-1)
const deletingIndex = ref(-1)
const clickedRecord = ""

const recordingStates = ref(Array(recordsList.value.length).fill(false))
const playingStates = ref(Array(recordsList.value.length).fill(false))
var _responseRecords = {}
var hasRecording = false

function toggleRecordingWithConfirmation(index) {
    if (index != recordingRecordIndex && hasRecording) {
        proxy.$modal.msgError(proxy.$t('label.audioRecorder.recording_stopped'))
        return
    }

    if(playingIndex != -1){
        playingStates.value[playingIndex] = false
        playingIndex = -1
        hasPalying = false
    }

    if(!hasRecording){
        if(recordsList.value[index].audioFilePath != null){
            overwriteRecordDialogVisible.value = true
            overwriteRecordIndex.value = index
        }else{        
            toggleRecording(index)
        }
    }else{
        toggleRecording(index)
    }
}
function toggleRecording(index) {

    recordingStates.value[index] = !recordingStates.value[index]    
    if (recordingStates.value[index]) {

        hasRecording = true
        recordingRecord = recordsList.value[index]
        recordingRecordIndex = index
        recordingRecordIndexForUI.value = index
        startRecording()
        proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.recording_started'))

    }
    else {

        stopRecording()
        // proxy.$modal.msgWarning(proxy.$t('label.audioRecorder.recording_stopped'))
        hasRecording = false
        recordingRecordIndex = -1
    }

    // 如果录音启动，播放状态自动停止
    if (recordingStates.value[index]) playingStates.value[index] = false
}


var audio = null
var playingIndex = -1
var hasPalying = false
function togglePlaying(index) {
    
    if(hasRecording){
        proxy.$modal.msgError(proxy.$t('label.audioRecorder.recording_error'))
        return
    }

    if (recordsList.value[index].audioFilePath == null) {
        return
    }

    if (index != playingIndex) {
        if (hasPalying) {
            proxy.$modal.msgError(proxy.$t('label.audioRecorder.recording_stopped'))
            return
        }
    }


    if (index != playingIndex) {
        audio = new Audio(import.meta.env.VITE_APP_BASE_API + recordsList.value[index].audioFilePath)
        audio.onended = () => {

            playingStates.value[index] = false
            hasPalying = false
        }
        playingIndex = index
    }

    playingStates.value[index] = !playingStates.value[index]
    if (playingStates.value[index]) {
        audio.play()
            .then(() => { })
            .catch(err => console.error(proxy.$t('label.audioRecorder.play') + proxy.$t('label.audioRecorder.failed'), err))

        hasPalying = true
    }
    else {
        audio.pause()
        hasPalying = false
    }

    // 如果播放启动，录音状态自动停止
    if (playingStates.value[index]) recordingStates.value[index] = false
}

function openDialog(index) {
    modifyingIndex.value = index
    clickedRecord.value = recordsList.value[index]
    dialogVisible.value = true
}


let mediaRecorder = null
let audioStream = null
let audioChunks = []
let recordingRecord = null
let recordingRecordIndex = -1
let recordingRecordIndexForUI = ref(-1)
const isRecording = ref(false)

let recordStartTime = 0
let recordTimer = null
const recordDuration = ref('00.00') 
/**
 * 开始录音
 */
const startRecording = async () => {
    try {
        playingIndex = -1
        audioStream = await navigator.mediaDevices.getUserMedia({ audio: true })
        mediaRecorder = new MediaRecorder(audioStream, { mimeType: 'audio/webm' })

        audioChunks = []

        mediaRecorder.ondataavailable = (e) => {
            if (e.data.size > 0) audioChunks.push(e.data)
        }

        mediaRecorder.onstop = async () => {
            clearInterval(recordTimer)
            // 获取录音时长（秒）

            const webmBlob = new Blob(audioChunks, { type: 'audio/webm' })
            const wavBlob = await convertWebMToWav(webmBlob)
            // downloadWav(wavBlob)
            // 将录音 blob 上传            
            const file = new File([wavBlob], `${recordingRecord.packageId}-${recordingRecord.taskId}-${recordingRecord.itemOrder}.wav`, { type: 'audio/wav' })

            uploadFile(file)
        }

        mediaRecorder.start()
        isRecording.value = true

        recordStartTime = Date.now()
        recordTimer = setInterval(() => {
            const elapsed = (Date.now() - recordStartTime) / 1000
            recordDuration.value = elapsed.toFixed(2)
            recordsList.value[recordingRecordIndex].audioDuration = formatDuration(elapsed)
        }, 1000)
    } catch (err) {
        console.error(proxy.$t('label.audioRecorder.no_microphone_access'), err)
    }
}

/**
 * 停止录音
 */
const stopRecording = () => {
    if (mediaRecorder && isRecording.value) {
        mediaRecorder.stop()
        isRecording.value = false

    }

    if (audioStream) {
        audioStream.getTracks().forEach((t) => t.stop())
        audioStream = null
    }
}


const recording = ({ row, rowIndex }) => {
  return rowIndex === recordingRecordIndexForUI.value ? 'recording' : ''
}



/**
 * 上传文件到 /common/upload
 * @param {File|Blob} file
 */
function uploadFile(file) {
    const headers = { Authorization: "Bearer " + getToken() }
    const formData = new FormData()
    formData.append('file', file, file.name)

    fetch(import.meta.env.VITE_APP_BASE_API+'/common/upload', {
        method: 'POST',
        headers: headers,
        body: formData
    })
        .then(res => res.json())
        .then(async (res) => {
            if (res.code === 200) {
                
                const audio = new Audio(URL.createObjectURL(file));

                const duration = await new Promise((resolve, reject) => {
                    audio.addEventListener('loadedmetadata', () => {
                        const d = audio.duration;
                        const intPart = Math.floor(d);
                        const decimal = Math.floor((d - intPart) * 100);
                        const formatted = `${String(intPart).padStart(2, '0')}.${String(decimal).padStart(2, '0')}`;
                        URL.revokeObjectURL(audio.src);
                        resolve(formatted);
                    });
                    audio.addEventListener('error', err => {
                        URL.revokeObjectURL(audio.src);
                        reject(err);
                    });
                });
            
                audio.addEventListener('error', (err) => {
                    console.error(proxy.$t('label.audioRecorder.recording_error') + ':', err)
                })

                recordingRecord.audioFilePath = res.fileName
                recordingRecord.audioDuration = duration
                recordsList.value[recordingRecordIndex] = recordingRecord
                updateRecords(recordingRecord).then((response) => {
                    proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.upload_success'))
                })

            } else {
                console.error(proxy.$t('label.audioRecorder.upload_failed') + ':', res)
                proxy.$modal.msgError(proxy.$t('label.audioRecorder.upload_failed'))
            }
        })
        .catch(err => {
            console.error(proxy.$t('label.audioRecorder.upload_failed') + ':', err)

        })
        .finally(() => {
            recordingRecord = null
            recordingRecordIndex = -1
            recordingRecordIndexForUI.value = -1
        })
}


onMounted(async () => {
    const taskId = route.params.taskId

    try {
        const responseTask = await getTask(taskId)
        task.value = responseTask.data

        const responseRecords = await listRecords({ taskId: task.value.taskId })
        
        const url = `${import.meta.env.VITE_APP_BASE_API}${task.value.audioFilePath}`

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

                // 转成二维数组
                const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 })

                // 第一列（A列）
                const keyWords = rows.map(row => row[0])

                // 从第二列开始
                const texts = rows.map(row => row.slice(1))

                const newRecords = []

                // 按行处理
                texts.forEach((row, index) => {
                    const rowStr = row.join(", ")

                    const record = {
                        taskId: task.value.taskId,
                        packageId: task.value.packageId,
                        itemOrder: index + 1,
                        text: rowStr,
                        keywords: keyWords[index]
                    }

                    newRecords.push(record)                
                })
                addRecords(newRecords).then(response => {
                    // this.$modal.msgSuccess("新增成功")
                    getList()
                })

            } catch (error) {
                console.log(error)
            }
        } else {
            _responseRecords = responseRecords
            getList()
        }

    } catch (error) {

    }


})


// === 辅助函数 ===

function formatDuration(seconds) {
    const intPart = Math.floor(seconds)
    const decimalPart = Math.floor((seconds % 1) * 100)

    const intStr = intPart.toString().padStart(2, '0')
    const decimalStr = decimalPart.toString().padStart(2, '0')

    return `${intStr}.${decimalStr}`
}


/**
 * 将 WebM Blob 转为 WAV Blob
 */
const convertWebMToWav = async (webmBlob) => {
    const arrayBuffer = await webmBlob.arrayBuffer()
    const audioCtx = new AudioContext()
    const audioBuffer = await audioCtx.decodeAudioData(arrayBuffer)

    const numOfChan = audioBuffer.numberOfChannels
    const sampleRate = audioBuffer.sampleRate
    const format = 1 // PCM
    const bitDepth = 16

    let interleaved
    if (numOfChan === 2) {
        interleaved = interleave(audioBuffer.getChannelData(0), audioBuffer.getChannelData(1))
    } else {
        interleaved = audioBuffer.getChannelData(0)
    }

    const buffer = new ArrayBuffer(44 + interleaved.length * 2)
    const view = new DataView(buffer)

    writeString(view, 0, 'RIFF')
    view.setUint32(4, 36 + interleaved.length * 2, true)
    writeString(view, 8, 'WAVE')
    writeString(view, 12, 'fmt ')
    view.setUint32(16, 16, true)
    view.setUint16(20, format, true)
    view.setUint16(22, numOfChan, true)
    view.setUint32(24, sampleRate, true)
    view.setUint32(28, sampleRate * numOfChan * bitDepth / 8, true)
    view.setUint16(32, numOfChan * bitDepth / 8, true)
    view.setUint16(34, bitDepth, true)
    writeString(view, 36, 'data')
    view.setUint32(40, interleaved.length * 2, true)
    floatTo16BitPCM(view, 44, interleaved)

    return new Blob([view], { type: 'audio/wav' })
}

/**
 * 下载 wav 文件
 */
const downloadWav = (blob) => {
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `record_${Date.now()}.wav`
    a.click()
    URL.revokeObjectURL(url)
}

const writeString = (view, offset, string) => {
    for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i))
    }
}

const interleave = (left, right) => {
    const length = left.length + right.length
    const result = new Float32Array(length)
    let inputIndex = 0
    for (let index = 0; index < length;) {
        result[index++] = left[inputIndex]
        result[index++] = right[inputIndex]
        inputIndex++
    }
    return result
}

const floatTo16BitPCM = (output, offset, input) => {
    for (let i = 0; i < input.length; i++, offset += 2) {
        let s = Math.max(-1, Math.min(1, input[i]))
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7fff, true)
    }
}

function rejectTask(){
  
    if(!dialogFormRemark.value){
    proxy.$modal.msgError(proxy.$t('label.audioRecorder.reject_reason_required'))
    return
    }
    dialogFormVisible = false

    //准备提交的参数
    let sysTask = {
        taskId: task.value.taskId,      
        status: 'reject',
        remark: proxy.$t('label.audioRecorder.reject_task') + ':' + dialogFormRemark.value
    }
    const formData = new FormData();
    formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
    updateTask(formData).then(response => {
        proxy.$modal.msgSuccess(proxy.$t('label.audioRecorder.task_rejected'))
        setTimeout(() => {
            proxy.$tab.closePage()
            proxy.$tab.closeOpenPage(`/label/my-task/index/${task.value.taskId}/`)
        }, 1000)
    
  })

}
