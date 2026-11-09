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
          "id": "obj-chan",
          "maxclass": "live.numbox",
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            360,
            360,
            60,
            22
          ],
          "saved_attribute_attributes": {
            "valueof": {
              "parameter_initial": [
                1
              ],
              "parameter_initial_enable": 1,
              "parameter_mmin": 1,
              "parameter_mmax": 16,
              "parameter_longname": "MIDI Channel",
              "parameter_shortname": "Channel",
              "parameter_type": 1
            }
          },
          "varname": "MIDI Channel"
        }
      },
      {
        "box": {
          "id": "obj-cdev",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "",
            "",
            ""
          ],
          "patching_rect": [
            360,
            320,
            121,
            22
          ],
          "text": "live.thisdevice"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b1",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            360,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 1",
              "parameter_shortname": "1"
            }
          },
          "text": "1",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "1",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 1"
        }
      },
      {
        "box": {
          "id": "obj-s1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            360,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m1",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360,
            240,
            60,
            22
          ],
          "text": "1"
        }
      },
      {
        "box": {
          "id": "obj-e1",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360,
            420,
            60,
            22
          ],
          "text": "== 1"
        }
      },
      {
        "box": {
          "id": "obj-p1",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            360,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b2",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            400,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            32.5,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 2",
              "parameter_shortname": "2"
            }
          },
          "text": "2",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "2",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 2"
        }
      },
      {
        "box": {
          "id": "obj-s2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            400,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m2",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400,
            240,
            60,
            22
          ],
          "text": "2"
        }
      },
      {
        "box": {
          "id": "obj-e2",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400,
            420,
            60,
            22
          ],
          "text": "== 2"
        }
      },
      {
        "box": {
          "id": "obj-p2",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            400,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b3",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            440,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            57,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 3",
              "parameter_shortname": "3"
            }
          },
          "text": "3",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "3",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 3"
        }
      },
      {
        "box": {
          "id": "obj-s3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            440,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m3",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            440,
            240,
            60,
            22
          ],
          "text": "3"
        }
      },
      {
        "box": {
          "id": "obj-e3",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            440,
            420,
            60,
            22
          ],
          "text": "== 3"
        }
      },
      {
        "box": {
          "id": "obj-p3",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            440,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b4",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            480,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            81.5,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 4",
              "parameter_shortname": "4"
            }
          },
          "text": "4",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "4",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 4"
        }
      },
      {
        "box": {
          "id": "obj-s4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            480,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m4",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            480,
            240,
            60,
            22
          ],
          "text": "4"
        }
      },
      {
        "box": {
          "id": "obj-e4",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            480,
            420,
            60,
            22
          ],
          "text": "== 4"
        }
      },
      {
        "box": {
          "id": "obj-p4",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            480,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b5",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            520,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            106,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 5",
              "parameter_shortname": "5"
            }
          },
          "text": "5",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "5",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 5"
        }
      },
      {
        "box": {
          "id": "obj-s5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            520,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m5",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            520,
            240,
            60,
            22
          ],
          "text": "5"
        }
      },
      {
        "box": {
          "id": "obj-e5",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            520,
            420,
            60,
            22
          ],
          "text": "== 5"
        }
      },
      {
        "box": {
          "id": "obj-p5",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            520,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b6",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            560,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            130.5,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 6",
              "parameter_shortname": "6"
            }
          },
          "text": "6",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "6",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 6"
        }
      },
      {
        "box": {
          "id": "obj-s6",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            560,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m6",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            560,
            240,
            60,
            22
          ],
          "text": "6"
        }
      },
      {
        "box": {
          "id": "obj-e6",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            560,
            420,
            60,
            22
          ],
          "text": "== 6"
        }
      },
      {
        "box": {
          "id": "obj-p6",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            560,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b7",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            600,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 7",
              "parameter_shortname": "7"
            }
          },
          "text": "7",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "7",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 7"
        }
      },
      {
        "box": {
          "id": "obj-s7",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            600,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m7",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            240,
            60,
            22
          ],
          "text": "7"
        }
      },
      {
        "box": {
          "id": "obj-e7",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            420,
            60,
            22
          ],
          "text": "== 7"
        }
      },
      {
        "box": {
          "id": "obj-p7",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            600,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b8",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            640,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            179.5,
            78,
            22.5,
            20
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
              "parameter_longname": "Ch 8",
              "parameter_shortname": "8"
            }
          },
          "text": "8",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "8",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 8"
        }
      },
      {
        "box": {
          "id": "obj-s8",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            640,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m8",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640,
            240,
            60,
            22
          ],
          "text": "8"
        }
      },
      {
        "box": {
          "id": "obj-e8",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640,
            420,
            60,
            22
          ],
          "text": "== 8"
        }
      },
      {
        "box": {
          "id": "obj-p8",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            640,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b9",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            680,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 9",
              "parameter_shortname": "9"
            }
          },
          "text": "9",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "9",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 9"
        }
      },
      {
        "box": {
          "id": "obj-s9",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            680,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m9",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            680,
            240,
            60,
            22
          ],
          "text": "9"
        }
      },
      {
        "box": {
          "id": "obj-e9",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            680,
            420,
            60,
            22
          ],
          "text": "== 9"
        }
      },
      {
        "box": {
          "id": "obj-p9",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            680,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b10",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            720,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            32.5,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 10",
              "parameter_shortname": "10"
            }
          },
          "text": "10",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "10",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 10"
        }
      },
      {
        "box": {
          "id": "obj-s10",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            720,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m10",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            720,
            240,
            60,
            22
          ],
          "text": "10"
        }
      },
      {
        "box": {
          "id": "obj-e10",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            720,
            420,
            60,
            22
          ],
          "text": "== 10"
        }
      },
      {
        "box": {
          "id": "obj-p10",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            720,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b11",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            760,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            57,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 11",
              "parameter_shortname": "11"
            }
          },
          "text": "11",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "11",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 11"
        }
      },
      {
        "box": {
          "id": "obj-s11",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            760,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m11",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            760,
            240,
            60,
            22
          ],
          "text": "11"
        }
      },
      {
        "box": {
          "id": "obj-e11",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            760,
            420,
            60,
            22
          ],
          "text": "== 11"
        }
      },
      {
        "box": {
          "id": "obj-p11",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            760,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b12",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            800,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            81.5,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 12",
              "parameter_shortname": "12"
            }
          },
          "text": "12",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "12",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 12"
        }
      },
      {
        "box": {
          "id": "obj-s12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            800,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m12",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            800,
            240,
            60,
            22
          ],
          "text": "12"
        }
      },
      {
        "box": {
          "id": "obj-e12",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            800,
            420,
            60,
            22
          ],
          "text": "== 12"
        }
      },
      {
        "box": {
          "id": "obj-p12",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            800,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b13",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            840,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            106,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 13",
              "parameter_shortname": "13"
            }
          },
          "text": "13",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "13",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 13"
        }
      },
      {
        "box": {
          "id": "obj-s13",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            840,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m13",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            840,
            240,
            60,
            22
          ],
          "text": "13"
        }
      },
      {
        "box": {
          "id": "obj-e13",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            840,
            420,
            60,
            22
          ],
          "text": "== 13"
        }
      },
      {
        "box": {
          "id": "obj-p13",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            840,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b14",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            880,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            130.5,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 14",
              "parameter_shortname": "14"
            }
          },
          "text": "14",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "14",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 14"
        }
      },
      {
        "box": {
          "id": "obj-s14",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            880,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m14",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            880,
            240,
            60,
            22
          ],
          "text": "14"
        }
      },
      {
        "box": {
          "id": "obj-e14",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            880,
            420,
            60,
            22
          ],
          "text": "== 14"
        }
      },
      {
        "box": {
          "id": "obj-p14",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            880,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b15",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            920,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            155,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 15",
              "parameter_shortname": "15"
            }
          },
          "text": "15",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "15",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 15"
        }
      },
      {
        "box": {
          "id": "obj-s15",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            920,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m15",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            920,
            240,
            60,
            22
          ],
          "text": "15"
        }
      },
      {
        "box": {
          "id": "obj-e15",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            920,
            420,
            60,
            22
          ],
          "text": "== 15"
        }
      },
      {
        "box": {
          "id": "obj-p15",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            920,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
            0.541,
            0.561,
            0.573,
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
          "id": "obj-b16",
          "maxclass": "live.text",
          "mode": 1,
          "numinlets": 1,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "parameter_enable": 1,
          "patching_rect": [
            960,
            180,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            179.5,
            100,
            22.5,
            20
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
              "parameter_longname": "Ch 16",
              "parameter_shortname": "16"
            }
          },
          "text": "16",
          "textcolor": [
            0.541,
            0.561,
            0.573,
            1
          ],
          "texton": "16",
          "textoncolor": [
            0,
            0,
            0,
            1
          ],
          "varname": "Ch 16"
        }
      },
      {
        "box": {
          "id": "obj-s16",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 2,
          "outlettype": [
            "",
            ""
          ],
          "patching_rect": [
            960,
            210,
            60,
            22
          ],
          "text": "sel 1"
        }
      },
      {
        "box": {
          "id": "obj-m16",
          "maxclass": "message",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            960,
            240,
            60,
            22
          ],
          "text": "16"
        }
      },
      {
        "box": {
          "id": "obj-e16",
          "maxclass": "newobj",
          "numinlets": 2,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            960,
            420,
            60,
            22
          ],
          "text": "== 16"
        }
      },
      {
        "box": {
          "id": "obj-p16",
          "maxclass": "newobj",
          "numinlets": 1,
          "numoutlets": 1,
          "outlettype": [
            ""
          ],
          "patching_rect": [
            960,
            450,
            93,
            22
          ],
          "text": "prepend set"
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
          "fontface": 1,
          "fontsize": 12,
          "id": "obj-ttl",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            400,
            20,
            100,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
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
          "id": "obj-sub",
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
          "presentation": 1,
          "presentation_rect": [
            8,
            27,
            80,
            18
          ],
          "text": "RECEIVE",
          "textcolor": [
            0,
            0.761,
            1,
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
            400,
            80,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            154,
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
            300,
            110,
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
            400,
            110,
            60,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            188,
            12,
            12,
            12
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
            400,
            140,
            65,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            58,
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
          "id": "obj-hint",
          "maxclass": "comment",
          "numinlets": 1,
          "numoutlets": 0,
          "outlettype": [],
          "patching_rect": [
            400,
            170,
            226,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            8,
            146,
            194,
            18
          ],
          "text": "Needs SY.CORE Link in this set",
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
            210,
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
            52,
            194,
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
            210,
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
            "obj-chan",
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
            "obj-cdev",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b1",
            0
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
            "obj-s1",
            0
          ],
          "destination": [
            "obj-m1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m1",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e1",
            0
          ],
          "destination": [
            "obj-p1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p1",
            0
          ],
          "destination": [
            "obj-b1",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b2",
            0
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
            "obj-s2",
            0
          ],
          "destination": [
            "obj-m2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m2",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e2",
            0
          ],
          "destination": [
            "obj-p2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p2",
            0
          ],
          "destination": [
            "obj-b2",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b3",
            0
          ],
          "destination": [
            "obj-s3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s3",
            0
          ],
          "destination": [
            "obj-m3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m3",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e3",
            0
          ],
          "destination": [
            "obj-p3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p3",
            0
          ],
          "destination": [
            "obj-b3",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b4",
            0
          ],
          "destination": [
            "obj-s4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s4",
            0
          ],
          "destination": [
            "obj-m4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m4",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e4",
            0
          ],
          "destination": [
            "obj-p4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p4",
            0
          ],
          "destination": [
            "obj-b4",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b5",
            0
          ],
          "destination": [
            "obj-s5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s5",
            0
          ],
          "destination": [
            "obj-m5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m5",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e5",
            0
          ],
          "destination": [
            "obj-p5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p5",
            0
          ],
          "destination": [
            "obj-b5",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b6",
            0
          ],
          "destination": [
            "obj-s6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s6",
            0
          ],
          "destination": [
            "obj-m6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m6",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e6",
            0
          ],
          "destination": [
            "obj-p6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p6",
            0
          ],
          "destination": [
            "obj-b6",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b7",
            0
          ],
          "destination": [
            "obj-s7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s7",
            0
          ],
          "destination": [
            "obj-m7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m7",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e7",
            0
          ],
          "destination": [
            "obj-p7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p7",
            0
          ],
          "destination": [
            "obj-b7",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b8",
            0
          ],
          "destination": [
            "obj-s8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s8",
            0
          ],
          "destination": [
            "obj-m8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m8",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e8",
            0
          ],
          "destination": [
            "obj-p8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p8",
            0
          ],
          "destination": [
            "obj-b8",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b9",
            0
          ],
          "destination": [
            "obj-s9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s9",
            0
          ],
          "destination": [
            "obj-m9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m9",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e9",
            0
          ],
          "destination": [
            "obj-p9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p9",
            0
          ],
          "destination": [
            "obj-b9",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b10",
            0
          ],
          "destination": [
            "obj-s10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s10",
            0
          ],
          "destination": [
            "obj-m10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m10",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e10",
            0
          ],
          "destination": [
            "obj-p10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p10",
            0
          ],
          "destination": [
            "obj-b10",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b11",
            0
          ],
          "destination": [
            "obj-s11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s11",
            0
          ],
          "destination": [
            "obj-m11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m11",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e11",
            0
          ],
          "destination": [
            "obj-p11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p11",
            0
          ],
          "destination": [
            "obj-b11",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b12",
            0
          ],
          "destination": [
            "obj-s12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s12",
            0
          ],
          "destination": [
            "obj-m12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m12",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e12",
            0
          ],
          "destination": [
            "obj-p12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p12",
            0
          ],
          "destination": [
            "obj-b12",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b13",
            0
          ],
          "destination": [
            "obj-s13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s13",
            0
          ],
          "destination": [
            "obj-m13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m13",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e13",
            0
          ],
          "destination": [
            "obj-p13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p13",
            0
          ],
          "destination": [
            "obj-b13",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b14",
            0
          ],
          "destination": [
            "obj-s14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s14",
            0
          ],
          "destination": [
            "obj-m14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m14",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e14",
            0
          ],
          "destination": [
            "obj-p14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p14",
            0
          ],
          "destination": [
            "obj-b14",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b15",
            0
          ],
          "destination": [
            "obj-s15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s15",
            0
          ],
          "destination": [
            "obj-m15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m15",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e15",
            0
          ],
          "destination": [
            "obj-p15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p15",
            0
          ],
          "destination": [
            "obj-b15",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-b16",
            0
          ],
          "destination": [
            "obj-s16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-s16",
            0
          ],
          "destination": [
            "obj-m16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-m16",
            0
          ],
          "destination": [
            "obj-chan",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-chan",
            0
          ],
          "destination": [
            "obj-e16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-e16",
            0
          ],
          "destination": [
            "obj-p16",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "obj-p16",
            0
          ],
          "destination": [
            "obj-b16",
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