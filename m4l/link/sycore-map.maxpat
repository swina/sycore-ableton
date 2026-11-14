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
          "id": "obj-logic",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            90,
            128,
            22
          ],
          "text": "js sycore-map.js"
        }
      },
      {
        "box": {
          "border": 0,
          "filename": "sycore-map-view.js",
          "id": "obj-view",
          "maxclass": "jsui",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            500,
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
          "id": "obj-rf",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            500,
            270,
            142,
            22
          ],
          "text": "route followtoggle"
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
            "obj-logic",
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
            "obj-logic",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-logic",
            0
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
            "obj-ms",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-logic",
            1
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
            "obj-logic",
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
            "obj-logic",
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