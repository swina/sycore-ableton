{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "classnamespace": "box",
    "rect": [
      100,
      100,
      1100,
      640
    ],
    "openinpresentation": 1,
    "devicewidth": 470,
    "boxes": [
      {
        "box": {
          "id": "obj-dev",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            20,
            121,
            22
          ],
          "text": "live.thisdevice"
        }
      },
      {
        "box": {
          "id": "obj-mr",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            200,
            20,
            100,
            22
          ],
          "text": "r sycore_map"
        }
      },
      {
        "box": {
          "border": 0,
          "filename": "C:/Users/swina/Documents/sycore-link/sycore-map.js",
          "id": "obj-view",
          "maxclass": "jsui",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            120,
            440,
            134
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            28,
            454,
            134
          ]
        }
      },
      {
        "box": {
          "id": "obj-rs",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 17,
          "outlettype": [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            270,
            317,
            22
          ],
          "text": "route 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
        }
      },
      {
        "box": {
          "id": "obj-ri0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi0",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr0",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            140,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            140,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            140,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            250,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            250,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            250,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            360,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            360,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            470,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            470,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            470,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            580,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            580,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            580,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            690,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            690,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr6",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            690,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            800,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            800,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr7",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            800,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri8",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            910,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi8",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            910,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr8",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            910,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri9",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1020,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi9",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1020,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr9",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1020,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri10",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1130,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi10",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1130,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr10",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1130,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri11",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1240,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi11",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1240,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr11",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1240,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri12",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1350,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi12",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1350,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1350,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri13",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1460,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi13",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1460,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr13",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1460,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri14",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1570,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi14",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1570,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr14",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1570,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-ri15",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            1680,
            300,
            72,
            22
          ],
          "text": "route id"
        }
      },
      {
        "box": {
          "id": "obj-pi15",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1680,
            330,
            86,
            22
          ],
          "text": "prepend id"
        }
      },
      {
        "box": {
          "id": "obj-lr15",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1680,
            370,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
          "id": "obj-rf",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            500,
            270,
            205,
            22
          ],
          "text": "route followtoggle askready"
        }
      },
      {
        "box": {
          "id": "obj-fset",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            500,
            300,
            93,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-ms",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            620,
            300,
            121,
            22
          ],
          "text": "s sycore_map_in"
        }
      },
      {
        "box": {
          "activebgcolor": [
            0.039,
            0.039,
            0.039,
            1
          ],
          "activebgoncolor": [
            0,
            0.639,
            0.439,
            1
          ],
          "activetextcolor": [
            0.961,
            0.961,
            0.961,
            1
          ],
          "activetextoncolor": [
            0,
            0,
            0,
            1
          ],
          "bgcolor": [
            0.039,
            0.039,
            0.039,
            1
          ],
          "bgoncolor": [
            0,
            0.639,
            0.439,
            1
          ],
          "bordercolor": [
            1,
            1,
            1,
            0.1
          ],
          "focusbordercolor": [
            1,
            1,
            1,
            0.1
          ],
          "fontsize": 9,
          "id": "obj-fol",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            500,
            20,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            406,
            6,
            56,
            17
          ],
          "rounded": 2,
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_mmax": 1,
              "parameter_type": 2,
              "parameter_initial_enable": 1,
              "parameter_initial": [
                1
              ],
              "parameter_longname": "Follow selected track",
              "parameter_shortname": "Follow"
            }
          },
          "text": "LOCK",
          "textcolor": [
            0.961,
            0.961,
            0.961,
            1
          ],
          "texton": "FOLLOW",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Follow"
        }
      },
      {
        "box": {
          "id": "obj-fp",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            500,
            60,
            114,
            22
          ],
          "text": "prepend follow"
        }
      },
      {
        "box": {
          "id": "obj-mi",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            800,
            20,
            60,
            22
          ],
          "text": "midiin"
        }
      },
      {
        "box": {
          "id": "obj-mo",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            800,
            60,
            65,
            22
          ],
          "text": "midiout"
        }
      },
      {
        "box": {
          "fontface": 1,
          "fontsize": 12,
          "id": "obj-ttl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            600,
            20,
            93,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            5,
            120,
            20
          ],
          "text": "SY.CORE MAP",
          "textcolor": [
            0.961,
            0.961,
            0.961,
            1
          ]
        }
      },
      {
        "box": {
          "angle": 270,
          "bgcolor": [
            0,
            0.639,
            0.439,
            1
          ],
          "bgfillcolor_color": [
            0,
            0.639,
            0.439,
            1
          ],
          "bgfillcolor_type": "color",
          "border": 0,
          "id": "obj-bar",
          "ignoreclick": 1,
          "maxclass": "panel",
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            900,
            50,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            470,
            2
          ],
          "proportion": 0.39,
          "rounded": 0,
          "style": ""
        }
      },
      {
        "box": {
          "angle": 270,
          "bgcolor": [
            0.075,
            0.075,
            0.075,
            1
          ],
          "bgfillcolor_color": [
            0.075,
            0.075,
            0.075,
            1
          ],
          "bgfillcolor_type": "color",
          "border": 1,
          "bordercolor": [
            1,
            1,
            1,
            0.1
          ],
          "id": "obj-bg",
          "ignoreclick": 1,
          "maxclass": "panel",
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            900,
            20,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            470,
            169
          ],
          "proportion": 0.39,
          "rounded": 6,
          "style": ""
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-dev",
            0
          ],
          "destination": [
            "obj-view",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mr",
            0
          ],
          "destination": [
            "obj-view",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-view",
            0
          ],
          "destination": [
            "obj-rs",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            0
          ],
          "destination": [
            "obj-ri0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri0",
            0
          ],
          "destination": [
            "obj-pi0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi0",
            0
          ],
          "destination": [
            "obj-lr0",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri0",
            1
          ],
          "destination": [
            "obj-lr0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            1
          ],
          "destination": [
            "obj-ri1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri1",
            0
          ],
          "destination": [
            "obj-pi1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi1",
            0
          ],
          "destination": [
            "obj-lr1",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri1",
            1
          ],
          "destination": [
            "obj-lr1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            2
          ],
          "destination": [
            "obj-ri2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri2",
            0
          ],
          "destination": [
            "obj-pi2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi2",
            0
          ],
          "destination": [
            "obj-lr2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri2",
            1
          ],
          "destination": [
            "obj-lr2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            3
          ],
          "destination": [
            "obj-ri3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri3",
            0
          ],
          "destination": [
            "obj-pi3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi3",
            0
          ],
          "destination": [
            "obj-lr3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri3",
            1
          ],
          "destination": [
            "obj-lr3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            4
          ],
          "destination": [
            "obj-ri4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri4",
            0
          ],
          "destination": [
            "obj-pi4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi4",
            0
          ],
          "destination": [
            "obj-lr4",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri4",
            1
          ],
          "destination": [
            "obj-lr4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            5
          ],
          "destination": [
            "obj-ri5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri5",
            0
          ],
          "destination": [
            "obj-pi5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi5",
            0
          ],
          "destination": [
            "obj-lr5",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri5",
            1
          ],
          "destination": [
            "obj-lr5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            6
          ],
          "destination": [
            "obj-ri6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri6",
            0
          ],
          "destination": [
            "obj-pi6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi6",
            0
          ],
          "destination": [
            "obj-lr6",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri6",
            1
          ],
          "destination": [
            "obj-lr6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            7
          ],
          "destination": [
            "obj-ri7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri7",
            0
          ],
          "destination": [
            "obj-pi7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi7",
            0
          ],
          "destination": [
            "obj-lr7",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri7",
            1
          ],
          "destination": [
            "obj-lr7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            8
          ],
          "destination": [
            "obj-ri8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri8",
            0
          ],
          "destination": [
            "obj-pi8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi8",
            0
          ],
          "destination": [
            "obj-lr8",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri8",
            1
          ],
          "destination": [
            "obj-lr8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            9
          ],
          "destination": [
            "obj-ri9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri9",
            0
          ],
          "destination": [
            "obj-pi9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi9",
            0
          ],
          "destination": [
            "obj-lr9",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri9",
            1
          ],
          "destination": [
            "obj-lr9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            10
          ],
          "destination": [
            "obj-ri10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri10",
            0
          ],
          "destination": [
            "obj-pi10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi10",
            0
          ],
          "destination": [
            "obj-lr10",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri10",
            1
          ],
          "destination": [
            "obj-lr10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            11
          ],
          "destination": [
            "obj-ri11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri11",
            0
          ],
          "destination": [
            "obj-pi11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi11",
            0
          ],
          "destination": [
            "obj-lr11",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri11",
            1
          ],
          "destination": [
            "obj-lr11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            12
          ],
          "destination": [
            "obj-ri12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri12",
            0
          ],
          "destination": [
            "obj-pi12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi12",
            0
          ],
          "destination": [
            "obj-lr12",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri12",
            1
          ],
          "destination": [
            "obj-lr12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            13
          ],
          "destination": [
            "obj-ri13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri13",
            0
          ],
          "destination": [
            "obj-pi13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi13",
            0
          ],
          "destination": [
            "obj-lr13",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri13",
            1
          ],
          "destination": [
            "obj-lr13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            14
          ],
          "destination": [
            "obj-ri14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri14",
            0
          ],
          "destination": [
            "obj-pi14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi14",
            0
          ],
          "destination": [
            "obj-lr14",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri14",
            1
          ],
          "destination": [
            "obj-lr14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rs",
            15
          ],
          "destination": [
            "obj-ri15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri15",
            0
          ],
          "destination": [
            "obj-pi15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pi15",
            0
          ],
          "destination": [
            "obj-lr15",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ri15",
            1
          ],
          "destination": [
            "obj-lr15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-view",
            1
          ],
          "destination": [
            "obj-rf",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rf",
            0
          ],
          "destination": [
            "obj-fset",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fset",
            0
          ],
          "destination": [
            "obj-fol",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rf",
            1
          ],
          "destination": [
            "obj-dev",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rf",
            2
          ],
          "destination": [
            "obj-ms",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fol",
            0
          ],
          "destination": [
            "obj-fp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fp",
            0
          ],
          "destination": [
            "obj-view",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mi",
            0
          ],
          "destination": [
            "obj-mo",
            0
          ]
        }
      }
    ]
  }
}