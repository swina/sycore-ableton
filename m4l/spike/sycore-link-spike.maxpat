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
      760,
      560
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
            30,
            121,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-tb",
          "maxclass": "newobj",
          "text": "t b",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            60,
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
            90,
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
            120,
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
            160,
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
            200,
            160,
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
            420,
            160,
            149,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pak",
          "maxclass": "newobj",
          "text": "pak 0 0. 0.",
          "numinlets": 3,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            200,
            93,
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
            230,
            135,
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
            200,
            230,
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
            300,
            230,
            142,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-node",
          "maxclass": "newobj",
          "text": "node.script sycore-link-spike.js @autostart 1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            270,
            331,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-route",
          "maxclass": "newobj",
          "text": "route note status",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            310,
            135,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pipe",
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
            350,
            100,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-mk",
          "maxclass": "newobj",
          "text": "makenote 100 125",
          "numinlets": 3,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            390,
            128,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-pk",
          "maxclass": "newobj",
          "text": "pack 0 0",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            420,
            72,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-mf",
          "maxclass": "newobj",
          "text": "midiformat",
          "numinlets": 7,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            450,
            86,
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
            300,
            420,
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
            490,
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
            260,
            350,
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
            260,
            380,
            60,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-c1",
          "maxclass": "comment",
          "text": "SY.CORE Link spike · clients:",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            360,
            380,
            219,
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
            0
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
            "obj-pipe",
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
            "obj-pipe",
            0
          ],
          "destination": [
            "obj-mk",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe",
            1
          ],
          "destination": [
            "obj-mk",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pipe",
            2
          ],
          "destination": [
            "obj-mk",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mk",
            0
          ],
          "destination": [
            "obj-pk",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mk",
            1
          ],
          "destination": [
            "obj-pk",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-pk",
            0
          ],
          "destination": [
            "obj-mf",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-mf",
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