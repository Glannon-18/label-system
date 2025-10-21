<template>
    <div id="page" style="width: 627px;height: 310px;">
        <div class="main_content" style="padding: 0px;">
            <button type="button" id="copy">Copy</button>
            <button type="button" id="paste">Paste</button>
            <button type="button" id="clearAll">Clear</button>
            <button type="button" title="Shrink letters" id="shrink">-</button>
            <button type="button" title="Enlarge letters" id="enlarge">+</button>
          <!--  <p><textarea id="editor" name="editor" rows="" cols="75" style="font-size: 24px; direction: ltr;"></textarea>
            </p>-->
            <!-- 加入候选词显示区域 -->
            <div id="suggestions" style="margin-top:5px; font-size:20px; color:#057cb5;"></div>

            <div id="keyboard">
                <div id="branah-keyboard">
                    <div id="branah-keyboard-alpha">
                        <button id="branah-k0" class="branah-key">
                            <div class="branah-label-reference">`</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;«</div>
                        </button>
                        <button id="branah-k1" class="branah-key">
                            <div class="branah-label-reference">1</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;១</div>
                        </button>
                        <button id="branah-k2" class="branah-key">
                            <div class="branah-label-reference">2</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;២</div>
                        </button>
                        <button id="branah-k3" class="branah-key">
                            <div class="branah-label-reference">3</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៣</div>
                        </button>
                        <button id="branah-k4" class="branah-key">
                            <div class="branah-label-reference">4</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៤</div>
                        </button>
                        <button id="branah-k5" class="branah-key">
                            <div class="branah-label-reference">5</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៥</div>
                        </button>
                        <button id="branah-k6" class="branah-key">
                            <div class="branah-label-reference">6</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៦</div>
                        </button>
                        <button id="branah-k7" class="branah-key">
                            <div class="branah-label-reference">7</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៧</div>
                        </button>
                        <button id="branah-k8" class="branah-key">
                            <div class="branah-label-reference">8</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៨</div>
                        </button>
                        <button id="branah-k9" class="branah-key">
                            <div class="branah-label-reference">9</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៩</div>
                        </button>
                        <button id="branah-k10" class="branah-key">
                            <div class="branah-label-reference">0</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;០</div>
                        </button>
                        <button id="branah-k11" class="branah-key">
                            <div class="branah-label-reference">-</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;គ</div>
                        </button>
                        <button id="branah-k12" class="branah-key">
                            <div class="branah-label-reference">=</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ធ</div>
                        </button>
                        <button id="branah-backspace"><span>Backspace</span></button>
                        <div class="branah-clear"></div>
                        <button id="branah-tab"><span>Tab</span></button>
                        <button id="branah-k13" class="branah-key">
                            <div class="branah-label-reference">q</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឈ</div>
                        </button>
                        <button id="branah-k14" class="branah-key">
                            <div class="branah-label-reference">w</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឺ</div>
                        </button>
                        <button id="branah-k15" class="branah-key">
                            <div class="branah-label-reference">e</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ែ</div>
                        </button>
                        <button id="branah-k16" class="branah-key">
                            <div class="branah-label-reference">r</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឬ</div>
                        </button>
                        <button id="branah-k17" class="branah-key">
                            <div class="branah-label-reference">t</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ទ</div>
                        </button>
                        <button id="branah-k18" class="branah-key">
                            <div class="branah-label-reference">y</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ួ</div>
                        </button>
                        <button id="branah-k19" class="branah-key">
                            <div class="branah-label-reference">u</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ូ</div>
                        </button>
                        <button id="branah-k20" class="branah-key">
                            <div class="branah-label-reference">i</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ី</div>
                        </button>
                        <button id="branah-k21" class="branah-key">
                            <div class="branah-label-reference">o</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ៅ</div>
                        </button>
                        <button id="branah-k22" class="branah-key">
                            <div class="branah-label-reference">p</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ភ</div>
                        </button>
                        <button id="branah-k23" class="branah-key">
                            <div class="branah-label-reference">[</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ៀ</div>
                        </button>
                        <button id="branah-k24" class="branah-key">
                            <div class="branah-label-reference">]</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឨ</div>
                        </button>
                        <button id="branah-k25">
                            <div class="branah-label-reference">\</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឮ</div>
                        </button>
                        <div class="branah-clear"></div>
                        <button id="branah-caps-lock" class="branah-recessed"><span>Caps Lock</span></button>
                        <button id="branah-k26" class="branah-key">
                            <div class="branah-label-reference">a</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ាំ</div>
                        </button>
                        <button id="branah-k27" class="branah-key">
                            <div class="branah-label-reference">s</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ៃ</div>
                        </button>
                        <button id="branah-k28" class="branah-key">
                            <div class="branah-label-reference">d</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឌ</div>
                        </button>
                        <button id="branah-k29" class="branah-key">
                            <div class="branah-label-reference">f</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ធ</div>
                        </button>
                        <button id="branah-k30" class="branah-key">
                            <div class="branah-label-reference">g</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឣ</div>
                        </button>
                        <button id="branah-k31" class="branah-key">
                            <div class="branah-label-reference">h</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ះ</div>
                        </button>
                        <button id="branah-k32" class="branah-key">
                            <div class="branah-label-reference">j</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ញ</div>
                        </button>
                        <button id="branah-k33" class="branah-key">
                            <div class="branah-label-reference">k</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;គ</div>
                        </button>
                        <button id="branah-k34" class="branah-key">
                            <div class="branah-label-reference">l</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឡ</div>
                        </button>
                        <button id="branah-k35" class="branah-key">
                            <div class="branah-label-reference">;</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ើ</div>
                        </button>
                        <button id="branah-k36" class="branah-key">
                            <div class="branah-label-reference">'</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;់</div>
                        </button>
                        <button id="branah-enter" class="branah-enter"><span>Enter</span></button>
                        <div class="branah-clear"></div>
                        <button id="branah-left-shift" class=""><span>Shift</span></button>
                        <button id="branah-k47" class="branah-key">
                            <div class="branah-label-reference">\</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;\</div>
                        </button>
                        <button id="branah-k37" class="branah-key">
                            <div class="branah-label-reference">z</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឍ</div>
                        </button>
                        <button id="branah-k38" class="branah-key">
                            <div class="branah-label-reference">x</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ឃ</div>
                        </button>
                        <button id="branah-k39" class="branah-key">
                            <div class="branah-label-reference">c</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ជ</div>
                        </button>
                        <button id="branah-k40" class="branah-key">
                            <div class="branah-label-reference">v</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;េះ</div>
                        </button>
                        <button id="branah-k41" class="branah-key">
                            <div class="branah-label-reference">b</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ព</div>
                        </button>
                        <button id="branah-k42" class="branah-key">
                            <div class="branah-label-reference">n</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ណ</div>
                        </button>
                        <button id="branah-k43" class="branah-key">
                            <div class="branah-label-reference">m</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ំ</div>
                        </button>
                        <button id="branah-k44" class="branah-key">
                            <div class="branah-label-reference">,</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;ំុ</div>
                        </button>
                        <button id="branah-k45" class="branah-key">
                            <div class="branah-label-reference">.</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;។</div>
                        </button>
                        <button id="branah-k46" class="branah-key">
                            <div class="branah-label-reference">/</div>
                            <div class="branah-label-natural" style="font-size:24px;">&nbsp;៊</div>
                        </button>
                        <button id="branah-right-shift" class=""><span>Shift</span></button>
                        <div class="branah-clear"></div>
                        <button id="branah-left-ctrl" class=""><span>Ctrl</span></button>
                        <button id="branah"><span>Emoji</span></button>
                        <button id="branah-left-alt" class=""><span>Alt</span></button>
                        <button id="branah-space"><span>Space</span></button>
                        <button id="branah-right-alt" class=""><span>AltGr</span></button>
                        <button id="branah-escape" title="Turn on/off keyboard input conversion" class=""><span>Esc</span>
                        </button>
                        <button id="branah-right-ctrl" class=""><span>Ctrl</span></button>
                        <div class="branah-clear"></div>
                    </div>
                    <div id="branah-keyboard-emoji" style="display:none"></div>
                </div>
            </div>


            <p>
                <span class="button">Esc</span>键可切换美式键盘和Khmer键盘。
                <span class="button">Shift</span>键和<span
                    class="button">AltGr</span>键显示出隐藏的 Khmer 字母。</p>


        </div>

    </div>
</template>



<script setup name="keyboard_km" lang="ts">
import {onMounted} from "vue";

onMounted(() => {
    console.log('Component mounted!')

})


</script>



<style >
    * {
        margin: 0;
        padding: 0
    }

    html {
        overflow-y: scroll
    }

    html, body {
        height: 100%
    }

    body {
        font-family: Verdana, Helvetica, Arial, Sans-Serif;
        font-size: 87.5%;
        line-height: 24px;
        color: #464646
    }

    a:link, a:visited, a:active {
        color: #005a9c;
        text-decoration: none
    }

    a:hover {
        text-decoration: underline
    }

    p {
        margin: .75em 0
    }

    h1 {
        font-size: 1.2857em;
        margin: .75em 0;
        color: #057cb5
    }

    h3 {
        font-size: 1em;
        margin: .75em 0;
        color: #057cb5
    }

    h4 {
        text-align: left
    }

    img {
        border: 0
    }

    table {
        border-spacing: 0
    }

    td {
        vertical-align: top
    }

    rb {
        color: #057cb5;
        font-size: 100%;
        margin-left: .5em
    }

    rt {
        color: #e0115f;
        font-size: 100%
    }

    .clear {
        clear: both
    }

    .middle {
        vertical-align: middle
    }

    .top {
        vertical-align: top
    }

    #footer {
        margin-top: 4em;
        padding-bottom: 2em;
        text-align: center;
        border-top: 1px solid #ccc;
        font-size: .75em
    }

    ul.menu {
        list-style: none;
        padding-top: 1em
    }

    li.menuitem {
        display: inline;
        padding: 0;
        margin: 0 0 0 1em
    }

    li.activemenuitem a {
        border-bottom: 1px solid #3C0
    }

    #action {
        text-align: left
    }

    #action button {
        padding: 0 5px;
        vertical-align: middle;
        line-height: 18px
    }

    #shrink, #enlarge {
        width: 24px;
        margin: 0 2px
    }

    a.soft_button {
        border: 1px solid lightblue;
        margin-left: 3px;
        padding: 0 2px;
        white-space: nowrap
    }

    .button {
        display: inline-block;
        padding: 0 5px;
        background-color: #f0f0f0;
        border: 2px solid #ccc;
        border-radius: 5px
    }

    input[type=number], input[type=text], textarea {
        font-family: Verdana, Helvetica, Arial, Sans-Serif;
        color: #464646;
        padding: 5px 8px;
        vertical-align: middle;
        border: 1px solid #ccc;
        border-radius: 4px;
        -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
        box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
        -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s
    }

    input[type=checkbox], input[type=radio] {
        transform: scale(1.4);
        vertical-align: -2px
    }

    .nowrap {
        white-space: nowrap
    }

    #branah-keyboard {
        line-height: 20px;
        font-size: 1em
    }

    #branah-keyboard button {
        float: left;
        display: block;
        margin: 1px;
        height: 3em;
        text-align: center;
        color: gray
    }

    #branah-keyboard .branah-label-natural {
        color: #e0115f
    }

    #branah-keyboard .branah-label-shift {
        color: #057cb5
    }

    #branah-keyboard .branah-label-natural, #branah-keyboard .branah-label-shift {
        margin-top: -5px;
        line-height: 20px;
        text-align: center;
        cursor: default
    }

    #branah-keyboard .branah-label-reference {
        color: gray;
        font-size: .9em;
        line-height: 12px;
        text-align: left;
        cursor: default
    }

    #branah-k29 .branah-label-reference, #branah-k32 .branah-label-reference {
        color: #000
    }

    #branah-keyboard .branah-recessed span {
        color: #3C0
    }

    #branah-keyboard .branah-recessed-hover span {
        color: #ffd800
    }

    #branah-keyboard .branah-clear {
        clear: both
    }

    @media only screen and (max-width: 640px) {
        #page {
            margin: 0 2px
        }

        #header {
            margin-bottom: 1em
        }

        #logo {
            display: inline-block;
            width: 100%;
            height: 46px;
            line-height: 46px;
            background-repeat: repeat-x;
            background-image: url(/images/branahmobile.jpg)
        }

        div.side_content {
            margin-top: 0
        }

        a.soft_button {
            padding: 0 2px 0 0;
            margin-left: 0
        }

        ul.list {
            list-style: none
        }

        ul.list li {
            text-align: center;
            line-height: 2em;
            margin: 1em
        }

        textarea {
            width: 85%
        }

        #action {
            line-height: 2.25em
        }

        #archived {
            font-size: .85em;
            margin: .5em 0 1em 0
        }

        #branah-keyboard button {
            width: 88px
        }

        #branah-keyboard .branah-key {
            width: 43px
        }

        .gsc-search-box, .gsc-control-cse {
            display: none
        }
    }

    @media only screen and (min-width: 641px) and (max-width: 840px) {
        p {
            text-align: justify
        }

        textarea {
            width: 610px
        }

        #page {
            width: 630px;
            margin: 0 auto
        }

        #header {
            margin-bottom: 1em
        }

        #logo {
            display: inline-block;
            width: 630px;
            height: 108px;
            line-height: 108px;
            background-image: url(/images/branahtab.jpg)
        }

        div.side_content {
            margin-top: 0
        }

        ul.list {
            list-style: none;
            display: inline-block;
            width: 120px
        }

        ul.list li {
            line-height: 2em;
            margin: 0
        }

        /*#editor {*/
        /*    width: 600px*/
        /*}*/

        #keyboard {
            width: 630px
        }

        #selectAll, #saveAsTextFile, #postToFacebook, #shrink, #enlarge {
            margin-right: 2px;
            padding: 0 5px;
            vertical-align: middle;
            line-height: 18px
        }
    }

    @media only screen and (min-width: 841px) {
        p {
            text-align: justify
        }

        textarea {
            width: 610px
        }

        #page {
            width: 840px;
            margin: 0 auto
        }

        #header {
            margin-bottom: 1em
        }

        #logo {
            display: inline-block;
            width: 840px;
            height: 144px;
            line-height: 144px;
            background-image: url(/images/branah.jpg)
        }

        div.side_content {
            position: absolute;
            top: 0;
            right: 5px;
            width: 160px;
            _margin-right: -205px
        }

        div.main_content {
            position: relative;
            min-height: 740px;
            padding-left: 5px;
            padding-right: 205px
        }

        div.content {
            padding: 0 5px
        }

        ul.list {
            list-style: none;
            display: inline-block;
            width: 160px
        }

        /*#editor {*/
        /*    width: 607px;*/
        /*    height: 96px*/
        /*}*/
    }

    @media only screen and (min-width: 641px) {
        #branah-keyboard {
            width: 630px
        }

        #branah-keyboard button {
            line-height: 2.75em
        }

        #branah-keyboard .branah-key {
            width: 40px
        }

        #branah-backspace {
            width: 78px
        }

        #branah-tab {
            width: 62px
        }

        #branah-k25 {
            width: 56px
        }

        #branah-caps-lock {
            width: 76px
        }

        #branah-enter {
            width: 84px
        }

        #branah-left-shift {
            width: 46px
        }

        #branah-right-shift {
            width: 114px
        }

        #branah-space {
            width: 246px;
            text-align: center
        }

        #branah-right-ctrl, #branah-right-alt, #branah-escape {
            width: 62px
        }

        #branah-left-ctrl, #branah-left-alt, #branah {
            width: 60px
        }
    }
</style>