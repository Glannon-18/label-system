(function () {
    var a = {};
    a.util = {
        mobile: /Android|webOS|iPhone|iPad|iPod|IEMobile|Opera Mini/i.test(navigator.userAgent),
        opera: ((!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(" OPR/") >= 0),
        mozilla: (typeof InstallTrigger !== "undefined"),
        windowWidth: function () {
            var i = window.document.documentElement.clientWidth, e = window.document.body;
            return window.document.compatMode === "CSS1Compat" && i || e && e.clientWidth || i
        },
        code: function (i) {
            if (!i) {
                var i = window.event
            }
            if (i.code != undefined && i.key != undefined) {
                return i.code
            }
            return "Unidentified"
        },
        keyCode: function (t) {
            if (!t) {
                var t = window.event
            }
            var i = t.keyCode;
            if (this.mozilla) {
                switch (i) {
                    case 59:
                        i = 186;
                        break;
                    case 107:
                        i = 187;
                        break;
                    case 109:
                        i = 189;
                        break;
                    case 61:
                        i = 187;
                        break;
                    case 173:
                        i = 189;
                        break
                }
            }
            if (this.opera) {
                switch (i) {
                    case 59:
                        i = 186;
                        break;
                    case 61:
                        i = 187;
                        break;
                    case 109:
                        i = 189;
                        break
                }
            }
            if (i == 18 && t.location && t.location == 2) {
                i = 255
            }
            return i
        },
        preventDefault: function (i) {
            if (!i) {
                var i = window.event
            }
            i.preventDefault ? i.preventDefault() : (i.returnValue = false)
        },
        srcId: function (i, t, v) {
            if (!i) {
                var i = window.event
            }
            var u;
            if (i.target) {
                u = i.target
            } else {
                if (i.srcElement) {
                    u = i.srcElement
                }
            }
            if (u.nodeType == 3) {
                u = target.parentNode
            }
            while (u.tagName.toLowerCase() != v) {
                u = u.parentNode;
                if (u == t || u.tagName.toLowerCase() == "body") {
                    return null
                }
            }
            return u.id
        },
        insertAtCaret: function (i, w) {
            var v = this.getSelectionStart(i);
            var t = this.getSelectionEnd(i);
            var u = i.value.length;
            i.value = i.value.substring(0, v) + w + i.value.substring(t, u);
            this.setCaretPosition(i, v + w.length, 0)
        },
        deleteAtCaret: function (u, t, i) {
            var x = this.getSelectionStart(u);
            var v = this.getSelectionEnd(u);
            var w = u.value.length;
            if (t > x) {
                t = x
            }
            if (v + i > w) {
                i = w - v
            }
            var y = u.value.substring(x - t, v + i);
            u.value = u.value.substring(0, x - t) + u.value.substring(v + i);
            this.setCaretPosition(u, x - t, 0);
            return y
        },
        getSelectionStart: function (i) {
            i.focus();
            if (i.selectionStart !== undefined) {
                return i.selectionStart
            } else {
                if (document.selection) {
                    var t = document.selection.createRange();
                    if (t == null) {
                        return 0
                    }
                    var v = i.createTextRange();
                    var u = v.duplicate();
                    v.moveToBookmark(t.getBookmark());
                    u.setEndPoint("EndToStart", v);
                    return u.text.length
                }
            }
            return 0
        },
        getSelectionEnd: function (i) {
            i.focus();
            if (i.selectionEnd !== undefined) {
                return i.selectionEnd
            } else {
                if (document.selection) {
                    var t = document.selection.createRange();
                    if (t == null) {
                        return 0
                    }
                    var v = i.createTextRange();
                    var u = v.duplicate();
                    v.moveToBookmark(t.getBookmark());
                    u.setEndPoint("EndToStart", v);
                    return u.text.length + t.text.length
                }
            }
            return i.value.length
        },
        setCaretPosition: function (t, v, i) {
            var u = t.value.length;
            if (v > u) {
                v = u
            }
            if (v + i > u) {
                i = u - i
            }
            t.focus();
            if (t.setSelectionRange) {
                t.setSelectionRange(v, v + i)
            } else {
                if (t.createTextRange) {
                    var w = t.createTextRange();
                    w.collapse(true);
                    w.moveEnd("character", v + i);
                    w.moveStart("character", v);
                    w.select()
                }
            }
            t.focus()
        },
        fromCharCodeS: function () {
            var v = arguments.length;
            var w = "";
            var e, u, x;
            for (var t = 0; t < v; t++) {
                x = arguments[t];
                if (x < 1114112 && 65535 < x) {
                    e = Math.floor((x - 65536) / 1024) + 55296;
                    u = ((x - 65536) % 1024) + 56320;
                    w = w + String.fromCharCode(e, u)
                } else {
                    if (x < 65536) {
                        w = w + String.fromCharCode(x)
                    }
                }
            }
            return w
        }
    };
    a.layout = function () {
        this.keys = [];
        this.deadkeys = [];
        this.dir = "ltr";
        this.name = "US";
        this.lang = "en"
    };
    a.layout.prototype.loadDefault = function () {
        this.keys = [{i: "k0", c: "0", n: "`", s: "~"}, {i: "k1", c: "0", n: "1", s: "!"}, {
            i: "k2",
            c: "0",
            n: "2",
            s: "@"
        }, {i: "k3", c: "0", n: "3", s: "#"}, {i: "k4", c: "0", n: "4", s: "$"}, {
            i: "k5",
            c: "0",
            n: "5",
            s: "%"
        }, {i: "k6", c: "0", n: "6", s: "^"}, {i: "k7", c: "0", n: "7", s: "&"}, {
            i: "k8",
            c: "0",
            n: "8",
            s: "*"
        }, {i: "k9", c: "0", n: "9", s: "("}, {i: "k10", c: "0", n: "0", s: ")"}, {
            i: "k11",
            c: "0",
            n: "-",
            s: "_"
        }, {i: "k12", c: "0", n: "=", s: "+"}, {i: "k13", c: "1", n: "q", s: "Q"}, {
            i: "k14",
            c: "1",
            n: "w",
            s: "W"
        }, {i: "k15", c: "1", n: "e", s: "E"}, {i: "k16", c: "1", n: "r", s: "R"}, {
            i: "k17",
            c: "1",
            n: "t",
            s: "T"
        }, {i: "k18", c: "1", n: "y", s: "Y"}, {i: "k19", c: "1", n: "u", s: "U"}, {
            i: "k20",
            c: "1",
            n: "i",
            s: "I"
        }, {i: "k21", c: "1", n: "o", s: "O"}, {i: "k22", c: "1", n: "p", s: "P"}, {
            i: "k23",
            c: "0",
            n: "[",
            s: "{"
        }, {i: "k24", c: "0", n: "]", s: "}"}, {i: "k25", c: "0", n: "\\", s: "|"}, {
            i: "k26",
            c: "1",
            n: "a",
            s: "A"
        }, {i: "k27", c: "1", n: "s", s: "S"}, {i: "k28", c: "1", n: "d", s: "D"}, {
            i: "k29",
            c: "1",
            n: "f",
            s: "F"
        }, {i: "k30", c: "1", n: "g", s: "G"}, {i: "k31", c: "1", n: "h", s: "H"}, {
            i: "k32",
            c: "1",
            n: "j",
            s: "J"
        }, {i: "k33", c: "1", n: "k", s: "K"}, {i: "k34", c: "1", n: "l", s: "L"}, {
            i: "k35",
            c: "0",
            n: ";",
            s: ":"
        }, {i: "k36", c: "0", n: "'", s: '"'}, {i: "k37", c: "1", n: "z", s: "Z"}, {
            i: "k38",
            c: "1",
            n: "x",
            s: "X"
        }, {i: "k39", c: "1", n: "c", s: "C"}, {i: "k40", c: "1", n: "v", s: "V"}, {
            i: "k41",
            c: "1",
            n: "b",
            s: "B"
        }, {i: "k42", c: "1", n: "n", s: "N"}, {i: "k43", c: "1", n: "m", s: "M"}, {
            i: "k44",
            c: "0",
            n: ",",
            s: "<"
        }, {i: "k45", c: "0", n: ".", s: ">"}, {i: "k46", c: "0", n: "/", s: "?"}, {
            i: "k47",
            c: "0",
            n: "\\",
            s: "|"
        }];
        this.deadkeys = [];
        this.dir = "ltr";
        this.name = "US";
        this.lang = "en"
    };
    a.layout.prototype.load = function (e) {
        this.keys = e.keys;
        this.deadkeys = e.deadkeys;
        this.dir = e.dir;
        this.name = e.name;
        this.lang = e.lang ? e.lang : "en"
    };
    a.layout.parser = {
        keys: {
            "192": "Backquote",
            "49": "Digit1",
            "50": "Digit2",
            "51": "Digit3",
            "52": "Digit4",
            "53": "Digit5",
            "54": "Digit6",
            "55": "Digit7",
            "56": "Digit8",
            "57": "Digit9",
            "48": "Digit0",
            "189": "Minus",
            "187": "Equal",
            "81": "KeyQ",
            "87": "KeyW",
            "69": "KeyE",
            "82": "KeyR",
            "84": "KeyT",
            "89": "KeyY",
            "85": "KeyU",
            "73": "KeyI",
            "79": "KeyO",
            "80": "KeyP",
            "219": "BracketLeft",
            "221": "BracketRight",
            "220": "Backslash",
            "65": "KeyA",
            "83": "KeyS",
            "68": "KeyD",
            "70": "KeyF",
            "71": "KeyG",
            "72": "KeyH",
            "74": "KeyJ",
            "75": "KeyK",
            "76": "KeyL",
            "186": "Semicolon",
            "222": "Quote",
            "90": "KeyZ",
            "88": "KeyX",
            "67": "KeyC",
            "86": "KeyV",
            "66": "KeyB",
            "78": "KeyN",
            "77": "KeyM",
            "188": "Comma",
            "190": "Period",
            "191": "Slash",
            "17": "ControlLeft",
            "18": "AltLeft",
            "16": "ShiftLeft",
            "32": "Space",
            "27": "Escape",
            "20": "CapsLock",
            "13": "Enter",
            "255": "AltRight"
        },
        codes: {
            Backquote: 0,
            Digit1: 1,
            Digit2: 2,
            Digit3: 3,
            Digit4: 4,
            Digit5: 5,
            Digit6: 6,
            Digit7: 7,
            Digit8: 8,
            Digit9: 9,
            Digit0: 10,
            Minus: 11,
            Equal: 12,
            KeyQ: 13,
            KeyW: 14,
            KeyE: 15,
            KeyR: 16,
            KeyT: 17,
            KeyY: 18,
            KeyU: 19,
            KeyI: 20,
            KeyO: 21,
            KeyP: 22,
            BracketLeft: 23,
            BracketRight: 24,
            Backslash: 25,
            KeyA: 26,
            KeyS: 27,
            KeyD: 28,
            KeyF: 29,
            KeyG: 30,
            KeyH: 31,
            KeyJ: 32,
            KeyK: 33,
            KeyL: 34,
            Semicolon: 35,
            Quote: 36,
            KeyZ: 37,
            KeyX: 38,
            KeyC: 39,
            KeyV: 40,
            KeyB: 41,
            KeyN: 42,
            KeyM: 43,
            Comma: 44,
            Period: 45,
            Slash: 46,
            IntlBackslash: 47
        },
        getKeyLegend: function (u, t) {
            var v = u.length;
            for (var e = 0; e < v; e++) {
                if (u[e].i == t) {
                    return (u[e].n ? u[e].n : "")
                }
            }
            return 0
        },
        getKey: function (u, t) {
            var v = u.length;
            for (var e = 0; e < v; e++) {
                if (u[e].i == t) {
                    return u[e]
                }
            }
            return null
        },
        isDeadkey: function (e, v) {
            if (!e) {
                return false
            }
            var u = e.length;
            for (var t = 0; t < u; t++) {
                if (e[t].k == v) {
                    return true
                }
            }
            return false
        },
        getMappedValue: function (e, w, v) {
            if (!e) {
                return ""
            }
            var u = e.length;
            for (var t = 0; t < u; t++) {
                if (e[t].k == v && e[t].b == w) {
                    return e[t].c
                }
            }
            return ""
        },
        getState: function (v, e, w, t, u, i) {
            var x = "n";
            if (!e && !w && v) {
                x = "n"
            } else {
                if (!e && w && !v) {
                    x = "s"
                } else {
                    if (!e && w && v) {
                        x = "s"
                    } else {
                        if (e && !w && !v) {
                            x = "n"
                        } else {
                            if (e && !w && v) {
                                x = "t"
                            } else {
                                if (e && w && !v) {
                                    x = "s"
                                } else {
                                    if (e && w && v) {
                                        x = "f"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (t) {
                if (u == "1") {
                    if (x == "n") {
                        x = "s"
                    } else {
                        if (x == "s") {
                            x = "n"
                        }
                    }
                } else {
                    if (u == "SGCap") {
                        if (x == "n") {
                            x = "y"
                        } else {
                            if (x == "s") {
                                x = "z"
                            }
                        }
                    }
                }
            }
            if (i) {
                if (x == "n") {
                    x = "t"
                } else {
                    if (x == "s") {
                        x = "f"
                    }
                }
            }
            return x
        }
    };
    a.keyboard = function (e, v) {
        this.defaultLayout = new a.layout();
        this.defaultLayout.loadDefault();
        this.virtualLayout = new a.layout();
        this.virtualLayout.loadDefault();
        this.currentLayout = this.virtualLayout;
        this.shift = false;
        this.shiftOn = false;
        this.caps = false;
        this.capsOn = false;
        this.alt = false;
        this.altGr = false;
        this.altGrOn = false;
        this.ctrl = false;
        this.altCtrlOn = false;
        this.fontSize = 18;
        this.counter = 0;
        this.interval = 0;
        this.prev = "";
        this.emoji = false;
        this.emojiStartingCodePoint = 128512;
        this.emojiCurrentCodePoint = 128512;
        this.cancelkeypress = false;
        this.customOnBackspace = function (i) {
        };
        this.customOnEnter = function () {
        };
        this.customOnSpace = function () {
            return false
        };
        this.customOnKey = function (i) {
            return false
        };
        this.customOnEsc = function () {
        };
        this.customDrawKeyboard = function (i) {
            return i
        };
        this.textbox = document.getElementById(v);
        this.textbox.style.fontSize = "18px";
        if (a.util.mobile) {
            this.textbox.readOnly = true
        }
        var u = ['<div id="branah-keyboard">'];
        u.push('<div id="branah-keyboard-alpha">');
        if (a.util.windowWidth() < 640) {
            for (var t = 13; t < 23; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            for (var t = 26; t < 35; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            for (var t = 37; t < 44; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<button id="branah-left-shift"><span>Shift</span></button>');
            u.push('<button id="branah-caps-lock"><span>Caps</span></button>');
            u.push('<button id="branah-escape" title="Turn on/off keyboard input conversion"><span>Esc</span></button>');
            u.push('<button id="branah-space"><span>Space</span></button>');
            u.push('<button id="branah-emoji" class="branah-key">\ud83d\ude00</button>');
            u.push('<button id="branah-enter" class="branah-enter"><span>Enter</span></button>');
            u.push('<button id="branah-left-ctrl" style="display:none"><span>Ctrl</span></button>');
            u.push('<button id="branah-left-alt" style="display:none"><span>Alt</span></button>');
            u.push('<button id="branah-right-alt"><span>AltGr</span></button>');
            u.push('<button id="branah-right-ctrl" style="display:none"><span>Ctrl</span></button>');
            u.push('<button id="branah-right-shift" style="display:none"><span>Shift</span></button>');
            u.push('<button id="branah-backspace"><span>Back</span></button>');
            for (var t = 0; t < 13; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            for (var t = 23; t < 26; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            for (var t = 35; t < 37; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            for (var t = 44; t < 48; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<div class="branah-clear"></div>')
        } else {
            for (var t = 0; t < 13; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<button id="branah-backspace"><span>Backspace</span></button>');
            u.push('<div class="branah-clear"></div>');
            u.push('<button id="branah-tab"><span>Tab</span></button>');
            for (var t = 13; t < 25; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<button id="branah-k25"></button>');
            u.push('<div class="branah-clear"></div>');
            u.push('<button id="branah-caps-lock"><span>Caps Lock</span></button>');
            for (var t = 26; t < 37; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<button id="branah-enter" class="branah-enter"><span>Enter</span></button>');
            u.push('<div class="branah-clear"></div>');
            u.push('<button id="branah-left-shift"><span>Shift</span></button>');
            u.push('<button id="branah-k47" class="branah-key"></button>');
            for (var t = 37; t < 47; t++) {
                u.push('<button id="branah-k', t, '" class="branah-key"></button>')
            }
            u.push('<button id="branah-right-shift"><span>Shift</span></button>');
            u.push('<div class="branah-clear"></div>');
            u.push('<button id="branah-left-ctrl"><span>Ctrl</span></button>');
            u.push('<button id="branah"><span>Emoji</span></button>');
            u.push('<button id="branah-left-alt"><span>Alt</span></button>');
            u.push('<button id="branah-space"><span>Space</span></button>');
            u.push('<button id="branah-right-alt"><span>AltGr</span></button>');
            u.push('<button id="branah-escape" title="Turn on/off keyboard input conversion"><span>Esc</span></button>');
            u.push('<button id="branah-right-ctrl"><span>Ctrl</span></button>');
            u.push('<div class="branah-clear"></div>')
        }
        u.push("</div>");
        u.push('<div id="branah-keyboard-emoji" style="display:none">');
        u.push("</div>");
        u.push("</div>");
        document.getElementById(e).innerHTML = u.join("");
        this.wireEvents();
        this.drawKeyboard()
    };
    a.keyboard.prototype.loadDefaultLayout = function (e) {
        this.defaultLayout.load(e);
        this.drawKeyboard()
    };
    a.keyboard.prototype.loadVirtualLayout = function (e) {
        this.virtualLayout.load(e);
        this.drawKeyboard();
        this.textbox.style.direction = this.attr("dir")
    };
    a.keyboard.prototype.switchLayout = function () {
        this.currentLayout = (this.currentLayout === this.defaultLayout) ? this.virtualLayout : this.defaultLayout;
        this.reset();
        this.drawKeyboard();
        this.textbox.style.direction = this.attr("dir")
    };
    a.keyboard.prototype.getFontSize = function () {
        return this.fontSize
    };
    a.keyboard.prototype.setFontSize = function (e) {
        this.fontSize = e;
        this.textbox.style.fontSize = this.fontSize + "px"
    };
    a.keyboard.prototype.onEsc = function () {
        this.switchLayout();
        this.customOnEsc()
    };
    a.keyboard.prototype.onShift = function () {
        this.shift = !this.shift;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onAlt = function () {
        this.alt = !this.alt;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onAltGr = function () {
        this.altGr = !this.altGr;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onCtrl = function () {
        this.ctrl = !this.ctrl;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onCapsLock = function () {
        this.caps = !this.caps;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onBackspace = function () {
        if (this.prev != "") {
            this.prev = "";
            this.shift = false;
            this.drawKeyboard()
        } else {
            var i = a.util.deleteAtCaret(this.textbox, 1, 0);
            if (i.length > 0) {
                var e = i.charCodeAt(0);
                if (e < 57344 && 56319 < e) {
                    i = a.util.deleteAtCaret(this.textbox, 1, 0) + i
                }
            }
            this.customOnBackspace(i)
        }
    };
    a.keyboard.prototype.onEnter = function () {
        a.util.insertAtCaret(this.textbox, "\u000A");
        this.customOnEnter()
    };
    a.keyboard.prototype.onSpace = function () {
        if (!this.customOnSpace()) {
            a.util.insertAtCaret(this.textbox, "\u0020")
        }
    };
    a.keyboard.prototype.onEmoji = function () {
        this.emoji = !this.emoji;
        this.emojiCurrentCodePoint = this.emojiStartingCodePoint;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onEmojiScrollUp = function () {
        this.emojiCurrentCodePoint -= 14;
        if (this.emojiCurrentCodePoint < 0) {
            this.emojiCurrentCodePoint = 0
        }
        this.drawKeyboard()
    };
    a.keyboard.prototype.onEmojiScrollDown = function () {
        this.emojiCurrentCodePoint += 14;
        this.drawKeyboard()
    };
    a.keyboard.prototype.onEmojiKey = function (e) {
        a.util.insertAtCaret(this.textbox, a.util.fromCharCodeS(this.emojiCurrentCodePoint + parseInt(e) - 100))
    };
    a.keyboard.prototype.attr = function (e) {
        if (e == "dir") {
            return this.currentLayout.dir
        } else {
            if (e == "lang") {
                return this.currentLayout.lang
            } else {
                if (e == "name") {
                    return this.currentLayout.name
                }
            }
        }
        return ""
    };
    a.keyboard.prototype.reset = function () {
        this.shift = false;
        this.caps = false;
        this.alt = false;
        this.altGr = false;
        this.ctrl = false;
        this.counter = 0;
        this.interval = 0;
        this.prev = ""
    };
    a.keyboard.prototype.stopRepeat = function () {
        if (this.interval != 0) {
            clearInterval(this.interval);
            this.counter = 0;
            this.interval = 0
        }
    };
    a.keyboard.prototype.onKey = function (i) {
        var e = a.layout.parser.getKey(this.currentLayout.keys, i);
        if (e) {
            var u = a.layout.parser.getState(this.ctrl, this.alt, this.shift, this.caps, e.c ? e.c : "0", this.altGr);
            var v = e[u] ? e[u] : "";
            if (this.prev != "") {
                var t = a.layout.parser.getMappedValue(this.currentLayout.deadkeys, v, this.prev);
                if (t != "") {
                    a.util.insertAtCaret(this.textbox, t)
                }
                this.prev = ""
            } else {
                if (a.layout.parser.isDeadkey(this.currentLayout.deadkeys, v)) {
                    this.prev = v
                } else {
                    if (v != "") {
                        if (!this.customOnKey(v)) {
                            a.util.insertAtCaret(this.textbox, v)
                        }
                    }
                }
            }
        } // 在鼠标点击虚拟键盘插入字符后触发联想更新
        if (typeof updateSuggestions === 'function') updateSuggestions();
    };
    a.keyboard.prototype.getEmojiHTML = function () {
        var u = 14;
        if (a.util.windowWidth() < 640) {
            u = 6
        }
        var v = [];
        for (var e = 100; e < 100 + (5 * u); e++) {
            v.push('<button id="branah-k', e, '" class="branah-key"><div style="font-size:', this.fontSize, 'px;">', a.util.fromCharCodeS(this.emojiCurrentCodePoint + e - 100), "</div></button>");
            var t = e - 99;
            if (t == u) {
                v.push('<button id="branah-emoji-scrollup" class="branah-key"><div style="font-size:', this.fontSize, 'px;">\u23f6</div></button>');
                v.push('<div class="branah-clear"></div>')
            } else {
                if (t == 2 * u) {
                    v.push('<button id="branah-emoji" class="branah-key"><span>abc</span></button>');
                    v.push('<div class="branah-clear"></div>')
                } else {
                    if (t == 3 * u) {
                        v.push('<button id="branah-emoji-backspace" class="branah-key"><div style="font-size:', this.fontSize, 'px;">\u232b</div></button>');
                        v.push('<div class="branah-clear"></div>')
                    } else {
                        if (t == 4 * u) {
                            v.push('<button id="branah-emoji-enter" class="branah-key"><div style="font-size:', this.fontSize, 'px;">\u21b5</div></button>');
                            v.push('<div class="branah-clear"></div>')
                        } else {
                            if (t == 5 * u) {
                                v.push('<button id="branah-emoji-scrolldown" class="branah-key"><div style="font-size:', this.fontSize, 'px;">\u23f7</div></button>');
                                v.push('<div class="branah-clear"></div>')
                            }
                        }
                    }
                }
            }
        }
        v.push('<div class="branah-clear"></div>');
        return v.join("")
    };
    a.keyboard.prototype.drawKeyboard = function () {
        if (this.emoji) {
            document.getElementById("branah-keyboard-emoji").innerHTML = this.getEmojiHTML();
            document.getElementById("branah-keyboard-emoji").style.display = "";
            document.getElementById("branah-keyboard-alpha").style.display = "none";
            return
        } else {
            document.getElementById("branah-keyboard-emoji").style.display = "none";
            document.getElementById("branah-keyboard-alpha").style.display = ""
        }
        if (!this.currentLayout.keys) {
            return
        }
        var E, G, J, K;
        var H = this.currentLayout.keys.length;
        for (var F = 0; F < H; F++) {
            G = this.currentLayout.keys[F];
            if (!document.getElementById("branah-" + G.i)) {
                continue
            }
            var D = this.ctrl;
            var e = this.alt;
            var I = this.shift;
            var C = this.caps;
            var t = this.altGr;
            if (this.shiftOn) {
                I = true
            }
            if (this.capsOn) {
                C = true
            }
            if (this.altCtrlOn) {
                D = true;
                e = true
            }
            if (this.altGrOn) {
                t = true
            }
            J = a.layout.parser.getState(D, e, I, C, G.c ? G.c : "0", t);
            K = G[J] ? G[J] : "";
            if (this.prev != "") {
                K = a.layout.parser.getMappedValue(this.currentLayout.deadkeys, K, this.prev)
            }
            E = [];
            E.push('<div class="branah-label-reference">', a.layout.parser.getKeyLegend(this.defaultLayout.keys, G.i), "</div>");
            if (!I) {
                K = this.customDrawKeyboard(K);
                if (K == "") {
                    K = "&nbsp;"
                }
                E.push('<div class="branah-label-natural" style="font-size:', this.fontSize, 'px;">&nbsp;', K, "</div>")
            } else {
                if (K == "") {
                    K = "&nbsp;"
                }
                E.push('<div class="branah-label-shift" style="font-size:', this.fontSize, 'px;">&nbsp;', K, "</div>")
            }
            document.getElementById("branah-" + G.i).innerHTML = E.join("")
        }
        var x = document.getElementById("branah-left-ctrl");
        var A = document.getElementById("branah-right-ctrl");
        if (x && A) {
            if (D) {
                x.className = "branah-recessed" + (this.ctrl ? "" : "-hover");
                A.className = "branah-recessed" + (this.ctrl ? "" : "-hover")
            } else {
                x.className = "";
                A.className = ""
            }
        }
        var w = document.getElementById("branah-left-alt");
        if (w) {
            if (e) {
                w.className = "branah-recessed" + (this.alt ? "" : "-hover")
            } else {
                w.className = ""
            }
        }
        var z = document.getElementById("branah-right-alt");
        if (z) {
            if (t) {
                z.className = "branah-recessed" + (this.altGr ? "" : "-hover")
            } else {
                z.className = ""
            }
        }
        var y = document.getElementById("branah-left-shift");
        var B = document.getElementById("branah-right-shift");
        if (y && B) {
            if (I) {
                y.className = "branah-recessed" + (this.shift ? "" : "-hover");
                B.className = "branah-recessed" + (this.shift ? "" : "-hover")
            } else {
                y.className = "";
                B.className = ""
            }
        }
        var u = document.getElementById("branah-caps-lock");
        if (u) {
            if (C) {
                u.className = "branah-recessed" + (this.caps ? "" : "-hover")
            } else {
                u.className = ""
            }
        }
        var v = document.getElementById("branah-escape");
        if (v) {
            if (this.currentLayout === this.defaultLayout) {
                v.className = "branah-recessed"
            } else {
                v.className = ""
            }
        }
    };
    a.keyboard.prototype.wireEvents = function () {
        var e = this;
        document.getElementById("branah-keyboard").onmousedown = function (i) {
            var t = a.util.srcId(i, this, "button");
            if (!t) {
                return
            }
            e.interval = setInterval(function () {
                e.counter++;
                if (e.counter > 5) {
                    switch (t) {
                        case"branah-backspace":
                        case"branah-emoji-backspace":
                            e.onBackspace();
                            break;
                        case"branah-enter":
                        case"branah-emoji-enter":
                            e.onEnter();
                            break;
                        case"branah-emoji-scrollup":
                            e.onEmojiScrollUp();
                            break;
                        case"branah-emoji-scrolldown":
                            e.onEmojiScrollDown();
                            break;
                        default:
                            if (t.search("^branah-k([0-9]|[1-3][0-9]|4[0-7])$") != -1) {
                                e.onKey(t.substr(7));
                                e.shift = false;
                                e.alt = false;
                                e.ctrl = false;
                                e.altGr = false;
                                e.drawKeyboard()
                            } else {
                                if (t.search("^branah-k1[0-6][0-9]$") != -1) {
                                    e.onEmojiKey(t.substr(8))
                                }
                            }
                            break
                    }
                }
            }, 50)
        };
        document.getElementById("branah-keyboard").onmouseup = function (i) {
            e.stopRepeat()
        };
        document.getElementById("branah-keyboard").onmouseout = function (i) {
            e.stopRepeat()
        };
        document.getElementById("branah-keyboard").onclick = function (i) {
            var t = a.util.srcId(i, this, "button");
            if (!t) {
                return
            }
            switch (t) {
                case"branah-left-shift":
                case"branah-right-shift":
                    e.onShift();
                    break;
                case"branah-left-alt":
                    e.onCtrl();
                    e.onAlt();
                    break;
                case"branah-right-alt":
                    e.onAltGr();
                    break;
                case"branah-left-ctrl":
                case"branah-right-ctrl":
                    e.onAlt();
                    e.onCtrl();
                    break;
                case"branah-escape":
                    e.onEsc();
                    break;
                case"branah-caps-lock":
                    e.onCapsLock();
                    break;
                case"branah-backspace":
                case"branah-emoji-backspace":
                    e.onBackspace();
                    break;
                case"branah-enter":
                case"branah-emoji-enter":
                    e.onEnter();
                    break;
                case"branah-space":
                    e.onSpace();
                    break;
                case"branah":
                case"branah-emoji":
                    e.onEmoji();
                    break;
                case"branah-emoji-scrollup":
                    e.onEmojiScrollUp();
                    break;
                case"branah-emoji-scrolldown":
                    e.onEmojiScrollDown();
                    break;
                default:
                    if (t.search("^branah-k([0-9]|[1-3][0-9]|4[0-7])$") != -1) {
                        e.onKey(t.substr(7));
                        e.shift = false;
                        e.alt = false;
                        e.ctrl = false;
                        e.altGr = false;
                        e.drawKeyboard()
                    } else {
                        if (t.search("^branah-k1[0-6][0-9]$") != -1) {
                            e.onEmojiKey(t.substr(8))
                        }
                    }
                    break
            }
        };
        if (!("ontouchstart" in document.documentElement) || !a.util.mobile) {
            document.getElementById("branah-left-shift").onmouseover = function (i) {
                e.shiftOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-shift").onmouseover = function (i) {
                e.shiftOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-left-shift").onmouseout = function (i) {
                e.shiftOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-shift").onmouseout = function (i) {
                e.shiftOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-left-ctrl").onmouseover = function (i) {
                e.altCtrlOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-ctrl").onmouseover = function (i) {
                e.altCtrlOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-left-ctrl").onmouseout = function (i) {
                e.altCtrlOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-ctrl").onmouseout = function (i) {
                e.altCtrlOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-left-alt").onmouseover = function (i) {
                e.altCtrlOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-alt").onmouseover = function (i) {
                e.altGrOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-left-alt").onmouseout = function (i) {
                e.altCtrlOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-right-alt").onmouseout = function (i) {
                e.altGrOn = false;
                e.drawKeyboard()
            };
            document.getElementById("branah-caps-lock").onmouseover = function (i) {
                e.capsOn = true;
                e.drawKeyboard()
            };
            document.getElementById("branah-caps-lock").onmouseout = function (i) {
                e.capsOn = false;
                e.drawKeyboard()
            }
        }
        e.textbox.onkeydown = function (t) {
            var i = a.util.code(t);
            if (i == "Unidentified") {
                var v = a.util.keyCode(t);
                i = a.layout.parser.keys[v + ""]
            }
            if ((i == "KeyA" || i == "KeyY" || i == "KeyZ" || i == "KeyC" || i == "KeyV" || i == "KeyX") && (e.ctrl && !e.alt && !e.shift)) {
                return
            }
            if (e.currentLayout == e.defaultLayout && i != "Escape") {
                return
            }
            switch (i) {
                case"ControlLeft":
                case"ControlRight":
                    e.ctrl = false;
                    e.onCtrl();
                    break;
                case"AltLeft":
                    e.alt = false;
                    e.onAlt();
                    break;
                case"AltRight":
                    e.altGr = false;
                    e.onAltGr();
                    break;
                case"ShiftLeft":
                case"ShiftRight":
                    e.shift = false;
                    e.onShift();
                    break;
                case"Escape":
                    e.onEsc();
                    break;
                case"CapsLock":
                    if (t.getModifierState && t.getModifierState("CapsLock")) {
                        e.caps = false
                    }
                    e.onCapsLock();
                    break;
                case"Backspace":
                    e.onBackspace();
                    a.util.preventDefault(t);
                    break;
                case"Space":
                    e.onSpace();
                    a.util.preventDefault(t);
                    break;
                case"Enter":
                    e.onEnter();
                    a.util.preventDefault(t);
                    break;
                default:
                    var u = a.layout.parser.codes[i];
                    if (u != undefined) {
                        e.onKey("k" + u);
                        e.drawKeyboard();
                        a.util.preventDefault(t);
                        e.cancelkeypress = true
                    }
                    break
            }
        };
        if (a.util.opera) {
            e.textbox.onkeypress = function (i) {
                if (e.cancelkeypress) {
                    a.util.preventDefault(i);
                    e.cancelkeypress = false
                }
            }
        }
        e.textbox.onkeyup = function (t) {
            var i = a.util.code(t);
            if (i == "Unidentified") {
                var u = a.util.keyCode(t);
                i = a.layout.parser.keys[u + ""]
            }
            switch (i) {
                case"ControlLeft":
                case"ControlRight":
                    e.ctrl = true;
                    e.onCtrl();
                    break;
                case"AltLeft":
                    e.alt = true;
                    e.onAlt();
                    break;
                case"AltRight":
                    e.altGr = true;
                    e.onAltGr();
                    break;
                case"ShiftLeft":
                case"ShiftRight":
                    e.shift = true;
                    e.onShift();
                    break;
                default:
            }
        }
    };
    var o = false;
    try {
        var d = "item";
        localStorage.setItem(d, d);
        localStorage.removeItem(d);
        o = true
    } catch (b) {
    }
    var f = false;
    try {
        var p = JSON.parse(JSON.stringify({item: "item"}));
        if (p.item == "item") {
            f = true
        }
    } catch (b) {
    }
    var g = null;
    var n = {undo: [], redo: [], layout: null, fontSize: 24};
    var s = "khmer";
    g = new a.keyboard("keyboard", "editor");
    var r = g.textbox;
    r.focus();
    if (o && f) {
        var p = JSON.parse(localStorage.getItem(s));
        if (p != null) {
            if (p.layout) {
                n.layout = p.layout
            }
            if (p.undo) {
                n.undo = p.undo
            }
            if (p.redo) {
                n.redo = p.redo
            }
            if (p.fontSize) {
                n.fontSize = p.fontSize
            }
        }
    }
    if (n.fontSize) {
        g.setFontSize(n.fontSize)
    }

    var k = [{
        Id: "Khmer", Name: "Khmer(NiDA)", Json: {
            name: "Khmer", dir: "ltr", keys: [
                {i: "k0", c: "1", n: "«", s: "»", t: "‌", f: ""},
                {i: "k1", c: "1", n: "១", s: "!", t: "", f: ""},
                {i: "k2", c: "1", n: "២", s: "ៗ", t: "@", f: ""},
                {i: "k3", c: "1", n: "៣", s: '"', t: "៑", f: ""},
                {i: "k4", c: "1", n: "៤", s: "៛", t: "$", f: ""},
                {i: "k5", c: "1", n: "៥", s: "%", t: "€", f: ""},
                {i: "k6", c: "1", n: "៦", s: "៌", t: "៙", f: ""},
                {i: "k7", c: "1", n: "៧", s: "័", t: "៚", f: ""},
                {i: "k8", c: "1", n: "៨", s: "៏", t: "*", f: ""},
                {i: "k9", c: "1", n: "៩", s: "(", t: "{", f: ""},
                {i: "k10", c: "1", n: "០", s: ")", t: "}", f: ""},
                {i: "k11", c: "1", n: "គ", s: "៝", t: "×", f: ""},
                {i: "k12", c: "1", n: "ធ", s: "ឪ", t: "៎", f: ""},

                {i: "k13", c: "1", n: "ឆ", s: "ឈ", t: "‌", f: "ឍ"},
                {i: "k14", c: "1", n: "ឺ", s: "ឹ", t: "", f: "យ្"},
                {i: "k15", c: "1", n: "េ", s: "ែ", t: "ឯ", f: "ឫ"},
                {i: "k16", c: "1", n: "រ", s: "ឬ", t: "ឫ", f: "ី"},
                {i: "k17", c: "1", n: "ត", s: "ទ", t: "", f: "ិ"},
                {i: "k18", c: "1", n: "យ", s: "ួ", t: "", f: "ួ"},
                {i: "k19", c: "1", n: "ុ", s: "ូ", t: "", f: "ើ"},
                {i: "k20", c: "1", n: "ិ", s: "ី", t: "ឦ", f: "ួ"},
                {i: "k21", c: "1", n: "ោ", s: "ៅ", t: "ឱ", f: "ិ"},
                {i: "k22", c: "1", n: "ផ", s: "ភ", t: "ឰ", f: "្៉"},
                {i: "k23", c: "0", n: "ៀ", s: "ឿ", t: "ឩ", f: "ឿ"},
                {i: "k24", c: "0", n: "ឨ", s: "ឧ", t: "ឳ", f: "ឿ"},
                {i: "k25", c: "0", n: "ឮ", s: "ឭ", t: "\\", f: "្៉"},

                {i: "k26", c: "1", n: "ា", s: "ាំ", t: "", f: "៉ែ"},
                {i: "k27", c: "1", n: "ស", s: "ៃ", t: "", f: "ើ"},
                {i: "k28", c: "1", n: "ដ", s: "ឌ", t: "", f: "្ៀ"},
                {i: "k29", c: "1", n: "ថ", s: "ធ", t: "", f: "្ោ"},
                {i: "k30", c: "1", n: "ង", s: "អ", t: "", f: "្៉"},
                {i: "k31", c: "1", n: "ហ", s: "ះ", t: "", f: "់្"},
                {i: "k32", c: "1", n: "្", s: "ញ", t: "", f: "្ា"},
                {i: "k33", c: "1", n: "ក", s: "គ", t: "", f: "ើ"},
                {i: "k34", c: "1", n: "ល", s: "ឡ", t: "", f: "្ោ"},
                {i: "k35", c: "0", n: "ើ", s: "ោៈ", t: "៖", f: "ោ"},
                {i: "k36", c: "0", n: "់", s: "៉", t: "ៈ", f: "៉"},

                {i: "k37", c: "1", n: "ឋ", s: "ឍ", t: "", f: "្្ុ"},
                {i: "k38", c: "1", n: "ខ", s: "ឃ", t: "", f: "្ៀ"},
                {i: "k39", c: "1", n: "ច", s: "ជ", t: "", f: "ិ"},
                {i: "k40", c: "1", n: "វ", s: "េះ", t: "", f: "េះ"},
                {i: "k41", c: "1", n: "ប", s: "ព", t: "", f: "ពា"},
                {i: "k42", c: "1", n: "ន", s: "ណ", t: "", f: "នា"},
                {i: "k43", c: "1", n: "ម", s: "ំ", t: "", f: "ំ"},
                {i: "k44", c: "0", n: "ំុ", s: "ុះ", t: ",", f: "ុះ"},
                {i: "k45", c: "0", n: "។", s: "៕", t: ".", f: "៕"},
                {i: "k46", c: "0", n: "៊", s: "?", t: "/", f: "៉"},
                {i: "k47", c: "0", n: "\\", s: "/"}

            ], deadkeys: []
        }
    }, {
        "Id": "Khmer_MS",
        "Name": "Khmer (Microsoft)",
        "Json": {
            "name": "Khmer_MS",
            "dir": "ltr",
            "keys": [
                {
                    "i": "k0",
                    "c": "1",
                    "n": "",
                    "s": "",
                    "t": "៙"
                },
                {
                    "i": "k1",
                    "c": "1",
                    "n": "១",
                    "s": "!",
                    "t": "1"
                },
                {
                    "i": "k2",
                    "c": "0",
                    "n": "២",
                    "s": "@",
                    "t": "2"
                },
                {
                    "i": "k3",
                    "c": "0",
                    "n": "៣",
                    "s": "#",
                    "t": "3"
                },
                {
                    "i": "k4",
                    "c": "0",
                    "n": "៤",
                    "s": "$",
                    "t": "4"
                },
                {
                    "i": "k5",
                    "c": "0",
                    "n": "៥",
                    "s": "%",
                    "t": "5"
                },
                {
                    "i": "k6",
                    "c": "0",
                    "n": "៦",
                    "s": "^",
                    "t": "6"
                },
                {
                    "i": "k7",
                    "c": "0",
                    "n": "៧",
                    "s": "&",
                    "t": "7"
                },
                {
                    "i": "k8",
                    "c": "0",
                    "n": "៨",
                    "s": "*",
                    "t": "8"
                },
                {
                    "i": "k9",
                    "c": "0",
                    "n": "៩",
                    "s": "(",
                    "t": "9"
                },
                {
                    "i": "k10",
                    "c": "0",
                    "n": "០",
                    "s": ")",
                    "t": "0"
                },
                {
                    "i": "k11",
                    "c": "0",
                    "n": "-",
                    "s": "_",
                    "t": "{"
                },
                {
                    "i": "k12",
                    "c": "0",
                    "n": "=",
                    "s": "+",
                    "t": "}"
                },
                {
                    "i": "k13",
                    "c": "1",
                    "n": "ឆ",
                    "s": "ឈ",
                    "t": "*"
                },
                {
                    "i": "k14",
                    "c": "1",
                    "n": "ឹ",
                    "s": "ឺ",
                    "t": ""
                },
                {
                    "i": "k15",
                    "c": "1",
                    "n": "េ",
                    "s": "ែ",
                    "t": "ឯ"
                },
                {
                    "i": "k16",
                    "c": "1",
                    "n": "រ",
                    "s": "ឬ",
                    "t": "ឫ"
                },
                {
                    "i": "k17",
                    "c": "1",
                    "n": "ត",
                    "s": "ទ",
                    "t": "ឦ"
                },
                {
                    "i": "k18",
                    "c": "1",
                    "n": "យ",
                    "s": "ួ",
                    "t": ""
                },
                {
                    "i": "k19",
                    "c": "1",
                    "n": "ុ",
                    "s": "ូ",
                    "t": "ឧ"
                },
                {
                    "i": "k20",
                    "c": "1",
                    "n": "ិ",
                    "s": "ី",
                    "t": "ឥ"
                },
                {
                    "i": "k21",
                    "c": "1",
                    "n": "ោ",
                    "s": "ៅ",
                    "t": "ឱ"
                },
                {
                    "i": "k22",
                    "c": "1",
                    "n": "ផ",
                    "s": "ភ",
                    "t": "ឳ"
                },
                {
                    "i": "k23",
                    "c": "0",
                    "n": "ើ",
                    "s": "ោះ",
                    "t": "["
                },
                {
                    "i": "k24",
                    "c": "0",
                    "n": "ឿ",
                    "s": "ៀ",
                    "t": "]"
                },
                {
                    "i": "k25",
                    "c": "0",
                    "n": "\\",
                    "s": "/",
                    "t": "៚"
                },
                {
                    "i": "k26",
                    "c": "1",
                    "n": "ា",
                    "s": "ៃ",
                    "t": "ឩ"
                },
                {
                    "i": "k27",
                    "c": "1",
                    "n": "ស",
                    "s": "ាំ",
                    "t": "ឪ"
                },
                {
                    "i": "k28",
                    "c": "1",
                    "n": "ដ",
                    "s": "ឌ",
                    "t": ""
                },
                {
                    "i": "k29",
                    "c": "1",
                    "n": "ថ",
                    "s": "ធ",
                    "t": ""
                },
                {
                    "i": "k30",
                    "c": "1",
                    "n": "ង",
                    "s": "ុះ",
                    "t": ""
                },
                {
                    "i": "k31",
                    "c": "1",
                    "n": "ហ",
                    "s": "ះ",
                    "t": ""
                },
                {
                    "i": "k32",
                    "c": "1",
                    "n": "ញ",
                    "s": "ុំ",
                    "t": "ឮ"
                },
                {
                    "i": "k33",
                    "c": "1",
                    "n": "ក",
                    "s": "គ",
                    "t": "ឭ"
                },
                {
                    "i": "k34",
                    "c": "1",
                    "n": "ល",
                    "s": "ឡ",
                    "t": "ឰ"
                },
                {
                    "i": "k35",
                    "c": "0",
                    "n": "ៈ",
                    "s": "៖",
                    "t": ";"
                },
                {
                    "i": "k36",
                    "c": "0",
                    "n": "់",
                    "s": "៉",
                    "t": "៝"
                },
                {
                    "i": "k37",
                    "c": "1",
                    "n": "ឋ",
                    "s": "ឍ",
                    "t": "#"
                },
                {
                    "i": "k38",
                    "c": "1",
                    "n": "ខ",
                    "s": "ឃ",
                    "t": "@"
                },
                {
                    "i": "k39",
                    "c": "1",
                    "n": "ច",
                    "s": "ជ",
                    "t": "&"
                },
                {
                    "i": "k40",
                    "c": "1",
                    "n": "វ",
                    "s": "េះ",
                    "t": "$"
                },
                {
                    "i": "k41",
                    "c": "1",
                    "n": "ប",
                    "s": "ព",
                    "t": "%"
                },
                {
                    "i": "k42",
                    "c": "1",
                    "n": "ន",
                    "s": "ណ",
                    "t": "("
                },
                {
                    "i": "k43",
                    "c": "1",
                    "n": "ម",
                    "s": "ំ",
                    "t": ")"
                },
                {
                    "i": "k44",
                    "c": "0",
                    "n": "អ",
                    "s": ",",
                    "t": "‹"
                },
                {
                    "i": "k45",
                    "c": "0",
                    "n": "។",
                    "s": ".",
                    "t": "›"
                },
                {
                    "i": "k46",
                    "c": "0",
                    "n": "​​",
                    "s": "?",
                    "t": "៕"
                },
                {
                    "i": "k47",
                    "c": "0",
                    "n": "\\",
                    "s": "/",
                    "t": "៚"
                }
            ],
            "deadkeys": []
        }
    }];
    if (k.length == 1) {
        g.loadVirtualLayout(k[0].Json)
    } else {
        var h = [];
        var l = [];
        if (!n.layout) {
            n.layout = k[0].Id
        }
        var m = false;
        for (var c = 0; c < k.length; c++) {
            h.push("<label", (c > 0 ? ' style=\"margin-left:2em\"' : ""), '><input id=\"', k[c].Id, '\" name=type type=radio', (n.layout == k[c].Id ? ' checked=\"checked\"' : ""), "> ", k[c].Name, "</label>");
            l[c] = new a.layout();
            l[c].load(k[c].Json);
            if (n.layout == k[c].Id) {
                g.loadVirtualLayout(k[c].Json);
                m = true
            }
        }
        if (m == false) {
            g.loadVirtualLayout(k[0].Json)
        }
        var j = document.createElement("p");
        j.innerHTML = h.join("");
        document.getElementById("keyboard").appendChild(j);
        for (var c = 0; c < k.length; c++) {
            var q = function (e, i) {
                document.getElementById(e).onclick = function () {
                    if (n.layout != e) {
                        g.virtualLayout = i;
                        g.currentLayout = g.virtualLayout;
                        g.reset();
                        g.drawKeyboard();
                        g.textbox.style.direction = i.dir;
                        n.layout = e;
                        if (o && f) {
                            localStorage.setItem(s, JSON.stringify(n))
                        }
                    }
                    g.textbox.focus()
                }
            }(k[c].Id, l[c])
        }
    }
    if (n.fontSize == null) {
        n.fontSize = g.getFontSize();
        if (o && f) {
            localStorage.setItem(s, JSON.stringify(n))
        }
    }
    document.getElementById("shrink").onclick = function () {
        if (n.fontSize < 14) {
            return
        }
        n.fontSize -= 2;
        g.setFontSize(n.fontSize);
        g.drawKeyboard();
        if (o && f) {
            localStorage.setItem(s, JSON.stringify(n))
        }
        r.focus()
    };
    document.getElementById("enlarge").onclick = function () {
        if (n.fontSize > 36) {
            return
        }
        n.fontSize += 2;
        g.setFontSize(n.fontSize);
        g.drawKeyboard();
        if (o && f) {
            localStorage.setItem(s, JSON.stringify(n))
        }
        r.focus()
    };

    document.getElementById("copy").onclick = function () {
        a.util.setCaretPosition(r, 0, r.value.length);
        var e = document.execCommand("copy");
        if (e) {
            a.util.setCaretPosition(r, r.value.length, r.value.length)
        } else {
            alert("Your browser does not allow automated copy. To copy the text in the text area, you can click Select All button and right click on the selected text. Then click the Copy option.")
        }
        r.focus()
    };
// ===== 新增 Paste 功能 =====
    document.getElementById("paste").onclick = async function () {
        try {
            const text = await navigator.clipboard.readText();
            if (text) {
                const start = r.selectionStart;
                const end = r.selectionEnd;
                r.value = r.value.slice(0, start) + text + r.value.slice(end);
                r.selectionStart = r.selectionEnd = start + text.length;
                r.focus();
                if (typeof updateSuggestions === 'function') updateSuggestions();
            } else {
                alert("剪贴板为空，请先复制内容");
            }
        } catch (err) {
            alert("浏览器不允许自动粘贴。\n请手动按 Ctrl+V 进行粘贴。");
        }
    };


    document.getElementById("clearAll").onclick = function () {
        if (r.value.length < 10 || confirm("Are you sure you want to clear all the text?")) {
            n.undo = [];
            n.redo = [];
            localStorage.setItem(s, JSON.stringify(n));
            r.value = ""
        }
        r.focus()
    }


    // ===== Khmer 词联想功能 =====
    const suggestionsDiv = document.getElementById('suggestions');
    const editor = document.getElementById('editor');

    // 简易词库（示例），你可以扩展/替换真实词库
    //const khmerWords = ['ការ', 'កាល', 'កាន់', 'កូន', 'កិត្តិយស', 'កង', 'កម្ពុជា', 'កសិករ', 'កៅអី', 'កាំបិត'];
    let khmerWords = [];

    async function loadKhmerWords() {
        try {
            const res = await fetch('dict.km2');
            khmerWords = await res.json();
            console.log(`✅ Loaded Khmer words: ${khmerWords.length}`);
            updateSuggestions(); // 加载后刷新一次候选显示
        } catch (e) {
            console.error('Failed to load Khmer words:', e);
        }
    }

    window.addEventListener('DOMContentLoaded', loadKhmerWords);

    // commitPos 标记“从哪里开始算这次正在输入（未提交）的字符）”
    // 初始为 0（即从文档开头开始）
    let commitPos = 0;
    let suggestionActive = false; // 是否激活候选框
    let currentIndex = -1; // 当前高亮候选词索引

    function normalizeCaret() {
        // 若用户把光标移到 commitPos 之前，则重置 commitPos（避免不一致）
        const pos = (editor.selectionStart !== undefined) ? editor.selectionStart : editor.value.length;
        if (pos < commitPos) commitPos = 0;
        return pos;
    }

    function getQuerySinceCommit() {
        const pos = normalizeCaret();
        // 取从 commitPos 到当前光标之间的字符串（这是“正在输入”的片段）
        return editor.value.slice(commitPos, pos);
    }

    function updateSuggestions() {
        const q = getQuerySinceCommit();

        // 如果没有正在输入的片段，清空候选（也可改成根据光标前单字匹配）
        if (!q) {
            suggestionsDiv.innerHTML = '';
            suggestionActive = false;
            currentIndex = -1;
            return;
        }

        // 只按前缀匹配（从开头匹配），最多 6 个候选
        const matches = khmerWords.filter(w => w.indexOf(q) === 0).slice(0, 6);

        if (matches.length > 0) {
            suggestionsDiv.innerHTML = matches.map(w =>
                `<span class="sugg-item" style="padding:5px; cursor:pointer; display:inline-block;">${w}</span>`
            ).join(' ');
            // 如果激活中且有高亮索引，维持高亮
            if (suggestionActive && currentIndex >= 0) {
                highlightSuggestion(currentIndex);
            }
        } else {
            suggestionsDiv.innerHTML = '';
            suggestionActive = false;
            currentIndex = -1;
        }
    }

    function highlightSuggestion(index) {
        const items = suggestionsDiv.querySelectorAll('.sugg-item');
        items.forEach((el, i) => {
            el.style.background = (i === index) ? '#b5e0ff' : 'transparent';
        });
    }

    // 当用户选中候选词时，用“从 commitPos 到当前光标”的范围替换为选中词
    function replaceFromCommitWith(word) {
        // caret 位置
        const pos = normalizeCaret();
        const before = editor.value.slice(0, commitPos);
        const after = editor.value.slice(pos);
        const newLeft = before + word;
        editor.value = newLeft + after;

        // 将 caret 放回到替换后的末端，并把 commitPos 移到这个末端（表示已提交）
        const newPos = newLeft.length;
        try {
            editor.setSelectionRange(newPos, newPos);
        } catch (e) {
        }
        editor.focus();

        // 把 commitPos 设为新Pos（下一次输入从这里开始计作新的 query）
        commitPos = newPos;

        // 更新候选显示（通常会清空）
        updateSuggestions();
    }

    // 点击候选词自动替换
    suggestionsDiv.addEventListener('click', function (e) {
        if (e.target && e.target.classList.contains('sugg-item')) {
            replaceFromCommitWith(e.target.textContent);
            suggestionActive = false;
            currentIndex = -1;
            highlightSuggestion(-1);
        }
    });

    // 对物理输入 / 虚拟键盘输入都要监听，保持实时更新与 commitPos 逻辑一致
    function onEditorInput(e) {
        // 如果光标在 commitPos 之前（用户跳位输入），重置 commitPos
        normalizeCaret();

        // 如果用户输入了非可打印字符（比如换行、空格），我们认为“提交”了当前片段
        // 那么将 commitPos 移到当前光标（表示下一段输入是新片段）
        const lastChar = editor.value.charAt((editor.selectionStart || 0) - 1);
        if (lastChar === ' ' || lastChar === '\n' || lastChar === '\t') {
            commitPos = editor.selectionStart || editor.value.length;
            suggestionsDiv.innerHTML = '';
            suggestionActive = false;
            currentIndex = -1;
            return;
        }

        // 否则按 commitPos 到光标之间的内容做候选
        updateSuggestions();
    }


    editor.addEventListener('input', onEditorInput);
    editor.addEventListener('keyup', onEditorInput);
    editor.addEventListener('click', function () {
        normalizeCaret();
        updateSuggestions();
    });

    // ===== 键盘控制候选框 =====
    editor.addEventListener('keydown', function (e) {
        const items = suggestionsDiv.querySelectorAll('.sugg-item');
        if (!items.length) return;

        if (e.key === 'ArrowDown') {
            // 激活候选框
            if (!suggestionActive) {
                suggestionActive = true;
                currentIndex = 0;
            }
            highlightSuggestion(currentIndex);
            e.preventDefault();
        } else if (e.key === 'ArrowUp') {
            // 取消激活状态
            if (suggestionActive) {
                suggestionActive = false;
                currentIndex = -1;
                highlightSuggestion(-1);
            }
            e.preventDefault();
        } else if (suggestionActive && (e.key === 'ArrowLeft' || e.key === 'ArrowRight')) {
            // 左右移动选择
            if (e.key === 'ArrowRight') {
                currentIndex = (currentIndex + 1) % items.length;
            } else if (e.key === 'ArrowLeft') {
                currentIndex = (currentIndex - 1 + items.length) % items.length;
            }
            highlightSuggestion(currentIndex);
            e.preventDefault();
        } else if (suggestionActive && e.key === 'Enter') {
            // 选中高亮的词
            if (currentIndex >= 0 && currentIndex < items.length) {
                const word = items[currentIndex].textContent;
                replaceFromCommitWith(word);
                suggestionActive = false;
                currentIndex = -1;
                highlightSuggestion(-1);
                e.preventDefault();
            }
        }
    });

    // 初始化（第一次渲染）
    updateSuggestions();


})();