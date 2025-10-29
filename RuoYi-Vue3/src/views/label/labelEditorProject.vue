<template>
  <div class="app-container">
    <!-- <textarea id="textarea" v-model="textGridText" style="width: 100%; height: 100px; display: none;"></textarea> -->
    <div style="display: flex; justify-content: space-between; ">
      <!-- <div> 任务包：{{ taskPackageName }}</div> -->
      <div> {{ $t('label.labelEditor.音频文件') }}：{{ task.data.audioFileName }}</div>
      <div style="display: flex; justify-content: flex-end;margin-left: 12px;">
        
        <el-link underline style="margin-right: 22px;" @click="showLabelStandard()">{{ $t('label.labelEditor.标注规范') }}</el-link>
        
      </div>
    </div>
    
    <!-- 语音标注音波图 -->
    <LabelEditorLoading v-show="!audioLoadOver" :audioFileName="task.data.audioFileName?task.data.audioFileName:''" :audioLoadprogress="audioLoadprogress"/>
    <div id="waveform-demo" v-show="audioLoadOver" class="waveform-container" style="width: 100%; height: 100px; margin-top: 10px;"></div>
    
    <!-- 操作按钮栏 -->
    <div style="margin-top: 50px; display: flex; justify-content: space-between; align-items: center;font-size: 14px;">
      <div style="display: flex; align-items: center;">
        <span style="margin-right: 12px;width:120px;">{{ currentTime }} / {{ duration }} </span>
        <el-tooltip :content="$t('label.labelEditor.上一段')+'（ ↑ ）'" placement="top">
        <el-button type="primary" id="backward" round plain>
          <el-icon style="transform: rotate(90deg)" ><Download /></el-icon>
        </el-button>
        </el-tooltip>
        <el-tooltip :content="$t('label.labelEditor.播放/暂停')+'（ Alt ）'" placement="top">
        <el-button type="primary" id="play"  round plain>
          <span v-if="isPlaying" style="width: 20px;">||</span>
          <span v-else style="width: 20px;">▶</span>
        </el-button>
        </el-tooltip>
        <el-tooltip :content="$t('label.labelEditor.下一段')+'（ ↓ ）'" placement="top">
        <el-button type="primary" id="forward" round plain>
          <el-icon style="transform: rotate(270deg)" ><Download /></el-icon>
        </el-button>
        </el-tooltip>
        <view style="margin-left: 12px;display: flex;align-items: center;">
          {{ $t('label.labelEditor.音量') }} <el-slider v-model="volume" style="width: 100px;margin-left: 3px;" />
        </view>
        <view style="margin-left: 12px;display: flex;align-items: center;">
          {{ $t('label.labelEditor.倍速') }} <el-select v-model="playbackRate" size="small" style="width: 70px;margin-left: 3px;">
            <el-option v-for="item in playbackRateList" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </view>
        <!-- <view style="margin-left: 12px;display: flex;align-items: center;">
          循环播放<el-switch v-model="loopPlay" />
        </view> -->
      </div>
      <div style="display: flex; gap: 0.5rem; font-size: 12px; align-items: center; justify-content: center;">
        <span style="color: gray;">{{ $t('label.labelEditor.无效时长标签') }}:</span>
        <div v-for="item in labels" :key="item.label">
          <el-tooltip class="box-item" :content="item.tip" placement="top-start"><el-tag style="cursor:pointer;" checked
              :type="item.type" click="insertText(item.label)">
              {{ item.label }}
            </el-tag></el-tooltip>
        </div>
      </div>
    </div>

    <!--分段标注列表-->
    <div style="margin-top: 0px; display: flex; flex-direction:column">
      <el-table ref="tableRef" :data="times" :highlight-current-row="false" 
        :style="{width: '100%', height: tableHeight + 'px', marginTop:'10px', border:'1px solid #ddd', borderRadius:'5px', fontSize:'16px'}"
        :show-header="true" :row-class-name="tableRowClassName" @row-click="rowClick">
        <el-table-column :label="$t('label.labelEditor.分段序号')" width="90">
            <template #default="scope"> 
              {{ scope.$index + 1 }}
            </template>
          </el-table-column>
        <el-table-column :label="$t('label.labelEditor.开始位置')" width="90">
            <template #default="scope"> 
              {{ scope.row.start }}
            </template>
          </el-table-column>
        <el-table-column :label="$t('label.labelEditor.结束位置')" width="90">
            <template #default="scope"> 
              {{ scope.row.end }}
            </template>
          </el-table-column>
        <el-table-column :label="$t('label.labelEditor.时长(秒)')" width="90">
            <template #default="scope"> 
            <span :style="Number((scope.row.end - scope.row.start).toFixed(3))>15?'color:red':''">
              {{ Number((scope.row.end - scope.row.start).toFixed(3)) }}
            </span>
            </template>
          </el-table-column>
        <el-table-column :label="$t('label.labelEditor.标注文本内容')">
          <template #header>
            <div style="display: flex; justify-content: space-between;">
              <div>{{ $t('label.labelEditor.标注文本内容') }}</div>
              <div>
                <!-- <el-input v-model="search" size="small" placeholder="查找与替换" /> -->
              </div>
            </div>
          </template>
            <template #default="scope"> 
              <div style="font-size:24px;">
                {{ scope.row.text }}
              </div>
          </template>
          </el-table-column>
        <el-table-column :label="$t('label.labelEditor.字符数')" width="100">
            <template #default="scope"> 
            <span :style="(scope.row.text&&scope.row.text.replace(/\s+/g,'').length>120)?'color:red':''">{{ scope.row.text&&scope.row.text.replace(/\s+/g,'').length }}</span>
            </template>
          </el-table-column>
      </el-table>
    </div>

    <!-- 底部提示说明 -->
    <div v-if="task.data.status==='pending_review'"
      style="line-height: 30px;margin-top: 10px; color: gray; font-size: 12px;">
      <!-- Tip：审核人可对标注内容进行修改，提交审核结果同时保存修改的内容。 -->
    </div>


    <!-- 操作方法 -->
    <el-dialog v-model="operationTipDialogVisible" title="" width="80%">
      <div data-v-2bde42cb="" style="font-size: 16px;color: rgb(51, 51, 51);">
        <el-divider>{{$t('label.labelEditor.操作方法')}}</el-divider>
        <p><strong >{{$t('label.labelEditor.缩放波形')}}</strong><span >：{{ $t('label.labelEditor.缩放波形-方法') }}</span></p>
        <p style="display: flex; justify-content: flex-start;line-height: 30px;">
          <span style="white-space: nowrap;"><strong>{{$t('label.labelEditor.切割分段')}}</strong>：</span>
          <span>{{ $t('label.labelEditor.切割分段-方法1') }}<br/>{{ $t('label.labelEditor.切割分段-方法2')}}</span>
        </p>
        <p style="display: flex; justify-content: flex-start;line-height: 30px;">
          <span><strong >{{$t('label.labelEditor.调整分段')}}</strong></span>
          <span >：{{ $t('label.labelEditor.调整分段-方法') }}</span>
        </p>
        <p style="display: flex; justify-content: flex-start;line-height: 30px;">
          <span><strong >{{$t('label.labelEditor.合并分段')}}</strong>：</span>
          <span>{{ $t('label.labelEditor.合并分段-方法1') }}<br/>{{ $t('label.labelEditor.合并分段-方法2')}}
            <el-tooltip :content="$t('label.labelEditor.合并上一段')" placement="top"><el-button size="small" type="primary" icon="Upload" round  plain/></el-tooltip>
            /<el-tooltip :content="$t('label.labelEditor.合并下一段')" placement="bottom"><el-button style="margin-left: 2px;" size="small" type="primary" icon="Download" round  plain/></el-tooltip>
          </span>
        </p>
        <el-divider>{{$t('label.labelEditor.快捷键')}}</el-divider>
        <p><strong >{{$t('label.labelEditor.转到上一段')}}</strong><span >：{{$t('label.labelEditor.转到上一段-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.转到下一段')}}</strong><span >：{{$t('label.labelEditor.转到下一段-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.合并上一段')}}</strong><span >：{{$t('label.labelEditor.合并上一段-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.合并下一段')}}</strong><span >：{{$t('label.labelEditor.合并下一段-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.播放/暂停')}}</strong><span >：{{$t('label.labelEditor.播放/暂停-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.保存更改')}}</strong><span >：{{$t('label.labelEditor.保存更改-快捷键')}}</span></p>
        <p><strong >{{$t('label.labelEditor.撤消更改')}}</strong><span >：{{$t('label.labelEditor.撤消更改-快捷键')}}</span></p>
      </div>
    </el-dialog>
    <!-- 标注规范 -->
    <el-dialog v-model="labelStandardDialogVisible" :title="$t('label.labelEditor.标注规范')" width="80%">
      <div data-v-2bde42cb="" style="font-size: 16px; line-height: 18px;">
        <p><strong >1）{{$t('label.labelEditor.文本')}}</strong><span >：{{$t('label.labelEditor.文本-规范')}} </span></p>
        <p><strong >2）{{$t('label.labelEditor.分段')}}</strong><span >： </span></p>
        <p><span >①{{$t('label.labelEditor.分段-规范1')}} </span></p>
        <p><span >②{{$t('label.labelEditor.分段-规范2')}} </span></p>
        <p><span >③{{$t('label.labelEditor.分段-规范3')}} </span></p>
        <p><strong >3）{{$t('label.labelEditor.无效时长标签')}}：</strong><span > </span></p>
        <p><span >&lt;NOISE&gt;：{{$t('label.labelEditor.<NOISE>')}} </span></p>
        <p><span >&lt;DEAF&gt;：{{$t('label.labelEditor.<DEAF>')}} </span></p>
        <p><span >&lt;OVERLAP&gt;：{{$t('label.labelEditor.<OVERLAP>')}} </span></p>
        <p><span >{{$t('label.labelEditor.无效标签-备注')}} </span></p>
        <p><span >&lt;OOV&gt;：{{$t('label.labelEditor.<OOV>')}} </span></p>
        <p><strong >4）{{$t('label.labelEditor.标点符号')}} </strong><span >：{{$t('label.labelEditor.标点符号-规范')}} </span></p>
        <p><strong >5）{{$t('label.labelEditor.用词规范')}}</strong><span >： </span></p>
        <p><span >①{{$t('label.labelEditor.用词规范-规范1')}} </span></p>
        <p><span >②{{$t('label.labelEditor.用词规范-规范2')}} </span></p>
        <p><span >③{{$t('label.labelEditor.用词规范-规范3')}} </span></p>
        <p><span >④{{$t('label.labelEditor.用词规范-规范4')}}</span></p>
      </div>
    </el-dialog>



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
  import { nextTick, onMounted, onUpdated, onUnmounted, reactive, watch } from "vue"
import LabelEditorLoading from './labelEditorLoading'
import LabelEditorHistoryOper from './labelEditorHistoryOper'
  // import KeyboardKm from './keyboard/keyboard_km'

const audioLoadprogress = ref(0)
const audioLoadOver = ref(false)
  const activeKeyBoard = ref(null)
  let injectedScript = null;
  /*
  function activeKeyBoardPanel(scope_index) {
    activeKeyBoard.value = scope_index;
    setTimeout(()=>{
      const jqLink = document.createElement('script');
      jqLink.src = '/html/keyboard_km.js';
      document.head.appendChild(jqLink);
      jqLink.onload = function() {
        console.log('loaded keyboard km success!')
      };
    }, 1000)
  }*/


  function activeKeyBoardPanel(scope_index) {
    activeKeyBoard.value = scope_index;
    if (injectedScript) {
      document.head.removeChild(injectedScript);
      injectedScript = null;
    }
    if (scope_index !== -1) {
      setTimeout(() => {
        injectedScript = document.createElement('script');
        injectedScript.src = '/html/keyboard_km.js';
        injectedScript.onload = function() {
          console.log('键盘脚本加载成功!');
        };
        injectedScript.onerror = function() {
          console.error('键盘脚本加载失败!');
          if (injectedScript && injectedScript.parentNode) {
            document.head.removeChild(injectedScript);
            injectedScript = null;
          }
        };

        document.head.appendChild(injectedScript);
      }, 1000);
    } else {
      if (injectedScript && injectedScript.parentNode) {
        document.head.removeChild(injectedScript);
        injectedScript = null;
      }
      console.log('键盘脚本已销毁');
    }
  }
















const labels = reactive([])

// ********* s 当前任务音频列表 *********
import AnnotatorTask from './annotatorTask'
const popoverVisible = ref(false)
const popoverRef = ref()
const togglePopover = () => {
  popoverVisible.value = !popoverVisible.value
}
const hidePopover = () => {
  popoverVisible.value = false
}
const handleSubmit = (data) => {
  hidePopover()
}
const onPopoverHide = () => {
  console.log('Popover 已关闭')
}
// ********* e 当前任务音频列表 *********
const drawerHisoryOperVisible = ref(false)
const directionHisoryOper = ref('rtl')
const openHisoryOperDrawer = () => {
  drawerHisoryOperVisible.value = true
}
const handleCloseHisoryOper = (val) => {
  drawerHisoryOperVisible.value = val
}
const handleDrawerCloseHisoryOper = (done) => {
 done()
}
function updateFormHistory(history) {
  console.log(history)
  proxy.$message.success(`恢复成功`)
}


//=========================定义函数=========================
//显示TG对比
const diffDialogVisible = ref(false)
const oldText = ref('')
const newText = ref('')
//将标注文本textGridJson转换为文本
function convertText(textGridJson){
  let textArray = textGridJson.item[0].intervals.map( (row, index)=>{
    return `${row.text||''}`
  })
  return textArray.join('\n')
}
//显示标注前后文本对比
function showTextDiff(){
  //获取原始的分段数据
  let oldTextGridJson = parseTextGrid(task.data.originalTextGrid)
  //将转换为分段号+文本
  oldText.value = convertText(oldTextGridJson)
  //-------------------------
  //获取最新的分段数据intervals
  let intervals = times.map((ts,i)=>{
    return {
      index: (i+1),
      xmin: ts.start,
      xmax: ts.end,
      text: ts.text,
    }
  })
  // 将intervals替换到 task.textGridJson.item[0].intervals
  task.textGridJson.item[0].intervals = intervals
  // 转换为分段号+文本
  newText.value = convertText(task.textGridJson)
  diffDialogVisible.value = true
}

//操作方法
const operationTipDialogVisible = ref(false)
const operationTipContent = ref('')
function showOperationTip(){
  operationTipDialogVisible.value = true
  // getNotice(1).then(res=>{
  //   console.log(res)
  //   operationTipContent.value = res.data.noticeContent
  // })
}
//标注规范
const labelStandardDialogVisible = ref(false)
const labelStandardContent = ref('')
function showLabelStandard(){
  labelStandardDialogVisible.value = true
  // getNotice(2).then(res=>{
  //   console.log(res)
  //   labelStandardContent.value = res.data.noticeContent
  // })
}

function insertText(text) {
  if (activeRegion && activeRegion.start !== activeRegion.end) {
    times.forEach(item => {
      if (item.start === activeRegion.start && item.end===activeRegion.end) {//当前分段
        //插入/移除标签
        if(item.text.indexOf(text)>-1){//如果已包含指定标签
          item.text = item.text.replace(new RegExp(text, 'g'), '')//则移除指定标签
        }else{
          item.text += text//否则插入指定标签
        }      
        //移除其它标签
        labels.forEach(e => {
          if(e.label != text){
            item.text = item.text.replace(new RegExp(e.label, 'g'), '')//移除标签
          }
        })  
        //去除首尾空格
        item.text = item.text.replace(/^\s+|\s+$/g, '')
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

//播放/暂停
function playOrPause(){
    if(ws.getCurrentTime() >= activeRegion.end){
      regions.getRegions().forEach(reg=>{
        if(reg.start== activeRegion.start && reg.end==activeRegion.end){
          reg.play()
          playStatus = true
        }
      })
    }else{
      ws.playPause()//音频播放/暂停
      playStatus = false
  }
    }

const handleSpace = (event) => {
  // 按Alt键
  if(event.altKey) {
    console.log('alt键被按下');
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    playOrPause()
  }
  // 按Ctrl+S键
  else if (event.ctrlKey && event.key === 's') { 
    console.log('按Ctrl+S键执行保存更改');
    //saveTask();
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
  }
  // 按上方向键
  else if (event.key === 'ArrowUp') {
    event.preventDefault(); // 阻止元素的默认行为
    console.log('上方向键被按下', activeRegion);
    // 上方向键 - 切换到上一行
    const currentIndex = times.findIndex(seg => seg.start==activeRegion.start && seg.end==activeRegion.end);
    if (currentIndex > 0) {
      //focusInput(times[currentIndex - 1]);
      activateRegion(times[currentIndex - 1]);
      //滚动到标注行
      scrollToRow(currentIndex - 1)
    }
  // 按下方向键
  } else if (event.key === 'ArrowDown') {
    event.preventDefault(); // 阻止元素的默认行为
    console.log('下方向键被按下', activeRegion);
    // 下方向键 - 切换到下一行
    const currentIndex = times.findIndex(seg => seg.start==activeRegion.start && seg.end==activeRegion.end);
    if (currentIndex < times.length - 1) {
      //focusInput(times[currentIndex + 1]);
      activateRegion(times[currentIndex + 1]);
      //滚动到标注行
      scrollToRow(currentIndex + 1)
    }
  }
  //按下Ctrl+Z键
  else if(event.ctrlKey && event.key=='z'){
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    console.log('按了ctrl+z')
    //撤销操作
    undo()
  }
}


/**
 * 处理文本输入框方向键事件
 * @param {Event} event - 键盘事件
 * @param {Object} row - 当前行数据
 */
function handleTextArrow(event, row) {
  //按Alt键
  if(event.altKey){
    console.log('Alt键被按下');
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    playOrPause()
  }
  // 按下空格键
  else if (event.key === ' ') {
    //event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    console.log('空格键被按下');
  }
  // 按Ctrl+↑上方向键
  else if(event.ctrlKey && event.key === 'ArrowUp') {
    console.log('Ctrl+↑ 键被按下');
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    mergeUp(event,row)
  }
  // 按Ctrl+↓下方向键
  else if(event.ctrlKey && event.key === 'ArrowDown') {
    console.log('Ctrl+↓ 键被按下');
    event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    mergeDown(event,row)
  }
  // 按上/下方向键
  else if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
    console.log('方向键被按下-->', event.key);
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    const textarea = event.target;
    const cursorPos = textarea.selectionStart;
    
    // 创建一个隐藏的div来模拟textarea的布局
    const hiddenDiv = document.createElement('div');
    hiddenDiv.style.position = 'absolute';
    hiddenDiv.style.visibility = 'hidden';
    hiddenDiv.style.whiteSpace = 'pre-wrap';
    hiddenDiv.style.width = textarea.clientWidth + 'px';
    hiddenDiv.style.font = window.getComputedStyle(textarea).font;
    hiddenDiv.style.padding = window.getComputedStyle(textarea).padding;
    hiddenDiv.style.border = window.getComputedStyle(textarea).border;
    hiddenDiv.style.lineHeight = window.getComputedStyle(textarea).lineHeight;
    
    // 设置div内容为textarea的文本
    hiddenDiv.textContent = textarea.value.substring(0, cursorPos);
    
    // 将div添加到DOM中
    document.body.appendChild(hiddenDiv);
    
    // 获取div的高度
    const divHeight = hiddenDiv.clientHeight;
    const lineHeight = parseInt(window.getComputedStyle(textarea).lineHeight, 10);
    const currentLine = Math.floor(divHeight / lineHeight);
    const totalLines = Math.floor(textarea.scrollHeight / lineHeight);
    
    // 移除隐藏的div
    document.body.removeChild(hiddenDiv);
    
    // 判断光标是否在视觉上的第一行或最后一行
    const isAtFirstLine = currentLine === 1 || !textarea.value;
    const isAtLastLine = currentLine === totalLines || !textarea.value;
    
    // 只有光标在视觉上的第一行(上键)或最后一行(下键)时才切换分段
    if ((event.key === 'ArrowUp' && (isAtFirstLine || cursorPos === 0)) || 
        (event.key === 'ArrowDown' && isAtLastLine)) {
      const currentIndex = times.findIndex(seg => seg.start === row.start && seg.end === row.end);
      if (event.key === 'ArrowUp' && currentIndex > 0) {
        focusInput(times[currentIndex - 1]);
        activateRegion(times[currentIndex - 1]);
      } else if (event.key === 'ArrowDown' && currentIndex < times.length - 1) {
        focusInput(times[currentIndex + 1]);
        activateRegion(times[currentIndex + 1]);
      }
    } else {
      // 如果不在第一行或最后一行，允许默认的方向键行为（移动光标）
      return;
    }
    return;
  }
  //按下Ctrl+Z键
  else if(event.ctrlKey && event.key=='z'){
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    console.log('keydown--按了ctrl+z')
  }
}

function handleTextEnter(event, row) {

  //event.preventDefault(); // 阻止元素的默认行为
  //event.stopPropagation();// 阻止事件继续在DOM树中传播
  // 处理回车键
  if(event.key === 'Enter') {
    console.log('回车键被按下', row.text);
  // 获取当前文本
  const text = row.text;
  // 查找换行符位置
  const newlineIndex = text.indexOf('\n');
  if (newlineIndex !== -1) {
    // 如果有换行符，则按换行符分割文本
    const firstPart = text.substring(0, newlineIndex);
    const secondPart = text.substring(newlineIndex + 1);
    // 更新当前行的文本为第一部分
      //row.text = firstPart;
    // 计算分割点（按时间比例）
      const splitPoint = ((Number(row.start)+Number(row.end))/2 ).toFixed(3)
    // 调用splitSegment函数处理分段
      let res = splitSegment(times, row, splitPoint, firstPart, secondPart);
      if(res){
        //提示切分成功，并注意调整分段边界
        proxy.$message.success(proxy.$t('label.labelEditor.切分成功，注意调整分段边界'))
      }
    }
  }
  //按下Ctrl+Z键
  else if(event.ctrlKey && event.key=='z'){
    //event.preventDefault(); // 阻止元素的默认行为
    event.stopPropagation();// 阻止事件继续在DOM树中传播
    console.log('keyup--按了ctrl+z')
  }
}

/**
 * 处理文本输入框失去焦点事件
 * @param {Event} event - 键盘事件
 * @param {Object} row - 当前行数据
 */
function handleTextBlur(event, row){
  event.stopPropagation();// 阻止事件继续在DOM树中传播
  console.log('textarea失去焦点--->', row.text)
  //去掉row.text中的首尾空格
  row.text = row.text.trim()
}

function handleTextChange(event, row, rowIndex){
  //event.stopPropagation();// 阻止事件继续在DOM树中传播
  console.log( `第${rowIndex+1}分段的textarea值改变了--->`, row.text)
  //去掉row.text中的首尾空格
  row.text = row.text.trim()
  //添加历史记录
  addHistoryTimes('修改分段文本')
}

//与上一分段合并
function mergeUp(event, row){
  event.stopPropagation();// 阻止事件继续在DOM树中传播
  //将当前行与上一行合并
  const prevRow = times[times.indexOf(row) - 1]
  if (prevRow && prevRow.start !== prevRow.end) {//如果上一行不为空
    prevRow.text += row.text //合并文本
    //将上一行的结束时间设置为当前行的结束时间
    prevRow.end = row.end
    times.splice(times.indexOf(row), 1)//删除当前行
    proxy.$message.success(proxy.$t('label.labelEditor.合并成功'))

    //清除所有区域
    regions.clearRegions()
    //重新创建分段线
    times.forEach((e, index) => {
      regionCreationSource = 'code'
      regions.addRegion({
        start: e.start,
        content: `${index+1}`,
        color: '#666',
        drag: false,
        resize: false
      })
    })

    //激活合并后的行
    activateRegion(prevRow)
    addHistoryTimes('向上合并一个分段')
    focusInput(prevRow)
  }
}

//与下一分段合并
function mergeDown(event, row){
  event.stopPropagation();// 阻止事件继续在DOM树中传播
  //将当前行与下一行合并
  const nextRow = times[times.indexOf(row) + 1]
  if (nextRow && nextRow.start !== nextRow.end) {//如果下一行不空
    row.text += nextRow.text //合并文本
    //将当前行的结束时间设置为下一行的结束时间
    row.end = nextRow.end
    times.splice(times.indexOf(nextRow), 1)//删除下一行
    proxy.$message.success(proxy.$t('label.labelEditor.合并成功'))

    //清除所有区域
    regions.clearRegions()
    //重新创建分段线
    times.forEach((e, index) => {
      regionCreationSource = 'code'
      regions.addRegion({
        start: e.start,
        content: `${index+1}`,
        color: '#666',
        drag: false,
        resize: false
      })
    })

    //激活合并后的行
    activateRegion(row)
    addHistoryTimes('向下合并一个分段')
    focusInput(row)
  }
}


// 聚焦到指定行的输入框
function focusInput(row) {
  nextTick(() => {
    const inputs = document.querySelectorAll('.el-textarea__inner');
    const index = times.indexOf(row);
    if (inputs[index]) {
      inputs[index].focus();
    }
  });
}
//所有输入框失去焦点
function  blurAllInputs(){
  nextTick(() => {
    const inputs = document.querySelectorAll('.el-textarea__inner');
    inputs.forEach(inputRef =>{
      inputRef.blur()
    })
  });
}

// 获取音频文件URL（需要根据实际路径结构调整）
function getAudioUrl(audioFileName) {
  // 使用完整的API路径访问音频文件，例如：`/dev-api/profile/upload/${audioFileName}`
  if (audioFileName.startsWith('/profile/upload/')) {
    return import.meta.env.VITE_APP_BASE_API +`${audioFileName}`;
  } else {
    return import.meta.env.VITE_APP_BASE_API +`/profile/upload/${audioFileName}`;
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
    let newtimes = task.textGridJson.item[0].intervals.map(ts=>{
      return {
        start: ts.xmin,
        end: ts.xmax,
        text: ts.text
      }
    })
    times.splice(0,times.length,...newtimes)

    //清除所有区域
    regions.clearRegions()
    //重建分段线
      times.forEach((e, index) => {
      regionCreationSource = 'code'
        regions.addRegion({
          start: e.start,
          content: `${index+1}`,
          color: '#666',
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
function saveTask(autoSave=false) {
  //将最新的times转为intervals
  let intervals = times.map((ts,i)=>{
    return {
      index: (i+1),
      xmin: ts.start,
      xmax: ts.end,
      text: ts.text,
    }
  })
  // 将intervals替换到 task.textGridJson.item[0].intervals
  task.textGridJson.item[0].intervals = intervals
  //转换textGridJson为TG文本格式
  let textGrid = stringifyTextGrid(task.textGridJson)
  // if(task.data.textGrid === textGrid) {
  //   proxy.$modal.msgWarning("标注内容未发生改变")
  //   return 
  // }
  //替换task.data的TextGrid字段
  task.data.textGrid = textGrid
  //准备保存的参数
  let sysTask = {
      taskId: taskId,
      textGrid: textGrid,
    }
  const formData = new FormData();
  formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
  updateTask(formData).then(response => {
    console.log(response)
    let msg = autoSave? proxy.$t("label.labelEditor.自动保存成功") : proxy.$t("label.labelEditor.保存成功")
    proxy.$modal.msgSuccess(msg)
  })
}


// 校验结果对话框相关变量
const validationDialogVisible = ref(false)
const validationErrors = ref([])

// 校验分段是否符合规则
function validateSegments() {
  const errors = []
  
  times.forEach((segment, index) => {
    const segmentNum = index + 1
    const duration = Number((segment.end - segment.start).toFixed(3))
    const text = segment.text
    
    // 1. 检查分段文本字符数不超过120个字符
    if (text.replace(/\s+/g,'').length > 120) {
      errors.push({
        index: segmentNum,
        reason: proxy.$t('label.labelEditor.文本字符数超过120个'),
        duration: duration,
        text: text.substring(0, 30) + (text.length > 30 ? '...' : '')
      })
    }
    
    // 2. 检查分段时长不超过15s（打了无效时长标签的除外）
    if (duration > 15) {
      // 检查是否包含无效时长标签
      const hasInvalidTag = labels.some(label => text.includes(label.label))
      
      if (!hasInvalidTag) {
        errors.push({
          index: segmentNum,
          reason: proxy.$t('label.labelEditor.分段时长超过15秒且未标记无效时长标签'),
          duration: duration,
          text: text.substring(0, 30) + (text.length > 30 ? '...' : '')
        })
      }
    }
    
    // 3. 检查文本不能为空白
    if (!text || text.trim() === '') {
      errors.push({
        index: segmentNum,
        reason: proxy.$t('label.labelEditor.标注文本为空白'),
        duration: duration,
        text: `(${proxy.$t('label.labelEditor.空文本')})`
      })
    }
  })
  
  return errors
}

/** 提交任务 */
function submitTask(isValidate=true) {
  if (isValidate) {//校验数据
    // 先进行校验
    const errors = validateSegments()
    // 如果有错误，显示校验结果对话框
    if (errors.length > 0) {
      validationErrors.value = errors
      validationDialogVisible.value = true
      return
    }
  }
  proxy.$modal.confirm(proxy.$t('label.labelEditor.确定提交审核吗？')).then(function () {
    //将最新的times转为intervals
    let intervals = times.map((ts,i)=>{
      return {
        index: (i+1),
        xmin: ts.start,
        xmax: ts.end,
        text: ts.text,
      }
    })
    // 将intervals替换到 task.textGridJson.item[0].intervals
    task.textGridJson.item[0].intervals = intervals
    //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
    let textGrid = stringifyTextGrid(task.textGridJson)
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
      proxy.$modal.msgSuccess(proxy.$t('label.labelEditor.提交成功'))
      setTimeout(() => {
        //跳转回"我的任务明细"页
        proxy.$router.push(`/label/my-task/index/${task.data.packageId}/${encodeURIComponent(route.params.taskPackageName)}`);
      }, 1000)
      
    })
  })
}

//驳回任务
function rejectTask(){
  console.log('rejectTask---',dialogFormRemark)
  if(!dialogFormRemark.value){
    proxy.$modal.msgError(proxy.$t('label.labelEditor.请填写驳回原因'))
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
  // 将intervals替换到 task.textGridJson.item[0].intervals
  task.textGridJson.item[0].intervals = intervals
  //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
  let textGrid = stringifyTextGrid(task.textGridJson)
  task.data.textGrid = textGrid
  //准备提交的参数
  let sysTask = {
      taskId: taskId,
      textGrid: textGrid,
      status: 'reject',
      remark: proxy.$t('label.labelEditor.驳回原因')+':'+dialogFormRemark.value
    }
  const formData = new FormData();
  formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
  updateTask(formData).then(response => {
    proxy.$modal.msgSuccess(proxy.$t("label.labelEditor.驳回成功"))
    setTimeout(() => {
      //跳转回“我的审核”页
      proxy.$router.push({ path: `/label/auditTask`, query: { t: new Date().getTime() } });
    }, 1000)
    
  })

}



/** 审核任务 */
function auditTask(isValidate=true) {
  
  // 是否先进行校验
  if(isValidate){
    const errors = validateSegments()
    // 如果有错误，显示校验结果对话框
    if (errors.length > 0) {
      validationErrors.value = errors
      validationDialogVisible.value = true
      return
    }
  }
  proxy.$modal.confirm(proxy.$t('label.labelEditor.确定审核通过吗？')).then(function () {
    //将最新的times转为intervals
    let intervals = times.map((ts,i)=>{
      return {
        index: (i+1),
        xmin: ts.start,
        xmax: ts.end,
        text: ts.text,
      }
    })
    // 将intervals替换到 task.textGridJson.item[0].intervals
    task.textGridJson.item[0].intervals = intervals
    //转换textGridJson为TG文本格式,替换task.data的TextGrid字段
    let textGrid = stringifyTextGrid(task.textGridJson)
    task.data.textGrid = textGrid
    //准备提交的参数
    let sysTask = {
        taskId: taskId,
        textGrid: textGrid,
        status: 'pass',
      }
    const formData = new FormData();
    formData.append('sysTask', new Blob([JSON.stringify(sysTask)], {type: "application/json"}));
    updateTask(formData).then(response => {
      proxy.$modal.msgSuccess(proxy.$t('label.labelEditor.审核成功'))
      setTimeout(() => {
        //跳转回“我的审核”页
        proxy.$router.push({ path: `/label/auditTask`, query: { t: new Date().getTime() } });
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
      return null;
    }
    if(newSegment.start >= newSegment.end) {
      console.log("新分段起始时间大于等于结束时间，调整失败");
      return null;
    }
    if(newSegment.start == oldSegment.start && newSegment.end == oldSegment.end) {
      console.log("新旧分段的起止和结束时间相同，无需调整");
      return null;
    }
    if(newSegment.end - newSegment.start < 0.1 ) {
      console.log("新分段时长小于0.1秒，调整失败");
      return null
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
            if(result[i].end <= newSegment.end) {//分段被覆盖
              //合并文本
              result[index].text = result[index].text + "" + result[i].text;
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
        if( (seg.start > newSegment.start && seg.end < newSegment.end) //左右边界都在新分段中间
          || (seg.start == newSegment.start && seg.end < newSegment.end)//左边界相同
          || (seg.start > newSegment.start && seg.end == newSegment.end)////右边界相同
        ){//中间分段被覆盖，不保留
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
      
      // 4. 移除任何可能产生的无效分段（如长度为0或负值的分段）
      return result.filter(seg => seg.start < seg.end);

    }else{
      console.error(`找不到要调整的分段`);
    }
}

function splitSegment(times, oldSegment, point, firstPart, secondPart) {
  // 查找oldSegment在times数组中的索引
  const index = times.findIndex(segment => segment === oldSegment);
  
  if (index !== -1) {
  //将从oldSegment分割为两个分段，其中一个分段的右边界为point
  let newSegment = {
    start: oldSegment.start,
      end: Number(point),
      text: firstPart
  }
    
    // 更新原分段左边界
    oldSegment.start = Number(point);
    oldSegment.text = secondPart
    
    // 替换数组中的分段
  times[index] = newSegment;
    // 在index之后插入原分段
    times.splice(index + 1, 0, oldSegment);

    //清除分段线
    regions.clearRegions()

    //重建分段线
    times.forEach((e, index) => {
      regionCreationSource = 'code'
      regions.addRegion({
        start: e.start,
        content: `${index+1}`,
        color: '#666',
        drag: false,
        resize: false
      })
    })
    
    //激活index分段
    activateRegion(newSegment)
    //保存历史操作
    addHistoryTimes('切割分段')
    
    return true;
    
  } else {
    console.error(`找不到要调整的分段`);
    return false;
  }
}

function loadTextGrid(){
  if(!task.data.textGrid){
    proxy.$message.error(proxy.$t('label.labelEditor.缺少预标注文本TextGrid'))
    return
  }
  // ----将预标注文本转为json---
  // console.log('task.textGrid-->\n',task.data.textGrid)
  task.textGridJson = parseTextGrid(task.data.textGrid)
  // console.log('解析TextGrid-->\n',task.textGridJson)

  //检查并修复时间序列数据
  task.textGridJson = fixIntervals(task.textGridJson)
  // console.log('检查并修复时间序列数据-->\n',task.textGridJson)

  //JSON转TextGrid
  task.textGrid = stringifyTextGrid(task.textGridJson)
  // console.log('JSON转TextGrid-->\n',task.textGrid)

  // 生成时间序列数据
  let realtimes = task.textGridJson.item[0].intervals.map(e => {//默认取第一个层的数据
    return {
      start: e.xmin,
      end: e.xmax,
      text: e.text
    }
  })

  //赋值区域
  times.splice(0, times.length);
  times.push(...realtimes);
  //保存历史数据
  addHistoryTimes('初始载入分段数据')
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

  getPackage(task.data.packageId).then(res=>{
    task.package = res.data;
    console.log('任务包详情：', task.package)
  })

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
    autoCenter: false, // 自动居中播放位置
    plugins: [
      regions,
      timeline,
      hover,
      ZoomPlugin.create({
        // 每个轮步的变焦量, 例如0.5表示每次变焦量放大0.5倍
        scale: 0.2,
        // Optionally, specify the maximum pixels-per-second factor while zooming
        //可选项地指定缩放时的最大每秒像素数值
        maxZoom: 300,
      }),
    ],
  })

  // 加载音频文件    
  ws.load( getAudioUrl(task.data.audioFilePath) )

    ws.on('loading', (percent) => {
      audioLoadprogress.value = percent;
    })

  ws.on('play', () => {
    isPlaying.value = true;
  })

  ws.on('pause', () => {
    isPlaying.value = false;
  })

  ws.on('zoom', (minPxPerSec) => {
    console.log('zoom---->minPxPerSec', minPxPerSec)
  })

  ws.on('decode', () => { 

    labels.push(...[
      { type: 'primary', label: '<NOISE>', 'tip': proxy.$t('label.labelEditor.<NOISE>') },
      { type: 'success', label: '<DEAF>', 'tip': proxy.$t('label.labelEditor.<DEAF>') },
      { type: 'info', label: '<OVERLAP>', 'tip': proxy.$t('label.labelEditor.<OVERLAP>') },
      { type: 'warning', label: '<OOV>', 'tip': proxy.$t('label.labelEditor.<OOV>') },
    ])

    //获得音频总时长
    duration = ws.decodedData.duration
    console.log(`音频总时长为 ${duration} 秒`)
    audioLoadOver.value = true;


    //加载预标注文本
    loadTextGrid()
    // console.log('times-->', JSON.stringify(times))

    //末尾分段的结束时间设为音频总时长
    times[times.length - 1].end = duration

    //添加分段标记 (零长度区域)
    // console.log(`当前点：`,times);
    console.log('添加初始分段标记-->')
    times.forEach( (ts,index) => {
      regionCreationSource = 'code'
      regions.addRegion({
        start: ts.start,
        content: `${index+1}`,
        color: '#666',
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
    // console.log('新增区域：', region.start, region.end)
    region.drag = false;//禁止拖拽新区域

    //判断是否为代码创建区域（非手动拖拽创建）
    if(regionCreationSource != 'code'){
      console.log("不可手动创建新区域");
      region.remove()
      return
    }
    //重置区域创建来源标记
    regionCreationSource = null;

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
      // proxy.$message.error('新增区域时长小于1秒，请重新框选区域！')
      // region.remove()
      // return //无效区域，时长小于1秒
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
    let start = Number(region.start.toFixed(3))
    let end = Number(region.end.toFixed(3))

    //吸附边界：如果新边界值与已有分段边界值距离小于0.3秒，则边界值等于已有分段边界值
    times.forEach( ts => {
      if(ts.start!=activeRegion.start && ts.end!=activeRegion.end){//排除当前分段
        if( Math.abs( ts.start - start) < 0.3){//左边界
          start = ts.start
        }
        if( Math.abs( ts.end - end) < 0.3){//右边界
          end = ts.end
        }
      }
    })

    let newSeg = {start:start, end:end}
    let newtimes = addSegment(times, newSeg)
    times.splice(0, times.length);
    times.push(...newtimes);
    console.log(`添加后：`,times);

    //清除分段线
    regions.clearRegions()

    //重建分段线
    times.forEach((e, index) => {
      regionCreationSource = 'code'
      regions.addRegion({
        start: e.start,
        content: `${index+1}`,
        color: '#666',
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
    // regionCreationSource = 'code'
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

      //不是可标注状态的不可操作
      if(!['underway','reject'].includes(task.data.status)) {
        console.log("当前任务状态下不可修改标注");
        activateRegion(activeRegion)
        return
      }

      //调整region的start和end精度保留3位小数
      let start = Number(region.start.toFixed(3))
      let end = Number(region.end.toFixed(3))

      //吸附边界：如果新边界值与已有分段边界值距离小于0.3秒，则新边界值等于已有分段边界值
      times.forEach( ts => {
        if(ts.start!=activeRegion.start && ts.end!=activeRegion.end){//排除当前分段
          if( Math.abs( ts.start - start) < 0.3){//左边界
            start = ts.start
          }
          if( Math.abs( ts.end - end) < 0.3){//右边界
            end = ts.end
          }
        }
      })

      if( Math.abs(end - start) < 0.1 ) {
        console.log("新分段时长小于0.1秒，调整失败");
        activateRegion(activeRegion)
        return 
      }
      if(start >= end) {
        console.log("新分段起始时间大于等于结束时间，调整失败");
        activateRegion(activeRegion)
        return 
      }
      if(start == activeRegion.start && end == activeRegion.end) {
        console.log("新旧分段的起止和结束时间相同，无需调整");
        activateRegion(activeRegion)
        return 
      }

      

      console.log(`识别到调整区域：(${activeRegion.start},${activeRegion.end})-->(${start},${end})`)
      
      console.log('调整前：', JSON.stringify(times))
      let oldReg = {start:activeRegion.start, end:activeRegion.end}
      let newReg = {start:start, end:end}
      let newtimes  = adjustSegment(times, oldReg, newReg)
      if(!(newtimes && newtimes.length > 0)){
        return
      }
      times.splice(0, times.length)
      times.push(...newtimes)
      console.log(`调整后：`, JSON.stringify(times))

      //清除分段线
      regions.clearRegions()

      //重建分段线
      times.forEach((e, index) => {
        regionCreationSource = 'code'
        regions.addRegion({
          start: e.start,
          content: `${index+1}`,
          color: '#666',
          drag: false,
          resize: false
        })
      })

      //将手动新增区域视为当前激活区域（记录边界值）
      activeRegion.start = start
      activeRegion.end = end

      
      const index = times.findIndex(seg => seg.start === start && seg.end === end);
      console.log('>>>>当前激活的分段：', JSON.stringify(times[index]));
      //移除此分段
      region.remove()
      //激活新分段
      activateRegion(newReg)
      //滚动到标注行
      scrollToRow(index)
      //保存历史操作
      addHistoryTimes('调整分段')
    })

    //单击区域事件
    regions.on('region-clicked', (region, e) => {
      console.log('regions.region-clicked:',  e);
      //e.stopPropagation() 
      // prevent triggering a click on the waveform
      // activeRegion = region
      //region.play(true)
      //region.setOptions({ color: randomColor() })

      //让所有输入框失去焦点
      blurAllInputs()

      // 获取点击位置的时间点
      const rect = ws.getWrapper().getBoundingClientRect();
      const clickX = e.clientX - rect.left;
      let clickTime = (clickX / rect.width) * ws.getDuration();
      console.log(`单击区域，位置: ${clickTime.toFixed(3)}s`);

      //播放音频（从点击的位置开始）
      //ws.play()

      //取消激活区域
      // region.remove()
      // activeRegion.start = 0
      // activeRegion.end = 0

    })

    // 双击区域事件
    regions.on('region-double-clicked', (region, e) => {
      console.log('region-double-clicked',  e);
      // region.play()

      // 获取双击位置的时间点
      const rect = ws.getWrapper().getBoundingClientRect();
      const clickX = e.clientX - rect.left;
      let clickTime = (clickX / rect.width) * ws.getDuration();
      clickTime = Number(clickTime.toFixed(3))
      console.log(`双击区域位置: ${clickTime}s`);

      //不是可标注状态的不可操作
      if(!['underway','reject'].includes(task.data.status)) {
        console.log("当前任务状态下不可修改标注");
        return
      }

      //在双击位置切分区域
      let index = times.findIndex(seg => seg.start<clickTime && seg.end>clickTime)
      //双击的位置太靠近区域边界则不切分
      if( Math.abs(times[index].start-clickTime)<0.3 || Math.abs(times[index].end-clickTime)<0.3 ){
        console.log("双击的位置距离区域边界太近了（小于0.3秒）");
        return
      }
      splitSegment(times, times[index], clickTime, '', times[index].text)
      //focusInput(times[index])

      e.stopPropagation()
    })

    //单击波形图事件
    ws.on('click', (x,y) => {
      console.log('ws.click')
      
      // 获取点击位置的时间点
      // relativeX 是点击位置相对于波形图宽度的比例（范围0到1）
      const duration = ws.getDuration(); // 获取音频总时长（秒）
      const clickTime = Number((x * duration).toFixed(3)); // 计算点击处的时间点
      console.log(`单击位置的时间点：${clickTime}`)

      blurAllInputs()

      //如果与上次单击的时间差过小，则忽略本次单击
      // let now = new Date().getTime()
      // if(now - lastClickTime < 500) {
      //   console.log('单击时间间隔过小，忽略本次单击');
      //   lastClickTime = now
      //   return
      // }
      // lastClickTime = now

      times.forEach((ts, index) => {
        if(clickTime>=ts.start && clickTime<=ts.end){//点击位置在此区间
          //如果点击的时当前激活分段
          if(activeRegion.start==ts.start && activeRegion.end==ts.end){
            //从点击位置开始播放
            ws.setTime(clickTime)
            ws.play()
          }else{
          //激活分段
          activateRegion(ts)
          //滚动到标注行
          scrollToRow(index)
            // focusInput(ts);
        }
        }
      })

    })

    ws.on('timeupdate', (ctime) => {
      let ct = String(ctime.toFixed(3))
      currentTime.value = ct
      if (activeRegion && ctime > activeRegion.end) {//播放到达当前激活分段的末尾
        ws.pause()
        playStatus = true
        // if(playMode=='single_cycle'){//单段循环
        //   //重新激活当前分段
          // activateRegion(activeRegion)
        // }else if(playMode=='play_in_order'){//分段顺序播放
        //   //激活下一分段
          // let index = times.findIndex(seg => seg.start==activeRegion.start && seg.end==activeRegion.end)
          // activateRegion(index + 1)
        // }else{//单段不循环
        //   ws.pause()
        // }  
      }
    })

    //双击波形图事件
    ws.on('dblclick', (x,y) => {
      console.log('ws.dblclick')
      // 1. 计算点击的时间点
      // relativeX 是点击位置相对于波形图宽度的比例（范围0到1）
      const duration = ws.getDuration(); // 获取音频总时长（秒）
      const clickTime = Number((x * duration).toFixed(3)); // 计算点击处的时间点
      console.log(`双击的时间点：${clickTime}`)

      // let index = times.findIndex(seg => seg.start<clickTime && seg.end>clickTime)
      // splitSegment(times, times[index], clickTime, '', times[index].text)

    })

    const playButton = document.querySelector('#play')
    const forwardButton = document.querySelector('#forward')
    const backButton = document.querySelector('#backward')

    if (playButton) {
      playButton.onclick = () => {
        console.log('playButton.onclick--->', ws.isPlaying())
        if(activeRegion.start==0 && activeRegion.end==0){//当前没有激活的分段
          //激活第1段
          activateRegion(times[0])
          //滚动到标注行
          scrollToRow(0)
        }else{
        if(ws.isPlaying()){//在播放
          ws.pause()
            playStatus = false
        }else{//已暂停
          let currentTime = ws.getCurrentTime();
          if(currentTime>=activeRegion.end){//当前播放位置已超出激活区域，则跳转到激活区域的开始处
            ws.setTime(activeRegion.start)
          }
          ws.play()
            playStatus = true
        }
        }
        
      }
    }

    if (forwardButton) {
      forwardButton.onclick = () => {
        let regionIndex = -1
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
        // focusInput(times[regionIndex]);
        // //4.跳转下一段的开始位置
        // ws.skip(times[regionIndex].start)
        // //5.重新开始播放
        // region.play()
      }
    }

    if (backButton) {
      backButton.onclick = () => {
        let regionIndex = -1
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
        // focusInput(times[regionIndex]);

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
  console.log('>>>激活目标分段>>>', JSON.stringify(ts))

  if(activeRegion.start==ts.start && activeRegion.end==ts.end){
    //已经是激活的分段
    console.log('是激活的分段', activeRegion)
    //return
  }else{
    console.log('未激活的分段', activeRegion)
    ws.setTime(ts.start)
  }


  // 1.清除非分段线（取消激活区域）
  regions.getRegions().forEach((region) => {
    if (region.start != region.end) {
      region.remove();
    }
  });

  //2.创建当前点击区域
  regionCreationSource = 'code'
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

  if(playStatus){
    region.play()
  }
  

  //记录当前区域为激活区域
  activeRegion.start = ts.start;
  activeRegion.end = ts.end;

  //监听点击区域事件，当再次点击此区域时，则清除此区域（取消激活）
  region.on('click', (e) => {
    console.log('region.click:',  e)
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
  if(row.start==activeRegion.start && row.end==activeRegion.end){
    //点击的是当前激活的分段
    console.log('点击的是当前激活的分段')
  }else{
    //通过row.start和row.end查找到对应分段
    // 类似分段的click事件函数：
    // 1.激活分段区域（含高亮显示）
    let region = activateRegion(row)
    // // 2.跳转分段起点
    // ws.skip(region.start)
    // // 3.播放分段音频
    // region.play()
  }
}


//=========================预处理TextGrid的3个函数=========================

// 第一个函数：将TextGrid格式文本转为JSON对象
function parseTextGrid(text) {
    const lines = text.split('\n');
    const result = {
        "File type": "",
        "Object class": "",
        "xmin": 0,
        "xmax": 0,
        "item": []
    };

    let currentItem = null;
    let currentInterval = null;

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        if (line.trim() === '') continue;
        
        // 解析文件类型
        if (line.startsWith('File type =')) {
            result["File type"] = line.split('=')[1].trim().replace(/"/g, '');
        }
        // 解析对象类
        else if (line.startsWith('Object class =')) {
            result["Object class"] = line.split('=')[1].trim().replace(/"/g, '');
        }
        // 解析根级别的xmin和xmax
        else if (line.startsWith('xmin =') && !currentItem) {
            result.xmin = parseFloat(line.split('=')[1].trim());
        }
        else if (line.startsWith('xmax =') && !currentItem) {
            result.xmax = parseFloat(line.split('=')[1].trim());
          if(result.xmax != duration) {
            console.warn(`TextGrid文件的xmax值与音频时长不匹配，已自动调整为音频总长度（${result.xmax} → ${duration}）`)
            result.xmax = duration
          }
        }
        // 开始新的item（只匹配带数字索引的item行）
        else if (line.match(/^\s*item\s*\[\d+\]\s*:/)) {
            currentItem = {
                class: "",
                name: "",
                xmin: 0,
                xmax: 0,
                intervals: []
            };
            result.item.push(currentItem);
        }
        // 解析item的属性
        else if (line.startsWith('        class =') && currentItem) {
            currentItem.class = line.split('=')[1].trim().replace(/"/g, '');
            }
        else if (line.startsWith('        name =') && currentItem) {
            currentItem.name = line.split('=')[1].trim().replace(/"/g, '');
            }
        else if (line.startsWith('        xmin =') && currentItem && currentItem.intervals.length === 0) {
            // 只有在没有intervals时才解析item级别的xmin
            currentItem.xmin = parseFloat(line.split('=')[1].trim());
        }
        else if (line.startsWith('        xmax =') && currentItem && currentItem.intervals.length === 0) {
            // 只有在没有intervals时才解析item级别的xmax
            currentItem.xmax = parseFloat(line.split('=')[1].trim());
            if(currentItem.xmax != duration) {
              // proxy.$message.error('警告：TextGrid文件的item级别的xmax值与音频时长不匹配，已自动调整为音频总长度。')
              currentItem.xmax = duration
            }
        }
            // 开始新的interval
        else if (line.match(/^\s*intervals\s*\[\d+\]\s*/)) {
            if (currentItem) {
            currentInterval = {
                xmin: 0,
                xmax: 0,
                    text: ""
            };
                currentItem.intervals.push(currentInterval);
            }
        }
        // 解析interval的属性
        else if (line.startsWith('            xmin =') && currentInterval) {
            currentInterval.xmin = parseFloat(line.split('=')[1].trim());
        }
        else if (line.startsWith('            xmax =') && currentInterval) {
            currentInterval.xmax = parseFloat(line.split('=')[1].trim());
        }
        else if (line.startsWith('            text =') && currentInterval) {
            currentInterval.text = line.split('=')[1].trim().replace(/"/g, '');
        }
    }
    //确保intervals的最后一个interval的xmax要和item.xmax对齐，如果不是则添加一个新的空白interval填补这个间隙
    for (let i = 0; i < result.item.length; i++) {
        const item = result.item[i];
        if (item.intervals.length > 0) {
            const lastInterval = item.intervals[item.intervals.length - 1];
            if (lastInterval.xmax < item.xmax) {
                // 填补间隙的空白interval
                item.intervals.push({
                    xmin: lastInterval.xmax,
                    xmax: item.xmax,
                    text: ""
                });
            }
        } else {
            // 没有intervals时，直接设置xmin和xmax为item级别的值
            item.intervals.push({
                xmin: item.xmin,
                xmax: item.xmax,
                text: ""
            });
        }
    }
    return result;
}

// 第二个函数：检查并修复intervals的连续性
function fixIntervals(jsonObj) {
    jsonObj.item.forEach(item => {
        if (item.intervals && item.intervals.length > 0) {
            const fixedIntervals = [];
            let lastXmax = item.xmin;
            
            // 按xmin排序，确保顺序正确
            const sortedIntervals = [...item.intervals].sort((a, b) => a.xmin - b.xmin);
            
            for (let i = 0; i < sortedIntervals.length; i++) {
                const current = sortedIntervals[i];
                
                // 检查是否有间隙（使用小误差容忍度）
                if (current.xmin > lastXmax + 0.001) {
                    // 插入空白interval填补间隙
                    fixedIntervals.push({
                        xmin: lastXmax,
                        xmax: current.xmin,
                        text: ""
                    });
                }
                
                // 添加当前interval
                fixedIntervals.push(current);
                lastXmax = current.xmax;
            }
            
            // 检查最后是否还有间隙到xmax
            if (lastXmax < item.xmax - 0.001) {
                fixedIntervals.push({
                    xmin: lastXmax,
                    xmax: item.xmax,
                    text: ""
                });
            }
            
            item.intervals = fixedIntervals;
        }
    });
    
    return jsonObj;
}

// 第三个函数：将JSON对象转回TextGrid格式文本
function stringifyTextGrid(jsonObj) {
    let result = [];
    
    // 头部信息
    result.push(`File type = "${jsonObj["File type"]}"`);
    result.push(`Object class = "${jsonObj["Object class"]}"`);
    result.push('');
    result.push(`xmin = ${jsonObj.xmin.toFixed(3)}`);
    result.push(`xmax = ${jsonObj.xmax.toFixed(3)}`);
    result.push('tiers? <exists>');
    result.push(`size = ${jsonObj.item.length}`);
    result.push('item []:');
    
    // 处理每个item
    jsonObj.item.forEach((item, itemIndex) => {
        result.push(`    item [${itemIndex + 1}]:`);
        result.push(`        class = "${item.class}"`);
        result.push(`        name = "${item.name}"`);
        result.push(`        xmin = ${item.xmin.toFixed(3)}`);
        result.push(`        xmax = ${item.xmax.toFixed(3)}`);
        result.push(`        intervals: size = ${item.intervals.length}`);
        
        // 处理每个interval
        item.intervals.forEach((interval, intervalIndex) => {
            result.push(`        intervals [${intervalIndex + 1}]:`);
            result.push(`            xmin = ${interval.xmin.toFixed(3)}`);
            result.push(`            xmax = ${interval.xmax.toFixed(3)}`);
            result.push(`            text = "${interval.text}"`);
        });
    });
    
    return result.join('\n');
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

// 音频播放状态（true为正在播放，false为暂停）
let isPlaying = ref(false)
// 控制音频播放(true为继续播放，false为暂停播放)
let playStatus = ref(true)

let playMode = 'single_only' //播放模式（单播single_only，单循环single_loop，顺序播放list_order）

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
let currentTime = ref('0.000')
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

// 上次单击音频波形图的时间
let lastClickTime = 0

const historyTimes = ref([]) //存放标注历史记录的数组
let historyIndex = -1 //当前回退的标注历史记录的下标值，-1代表不回退 
// watch(times, (newVal, oldVal) => {
//   if(historyIndex > -1){//正在回退历史记录
//     //回退时的更改不放到历史记录中
//     console.log('正在回退版本，更改不放入历史记录中')
//   }else{//不是退回历史的更改
//     //更改放到历史记录中
//     historyTimes.value.push({
//         timesData: newVal,
//         currentRegion: activeRegion,
//         time: formatDateTime(new Date(), 'yyyy-MM-dd HH:mm:ss')
//     })
//     console.log('新增历史记录', JSON.parse(JSON.stringify(historyTimes)))
//   }
// }, { immediate: true, deep: true })

//新增操作历史记录
function addHistoryTimes(actionName) {
  //判断当前times历史最后一次数据timesData是否相同，如果相同则不新增历史记录
  if(historyTimes.value.length>0 && JSON.stringify(times) === historyTimes.value[historyTimes.value.length-1].timesData){
    console.log('当前操作与上一次相同，不新增历史记录')
    return
  }
  historyTimes.value.push({
    actionName: actionName,
    timesData: JSON.stringify(times),
    activeRegion: JSON.stringify(activeRegion),
    actionTime: formatDateTime(new Date(), 'yyyy-MM-dd HH:mm:ss')
  })
  console.log('新增历史记录', JSON.parse(JSON.stringify(historyTimes.value)))
  //自动保存修改
  if(historyTimes.value.length>1){
    //saveTask(true)
  }  
}

//退回上一次操作
function undo(){
  if(historyTimes.value.length<=1){
    // proxy.$message.error('没有历史操作可以撤销了')
    return
  };

  // proxy.$modal.confirm('是否放弃更改并回退到上一次操作？').then(function () {
    
    //将historyTimes里倒数第二次操作的数据取出
    let ht = historyTimes.value[historyTimes.value.length-2]
    if(!ht)return;
    // console.log('退回历史操作', JSON.stringify(ht))
    //替换历史分段数据
    times.splice(0, times.length)
    times.push(...JSON.parse(ht.timesData))
    //清除所有区域
    regions.clearRegions()
    setTimeout(()=>{
      //重新创建分段线
      times.forEach((e, index) => {
        regionCreationSource = 'code'
        regions.addRegion({
          start: e.start,
          content: `${index+1}`,
          color: '#666',
          drag: false,
          resize: false
        })
      })
    },100)
    setTimeout(()=>{
      activateRegion(JSON.parse(ht.activeRegion))
    },200)
    //丢弃下一步操作的历史记录
    historyTimes.value.splice(historyTimes.value.length-1, 1)
    console.log('退回历史记录后', JSON.parse(JSON.stringify(historyTimes.value)))

  // });
  
}

function deepEqual(obj1, obj2) {
  // 严格相等检查（处理基本类型和相同引用）
  if (obj1 === obj2) {
    return true;
  }
  
  // null 和 undefined 检查
  if (obj1 == null || obj2 == null) {
    return obj1 === obj2;
  }
  
  // 类型检查
  if (typeof obj1 !== typeof obj2) {
    return false;
  }
  
  // 处理基本类型
  if (typeof obj1 !== 'object') {
    return obj1 === obj2;
  }
  
  // 处理数组
  if (Array.isArray(obj1) !== Array.isArray(obj2)) {
    return false;
  }
  
  // 获取对象的键
  const keys1 = Object.keys(obj1);
  const keys2 = Object.keys(obj2);
  
  // 键的数量比较
  if (keys1.length !== keys2.length) {
    return false;
  }
  
  // 递归比较每个属性
  for (let key of keys1) {
    if (!keys2.includes(key)) {
      return false;
    }
    if (!deepEqual(obj1[key], obj2[key])) {
      return false;
    }
  }
  
  return true;
}

//获取常用时间
function formatDateTime(date, format) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return format
    .replace('yyyy', year)
    .replace('MM', month)
    .replace('dd', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds);
}

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
// 区域创建来源标记（code：程序创建，其它为手动鼠标拖拽创建）
let regionCreationSource = null; // 可能的取值: null, 'code', 未来可扩展 'user-drag'

// 初始化时间轴插件
const timeline = TimelinePlugin.create({
  formatTimeCallback: (time) => {
    return `${time.toFixed(0)}`
  },
})
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

  //添加分段线
  times.forEach(e => {
    regionCreationSource = 'code'
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
let tableHeight = ref(400)

// 添加键盘事件监听器
onMounted(() => {
  window.addEventListener('keydown', handleSpace);
  // 启动定时器
  startTimer();
})

onUpdated(() => {
  nextTick(() => {
    calculateTableHeight(); // 初始化表格高度
    window.addEventListener('resize', calculateTableHeight);
  });
})

//计算表格高度
function calculateTableHeight() {
  const windowHeight = window.innerHeight;
  const tableTop = tableRef.value.$el.getBoundingClientRect().top;
  tableHeight.value = Math.abs(windowHeight - tableTop - 20); // 20是底部留白
  console.log('tableHeight-->', tableHeight.value)
}

// 移除键盘事件监听器
onUnmounted(() => {
  window.removeEventListener('keydown', handleSpace);
  // 清除定时器
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
})

let timer = null
// 启动定时器
function startTimer() {
  // 先清除已存在的定时器
  if (timer) {
    clearInterval(timer);
  }
  // 设置新的定时器
  timer = setInterval(() => {
    console.log("执行定时任务");
    getTask(taskId).then(res=>{
      console.log('任务详情：', res)
    })
  }, 10 * 60 * 1000); //间隔10分钟
}

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
  caret-color: red;
  caret-shape: block;

  /*.cell .el-textarea__inner{
    font-size: 18px;
  }*/
}

/* 覆盖 el-table 的行 hover 样式 */
::v-deep .el-table__body tr:hover > td {
  background-color: transparent !important;
}

::v-deep .el-drawer[aria-label="历史记录"] header {
  display: none !important;
}
::v-deep .el-drawer[aria-label="历史记录"] .el-drawer__body {
  padding: 0px !important;
}
::v-deep .el-textarea__inner[placeholder="请输入标注内容"] {
  padding-right: 40px;
}


/* 专门针对代码内容和行号设置字体大小 */
.custom-diff-container :deep(.blob-num), /* 行号 */
.custom-diff-container :deep(.blob-code-inner) { /* 代码内容 */
  font-size: 20px !important; /* 使用 !important 确保覆盖默认样式 */
  line-height: 1.2; /* 可以同时调整行高以获得更好视觉效果 */
  padding: 5px 0; /* 适当增加内边距 */
}
</style>