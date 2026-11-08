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
      1000,
      520
    ],
    "openinpresentation": 0,
    "boxes": [
      {
        "box": {
          "id": "obj-dev",
          "maxclass": "newobj",
          "text": "live.thisdevice",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tb",
          "maxclass": "newobj",
          "text": "t b b",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-path",
          "maxclass": "message",
          "text": "path live_set",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-lp",
          "maxclass": "newobj",
          "text": "live.path",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obP",
          "maxclass": "newobj",
          "text": "live.observer is_playing",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obB",
          "maxclass": "newobj",
          "text": "live.observer current_song_time",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obT",
          "maxclass": "newobj",
          "text": "live.observer tempo",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obN",
          "maxclass": "newobj",
          "text": "live.observer signature_numerator",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obD",
          "maxclass": "newobj",
          "text": "live.observer signature_denominator",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-pak",
          "maxclass": "newobj",
          "text": "pak 0 0. 0. 4 4",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-pre",
          "maxclass": "newobj",
          "text": "prepend transport",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tpath",
          "maxclass": "message",
          "text": "path this_device canonical_parent",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tlp",
          "maxclass": "newobj",
          "text": "live.path",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-obName",
          "maxclass": "newobj",
          "text": "live.observer name",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tpre",
          "maxclass": "newobj",
          "text": "prepend track",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-start",
          "maxclass": "message",
          "text": "script start",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-inst",
          "maxclass": "message",
          "text": "script npm install",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-node",
          "maxclass": "newobj",
          "text": "node.script C:/Users/swina/Documents/sycore-link/sycore-link.js @autostart 1",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-route",
          "maxclass": "newobj",
          "text": "route midi3 midi2 clear status",
          "numinlets": 1,
          "numoutlets": 5,
          "outlettype": [
            "",
            "",
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            300,
            226,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-t3",
          "maxclass": "newobj",
          "text": "t l b",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tr3",
          "maxclass": "newobj",
          "text": "transport",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-ex3",
          "maxclass": "newobj",
          "text": "expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            420,
            345,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-up3",
          "maxclass": "newobj",
          "text": "unpack 0 0 0 0.",
          "numinlets": 1,
          "numoutlets": 4,
          "outlettype": [
            "",
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            390,
            121,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pipe3",
          "maxclass": "newobj",
          "text": "pipe 0 0 0 0",
          "numinlets": 4,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            450,
            100,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pk3",
          "maxclass": "newobj",
          "text": "pack 0 0 0",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            480,
            86,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-t2",
          "maxclass": "newobj",
          "text": "t l b",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-tr2",
          "maxclass": "newobj",
          "text": "transport",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-ex2",
          "maxclass": "newobj",
          "text": "expr max(0.\\, ($f1*$f4 - $f2)*60000./($f3*$f4))",
          "numinlets": 4,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            380,
            420,
            345,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-up2",
          "maxclass": "newobj",
          "text": "unpack 0 0 0.",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            380,
            390,
            107,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pipe2",
          "maxclass": "newobj",
          "text": "pipe 0 0 0",
          "numinlets": 3,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            380,
            450,
            86,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pk2",
          "maxclass": "newobj",
          "text": "pack 0 0",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            380,
            480,
            72,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-tclr",
          "maxclass": "newobj",
          "text": "t clear clear",
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
          ]
        }
      },
      {
        "box": {
          "id": "obj-in",
          "maxclass": "newobj",
          "text": "midiin",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            470,
            370,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-iter",
          "maxclass": "newobj",
          "text": "iter",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            510,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-out",
          "maxclass": "newobj",
          "text": "midiout",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            540,
            65,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-set",
          "maxclass": "newobj",
          "text": "prepend set",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            470,
            300,
            93,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-stat",
          "maxclass": "message",
          "text": "0",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            470,
            330,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-c1",
          "maxclass": "comment",
          "text": "SY.CORE Link · clients connected",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            520,
            330,
            240,
            22
          ]
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
            "obj-up3",
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
            "obj-up3",
            3
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
            "obj-pipe3",
            3
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
            "obj-pk3",
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
            "obj-up2",
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
            "obj-up2",
            2
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
            "obj-pipe2",
            2
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
            "obj-pk2",
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
            "obj-set",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-set",
            0
          ],
          "destination": [
            "obj-stat",
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