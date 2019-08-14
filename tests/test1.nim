# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import ansitohtml
import tables

test "Simple colour":
  check "Hello \e[31mworld\e[m".ansiToHtml ==
    "Hello <span style=\"color: maroon;\">world</span>"

test "Custom table":
  check "Hello \e[31mworld\e[m".ansiToHtml({"31": "color: green"}.toTable) ==
    "Hello <span style=\"color: green;\">world</span>"

test "Complex colour":
  check "Hello \e[38;5;247;48;2;112;100;30mworld\e[m".ansiToHtml ==
    "Hello <span style=\"color: rgb(158,158,158);background-color: rgb(112,100,30);\">world</span>"

test "End and begin right after each other":
  check "\e[31mHello \e[m\e[34mworld\e[m".ansiToHtml ==
    "<span style=\"color: maroon;\">Hello </span><span style=\"color: blue;\">world</span>"

test "Custom table expands default table":
  check "\e[34mHello\e[m \e[31mworld\e[m".ansiToHtml({"31": "color: green"}.toTable) ==
    "<span style=\"color: blue;\">Hello</span> <span style=\"color: green;\">world</span>"
