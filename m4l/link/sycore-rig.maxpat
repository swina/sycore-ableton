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
          "filename": "sycore-rig-grid.js",
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
          "id": "obj-orb",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            520,
            40,
            86,
            22
          ],
          "text": "route bang"
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
          "id": "obj-ofs",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            560,
            120,
            114,
            22
          ],
          "text": "s ---rig_front"
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
              940,
              510
            ],
            "openinpresentation": 1,
            "devicewidth": 820,
            "boxes": [
              {
                "box": {
                  "comment": "",
                  "id": "obj-in",
                  "index": 1,
                  "maxclass": "inlet",
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
                  ]
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
                  "filename": "sycore-rig-grid.js",
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
                    820,
                    390
                  ],
                  "presentation": 1,
                  "presentation_rect": [
                    0,
                    0,
                    820,
                    390
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
              },
              {
                "box": {
                  "id": "obj-wf",
                  "maxclass": "newobj",
                  "numinlets": 1,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    200,
                    400,
                    114,
                    22
                  ],
                  "text": "r ---rig_front"
                }
              },
              {
                "box": {
                  "id": "obj-wb",
                  "maxclass": "newobj",
                  "numinlets": 1,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    260,
                    400,
                    60,
                    22
                  ],
                  "text": "t b"
                }
              },
              {
                "box": {
                  "id": "obj-wd",
                  "maxclass": "newobj",
                  "numinlets": 2,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    200,
                    430,
                    72,
                    22
                  ],
                  "text": "delay 30"
                }
              },
              {
                "box": {
                  "id": "obj-wm",
                  "maxclass": "message",
                  "numinlets": 2,
                  "numoutlets": 1,
                  "outlettype": [
                    ""
                  ],
                  "patching_rect": [
                    200,
                    460,
                    60,
                    22
                  ],
                  "text": "front"
                }
              },
              {
                "box": {
                  "id": "obj-wt",
                  "maxclass": "newobj",
                  "numinlets": 1,
                  "numoutlets": 2,
                  "outlettype": [
                    "",
                    ""
                  ],
                  "patching_rect": [
                    200,
                    490,
                    93,
                    22
                  ],
                  "text": "thispatcher"
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
              },
              {
                "patchline": {
                  "source": [
                    "obj-wf",
                    0
                  ],
                  "destination": [
                    "obj-wb",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-wb",
                    0
                  ],
                  "destination": [
                    "obj-wd",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-wd",
                    0
                  ],
                  "destination": [
                    "obj-wm",
                    0
                  ]
                }
              },
              {
                "patchline": {
                  "source": [
                    "obj-wm",
                    0
                  ],
                  "destination": [
                    "obj-wt",
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
            10,
            5,
            90,
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
          "border": 0,
          "filename": "sycore-rig-grid.js",
          "id": "obj-chd",
          "maxclass": "jsui",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            260,
            208,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            100,
            3,
            208,
            22
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
            "obj-rr",
            0
          ],
          "destination": [
            "obj-chd",
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
            "obj-orb",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-orb",
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
            "obj-orb",
            1
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
      },
      {
        "patchline": {
          "source": [
            "obj-omsg",
            0
          ],
          "destination": [
            "obj-ofs",
            0
          ]
        }
      }
    ]
  }
}