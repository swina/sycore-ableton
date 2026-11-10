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
      1900,
      640
    ],
    "openinpresentation": 1,
    "devicewidth": 460,
    "boxes": [
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
            149,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            6,
            200,
            20
          ],
          "text": "SY.CORE MAP · spike",
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
          "id": "obj-mi",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            900,
            100,
            58,
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
            900,
            140,
            65,
            22
          ],
          "text": "midiout"
        }
      },
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
          "id": "obj-js",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            120,
            464,
            22
          ],
          "text": "js C:/Users/swina/Documents/sycore-map-spike/sycore-map-spike.js"
        }
      },
      {
        "box": {
          "id": "obj-fol",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            300,
            20,
            58,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            34,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Follow",
              "parameter_shortname": "Follow",
              "parameter_type": 2,
              "parameter_mmax": 1,
              "parameter_enum": [
                "off",
                "on"
              ],
              "parameter_initial_enable": 1,
              "parameter_initial": [
                1
              ]
            }
          }
        }
      },
      {
        "box": {
          "fontsize": 10,
          "id": "obj-folc",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            300,
            50,
            163,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            30,
            33,
            140,
            18
          ],
          "text": "Follow selected track",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-folp",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            300,
            80,
            114,
            22
          ],
          "text": "prepend follow"
        }
      },
      {
        "box": {
          "id": "obj-dial",
          "maxclass": "live.dial",
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
            51,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            100,
            44,
            48
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Slot 1",
              "parameter_shortname": "Slot 1",
              "parameter_type": 0,
              "parameter_mmin": 0,
              "parameter_mmax": 1
            }
          }
        }
      },
      {
        "box": {
          "id": "obj-dialp",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            420,
            80,
            100,
            22
          ],
          "text": "prepend dial"
        }
      },
      {
        "box": {
          "id": "obj-sw",
          "maxclass": "live.toggle",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            520,
            20,
            51,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            70,
            108,
            16,
            16
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_longname": "Sweep 16",
              "parameter_shortname": "Sweep",
              "parameter_type": 2,
              "parameter_mmax": 1,
              "parameter_enum": [
                "off",
                "on"
              ]
            }
          }
        }
      },
      {
        "box": {
          "fontsize": 10,
          "id": "obj-swc",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            520,
            50,
            142,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            90,
            107,
            130,
            18
          ],
          "text": "Sweep all 16 (CPU)",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-swp",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            520,
            80,
            107,
            22
          ],
          "text": "prepend sweep"
        }
      },
      {
        "box": {
          "id": "obj-dump",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640,
            80,
            50,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            240,
            106,
            50,
            20
          ],
          "text": "dump"
        }
      },
      {
        "box": {
          "fontsize": 10,
          "id": "obj-dumpc",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            80,
            107,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            296,
            107,
            100,
            18
          ],
          "text": "→ Max console",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ]
        }
      },
      {
        "box": {
          "id": "obj-rt",
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
            400,
            121,
            22
          ],
          "text": "route info time"
        }
      },
      {
        "box": {
          "id": "obj-ps1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            430,
            93,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-ps2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            160,
            430,
            93,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "fontsize": 10,
          "id": "obj-inf",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            460,
            50,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            56,
            440,
            18
          ],
          "text": "—",
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
          "fontsize": 10,
          "id": "obj-tim",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            160,
            490,
            50,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            76,
            440,
            18
          ],
          "text": "—",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
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
            180,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
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
            220,
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
            250,
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
            290,
            100,
            22
          ],
          "text": "live.remote~"
        }
      },
      {
        "box": {
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
            50,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            0,
            0,
            460,
            169
          ],
          "rounded": 6
        }
      }
    ],
    "lines": [
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
      },
      {
        "patchline": {
          "source": [
            "obj-dev",
            0
          ],
          "destination": [
            "obj-js",
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
            "obj-folp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-folp",
            0
          ],
          "destination": [
            "obj-js",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-dial",
            0
          ],
          "destination": [
            "obj-dialp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-dialp",
            0
          ],
          "destination": [
            "obj-js",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-sw",
            0
          ],
          "destination": [
            "obj-swp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-swp",
            0
          ],
          "destination": [
            "obj-js",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-dump",
            0
          ],
          "destination": [
            "obj-js",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-js",
            1
          ],
          "destination": [
            "obj-rt",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rt",
            0
          ],
          "destination": [
            "obj-ps1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rt",
            1
          ],
          "destination": [
            "obj-ps2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ps1",
            0
          ],
          "destination": [
            "obj-inf",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ps2",
            0
          ],
          "destination": [
            "obj-tim",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-js",
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
      }
    ]
  }
}