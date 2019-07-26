import ansiparse, strutils, tables

const styleTable = {
  "1": "font-weight: bold",
  "3": "font-style: italic",
  "4": "text-decoration: underline",
  "22": "font-weight: normal",
  "23": "font-style: normal",
  "24": "text-decoration: none",
  "30": "color: black",
  "31": "color: maroon",
  "32": "color: green",
  "33": "color: orange",
  "34": "color: blue",
  "35": "color: purple",
  "36": "color: teal",
  "37": "color: silver",
  "40": "background-color: black",
  "41": "background-color: maroon",
  "42": "background-color: green",
  "43": "background-color: orange",
  "44": "background-color: blue",
  "45": "background-color: purple",
  "46": "background-color: teal",
  "47": "background-color: silver",
  "90": "color: gray",
  "91": "color: red",
  "92": "color: lime",
  "93": "color: yellow",
  "94": "color: blue",
  "95": "color: fuchsia",
  "96": "color: aqua",
  "97": "color: white",
  "100": "background-color: gray",
  "101": "background-color: red",
  "102": "background-color: lime",
  "103": "background-color: yellow",
  "104": "background-color: blue",
  "105": "background-color: fuchsia",
  "106": "background-color: aqua",
  "107": "background-color: white"

}.toTable

proc ansiToHtml*(input: string, styleTable = styleTable): string =
  let ansiSequence = input.parseAnsi()
  for part in ansiSequence:
    case part.kind:
    of String: result.add part.str
    of CSI:
      if part.final == 'm':
        let parameters = part.parameters.split({';', ':'})
        if parameters[^1] == "0" or part.parameters.len == 0:
          result.add "</span>"
        else:
          var
            styles = ""
            i = 0
          while i < parameters.len:
            let param = parameters[i]
            if param == "38" or param == "48":
              if i+2 < parameters.len:
                let style = if param == "48": "background-color:" else: "color:"
                if parameters[i+1] == "5":
                  let colourid = parseInt(parameters[i+2])
                  if colourid < 8:
                    styles.add styleTable[$(colourid + (if param == "48": 40 else: 30))] & ";"
                  elif colourid < 16:
                    styles.add styleTable[$(colourid + (if param == "48": 100 else: 90))] & ";"
                  elif colourid > 231:
                    let c = (colourid - 232) * 10 + 8
                    styles.add style & " rgb(" & $c & "," & $c & "," & $c & ");"
                  else:
                    let
                      r = (colourid - 16) div 36
                      g = ((colourid - 16) mod 36) div 6
                      b = (colourid - 16) mod 6
                    styles.add style & " rgb(" &
                      $(if r == 0: 0 else: 55 + r * 40) & "," &
                      $(if g == 0: 0 else: 55 + g * 40) & "," &
                      $(if b == 0: 0 else: 55 + b * 40) & ");"
                  i += 2
                elif parameters[i+1] == "2" and i+4 < parameters.len:
                  styles.add style & " rgb(" &
                    parameters[i+2] & "," &
                    parameters[i+3] & "," &
                    parameters[i+4] & ");"
                  i += 4
            elif styleTable.hasKey(param):
              styles.add styleTable[param] & ";"
            i += 1
          result.add "<span style=\"" & styles & "\">"
