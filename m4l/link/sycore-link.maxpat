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
    "devicewidth": 270,
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
          "id": "obj-tb",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            50,
            60,
            22
          ],
          "text": "t b b"
        }
      },
      {
        "box": {
          "id": "obj-path",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            80,
            107,
            22
          ],
          "text": "path live_set"
        }
      },
      {
        "box": {
          "id": "obj-lp",
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
            110,
            79,
            22
          ],
          "text": "live.path"
        }
      },
      {
        "box": {
          "id": "obj-obP",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            150,
            184,
            22
          ],
          "text": "live.observer is_playing"
        }
      },
      {
        "box": {
          "id": "obj-obB",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            190,
            150,
            233,
            22
          ],
          "text": "live.observer current_song_time"
        }
      },
      {
        "box": {
          "id": "obj-obT",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            400,
            150,
            149,
            22
          ],
          "text": "live.observer tempo"
        }
      },
      {
        "box": {
          "id": "obj-obN",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            540,
            150,
            247,
            22
          ],
          "text": "live.observer signature_numerator"
        }
      },
      {
        "box": {
          "id": "obj-obD",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            770,
            150,
            261,
            22
          ],
          "text": "live.observer signature_denominator"
        }
      },
      {
        "box": {
          "id": "obj-pak",
          "maxclass": "newobj",
          "numinlets": 5,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            190,
            121,
            22
          ],
          "text": "pak 0 0. 0. 4 4"
        }
      },
      {
        "box": {
          "id": "obj-pre",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            220,
            135,
            22
          ],
          "text": "prepend transport"
        }
      },
      {
        "box": {
          "id": "obj-tdel",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            760,
            20,
            72,
            22
          ],
          "text": "del 1500"
        }
      },
      {
        "box": {
          "id": "obj-tpath",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            50,
            247,
            22
          ],
          "text": "path this_device canonical_parent"
        }
      },
      {
        "box": {
          "id": "obj-tlp",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            600,
            80,
            79,
            22
          ],
          "text": "live.path"
        }
      },
      {
        "box": {
          "id": "obj-obName",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            600,
            110,
            142,
            22
          ],
          "text": "live.observer name"
        }
      },
      {
        "box": {
          "id": "obj-tpre",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            220,
            107,
            22
          ],
          "text": "prepend track"
        }
      },
      {
        "box": {
          "id": "obj-start",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            250,
            220,
            100,
            22
          ],
          "text": "script start"
        }
      },
      {
        "box": {
          "id": "obj-inst",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            350,
            220,
            142,
            22
          ],
          "text": "script npm install"
        }
      },
      {
        "box": {
          "id": "obj-node",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            260,
            548,
            22
          ],
          "text": "node.script C:/Users/swina/Documents/sycore-link/sycore-link.js @autostart 1"
        }
      },
      {
        "box": {
          "id": "obj-route",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 9,
          "outlettype": [
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
            300,
            352,
            22
          ],
          "text": "route midi3 midi2 clear info stats state rig map"
        }
      },
      {
        "box": {
          "id": "obj-rigs",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1000,
            300,
            100,
            22
          ],
          "text": "s sycore_rig"
        }
      },
      {
        "box": {
          "id": "obj-rigr",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1000,
            220,
            121,
            22
          ],
          "text": "r sycore_rig_in"
        }
      },
      {
        "box": {
          "id": "obj-maps",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            1140,
            300,
            100,
            22
          ],
          "text": "s sycore_map"
        }
      },
      {
        "box": {
          "id": "obj-mapr",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1140,
            220,
            121,
            22
          ],
          "text": "r sycore_map_in"
        }
      },
      {
        "box": {
          "id": "obj-t3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            330,
            60,
            22
          ],
          "text": "t l b"
        }
      },
      {
        "box": {
          "id": "obj-tr3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 9,
          "outlettype": [
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
            120,
            360,
            79,
            22
          ],
          "text": "transport"
        }
      },
      {
        "box": {
          "id": "obj-sl3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            360,
            86,
            22
          ],
          "text": "zl.slice 3"
        }
      },
      {
        "box": {
          "id": "obj-ex3",
          "maxclass": "newobj",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            120,
            390,
            345,
            22
          ],
          "text": "expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))"
        }
      },
      {
        "box": {
          "id": "obj-td3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            120,
            410,
            60,
            22
          ],
          "text": "t f f"
        }
      },
      {
        "box": {
          "id": "obj-gt3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            200,
            430,
            60,
            22
          ],
          "text": "> 0.5"
        }
      },
      {
        "box": {
          "id": "obj-gp3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            200,
            450,
            60,
            22
          ],
          "text": "+ 1"
        }
      },
      {
        "box": {
          "id": "obj-g3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            430,
            60,
            22
          ],
          "text": "gate 2"
        }
      },
      {
        "box": {
          "id": "obj-up3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            90,
            450,
            100,
            22
          ],
          "text": "unpack 0 0 0"
        }
      },
      {
        "box": {
          "id": "obj-pipe3",
          "maxclass": "newobj",
          "numinlets": 4,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            90,
            470,
            100,
            22
          ],
          "text": "pipe 0 0 0 0"
        }
      },
      {
        "box": {
          "id": "obj-pk3",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            90,
            490,
            86,
            22
          ],
          "text": "pack 0 0 0"
        }
      },
      {
        "box": {
          "id": "obj-t2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            380,
            330,
            60,
            22
          ],
          "text": "t l b"
        }
      },
      {
        "box": {
          "id": "obj-tr2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 9,
          "outlettype": [
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
            470,
            360,
            79,
            22
          ],
          "text": "transport"
        }
      },
      {
        "box": {
          "id": "obj-sl2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            380,
            360,
            86,
            22
          ],
          "text": "zl.slice 2"
        }
      },
      {
        "box": {
          "id": "obj-ex2",
          "maxclass": "newobj",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            470,
            390,
            345,
            22
          ],
          "text": "expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))"
        }
      },
      {
        "box": {
          "id": "obj-td2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            470,
            410,
            60,
            22
          ],
          "text": "t f f"
        }
      },
      {
        "box": {
          "id": "obj-gt2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            550,
            430,
            60,
            22
          ],
          "text": "> 0.5"
        }
      },
      {
        "box": {
          "id": "obj-gp2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            550,
            450,
            60,
            22
          ],
          "text": "+ 1"
        }
      },
      {
        "box": {
          "id": "obj-g2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            380,
            430,
            60,
            22
          ],
          "text": "gate 2"
        }
      },
      {
        "box": {
          "id": "obj-up2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            440,
            450,
            86,
            22
          ],
          "text": "unpack 0 0"
        }
      },
      {
        "box": {
          "id": "obj-pipe2",
          "maxclass": "newobj",
          "numinlets": 3,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            440,
            470,
            86,
            22
          ],
          "text": "pipe 0 0 0"
        }
      },
      {
        "box": {
          "id": "obj-pk2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            440,
            490,
            72,
            22
          ],
          "text": "pack 0 0"
        }
      },
      {
        "box": {
          "id": "obj-tclr",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            330,
            340,
            107,
            22
          ],
          "text": "t clear clear"
        }
      },
      {
        "box": {
          "id": "obj-snd",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            250,
            520,
            142,
            22
          ],
          "text": "s sycore_link_midi"
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
            520,
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
            550,
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
            580,
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
            610,
            72,
            22
          ],
          "text": "gate 1 1"
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
          "activetextcolor": [
            0.961,
            0.961,
            0.961,
            1
          ],
          "bgcolor": [
            0.039,
            0.039,
            0.039,
            1
          ],
          "bgfillcolor_color": [
            0.039,
            0.039,
            0.039,
            1
          ],
          "fontsize": 10,
          "id": "obj-menu",
          "maxclass": "live.menu",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            360,
            550,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            66,
            90,
            62,
            18
          ],
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
          "textcolor": [
            0.961,
            0.961,
            0.961,
            1
          ],
          "tricolor": [
            0,
            0.761,
            1,
            1
          ],
          "varname": "Channel"
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
            650,
            60,
            22
          ],
          "text": "iter"
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
            680,
            65,
            22
          ],
          "text": "midiout"
        }
      },
      {
        "box": {
          "id": "obj-pinfo",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            700,
            300,
            93,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "obj-pstats",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            850,
            300,
            93,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "blinkcolor": [
            0.961,
            0.62,
            0.043,
            1
          ],
          "blinktime": 60,
          "id": "obj-sled",
          "ignoreclick": 1,
          "maxclass": "led",
          "numinlets": 1,
          "numoutlets": 1,
          "offcolor": [
            1,
            1,
            1,
            0.06
          ],
          "oncolor": [
            0.961,
            0.62,
            0.043,
            1
          ],
          "outlettype": [
            ""
          ],
          "patching_rect": [
            700,
            360,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            10,
            12,
            12,
            12
          ]
        }
      },
      {
        "box": {
          "id": "obj-ssel",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "patching_rect": [
            850,
            330,
            79,
            22
          ],
          "text": "sel 0 1 2"
        }
      },
      {
        "box": {
          "id": "obj-s0",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            850,
            360,
            219,
            22
          ],
          "text": "oncolor 0.961 0.62 0.043 1, 1"
        }
      },
      {
        "box": {
          "id": "obj-s1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1050,
            360,
            205,
            22
          ],
          "text": "oncolor 0. 0.639 0.439 1, 1"
        }
      },
      {
        "box": {
          "id": "obj-s2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            1250,
            360,
            226,
            22
          ],
          "text": "oncolor 0.937 0.267 0.267 1, 1"
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
            700,
            400,
            100,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            28,
            7,
            150,
            20
          ],
          "text": "SY.CORE LINK",
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
          "fontface": 1,
          "fontsize": 9,
          "id": "obj-actl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            430,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            214,
            9,
            34,
            18
          ],
          "text": "MIDI",
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
          "id": "obj-ab",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            460,
            60,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "blinkcolor": [
            0,
            0.761,
            1,
            1
          ],
          "blinktime": 60,
          "id": "obj-aled",
          "ignoreclick": 1,
          "maxclass": "led",
          "numinlets": 1,
          "numoutlets": 1,
          "offcolor": [
            1,
            1,
            1,
            0.06
          ],
          "oncolor": [
            0,
            0.761,
            1,
            1
          ],
          "outlettype": [
            ""
          ],
          "patching_rect": [
            700,
            460,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            248,
            12,
            12,
            12
          ]
        }
      },
      {
        "box": {
          "fontsize": 10,
          "id": "obj-info",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            490,
            79,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            32,
            254,
            18
          ],
          "text": "starting…",
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
          "id": "obj-stats",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            520,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            52,
            254,
            18
          ],
          "text": "–",
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
          "fontface": 1,
          "fontsize": 9,
          "id": "obj-chl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            550,
            65,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            90,
            60,
            18
          ],
          "text": "CHANNEL",
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
          "fontsize": 9,
          "id": "obj-chd",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            580,
            156,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            134,
            90,
            130,
            18
          ],
          "text": "played on this track",
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
          "fontsize": 9,
          "id": "obj-hint",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            700,
            610,
            254,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            146,
            254,
            18
          ],
          "text": "Other tracks: SY.CORE Link Receive",
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
            270,
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
            1,
            1,
            1,
            0.1
          ],
          "bgfillcolor_color": [
            1,
            1,
            1,
            0.1
          ],
          "bgfillcolor_type": "color",
          "border": 0,
          "id": "obj-div",
          "ignoreclick": 1,
          "maxclass": "panel",
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            900,
            80,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            76,
            254,
            1
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
            270,
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
            "obj-tb",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tb",
            1
          ],
          "destination": [
            "obj-path",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tb",
            0
          ],
          "destination": [
            "obj-tpath",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tb",
            0
          ],
          "destination": [
            "obj-tdel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tdel",
            0
          ],
          "destination": [
            "obj-tpath",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-path",
            0
          ],
          "destination": [
            "obj-lp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-lp",
            0
          ],
          "destination": [
            "obj-obP",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-lp",
            0
          ],
          "destination": [
            "obj-obB",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-lp",
            0
          ],
          "destination": [
            "obj-obT",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-lp",
            0
          ],
          "destination": [
            "obj-obN",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-lp",
            0
          ],
          "destination": [
            "obj-obD",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obP",
            0
          ],
          "destination": [
            "obj-pak",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obB",
            0
          ],
          "destination": [
            "obj-pak",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obT",
            0
          ],
          "destination": [
            "obj-pak",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obN",
            0
          ],
          "destination": [
            "obj-pak",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obD",
            0
          ],
          "destination": [
            "obj-pak",
            4
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pak",
            0
          ],
          "destination": [
            "obj-pre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pre",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tpath",
            0
          ],
          "destination": [
            "obj-tlp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tlp",
            0
          ],
          "destination": [
            "obj-obName",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-obName",
            0
          ],
          "destination": [
            "obj-tpre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tpre",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-start",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-inst",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            6
          ],
          "destination": [
            "obj-rigs",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-rigr",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            7
          ],
          "destination": [
            "obj-maps",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mapr",
            0
          ],
          "destination": [
            "obj-node",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-node",
            0
          ],
          "destination": [
            "obj-route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            0
          ],
          "destination": [
            "obj-t3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-t3",
            1
          ],
          "destination": [
            "obj-tr3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-t3",
            0
          ],
          "destination": [
            "obj-sl3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr3",
            7
          ],
          "destination": [
            "obj-ex3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr3",
            4
          ],
          "destination": [
            "obj-ex3",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr3",
            3
          ],
          "destination": [
            "obj-ex3",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-sl3",
            1
          ],
          "destination": [
            "obj-ex3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ex3",
            0
          ],
          "destination": [
            "obj-td3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-td3",
            1
          ],
          "destination": [
            "obj-pipe3",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-td3",
            0
          ],
          "destination": [
            "obj-gt3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-gt3",
            0
          ],
          "destination": [
            "obj-gp3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-gp3",
            0
          ],
          "destination": [
            "obj-g3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-sl3",
            0
          ],
          "destination": [
            "obj-g3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-g3",
            1
          ],
          "destination": [
            "obj-up3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-up3",
            2
          ],
          "destination": [
            "obj-pipe3",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-up3",
            1
          ],
          "destination": [
            "obj-pipe3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-up3",
            0
          ],
          "destination": [
            "obj-pipe3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe3",
            0
          ],
          "destination": [
            "obj-pk3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe3",
            1
          ],
          "destination": [
            "obj-pk3",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe3",
            2
          ],
          "destination": [
            "obj-pk3",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            1
          ],
          "destination": [
            "obj-t2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-t2",
            1
          ],
          "destination": [
            "obj-tr2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-t2",
            0
          ],
          "destination": [
            "obj-sl2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr2",
            7
          ],
          "destination": [
            "obj-ex2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr2",
            4
          ],
          "destination": [
            "obj-ex2",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tr2",
            3
          ],
          "destination": [
            "obj-ex2",
            3
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-sl2",
            1
          ],
          "destination": [
            "obj-ex2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ex2",
            0
          ],
          "destination": [
            "obj-td2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-td2",
            1
          ],
          "destination": [
            "obj-pipe2",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-td2",
            0
          ],
          "destination": [
            "obj-gt2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-gt2",
            0
          ],
          "destination": [
            "obj-gp2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-gp2",
            0
          ],
          "destination": [
            "obj-g2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-sl2",
            0
          ],
          "destination": [
            "obj-g2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-g2",
            1
          ],
          "destination": [
            "obj-up2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-up2",
            1
          ],
          "destination": [
            "obj-pipe2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-up2",
            0
          ],
          "destination": [
            "obj-pipe2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe2",
            0
          ],
          "destination": [
            "obj-pk2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe2",
            1
          ],
          "destination": [
            "obj-pk2",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pk3",
            0
          ],
          "destination": [
            "obj-snd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pk2",
            0
          ],
          "destination": [
            "obj-snd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pk3",
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
            "obj-pk2",
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
            "obj-g3",
            0
          ],
          "destination": [
            "obj-snd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-g2",
            0
          ],
          "destination": [
            "obj-snd",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-g3",
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
            "obj-g2",
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
            "obj-route",
            2
          ],
          "destination": [
            "obj-tclr",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tclr",
            0
          ],
          "destination": [
            "obj-pipe3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-tclr",
            1
          ],
          "destination": [
            "obj-pipe2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            3
          ],
          "destination": [
            "obj-pinfo",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pinfo",
            0
          ],
          "destination": [
            "obj-info",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            4
          ],
          "destination": [
            "obj-pstats",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pstats",
            0
          ],
          "destination": [
            "obj-stats",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-route",
            5
          ],
          "destination": [
            "obj-ssel",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ssel",
            0
          ],
          "destination": [
            "obj-s0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ssel",
            1
          ],
          "destination": [
            "obj-s1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ssel",
            2
          ],
          "destination": [
            "obj-s2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s0",
            0
          ],
          "destination": [
            "obj-sled",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s1",
            0
          ],
          "destination": [
            "obj-sled",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s2",
            0
          ],
          "destination": [
            "obj-sled",
            0
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
            "obj-ab",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-ab",
            0
          ],
          "destination": [
            "obj-aled",
            0
          ]
        }
      }
    ]
  }
}