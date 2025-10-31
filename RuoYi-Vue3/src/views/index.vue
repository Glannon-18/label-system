<template>
  <div class="app-container home">
    <el-row :gutter="20">
      <el-col :sm="24" :lg="24" style="padding-left: 20px">
        <h2>语音标注系统</h2>
        <p>
          语音标注系统是一种专门用于对语音数据进行结构化处理和语义标记的技术平台，广泛应用于语音识别、自然语言处理、智能客服、语音合成及人工智能训练等多个领域。其核心功能是将原始音频信号转化为带有时间戳、文本内容、发音特征、语义标签或其他元信息的结构化数据，从而为后续的模型训练与算法优化提供高质量的标注数据。 一个典型的语音标注系统通常包含音频播放控制、波形可视化、文本转录、时间对齐、标签分类、多人协作与质量审核等模块。标注人员可以在系统中逐句听取语音片段，准确转录说话内容，并根据任务需求添加诸如说话人身份、情感倾向、语速快慢、口音类型、噪声等级甚至语义意图等多维度标签。部分高级系统还支持自动预标注功能，利用已有语音识别模型生成初步文本，再由人工校对修正，大幅提升标注效率。 语音标注的质量直接影响语音识别（ASR）和语音合成（TTS）系统的性能。例如，在训练智能语音助手时，若标注数据中存在大量错字、时间错位或标签混乱，将导致模型学习到错误的映射关系，从而降低实际应用中的准确率和用户体验。因此，专业的语音标注系统不仅强调操作的便捷性与协同性，还注重数据的一致性、可追溯性和安全性。 随着人工智能对高质量数据依赖程度的不断提升，语音标注系统正朝着智能化、自动化与标准化方向发展。未来，结合主动学习、半监督学习等技术，语音标注将更高效、更精准，为语音智能技术的落地提供坚实的数据基石。
        </p>
        <p>
          <b>当前版本:</b> <span>v1.0.0</span>
        </p>
      </el-col>
    </el-row>
    <el-divider />
  </div>
</template>

<script setup name="Index">
const version = ref('3.9.0')

function goTarget(url) {
  window.open(url, '__blank')
}
</script>

<style scoped lang="scss">
.home {
  blockquote {
    padding: 10px 20px;
    margin: 0 0 20px;
    font-size: 17.5px;
    border-left: 5px solid #eee;
  }
  hr {
    margin-top: 20px;
    margin-bottom: 20px;
    border: 0;
    border-top: 1px solid #eee;
  }
  .col-item {
    margin-bottom: 20px;
  }

  ul {
    padding: 0;
    margin: 0;
  }

  font-family: "open sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 13px;
  color: #676a6c;
  overflow-x: hidden;

  ul {
    list-style-type: none;
  }

  h4 {
    margin-top: 0px;
  }

  h2 {
    margin-top: 10px;
    font-size: 26px;
    font-weight: 100;
  }

  p {
    margin-top: 10px;

    b {
      font-weight: 700;
    }
  }

  .update-log {
    ol {
      display: block;
      list-style-type: decimal;
      margin-block-start: 1em;
      margin-block-end: 1em;
      margin-inline-start: 0;
      margin-inline-end: 0;
      padding-inline-start: 40px;
    }
  }
}
</style>

