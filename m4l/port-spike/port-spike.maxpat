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
      900,
      520
    ],
    "openinpresentation": 1,
    "devicewidth": 570,
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
          "id": "obj-inst",
          "maxclass": "message",
          "text": "script npm install",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            270,
            142,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            4,
            4,
            110,
            20
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
            160,
            270,
            100,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            118,
            4,
            70,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-ports",
          "maxclass": "message",
          "text": "ports",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            260,
            270,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            192,
            4,
            44,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-pW1",
          "maxclass": "message",
          "text": "port MIDIWIN (B)",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            320,
            240,
            128,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            4,
            28,
            110,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-pW2",
          "maxclass": "message",
          "text": "port MIDI WIN 2 (B)",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            450,
            240,
            149,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            118,
            28,
            124,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-pW3",
          "maxclass": "message",
          "text": "port MIDI WIN 3 (B)",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            240,
            149,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            246,
            28,
            124,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-pSyc",
          "maxclass": "message",
          "text": "port SYC OUT A",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            750,
            240,
            114,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            374,
            28,
            104,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-chN",
          "maxclass": "number",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            510,
            270,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            532,
            28,
            34,
            20
          ],
          "minimum": 1,
          "maximum": 16
        }
      },
      {
        "box": {
          "id": "obj-chP",
          "maxclass": "newobj",
          "text": "prepend channel",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            510,
            295,
            121,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-chL",
          "maxclass": "comment",
          "text": "channel:",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            450,
            270,
            72,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            484,
            30,
            50,
            18
          ]
        }
      },
      {
        "box": {
          "id": "obj-pOn",
          "maxclass": "message",
          "text": "pattern on",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            590,
            270,
            86,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            250,
            4,
            70,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-pOff",
          "maxclass": "message",
          "text": "pattern off",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            670,
            270,
            93,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            324,
            4,
            74,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-node",
          "maxclass": "newobj",
          "text": "node.script C:/Users/swina/Documents/sycore-port-spike/port-spike.js @autostart 1",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            30,
            310,
            583,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-route",
          "maxclass": "newobj",
          "text": "route stats port",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            30,
            350,
            128,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-setS",
          "maxclass": "newobj",
          "text": "prepend set",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            380,
            93,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-stat",
          "maxclass": "message",
          "text": "-",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            30,
            410,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            4,
            78,
            562,
            20
          ]
        }
      },
      {
        "box": {
          "id": "obj-setP",
          "maxclass": "newobj",
          "text": "prepend set",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            330,
            380,
            93,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-portM",
          "maxclass": "message",
          "text": "-",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            330,
            410,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            4,
            54,
            562,
            20
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
            560,
            380,
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
            560,
            410,
            65,
            22
          ]
        }
      },
      {
        "box": {
          "id": "obj-c1",
          "maxclass": "comment",
          "text": "Pick a port (ports: list in the Max console) and a channel, Live in Play: a C chord on every beat. Stats: lateness of the sends (timer quality).",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            30,
            440,
            1024,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            4,
            104,
            562,
            36
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
            "obj-ports",
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
            "obj-pW1",
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
            "obj-pW2",
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
            "obj-pW3",
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
            "obj-pSyc",
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
            "obj-pOn",
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
            "obj-pOff",
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
            "obj-chN",
            0
          ],
          "destination": [
            "obj-chP",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chP",
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
            "obj-setS",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-setS",
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
            "obj-route",
            1
          ],
          "destination": [
            "obj-setP",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-setP",
            0
          ],
          "destination": [
            "obj-portM",
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