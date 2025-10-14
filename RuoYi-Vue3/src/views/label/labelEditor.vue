<!--解决times不更新显示问题之前的备份-->
<template>
  <div class="app-container" ref="root">
    <el-row :gutter="10" class="mb8">
      <el-col :span="24">
        <h2> 任务包：{{ taskPackageName }} (Task ID: {{ taskId }})</h2>
      </el-col>
    </el-row>
    
    <el-form v-if="flag" :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="任务状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择任务状态" clearable style="width: 120px;">
          <el-option
            v-for="dict in task_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row v-if="flag" :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
          v-hasPermi="['label:project:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['label:project:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['label:project:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="Download"
          @click="handleExport"
          v-hasPermi="['label:project:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-if="flag" v-loading="loading" :data="taskList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
<!--      <el-table-column label="任务ID" align="center" prop="taskId" />-->
      <el-table-column label="音频文件名" align="center" prop="audioFileName" />
      <el-table-column v-if="false" label="音频波形" align="center">
        <template #default="scope">
          <div :id="'waveform-' + scope.row.taskId" class="waveform-container" style="width: 100%; height: 60px;"></div>
        </template>
      </el-table-column>
      <el-table-column label="任务状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="task_status" :value="scope.row.status"/>
        </template>
      </el-table-column>
<!--      <el-table-column label="分配人账户名" align="center" prop="annotator" />-->
<!--      <el-table-column label="审核人员账户名" align="center" prop="auditor" />-->
      <el-table-column label="创建者" align="center" prop="createBy" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center" prop="remark" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['label:project:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['label:project:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination  v-if="flag"
      v-show="total>0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />


    <!-- 语音标注demo -->
    <div id="waveform-demo" class="waveform-container" style="width: 100%; height: 100px; margin-top: 0px;"></div>
    
    <div style="margin-top: 40px; display: flex; justify-content: center; align-items: center;font-size: 14px;">
      <el-button id="backward">|◁上一段</el-button>
      <el-button id="play">▶播放/‖暂停</el-button>
      <el-button id="forward">下一段▷|</el-button>
      <view style="margin-left: 12px;display: flex;align-items: center;">
        音量<el-slider v-model="volume" style="width: 100px"/>
      </view>
      <view style="margin-left: 12px;display: flex;align-items: center;">
        倍速<el-select v-model="playbackRate" size="small" style="width: 100px" >
          <el-option
            v-for="item in playbackRateList"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </view>
      <!-- <view style="margin-left: 12px;display: flex;align-items: center;">
        循环播放<el-switch v-model="loopPlay" />
      </view> -->
      
    </div>

    <div style="margin-top: 20px; display: flex;">
      <!--分段列表-->
      <!-- <table border="1">
        <thead>
          <tr>
            <th>分段序号</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>标注内容</th>
          </tr>          
        </thead>
        <tbody>
          <tr v-for="(ts, index) in times">
            <td>{{ index + 1}}</td>
            <td>{{ formatSecondsToMMSSS(ts.start) }}</td>
            <td>{{ formatSecondsToMMSSS(ts.end) }}</td>
            <td>{{ ts.text }}</td>
          </tr>
        </tbody>
      </table> -->

      <el-table :data="times" :highlight-current-row="false" style="width: 100%" :row-class-name="tableRowClassName" @row-click="rowClick" > 
          <el-table-column label="分段序号" width="100"> 
            <template #default="scope"> 
              {{ scope.$index + 1 }}
            </template>
          </el-table-column>
          <el-table-column label="开始时间" width="200"> 
            <template #default="scope"> 
              {{ scope.row.start }}
            </template>
          </el-table-column>
          <el-table-column label="结束时间" width="200"> 
            <template #default="scope"> 
              {{ scope.row.end }}
            </template>
          </el-table-column>
          <el-table-column label="标注内容" > 
            <template #default="scope"> 
              <el-input type="textarea" v-model="scope.row.text" placeholder="请输入标注文本内容" style="width:100%;" />
            </template>
          </el-table-column>
          <el-table-column label="文本长度" width="200"> 
            <template #default="scope"> 
              {{ scope.row.text.length }}
            </template>
          </el-table-column>
      </el-table>

    </div>



    <!-- 添加或修改任务对话框 -->
    <el-dialog :title="title" v-model="open" width="700px" append-to-body>
      <el-form ref="taskRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="音频文件名" prop="audioFileName">
          <file-upload v-model="form.audioFileName" :file-size="20" :limit="1"/>
        </el-form-item>
        <el-form-item label="音频波形">
          <div id="waveform-detail" class="waveform-container" v-if="form.audioFileName" style="width: 100%; height: 100px;"></div>
          <div v-else>请先上传音频文件</div>
        </el-form-item>
        <el-form-item label="任务状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择任务状态">
            <el-option
              v-for="dict in task_status"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
<!--        <el-form-item label="分配人账户名" prop="annotator">-->
<!--          <el-input v-model="form.annotator" placeholder="请输入分配人账户名" />-->
<!--        </el-form-item>-->
<!--        <el-form-item label="审核人员账户名" prop="auditor">-->
<!--          <el-input v-model="form.auditor" placeholder="请输入审核人员账户名" />-->
<!--        </el-form-item>-->
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Task">
import { listTask, getTask, delTask, addTask, updateTask } from "@/api/label/task"
import WaveSurfer from "wavesurfer.js"
import RegionsPlugin from 'wavesurfer.js/dist/plugins/regions.esm.js'
import TimelinePlugin from 'wavesurfer.js/dist/plugins/timeline.esm.js'
import ZoomPlugin from 'wavesurfer.js/dist/plugins/zoom.esm.js'
import Hover from 'wavesurfer.js/dist/plugins/hover.esm.js'
import { nextTick, onMounted, onUnmounted, reactive, watch } from "vue"

const { proxy } = getCurrentInstance()
const { task_status } = proxy.useDict('task_status')
const route = useRoute()

const taskList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const flag = ref(false)
let volume = ref(50)
let playbackRateList = ref([
  { label: '2.0x', value: 2.0 },
  { label: '1.5x', value: 1.5 },
  { label: '1.25x', value: 1.25 },
  { label: '1.0x', value: 1.0 },
  { label: '0.75x', value: 0.75 },
  { label: '0.5x', value: 0.5 },
  { label: '0.25x', value: 0.25 },
  
])
let playbackRate = ref({ label: '1.0x', value: 1.0 })
let loopPlay = ref(false)

watch(volume,(newVal, oldVal)=>{
  ws.setVolume(newVal/100)
})
watch(playbackRate,(newVal, oldVal)=>{
  console.log('playbackRate-->', newVal)
  ws.setPlaybackRate(newVal, true)
})

let ws = null;
// 当前激活的颜色
let activeColor = 'rgba(255, 255, 0, 0.3)';
// 当前激活的区域
let activeRegion = reactive({start: 0, end: 0, text:''})
// 音频总时长
let duration = ref(0)
// 音频标注分段列表
let times = reactive([
  {start: 0, end: 5, text: '111'},
  {start: 5, end: 10, text: '222'},
  {start: 10, end: 15, text: '333'},
  {start: 15, end: 20, text: '444'},
  {start: 20, end: duration, text: '555'},
])

// 定义行类名函数
const tableRowClassName = ({ row, rowIndex }) => {
  // 示例条件：高亮开始时间为0的行
  if (row.start === activeRegion.start && row.end===activeRegion.end) {
    return 'highlight-row'
  }
  // 可以添加更多条件
  // if (row.text === '222') {
  //   return 'special-row'
  // }
  return ''
}

const root = ref(null);

const handleSpace = (event) => {
  if (event.key === ' ') { // 确保是空格键被按下
    console.log('空格键被按下');
    ws.playPause()
  }
};

onMounted(() => {
  if (root.value) {
    
  }
});


// Wavesurfer实例
const wavesurferInstances = ref({})





// 获取路由参数
const taskPackageId = route.params.taskPackageId
const taskPackageName = route.params.taskPackageName
const taskId = route.params.taskId  // 从路由中获取taskId

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    audioFileName: null,
    status: null,
    annotator: null,
    auditor: null,
    createBy: null,
    taskPackageId: taskPackageId  // 添加任务包ID作为查询条件
  },
  rules: {
    packageId: [
      { required: true, message: "所属包的ID不能为空", trigger: "blur" }
    ],
    audioFileName: [
      { required: true, message: "音频文件名不能为空", trigger: "blur" }
    ],
    audioFilePath: [
      { required: true, message: "音频文件在服务器的路径不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询任务列表 */
function getList() {
  loading.value = true
  // 设置查询条件，根据任务包ID查询任务
  if (taskPackageId) {
    queryParams.value.packageId = taskPackageId
  }
  listTask(queryParams.value).then(response => {
    taskList.value = response.rows
    total.value = response.total
    loading.value = false
    
    // 等待DOM更新后渲染波形
    nextTick(() => {
      renderWaveforms()      
      // renderDemoWaveform()
    })
  })
}

// 获取音频文件URL（需要根据实际路径结构调整）
function getAudioUrl(audioFileName) {
  console.log("getAudioUrl-->", audioFileName)
  // 使用完整的API路径访问音频文件
  // 根据错误信息中的URL，需要添加/dev-api前缀
  if (audioFileName.startsWith('/profile/upload/')) {
    return `/dev-api${audioFileName}`;
  } else {
    return `/dev-api/profile/upload/${audioFileName}`;
  }
}


// 添加一个错误处理函数来更好地调试波形加载问题
function handleWaveSurferError(taskId, error) {
  console.error(`加载任务 ${taskId} 的波形时出错:`, error);
}


// 渲染波形
function renderWaveforms() {
  // 清除之前的实例
  Object.values(wavesurferInstances.value).forEach(instance => {
    instance.destroy()
  })
  wavesurferInstances.value = {}
  
  // 为每个任务创建波形实例
  taskList.value.forEach(task => {
    const waveformId = 'waveform-' + task.taskId
    const container = document.getElementById(waveformId)
    
    if (container && task.audioFileName) {
      // 销毁已存在的实例
      if (wavesurferInstances.value[task.taskId]) {
        wavesurferInstances.value[task.taskId].destroy()
      }
      
      // 创建新的wavesurfer实例
      const wavesurfer = WaveSurfer.create({
        container: '#' + waveformId,
        waveColor: '#43A047',
        progressColor: '#1E88E5',
        height: 60,
        barWidth: 2,
        responsive: true,
        hideScrollbar: true,
        interact: false // 禁用交互，仅用于显示
      })
      
      // 加载音频文件
      const audioUrl = getAudioUrl(task.audioFileName)
      wavesurfer.load(audioUrl)
      
      // 添加错误处理
      wavesurfer.on('error', (error) => {
        handleWaveSurferError(task.taskId, error)
      })
      
      // 存储实例引用
      wavesurferInstances.value[task.taskId] = wavesurfer
    }
  })
}

// 渲染详情波形
function renderDetailWaveform(audioFileName) {
  const container = document.getElementById('waveform-detail')
  if (container) {
    // 清除之前的实例
    if (wavesurferInstances.value['detail']) {
      wavesurferInstances.value['detail'].destroy()
    }
    
    // 创建新的wavesurfer实例
    const wavesurfer = WaveSurfer.create({
      container: '#waveform-detail',
      waveColor: '#43A047',
      progressColor: '#1E88E5',
      height: 100,
      barWidth: 2,
      responsive: true,
      hideScrollbar: true
    })
    
    // 加载音频文件
    const audioUrl = getAudioUrl(audioFileName)
    wavesurfer.load(audioUrl)
    
    // 添加错误处理
    wavesurfer.on('error', (error) => {
      handleWaveSurferError('detail', error)
    })
    
    // 存储实例引用
    wavesurferInstances.value['detail'] = wavesurfer
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
    taskId: null,
    packageId: null,
    audioFileName: null,
    audioFilePath: null,
    status: null,
    annotator: null,
    auditor: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("taskRef")
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
  ids.value = selection.map(item => item.taskId)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加任务"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _taskId = row.taskId || ids.value
  getTask(_taskId).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改任务"
    
    // 等待DOM更新后渲染波形
    nextTick(() => {
      if (response.data.audioFileName) {
        renderDetailWaveform(response.data.audioFileName)
      }
    })
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["taskRef"].validate(valid => {
    if (valid) {
      if (form.value.taskId != null) {
        updateTask(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addTask({...form.value, packageId: taskPackageId}).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _taskIds = row.taskId || ids.value
  proxy.$modal.confirm('是否确认删除任务编号为"' + _taskIds + '"的数据项？').then(function() {
    return delTask(_taskIds)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('system/task/export', {
    ...queryParams.value
  }, `task_${new Date().getTime()}.xlsx`)
}

onUnmounted(() => {
  // 组件销毁时清理所有wavesurfer实例
  Object.values(wavesurferInstances.value).forEach(instance => {
    if (instance) {
      instance.destroy()
    }
  })
  if (root.value) {
    root.value.removeEventListener('keyup', handleSpace);
  }
})

//添加分段
function addSegment(times, newSegment) {
    console.log("addSegment:", newSegment);
    // 参数验证
    if (!Array.isArray(times) || !newSegment) return times;
    // console.log("addSegment2:", newSegment);
    if (!newSegment.start || !newSegment.end) return times;
    // console.log("addSegment3:", newSegment);
    if (newSegment.start >= newSegment.end) return times;
    // console.log("addSegment4:", newSegment);
    
    // 深拷贝原数组避免修改原数据
    let result = JSON.parse(JSON.stringify(times));
    const { start, end, text = "" } = newSegment;
    
    const segmentsToAdd = [];
    let mergedText = text;

    result.forEach(current=>{
      // 检查当前分段与新分段有重叠
      if ( (current.start <= start && start <= current.end) || (current.start <= end && end <= current.end) ) {
        //当前分段完全包含新分段,则拆分成两部分
        if (current.start <= start && current.end >= end) {
          segmentsToAdd.push({ start: current.start, end: start, text: current.text });
          segmentsToAdd.push({ start: end, end: current.end, text: "" });
        }
        // 左重叠：当前分段开始于新分段之前
        else if (current.start < start && current.end > start) {
          segmentsToAdd.push({ start: current.start, end: start, text: current.text });
        }
        // 右重叠：当前分段结束于新分段之后
        else if (current.start < end && current.end > end ) {
          segmentsToAdd.push({ start: end, end: current.end, text: current.text });
        }else{
          segmentsToAdd.push(current)
        }
      //新分段完全包含当前分段,则不保留当前分段，仅合并文本
      } else if (current.start >= start && current.end <= end) {
        mergedText += current.text;
      //当前分段完全不与新分段重叠,则直接保留
      }else{
        segmentsToAdd.push(current)
      }
      
    })

    //过滤掉完全包含在新分段内的分段
    result = segmentsToAdd.filter(seg => seg.start < start || seg.end > end);

    // 插入新分段
    result.push({ start, end, text: mergedText });
    
    // 按start排序确保顺序正确
    return result.sort((a, b) => a.start - b.start);
}

// 调整分段
function adjustSegment(times, oldSegment, newSegment) {

    console.log(`调整分段 ${oldSegment.start}-${oldSegment.end} --> ${newSegment.start}-${newSegment.end}`);

    // 参数验证
    if(!Array.isArray(times) || !newSegment || !oldSegment) {
      console.log("参数验证失败");
      return times;
    }
    if(newSegment.start >= newSegment.end) {
      console.log("新分段起始时间大于等于结束时间，调整失败");
      return times;
    }
    if(newSegment.start == oldSegment.start && newSegment.end == oldSegment.end) {
      console.log("新旧分段的起止和结束时间相同，无需调整");
      return times;
    }
    if(newSegment.end - newSegment.start < 0.2 ) {
      console.log("新分段时长小于0.1秒，调整失败");
      return times;
    }

    // 深拷贝原数组避免修改原数据
    let result = JSON.parse(JSON.stringify(times));

    // 1. 找到要调整的分段索引
    const index = result.findIndex(seg => seg.start === oldSegment.start && seg.end === oldSegment.end);

    if (index !== -1) {
      console.log(`找到要调整的分段索引为 ${index}`);

      if (index == 0){
        console.log(`是第一个分段`);
      }else if(index==result.length-1) {
        console.log(`是最后一个分段`);
      }else{
        console.log(`不是第一个或最后一个分段`);
      }

      // 2. 更新当前分段的边界
      result[index].start = newSegment.start;
      result[index].end = newSegment.end;
      
      // 3. 同步调整相邻分段边界（关键）

      // // 如果当前分段的右边界减小，则同步调整下一个分段的左边界
      // if (index + 1 < result.length) {
      //     result[index + 1].start = newSegment.end; // 确保下一个分段起点紧接当前分段终点
      // }      
      // // 如果当前分段的左边界减小，则同步调整上一个分段的右边界
      // if (index > 0) {
      //     result[index - 1].end = newSegment.start;
      // }

      //判断调整的边界是左边界还是右边界
      if (newSegment.start != oldSegment.start) {
        console.log(`调整左边界`);
        if(newSegment.start < oldSegment.start) {
          console.log(`👈往左调整`);
          //检查左边的所有分段是否被覆盖。被覆盖的分段的文本需要合并到新分段文本前面; 不被覆盖但有重叠的分段只需要调整分段的右边界，以保持时间轴的连续性
          for (let i = index - 1; i >= 0; i--) {
            if(newSegment.start <= result[i].start ) {//被新分段覆盖
              //合并文本
              result[index].text = result[i].text + " " + result[index].text;
            }else if(newSegment.start > result[i].start && newSegment.start < result[i].end ){//在左边相邻的分段内有重叠，则调整右边界）
              result[i].end = newSegment.start;
            }else{
              break;
            }
          }

        }else{
          console.log(`👉往右调整`);
          //左边相邻的分段的右边界调整为新分段的左边界
          if(index > 0) {
            result[index - 1].end = newSegment.start;
          }

        }
      }else{
        console.log(`调整右边界`);
        if(newSegment.end < oldSegment.end) {
          console.log(`👈往左边调整`);
          //右边相邻的分段的左边界调整为新分段的右边界
          if(index < result.length - 1) {
            result[index + 1].start = newSegment.end;
          }

        }else{
          console.log(`👉往右边调整`);          
          //检查右边的所有分段是否被覆盖。
          //被覆盖的分段的文本需要合并到新分段文本后面；
          //不被覆盖但有重叠的分段只需要调整分段的左边界，以保持时间轴的连续性
          for (let i = index + 1; i < times.length; i++) {//遍历右边的分段
            if(result[i].end < newSegment.end) {//分段被覆盖
              //合并文本
              result[index].text = result[index].text + " " + result[i].text;
            }else if(newSegment.end > result[i].start && newSegment.end < result[i].end ){//分段有重叠
              //调整分段的左边界
              result[i].start = newSegment.end;
            }else{
              break;
            }
          }

        }
      }

      //过滤掉被新分段覆盖的分段(不包括新分段本身)
      result = result.filter(seg => {
        if(seg.start==newSegment.start && seg.end==newSegment.end){//新分段本身，保留
          return true
        } 
        if(seg.start==0 && seg.start==newSegment.start && seg.end < newSegment.end){//第一个分段被覆盖，不保留
          return false
        }
        if(seg.end==duration &&seg.end==newSegment.end && newSegment.start < seg.start){//最后一个分段被覆盖，不保留
          return false
        }
        if((seg.start > newSegment.start && seg.end < newSegment.end)){//中间分段被覆盖，不保留
          return false
        }
        return true //保留其他分段
      });

      //检查result的第一个分段的左边界是否为0，如果不为0，则插入一个空的分段，用于保持时间轴的连续性
      if (result[0].start != 0) {
        result.unshift({ start: 0, end: result[0].start, text: "" });
      }

      //检查result的最后一个分段的右边界是否为总时长，如果不为总时长，则插入一个空的分段，用于保持时间轴的连续性
      if (result[result.length - 1].end != duration) {
        result.push({ start: result[result.length - 1].end, end: duration, text: "" });
      }




      
      // //特殊情况1：如果调整的是第一个分段的左边界增大，即调整后第一份分段的左边界大于0，则需要在该分段之前插入一个空的分段，用于保持时间轴的连续性
      // if (index === 0 && newSegment.start > 0) {
      //     result.unshift({ start: 0, end: newSegment.start, text: "" });
      // }

      // //特殊情况2：如果调整的是最后一个分段的右边界减小，即调整后最后一个分段的右边界小于总时长，则需要在该分段之后插入一个空的分段，用于保持时间轴的连续性
      // if (index === result.length - 1 && newSegment.end < duration) {
      //     result.push({ start: newSegment.end, end: duration, text: "" });
      // }
      
      // 4. 移除任何可能产生的无效分段（如长度为0或负值的分段）
      return result.filter(seg => seg.start < seg.end);

    }else{
      console.error(`找不到要调整的分段`);
    }
}

// 渲染demo波形
function renderDemoWaveform(
  audioFileName = '/profile/upload/2025/10/11/Khmer_JLP_250904_12_0001_20251011102407A001.wav') 
{
  console.log('renderDemoWaveform()--->')
  const container = document.getElementById('waveform-demo')
  if (container) {        
    // 创建wavesurfer实例
    ws = WaveSurfer.create({
      container: '#waveform-demo',
      waveColor: '#43A047',
      progressColor: '#1E88E5',
      height: 100,
      barWidth: 2,
      responsive: true,
      hideScrollbar: false,
      interact: true, // 可交互
      url:'/dev-api/profile/upload/2025/10/11/Khmer_JLP_250904_12_0001_20251011102407A001.wav',
      plugins: [
        regions,
        timeline,
        hover,
        ZoomPlugin.create({
          // 每个轮步的变焦量, 例如0.5表示每次变焦量放大0.5倍
          scale: 0.2,
          // Optionally, specify the maximum pixels-per-second factor while zooming
          //可选项地指定缩放时的最大每秒像素数值
          maxZoom: 100,
        }),
      ],
    })

    // 加载音频文件    
    // const audioUrl = getAudioUrl(audioFileName)
    // const audioUrl = getAudioUrl('/profile/upload/2025/10/11/Khmer_JLP_250904_12_0001_20251011102407A001.wav')
    // ws.load(audioUrl)

    ws.on('decode', () => { 
      root.value.addEventListener('keyup', handleSpace);

      //获得音频总时长
      duration = ws.decodedData.duration
      console.log(`音频总时长为 ${duration} 秒`)

      //末尾分段的结束时间设为音频总时长
      times[times.length - 1].end = duration

      //添加分段标记 (零长度区域)
      console.log(`当前点：`,times);
      console.log('添加初始分段标记-->')
      times.forEach( (ts,index) => {
        regions.addRegion({
          start: ts.start,
          content: `${index+1}`,
          color: '#000',
          drag: false,
          resize: false
        })
      })
      
    })


    // 添加错误处理
    ws.on('error', (error) => {
      handleWaveSurferError('demo', error)
    })


    //通过拖动波形上的空白区域来创建区域。返回一个函数来禁用拖动选择。
    regions.enableDragSelection({//允许拖拽创建区域
      color: activeColor,
    })
    //创建新区域事件
    regions.on('region-created', (region) => {
      console.log('新增区域：', region)
      region.drag = false;//禁止拖拽新区域

      if(!(region.start && region.end && region.start!==region.end)) return //无效区域

      //判断如果是框选区域新增则处理，点击激活区域则忽略
      console.log('region.content-->',region.content)
      if(region.content && region.content.innerText=='click'){
        console.log(`识别是【点击】激活区域：${region.start}-${region.end}`, region);
        return
      }
        //新增区域的方式：1框选新增，2点击激活（带clickAdd标识）
      // }else{ //是拖拽创建的区域，处理drag问题
        // console.log(`识别是【框选】新增区域：${region.start}-${region.end}`, region);


      // 检查新建区域的起止时间点是否靠近已有边界，自动吸附边界处理

      // 校验分段有效时长，不小于最小有效值

      // 取留边界时间点3位小数，确定新区域边界
      // region.start = Math.round(region.start * 100) / 100
      // region.end = Math.round(region.end * 100) / 100

      // 移除再重新创建新区域，以保证新建区域时间点与记录值匹配


      //如果分段已存在则返回，不重复添加
      if(times.findIndex(seg => seg.start == region.start && seg.end == region.end) > -1){
        console.log(`分段[${region.start}-${region.end}]已存在，不重复添加`)
        return
      }

      //====添加新区域到时间序列数组中===
      console.log(`添加前：`,times);
      let newtimes = addSegment(times, {start:region.start, end:region.end})
      times.splice(0, times.length);
      times.push(...newtimes);
      console.log(`添加后：`,times);

      //清除零长区域
      regions.getRegions().forEach((reg) => {
        if (reg.start == reg.end) {//清除零长区域
          reg.remove()
        }
        if(reg.start==activeRegion.start && reg.end==activeRegion.end){//清除（取消）前个激活区域
          reg.remove()
        }
      })

      //重建零长区域
      times.forEach((e, index) => {
        regions.addRegion({
          start: e.start,
          content: `${index+1}`,
          color: '#000',
          drag: false,
          resize: false
        })
      })

      //将手动新增区域视为当前激活区域（记录边界值）
      activeRegion.start = region.start
      activeRegion.end = region.end

      const index = times.findIndex(seg => seg.start === region.start && seg.end === region.end);
      console.log('++++当前激活的分段：', JSON.stringify(times[index]));
      region.play()
      

      // //删除当前区域
      // region.remove()

      // //新创建当前区域
      // const region2 = regions.addRegion({
      //   start: activeRegion.start,
      //   end: activeRegion.end, // 现在设置了有效的结束时间
      //   color: activeColor,
      //   drag: false, //不可拖动
      //   resize: true, //可调大小
      //   content: 'click' //标识为点击创建的新区域
      // });

      // //监听点击区域事件，当再次点击此区域时，则清除此区域（取消激活）
      // region2.on('click', (e) => {
      //   console.log('region.click:',  e)
      //   e.stopPropagation() // prevent triggering a click on the waveform
        
      //   //取消激活区域
      //   region2.remove()
      //   activeRegion.start = 0
      //   activeRegion.end = 0
      // })

        


    })

    //修改区域事件
    regions.on('region-updated', (region) => {
      console.log('regions.region-updated');

      //调整region的start和end精度保留2位小数
      // region.start = Math.round(region.start * 100) / 100
      // region.end = Math.round(region.end * 100) / 100

      console.log(`识别到调整区域：(${activeRegion.start},${activeRegion.end})-->(${region.start},${region.end})`)
      
      console.log('调整前：', JSON.stringify(times))
      let oldReg = {start:activeRegion.start, end:activeRegion.end}
      let newReg = {start:region.start, end:region.end}
      let newtimes  = adjustSegment(times, oldReg, newReg)
      times.splice(0, times.length)
      times.push(...newtimes)
      console.log(`调整后：`, JSON.stringify(times))

      //清除零长区域
      regions.getRegions().forEach((reg) => {
        if (reg.start == reg.end) {//清除零长区域
          reg.remove()
        }
      })

      //重建零长区域
      times.forEach((e, index) => {
        regions.addRegion({
          start: e.start,
          content: `${index+1}`,
          color: '#000',
          drag: false,
          resize: false
        })
      })

      //将手动新增区域视为当前激活区域（记录边界值）
      activeRegion.start = region.start
      activeRegion.end = region.end

      
      const index = times.findIndex(seg => seg.start === region.start && seg.end === region.end);
      console.log('>>>>当前激活的分段：', JSON.stringify(times[index]));

    })

    //单击区域事件
    regions.on('region-clicked', (region, e) => {
      console.log('regions.region-clicked:',  e);
      //e.stopPropagation() 
      // prevent triggering a click on the waveform
      // activeRegion = region
      //region.play(true)
      //region.setOptions({ color: randomColor() })
    })

    // 双击区域事件
    regions.on('region-double-clicked', (region, e) => {
      console.log('region-double-clicked',  e);
      // region.play()

      // //
      // const rect = ws.getWrapper().getBoundingClientRect();
      // const clickX = e.clientX - rect.left;
      // const clickTime = (clickX / rect.width) * ws.getDuration();
      // console.log(`点击位置: ${clickTime.toFixed(2)}s`);

      //获取双击位置的时间
      // const clickX = e.clientX - ws.getWrapper().getBoundingClientRect().left;

      // 在双击位置切分区域
      //splitRegionAtTime(region, clickTime)

      e.stopPropagation()
    })

    //单击波形图事件
    ws.on('click', (x,y) => {
      console.log('ws.click')
      
      // 获取点击位置的时间点
      // relativeX 是点击位置相对于波形图宽度的比例（范围0到1）
      const duration = ws.getDuration(); // 获取音频总时长（秒）
      const clickTime = (x * duration).toFixed(3); // 计算点击处的时间点
      console.log(`单击位置的时间点：${clickTime}`)

      times.forEach((ts, index) => {
        if(clickTime>=ts.start && clickTime<=ts.end){//点击位置在此区间
          //激活分段
          activateRegion(ts)
        }
      });

    })

    ws.on('timeupdate', (currentTime) => {
      // When the end of the region is reached
      if (activeRegion && currentTime >= activeRegion.end) {
        // Stop playing
        ws.pause()
      }
    })

    //双击波形图事件
    ws.on('dblclick', (x,y) => {
      console.log('ws.dblclick')
      // 1. 计算点击的时间点
      // relativeX 是点击位置相对于波形图宽度的比例（范围0到1）
      const duration = ws.getDuration(); // 获取音频总时长（秒）
      const clickTime = (x * duration).toFixed(3); // 计算点击处的时间点
      console.log(`双击的时间点：${clickTime}---${times}`)
    })

    const playButton = document.querySelector('#play')
    const forwardButton = document.querySelector('#forward')
    const backButton = document.querySelector('#backward')

    if (playButton) {
      playButton.onclick = () => {
        if(!ws.isPlaying() && activeRegion.start!=activeRegion.end &&ws.currentTime>=activeRegion.end){
          ws.skip(activeRegion.start)
          ws.play()
        }else{
          ws.pause()
        }
      }
    }

    if (forwardButton) {
      forwardButton.onclick = () => {
        let regionIndex = 0
        //1.定位当前段    
        // 查找当前激活的分段
        if(activeRegion.end - activeRegion.start >0){
          regionIndex = times.findIndex(seg => seg.start==activeRegion.start && seg.end==activeRegion.end)
        }
        // 或者根据当前播放所在位置查找当前分段
        //2.查找下一段
        // 索引加一，但必须小于times.length        
        regionIndex = (regionIndex+1) > times.length ? times.length : (regionIndex+1)
        //3.激活下一段
        activateRegion(times[regionIndex])
        // //4.跳转下一段的开始位置
        // ws.skip(times[regionIndex].start)
        // //5.重新开始播放
        // region.play()
      }
    }

    if (backButton) {
      backButton.onclick = () => {
        let regionIndex = 0
        //1.定位当前段    
        // 查找当前激活的分段
        if(activeRegion.end - activeRegion.start >0){
          regionIndex = times.findIndex(seg => seg.start==activeRegion.start && seg.end==activeRegion.end)
        }
        // 或者根据当前播放所在位置查找当前分段
        //2.查找上一段
        // 索引减一，但必须大于0
        regionIndex = (regionIndex-1) < 0 ? 0 : (regionIndex-1)
        //3.激活上一段
        activateRegion(times[regionIndex])
        // //跳转上一段的开始位置
        // ws.skip(times[regionIndex].start)
        // //5.重新开始播放
        // region.play()
      }
    }
  }
}

//激活分段
function activateRegion(ts){
  console.log('****当前激活分段：', JSON.stringify(ts))

  // 1.清除非零长区域（取消激活区域）
  regions.getRegions().forEach((region) => {
    if (region.start != region.end) {
      region.remove();
    }
  });

  //2.创建当前点击区域
  const region = regions.addRegion({
    start: ts.start,
    end: ts.end, // 现在设置了有效的结束时间
    color: activeColor,
    drag: false, //不可拖动
    resize: true, //可调大小
    //content: 'click'
  });

  //设置区域属性（在created事件中获取不到区域属性，只能通过region.getProperties()获取）
  //region['clickAdd'] = true //点击新增区域的标识

  region.play()

  //记录当前区域为激活区域
  activeRegion.start = ts.start;
  activeRegion.end = ts.end;

  //监听点击区域事件，当再次点击此区域时，则清除此区域（取消激活）
  region.on('click', (e) => {
    console.log('region.click:',  e)
    e.stopPropagation() // prevent triggering a click on the waveform
    
    //取消激活区域
    region.remove()
    activeRegion.start = 0
    activeRegion.end = 0

  })

  return region
}

function formatSecondsToMMSSS(seconds) {
    // 创建一个新的Date对象，这里乘以1000是因为Date构造函数接收的是毫秒
    let date = new Date(seconds * 1000);

    // 获取分钟、秒和毫秒部分
    let minutes = date.getUTCMinutes();
    let secondsInMinute = date.getUTCSeconds();
    let milliseconds = date.getUTCMilliseconds();

    // 确保每个部分都是两位数
    minutes = String(minutes).padStart(2, '0');
    secondsInMinute = String(secondsInMinute).padStart(2, '0');
    milliseconds = String(milliseconds).padStart(3, '0');

    // 组合成mm:ss:SSS格式
    return `${minutes}:${secondsInMinute}:${milliseconds}`;
}

function rowClick(row, column, event){
  console.log('表格的行被点击了--->', row, column, event)
  //通过row.start和row.end查找到对应分段
  // 类似分段的click事件函数：
  // 1.激活分段区域（含高亮显示）
  let region = activateRegion(row)
  // 2.跳转分段起点
  ws.skip(region.start)
  // 3.播放分段音频
  region.play()
}

// 示例使用
// console.log(formatSecondsToMMSSS(61.123)); // 输出: "01:01:123"

// 初始化区域插件
let regions = RegionsPlugin.create()

const timeline = TimelinePlugin.create()
const hover = Hover.create({
      formatTimeCallback: (time) => {
        return `${time.toFixed(3)}s`
      },
      lineColor: '#ff0000',
      lineWidth: 1,
      labelBackground: '#555',
      labelColor: '#fff',
      labelSize: '11px',
      labelPreferLeft: false,
    })


// 等待DOM更新后渲染波形
nextTick(() => {
  renderDemoWaveform()
})

getList()
</script>

<style scoped>
.waveform-container {
  border: 1px solid #ddd;
  border-radius: 4px;
}

/* 高亮行的样式 */
:deep(.el-table .highlight-row) {
  background-color: rgba(255, 225, 0, 0.3) !important;
  /*color: #409EFF;*/
  font-weight: bold;
}

:deep(.el-table .special-row) {
  background-color: #f0f9e8 !important;
  color: #67C23A;
}

/* 覆盖 el-table 的行 hover 样式 */
.el-table .el-table__body tr.hover-row > td {
  background-color: rgba(255, 225, 0, 0.3) !important; /* 设置为透明或者你想要的背景颜色 */
}
</style>