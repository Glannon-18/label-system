<template>
  <div class="app-container" >

    <!-- <textarea id="textarea" v-model="textGridText" style="width: 100%; height: 100px; display: none;"></textarea> -->

    <div style="display: flex; justify-content: space-between; ">
      <!-- <div> 任务包：{{ taskPackageName }}</div> -->
      <div> 音频文件：{{ task.data.audioFileName }}</div>
      <div style="display: flex; justify-content: flex-end;margin-left: 12px;">
        <!-- <el-link underline style="margin-right: 50px;" @click="toSpecification()">标注规范</el-link> -->
        <div v-if="['unstart','underway','reject','pass'].includes(task.data.status)">
          <el-button type="danger" plain @click="redo()">重做</el-button>
          <el-button type="primary" plain @click="saveTask()">保存更改</el-button>
          <el-button type="success" plain @click="submitTask()">提交审核</el-button>
        </div>

        <div v-if="['pending_review'].includes(task.data.status)">
          <el-button type="danger" plain @click="dialogFormVisible = true" vhasPermi="['label:task:audit']">审核驳回</el-button>
          <el-button type="success" plain @click="auditTask('pass')" vhasPermi="['label:task:audit']">审核通过</el-button>
        </div>

        <!-- 审核驳回对话框 -->
        <el-dialog v-model="dialogFormVisible" title="审核驳回" width="500">
          <el-input v-model="dialogFormRemark" type="textarea" :rows="3" placeholder="请输入驳回原因" style="width: 100%;" />
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="dialogFormVisible = false">取消</el-button>
              <el-button type="primary" @click="rejectTask()">确定</el-button>
            </div>
          </template>
        </el-dialog>

      </div>
    </div>
    
    <!-- 语音标注音波图 -->
    <div id="waveform-demo" class="waveform-container" style="width: 100%; height: 100px; margin-top: 10px;"></div>
    
    <!-- 操作按钮栏 -->
    <div style="margin-top: 50px; display: flex; justify-content: space-between; align-items: center;font-size: 14px;">
      <div style="display: flex; gap: 0.5rem; font-size: 12px; align-items: center; justify-content: center;">
        <span style="color: gray;">点击插入无效时长标签:</span>
        <div v-for="item in labels" :key="item.label">
          <el-tooltip 
            class="box-item"
            :content="item.tip"
            placement="top-start"
          ><el-tag style="cursor:pointer;" checked :type="item.type" @click="insertText(item.label)">
            {{ item.label }}
          </el-tag></el-tooltip>
        </div>
      </div>
      <div style="display: flex;">
        <!-- {{ formatSecondsToMMSSS(currentTime)  }} / {{ formatSecondsToMMSSS(duration)}}  -->
        <el-button type="info" plain id="backward">上一段</el-button>
        <el-button type="info" plain id="play">▶播放/‖暂停</el-button>
        <el-button type="info" plain id="forward">下一段</el-button>
        <view style="margin-left: 12px;display: flex;align-items: center;">
          音量 <el-slider v-model="volume" style="width: 100px;margin-left: 3px;"/>
        </view>
        <view style="margin-left: 12px;display: flex;align-items: center;">
          倍速 <el-select v-model="playbackRate" size="small" style="width: 70px;margin-left: 3px;" >
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
    </div>

    <!--分段标注列表-->
    <div style="margin-top: 10px; display: flex; flex-direction:column">
      <el-table ref="tableRef" :data="times" :highlight-current-row="false" 
        style="width: 100%;height: 400px; margin-top:10px; border:1px solid #ddd; border-radius: 5px; overflow: hidden;"  
        :show-header="true" 
        :row-class-name="tableRowClassName" @row-click="rowClick" > 
          <el-table-column label="分段序号" width="100"> 
            <template #default="scope"> 
              {{ scope.$index + 1 }}
            </template>
          </el-table-column>
          <el-table-column label="开始时间" width="100"> 
            <template #default="scope"> 
              {{ scope.row.start }}
            </template>
          </el-table-column>
          <el-table-column label="结束时间" width="100"> 
            <template #default="scope"> 
              {{ scope.row.end }}
            </template>
          </el-table-column>
          <el-table-column label="时长(秒)" width="100"> 
            <template #default="scope"> 
              {{ (scope.row.end - scope.row.start).toFixed(3) }}
            </template>
          </el-table-column>
          <el-table-column label="标注文本内容" > 
            <template #default="scope"> 
              <el-input type="textarea" clearable autosize v-model="scope.row.text" placeholder="请输入标注内容" style="width:100%;font-size:16px;" />
            </template>
          </el-table-column>
          <el-table-column label="字符数" width="100"> 
            <template #default="scope"> 
              <span :style="scope.row.text.length>120?'color:red':''">{{ scope.row.text.length }}</span>
            </template>
          </el-table-column>
      </el-table>
    </div>

    <!-- 底部提示说明 -->
    <div v-if="task.data.status==='pending_review'" style="line-height: 30px;margin-top: 10px; color: gray; font-size: 12px;">
      Tip：审核人可对标注内容进行修改，提交审核结果同时保存修改的内容。
    </div>

  </div>
</template>


<script setup name="labelEditor">
//=========================引入模块=========================
import { getPackage } from "@/api/label/package"
import { listTask, getTask, updateTask } from "@/api/label/task"

import WaveSurfer from "wavesurfer.js"
import RegionsPlugin from 'wavesurfer.js/dist/plugins/regions.esm.js'
import TimelinePlugin from 'wavesurfer.js/dist/plugins/timeline.esm.js'
import ZoomPlugin from 'wavesurfer.js/dist/plugins/zoom.esm.js'
import Hover from 'wavesurfer.js/dist/plugins/hover.esm.js'
import { nextTick, onMounted, onUnmounted, reactive, watch } from "vue"


const labels = reactive([
  { type: 'primary', label: '<NOISE>', 'tip': '表示非人声噪音' },
  { type: 'success', label: '<DEAF>', 'tip': '表示无法转写的人声' },
  { type: 'info', label: '<OVERLAP>', 'tip': '表示多人同时发音：混读、听不清、文本无法转写出来' },
  { type: 'warning', label: '<OOV>', 'tip': '表示整段非目标语种，包括：中文、英文等' },
])


//=========================定义函数=========================
function insertText(text) {
  if (activeRegion && activeRegion.start !== activeRegion.end) {
    times.forEach(item => {
      if (item.start === activeRegion.start && item.end===activeRegion.end) {
        item.text += text
      }
    })
  }else{
    //提示：请选择一个有效区域
    proxy.$modal.msgWarning("请先选择一个有效区域")
  }
}

// 定义行类名函数
const tableRowClassName = ({ row, rowIndex }) => {
  // 示例条件：高亮开始时间为0的行
  if (row.start === activeRegion.start && row.end===activeRegion.end) {
    return 'highlight-row'
  }
  return ''
}


const handleSpace = (event) => {
  if (event.key === ' ') { // 确保是空格键被按下
    console.log('空格键被按下');
    ws.playPause()
  }
};




// 获取音频文件URL（需要根据实际路径结构调整）
function getAudioUrl(audioFileName) {
  // 使用完整的API路径访问音频文件，例如：`/dev-api/profile/upload/${audioFileName}`
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

// 添加一个函数来确定返回的页面路径
function getReturnPath() {
  // 根据当前路由名称确定返回路径
  const route = useRoute();
  
  // 判断当前是从哪个页面进入的
  if (route.name === 'audit-label') {
    // 从"我的审核"进入的，返回到审核任务列表页
    return '/label/auditTask';
  } else if (route.name === 'label-editor') {
    // 从"我的任务包明细"进入的，返回到我的任务列表页
    return '/label/my-task';
  } else if (route.name === 'audio-annotator') {
    // 从"任务包明细管理"进入的，返回到任务包明细管理页
    return '/label/project-task';
  } else {
    // 默认返回到首页
    return '/index';
  }
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
      const audioUrl = getAudioUrl(task.audioFilePath)
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



/** 修改按钮操作 */
function handleUpdate(row) {
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

//重做标注
function redo(){
  //刷新页面
  // proxy.$router.go(0)
  proxy.$modal.confirm('是否放弃更改并载入上一次保存的标注数据？').then(function () {
    let newtimes = task.textGridJson.intervals.map(ts=>{
      return {
        start: ts.xmin,
        end: ts.xmax,
        text: ts.text
      }
    })
    times.splice(0,times.length,...newtimes)

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

      activeRegion.start = 0
      activeRegion.end = 0

      proxy.$modal.msgSuccess("重新载入数据成功")

  })
}

/** 保存任务  */
function saveTask() {
  //将最新的times转为intervals
  let intervals = times.map((ts,i)=>{
    return {
      index: (i+1),
      xmin: ts.start,
      xmax: ts.end,
      text: ts.text,
    }
  })
  // 将intervals替换到 task.textGridJson.intervals 和 task.textGridJson.tiers[0].intervals
  task.textGridJson.intervals = intervals
  task.textGridJson.tiers[0].intervals = intervals
  //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
  let textGrid = convertJsonToTextGrid(task.textGridJson)
  task.data.textGrid = textGrid
  //将任务状态改为“标注中”
  task.data.status = 'underway'
  //准备保存的参数
  let sysTask = {
      taskId: taskId,
      textGrid: textGrid,
      status: 'underway',//标注中
    }
  const formData = new FormData();
  formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
  updateTask(formData).then(response => {
    console.log(response)
    proxy.$modal.msgSuccess("保存成功")
  })
}

/** 提交任务 */
function submitTask() {
  proxy.$modal.confirm('确定提交审核吗？').then(function () {
    //将最新的times转为intervals
    let intervals = times.map((ts,i)=>{
      return {
        index: (i+1),
        xmin: ts.start,
        xmax: ts.end,
        text: ts.text,
      }
    })
    // 将intervals替换到 task.textGridJson.intervals 和 task.textGridJson.tiers[0].intervals
    task.textGridJson.intervals = intervals
    task.textGridJson.tiers[0].intervals = intervals
    //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
    let textGrid = convertJsonToTextGrid(task.textGridJson)
    task.data.textGrid = textGrid
    //准备提交的参数
    let sysTask = {
        taskId: taskId,
        textGrid: textGrid,
        status: 'pending_review',//待审核
        remark:'',//备注清空
      }
    const formData = new FormData();
    formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
    updateTask(formData).then(response => {
      proxy.$modal.msgSuccess("提交成功")
      setTimeout(() => {
        proxy.$tab.closePage()  // 关闭当前页
        // 根据来源页面跳转回相应的列表页
        const returnPath = getReturnPath();
        if (returnPath === '/label/my-task' || returnPath === '/label/project-task') {
          // 对于需要参数的路由，我们需要传递参数
          const route = useRoute();
          if (route.params.taskPackageId && route.params.taskPackageName) {
            proxy.$router.push(`${returnPath}/index/${route.params.taskPackageId}/${encodeURIComponent(route.params.taskPackageName)}`);
          } else {
            proxy.$router.push(returnPath);
          }
        } else if (returnPath === '/label/auditTask') {
          // 为auditTask页面添加时间戳参数以触发刷新
          proxy.$router.push({ path: returnPath, query: { t: new Date().getTime() } });
        } else {
          proxy.$router.push(returnPath);
        }
      }, 1000)
      
    })
  })
}

//驳回任务
function rejectTask(){
  console.log('rejectTask---',dialogFormRemark)
  if(!dialogFormRemark.value){
    proxy.$modal.msgError("请填写驳回原因")
    return
  }
  dialogFormVisible = false

  //将最新的times转为intervals
  let intervals = times.map((ts,i)=>{
    return {
      index: (i+1),
      xmin: ts.start,
      xmax: ts.end,
      text: ts.text,
    }
  })
  // 将intervals替换到 task.textGridJson.intervals 和 task.textGridJson.tiers[0].intervals
  task.textGridJson.intervals = intervals
  task.textGridJson.tiers[0].intervals = intervals
  //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
  let textGrid = convertJsonToTextGrid(task.textGridJson)
  task.data.textGrid = textGrid
  //准备提交的参数
  let sysTask = {
      taskId: taskId,
      textGrid: textGrid,
      status: 'reject',
      remark: '驳回原因:'+dialogFormRemark.value
    }
  const formData = new FormData();
  formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
  updateTask(formData).then(response => {
    proxy.$modal.msgSuccess("驳回成功")
    setTimeout(() => {
      proxy.$tab.closePage()  // 关闭当前页
      // 根据来源页面跳转回相应的列表页
      const returnPath = getReturnPath();
      if (returnPath === '/label/my-task' || returnPath === '/label/project-task') {
        // 对于需要参数的路由，我们需要传递参数
        const route = useRoute();
        if (route.params.taskPackageId && route.params.taskPackageName) {
          proxy.$router.push(`${returnPath}/index/${route.params.taskPackageId}/${encodeURIComponent(route.params.taskPackageName)}`);
        } else {
          proxy.$router.push(returnPath);
        }
      } else if (returnPath === '/label/auditTask') {
        // 为auditTask页面添加时间戳参数以触发刷新
        proxy.$router.push({ path: returnPath, query: { t: new Date().getTime() } });
      } else {
        proxy.$router.push(returnPath);
      }
    }, 1000)
    
  })

}



/** 审核任务 */
function auditTask(status) {
  let confirmTxt = '确定审核通过吗？'
  if(status == 'reject'){
    confirmTxt = '确定驳回任务吗？'
  }
  proxy.$modal.confirm(confirmTxt).then(function () {
    //将最新的times转为intervals
    let intervals = times.map((ts,i)=>{
      return {
        index: (i+1),
        xmin: ts.start,
        xmax: ts.end,
        text: ts.text,
      }
    })
    // 将intervals替换到 task.textGridJson.intervals 和 task.textGridJson.tiers[0].intervals
    task.textGridJson.intervals = intervals
    task.textGridJson.tiers[0].intervals = intervals
    //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
    let textGrid = convertJsonToTextGrid(task.textGridJson)
    task.data.textGrid = textGrid
    //准备提交的参数
    let sysTask = {
        taskId: taskId,
        textGrid: textGrid,
        status: status,
        remark: status === 'pass' ? '审核通过' : '审核驳回'
      }
    const formData = new FormData();
    formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
    updateTask(formData).then(response => {
      proxy.$modal.msgSuccess("审核成功")
      setTimeout(() => {
        proxy.$tab.closePage()  // 关闭当前页
        // 根据来源页面跳转回相应的列表页
        const returnPath = getReturnPath();
        if (returnPath === '/label/my-task' || returnPath === '/label/project-task') {
          // 对于需要参数的路由，我们需要传递参数
          const route = useRoute();
          if (route.params.taskPackageId && route.params.taskPackageName) {
            proxy.$router.push(`${returnPath}/index/${route.params.taskPackageId}/${encodeURIComponent(route.params.taskPackageName)}`);
          } else {
            proxy.$router.push(returnPath);
          }
        } else if (returnPath === '/label/auditTask') {
          // 为auditTask页面添加时间戳参数以触发刷新
          proxy.$router.push({ path: returnPath, query: { t: new Date().getTime() } });
        } else {
          proxy.$router.push(returnPath);
        }
      }, 1000)
      
    })
  })
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

function splitSegment(times, oldSegment, point) {
  //将从oldSegment分割为两个分段，其中一个分段的右边界为point
  let newSegment = {
    start: oldSegment.start,
    end: point,
    text: oldSegment.text
  }
  oldSegment.start = point;
  times[index] = newSegment;
  return times;


}
// 渲染demo波形
async function init(){
  console.log('init()--->')
  const container = document.getElementById('waveform-demo')
  if (container) {  // 判断waveform容器是否存在
    
  // 获取任务详情信息
  let res = await getTask(taskId);
  console.log('任务详情：', res)
  task.data = res.data;

  if(!task.data.textGrid){
    proxy.$message.error('缺少预标注文本TextGrid')
  }
  
  // ----将预标注文本转为json---
  // 解析TextGrid
  task.textGridJson = parseTextGridToJson(task.data.textGrid)
  // console.log('task.textGridJson-->',JSON.stringify(task.textGridJson))

  // 生成时间序列数据
  let realtimes = task.textGridJson.intervals.map(e => {
    return {
      start: e.xmin,
      end: e.xmax,
      text: e.text
    }
  })

  //赋值区域
  times.splice(0, times.length);
  times.push(...realtimes);

  // 等待DOM更新
  // await nextTick()

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
    minPxPerSec: 45,
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
  ws.load( getAudioUrl(task.data.audioFilePath) )

  ws.on('play', () => {
    console.log('ws.currentTime-->', ws.getCurrentTime())
    currentTime.value = ws.getCurrentTime()
  })

  ws.on('zoom', (minPxPerSec) => {
    console.log('zoom---->minPxPerSec', minPxPerSec)
  })

  ws.on('decode', () => { 

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
    // console.log('新增区域：', region)
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
    if(region.end-region.start < 1){
      proxy.$message.error('新增区域时长小于1秒，请重新框选区域！')
      region.remove()
      return //无效区域，时长小于1秒
    }

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
    let newSeg = {start:region.start.toFixed(3), end:region.end.toFixed(3)}
    let newtimes = addSegment(times, newSeg)
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
    activeRegion.start = newSeg.start
    activeRegion.end = newSeg.end

    //移除并激活新分段
    //region.play()
    region.remove()
    activateRegion(newSeg)

    const index = times.findIndex(seg => seg.start === newSeg.start && seg.end === newSeg.end);
    //滚动到标注行
    scrollToRow(index)
    console.log('++++当前激活的分段：', JSON.stringify(times[index]));

    
    

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
      let start = region.start.toFixed(3)
      let end = region.end.toFixed(3)

      console.log(`识别到调整区域：(${activeRegion.start},${activeRegion.end})-->(${region.start},${region.end})`)
      
      console.log('调整前：', JSON.stringify(times))
      let oldReg = {start:activeRegion.start, end:activeRegion.end}
      let newReg = {start:start, end:end}
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
      activeRegion.start = start
      activeRegion.end = end

      
      const index = times.findIndex(seg => seg.start === start && seg.end === end);
      console.log('>>>>当前激活的分段：', JSON.stringify(times[index]));
      //移除分段
      region.remove()
      //激活新分段
      activateRegion(newReg)
      //滚动到标注行
      scrollToRow(index)

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
          //滚动到标注行
          scrollToRow(index)
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
        console.log('playButton.onclick--->', ws.isPlaying())
        if(ws.isPlaying()){//在播放
          ws.pause()
        }else{//已暂停
          let currentTime = ws.getCurrentTime();
          if(currentTime>=activeRegion.end){//当前播放位置已超出激活区域，则跳转到激活区域的开始处
            ws.setTime(activeRegion.start)
          }
          ws.play()
        }
        

        //如果当前不在播放，并且
        // if(!ws.isPlaying() && activeRegion.start!=activeRegion.end &&ws.currentTime>=activeRegion.end){
        //   ws.skip(activeRegion.start)
        //   ws.play()
        // }else{
        //   ws.pause()
        // }

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
        //滚动到标注行
        scrollToRow(regionIndex)
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
        //滚动到标注行
        scrollToRow(regionIndex)

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
  let region = regions.addRegion({
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

// 格式化秒数
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

// 点击表格的行
function rowClick(row, column, event){
  console.log('表格的行被点击了--->', row, column, event)
  //通过row.start和row.end查找到对应分段
  // 类似分段的click事件函数：
  // 1.激活分段区域（含高亮显示）
  let region = activateRegion(row)
  // // 2.跳转分段起点
  // ws.skip(region.start)
  // // 3.播放分段音频
  // region.play()
}


/**
 * 将TextGrid文本转换为JSON对象
 * @param {string} textGridText - TextGrid格式的文本
 * @returns {Object} JSON对象
 */
function parseTextGridToJson(textGridText) {
    const lines = textGridText.split('\n').filter(line => line.trim() !== '');
    const result = {
        fileType: '',
        objectClass: '',
        xmin: 0,
        xmax: 0,
        tiers: [],
        intervals: []
    };

    let currentTier = null;
    let currentInterval = null;
    let inIntervals = false;
    let intervalIndex = 0;

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        
        if (line.startsWith('File type =')) {
            result.fileType = line.split('=')[1].trim().replace(/"/g, '');
        } else if (line.startsWith('Object class =')) {
            result.objectClass = line.split('=')[1].trim().replace(/"/g, '');
        } else if (line.startsWith('xmin =')) {
            const value = parseFloat(line.split('=')[1].trim());
            if (!inIntervals) {
                result.xmin = value;
            } else if (currentInterval) {
                currentInterval.xmin = value;
            } else if (currentTier) {
                currentTier.xmin = value;
            }
        } else if (line.startsWith('xmax =')) {
            const value = parseFloat(line.split('=')[1].trim());
            if (!inIntervals) {
                result.xmax = value;
            } else if (currentInterval) {
                currentInterval.xmax = value;
            } else if (currentTier) {
                currentTier.xmax = value;
            }
        } else if (line.startsWith('size =')) {
            // 处理tier数量
        } else if (line.startsWith('item [')) {
            // 开始新的tier
            currentTier = {
                class: '',
                name: '',
                xmin: 0,
                xmax: 0,
                intervals: []
            };
            result.tiers.push(currentTier);
        } else if (line.startsWith('class =')) {
            if (currentTier) {
                currentTier.class = line.split('=')[1].trim().replace(/"/g, '');
            }
        } else if (line.startsWith('name =')) {
            if (currentTier) {
                currentTier.name = line.split('=')[1].trim().replace(/"/g, '');
            }
        } else if (line.startsWith('intervals: size =')) {
            inIntervals = true;
            intervalIndex = 0;
        } else if (line.startsWith('intervals [')) {
            // 开始新的interval
            currentInterval = {
                index: ++intervalIndex,
                xmin: 0,
                xmax: 0,
                text: ''
            };
            if (currentTier) {
                currentTier.intervals.push(currentInterval);
            }
            result.intervals.push(currentInterval);
        } else if (line.startsWith('text =')) {
            if (currentInterval) {
                // 提取引号内的文本内容
                const match = line.match(/text = "([^"]*)"/);
                if (match) {
                    currentInterval.text = match[1];
                }
            }
        }
    }

    return result;
}

/**
 * 将JSON对象转换回TextGrid文本格式
 * @param {Object} jsonData - 包含TextGrid数据的JSON对象
 * @returns {string} TextGrid格式的文本
 */
function convertJsonToTextGrid(jsonData) {
    let textGridText = '';
    
    // 头部信息
    textGridText += `File type = "ooTextFile"\n`;
    textGridText += `Object class = "TextGrid"\n\n`;
    textGridText += `xmin = ${jsonData.xmin}\n`;
    textGridText += `xmax = ${jsonData.xmax}\n`;
    textGridText += `tiers? <exists>\n`;
    textGridText += `size = ${jsonData.tiers.length}\n`;
    textGridText += `item []:\n`;
    
    // 处理每个tier
    jsonData.tiers.forEach((tier, tierIndex) => {
        textGridText += `    item[${tierIndex + 1}]:\n`;
        textGridText += `        class = "${tier.class}"\n`;
        textGridText += `        name = "${tier.name}"\n`;
        textGridText += `        xmin = ${tier.xmin}\n`;
        textGridText += `        xmax = ${tier.xmax}\n`;
        textGridText += `        intervals: size = ${tier.intervals.length}\n`;
        
        // 处理每个interval
        tier.intervals.forEach((interval, intervalIndex) => {
            textGridText += `        intervals [${intervalIndex + 1}]\n`;
            textGridText += `            xmin = ${interval.xmin}\n`;
            textGridText += `            xmax = ${interval.xmax}\n`;
            textGridText += `            text = "${interval.text}"\n`;
        });
    });
    
    return textGridText;
}




//=========================定义变量=========================

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


//播放音量
let volume = ref(50)
watch(volume,(newVal, oldVal)=>{//监听音量值改变
  ws.setVolume(newVal/100)
})

//播放速度
let playbackRateList = ref([
  { label: '3.0x', value: 3.0 },
  { label: '2.0x', value: 2.0 },
  { label: '1.5x', value: 1.5 },
  { label: '1.25x', value: 1.25 },
  { label: '1.0x', value: 1.0 },
  { label: '0.75x', value: 0.75 },
  { label: '0.5x', value: 0.5 },
  { label: '0.25x', value: 0.25 },
  
])
let playbackRate = ref({ label: '1.0x', value: 1.0 })
watch(playbackRate,(newVal, oldVal)=>{//监听播放倍速值变化
  ws.setPlaybackRate(newVal, true)
})




// Wavesurfer实例
const wavesurferInstances = ref({})
// 获取路由参数
let taskPackageId = route.params.taskPackageId //任务包ID
let taskPackageName = route.params.taskPackageName //任务包名称
let taskId = route.params.taskId  // 从路由中获取taskId
//任务数据
let task = reactive({
  data:{ //任务信息
    taskId: taskId,
    audioFileName: '',
    packageId: taskPackageId,
    textGrid: '',//TG文本
  },  
  textGridJson: {},//TG文本转的JSON（用于显示、重置、提交等）
})


// 音频播放控件
let ws = null;
// 激活区域颜色
let activeColor = 'rgba(255, 255, 0, 0.3)';
// 当前激活的区域
let activeRegion = reactive({start: 0, end: 0})
// 音频总时长
let duration = ref(0)
// 当前播放时间点
let currentTime = ref(0)
// 音频标注分段列表
let times = reactive([
  // {start: 0, end: 5, text: '111'},
  // {start: 5, end: 10, text: '222'},
  // {start: 10, end: 15, text: '333'},
  // {start: 15, end: 20, text: '444'},
  // {start: 20, end: 25, text: '555'},
  // {start: 25, end: 30, text: '666'},
  // {start: 30, end: 35, text: '777'},
  // {start: 35, end: 40, text: '888'},
  // {start: 40, end: 45, text: '999'},
  // {start: 45, end: 50, text: '1010'},
  // {start: 50, end: 55, text: '1111'},
])
//表格
const tableRef = ref()

const scrollToRow = (rowIndex) => {
  if (!tableRef.value) return

  console.log('scrollToRow-->', rowIndex, tableRef)

  // tableRef.value.setScrollTop(rowIndex * 50)

  const rowHeightList = [];
  let temp = tableRef.value.$el.getElementsByClassName('el-table__row'); //获取到所有行元素
  for (let i = 0; i < temp.length; i++) {
    const item = temp[i];
    rowHeightList.push(item.scrollHeight);
  }
  let totalHeight = 0; //求出选中行之前的的高度之和,需要注意的是,当前行的高度不能包含进去
  for (let index = 0; index < rowHeightList.length; index++) {
    const row = rowHeightList[index];
    if (index < rowIndex) {
      totalHeight += row;
    }
  }
  // 滚动到指定行
  tableRef.value.setScrollTop(totalHeight);
  
  // 设置高亮
  // tableRef.value.setCurrentRow(times[rowIndex])
  
  // 滚动到指定行
  // nextTick(() => {
  //   setTimeout(()=>{
  //     tableRef.value.scrollTo({ 
  //       row: rowIndex, 
  //       position: 'top' 
  //     })
  //   }, 100)    
  // })
}



// 初始化区域插件
let regions = RegionsPlugin.create()
// 初始化时间轴插件
const timeline = TimelinePlugin.create()
// 初始化hover插件
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



//=========================初始执行代码=========================

//已初始化就可以去读取task数据，然后tg文本转换为json，显示分段标注列表
//波形图要等nextTick执行DOM更新后，才能创建wavesurfer实例
//ws实例创建完成后，加载显示波形图

// 等待DOM更新后渲染波形
nextTick(() => {
  init()
})

let textGridText = ref('');

watch(textGridText, (newValue, oldValue) => {

  // 解析TextGrid
  let jsonData = parseTextGridToJson(newValue)
  // console.log('jsonData-->',JSON.stringify(jsonData))

  // 生成区域数据
  let realtimes = jsonData.intervals.map(e => {
    return {
      start: e.xmin,
      end: e.xmax,
      text: e.text
    }
  })

  //重新赋值区域
  times.splice(0, times.length);
  times.push(...realtimes);

  //清除区域
  ws.getRegions.forEach(region => {
    region.remove()
  });

  //添加零长区域
  times.forEach(e => {
    ws.addRegion({
      start: e.start,
      end: e.end,
      content: e.text,
      color: 'rgba(0, 0, 0, 0.1)'
    })
  })

  // console.log('times-->',JSON.stringify(times))

})



let dialogFormVisible = ref(false)
let dialogFormRemark = ref('')
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
  /*.cell .el-textarea__inner{
    font-size: 18px;
  }*/
}

/* 覆盖 el-table 的行 hover 样式 */
::v-deep .el-table__body tr:hover > td {
  background-color: transparent !important;
}
</style>