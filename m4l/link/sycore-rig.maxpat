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
    "devicewidth": 380,
    "boxes": [
      {
        "box": {
          "id": "obj-rr",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            20,
            100,
            22
          ],
          "text": "r sycore_rig"
        }
      },
      {
        "box": {
          "border": 0,
          "filename": "C:/Users/swina/Documents/sycore-link/sycore-rig-grid.js",
          "id": "obj-grid",
          "maxclass": "jsui",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            60,
            360,
            134
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            28,
            364,
            134
          ]
        }
      },
      {
        "box": {
          "id": "obj-rs",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            220,
            121,
            22
          ],
          "text": "s sycore_rig_in"
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
          "id": "obj-open",
          "maxclass": "live.text",
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            420,
            20,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            316,
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
              "parameter_invisible": 2,
              "parameter_longname": "Open window",
              "parameter_shortname": "Open"
            }
          },
          "text": "OPEN",
          "textcolor": [
            0.961,
            0.961,
            0.961,
            1
          ],
          "texton": "OPEN",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Open"
        }
      },
      {
        "box": {
          "id": "obj-osel",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            420,
            60,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-omsg",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            420,
            90,
            60,
            22
          ],
          "text": "open"
        }
      },
      {
        "box": {
          "id": "obj-pc",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            420,
            120,
            72,
            22
          ],
          "text": "pcontrol"
        }
      },
      {
        "box": {
          "id": "obj-win",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
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
              120,
              120,
              880,
              450
            ],
            "openinpresentation": 1,
            "devicewidth": 760,
            "boxes": [
              {
                "box": {
                  "id": "obj-in",
                  "maxclass": "newobj",
                  "numinlets": 0,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    20,
                    20,
                    60,
                    22
                  ],
                  "text": "inlet"
                }
              },
              {
                "box": {
                  "id": "obj-wr",
                  "maxclass": "newobj",
                  "numinlets": 1,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    20,
                    400,
                    100,
                    22
                  ],
                  "text": "r sycore_rig"
                }
              },
              {
                "box": {
                  "border": 0,
                  "filename": "C:/Users/swina/Documents/sycore-link/sycore-rig-grid.js",
                  "id": "obj-grid",
                  "maxclass": "jsui",
                  "numinlets": 1,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    0,
                    0,
                    760,
                    330
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    0,
                    0,
                    760,
                    330
                  ]
                }
              },
              {
                "box": {
                  "id": "obj-ws",
                  "maxclass": "newobj",
                  "numinlets": 1,
                  "numoutlets": 0,
                  "outlettype": [],
                  "patching_rect": [
                    20,
                    440,
                    121,
                    22
                  ],
                  "text": "s sycore_rig_in"
                }
              }
            ],
            "lines": [
              {
                "patchline": {
                  "source": [
                    "obj-wr",
                    0
                  ],
                  "destination": [
                    "obj-grid",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-grid",
                    0
                  ],
                  "destination": [
                    "obj-ws",
                    0
                  ]
                }
              }
            ],
            "toolbarvisible": 0,
            "statusbarvisible": 0,
            "enablehscroll": 0,
            "enablevscroll": 0,
            "bgcolor": [
              0.075,
              0.075,
              0.075,
              1
            ]
          },
          "patching_rect": [
            420,
            160,
            107,
            22
          ],
          "text": "p SY.CORE Rig"
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
            28,
            5,
            150,
            20
          ],
          "text": "SY.CORE RIG",
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
          "fontsize": 9,
          "id": "obj-sub",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            600,
            50,
            226,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            128,
            6,
            180,
            18
          ],
          "text": "slots · mute · solo · sections",
          "textcolor": [
            0.357,
            0.384,
            0.396,
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
            380,
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
            380,
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
            "obj-rr",
            0
          ],
          "destination": [
            "obj-grid",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-grid",
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
            "obj-open",
            0
          ],
          "destination": [
            "obj-osel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-osel",
            0
          ],
          "destination": [
            "obj-omsg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-omsg",
            0
          ],
          "destination": [
            "obj-pc",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pc",
            0
          ],
          "destination": [
            "obj-win",
            0
          ]
        }
      }
    ]
  }
}