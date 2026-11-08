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
    "devicewidth": 210,
    "boxes": [
      {
        "box": {
          "id": "obj-rcv",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            20,
            142,
            22
          ],
          "text": "r sycore_link_midi"
        }
      },
      {
        "box": {
          "id": "obj-ft",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            60,
            60,
            22
          ],
          "text": "t l l"
        }
      },
      {
        "box": {
          "id": "obj-fn",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            120,
            90,
            72,
            22
          ],
          "text": "zl nth 1"
        }
      },
      {
        "box": {
          "id": "obj-fx",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            120,
            120,
            296,
            22
          ],
          "text": "expr $i2 == 0 || (($i1 & 15) + 1) == $i2"
        }
      },
      {
        "box": {
          "id": "obj-fg",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            150,
            72,
            22
          ],
          "text": "gate 1 1"
        }
      },
      {
        "box": {
          "id": "obj-menu",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            360,
            90,
            60,
            22
          ],
          "parameter_enable": 1,
          "varname": "Channel",
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_enum": [
                "All",
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16"
              ],
              "parameter_initial": [
                0
              ],
              "parameter_initial_enable": 1,
              "parameter_longname": "Channel",
              "parameter_shortname": "Channel",
              "parameter_type": 2,
              "parameter_mmax": 16
            }
          },
          "presentation": 1,
          "presentation_rect": [
            10,
            34,
            60,
            18
          ]
        }
      },
      {
        "box": {
          "id": "obj-iter",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            190,
            60,
            22
          ],
          "text": "iter"
        }
      },
      {
        "box": {
          "id": "obj-in",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            200,
            190,
            60,
            22
          ],
          "text": "midiin"
        }
      },
      {
        "box": {
          "id": "obj-out",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            220,
            65,
            22
          ],
          "text": "midiout"
        }
      },
      {
        "box": {
          "id": "obj-ttl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            400,
            20,
            156,
            22
          ],
          "fontsize": 12,
          "fontface": 1,
          "text": "SY.CORE Link Receive",
          "presentation": 1,
          "presentation_rect": [
            8,
            6,
            200,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-chl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            400,
            50,
            65,
            22
          ],
          "text": "Channel",
          "presentation": 1,
          "presentation_rect": [
            76,
            34,
            80,
            18
          ]
        }
      },
      {
        "box": {
          "id": "obj-hint",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            400,
            80,
            380,
            22
          ],
          "textcolor": [
            0.6,
            0.6,
            0.6,
            1
          ],
          "text": "Needs the SY.CORE Link device on a track of this set",
          "presentation": 1,
          "presentation_rect": [
            8,
            60,
            190,
            32
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "obj-rcv",
            0
          ],
          "destination": [
            "obj-ft",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ft",
            1
          ],
          "destination": [
            "obj-fn",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fn",
            0
          ],
          "destination": [
            "obj-fx",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-menu",
            0
          ],
          "destination": [
            "obj-fx",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fx",
            0
          ],
          "destination": [
            "obj-fg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ft",
            0
          ],
          "destination": [
            "obj-fg",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-fg",
            0
          ],
          "destination": [
            "obj-iter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-iter",
            0
          ],
          "destination": [
            "obj-out",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-in",
            0
          ],
          "destination": [
            "obj-out",
            0
          ]
        }
      }
    ]
  }
}