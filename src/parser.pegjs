start
  = i:indent exp:expression newlines? o:getOffset { return [i, exp, o]; }

getOffset
  = "" { return offset; }

indent
  = i:(indentSpace*) { return i.reduce(function(a, b) { return a + b; }, 0); }

indentSpace
  = " " { return 1; }
  / "\t" { return 8; }

expression
  = c:constructor newlines whitespace op:operator whitespace exp:expression { return ["operator", op, c, exp] }
  / c:constructor whitespace op:operator whitespace { return ["layoutOperator", op, c] }
  / constructor

constructor
  = c:block args:(whitespace b:block { return b; })* { return ["constructor", c, args]; }

innerExpression
  = "(" whitespace exp:expression whitespace ")" { return ["innerExpression", exp]; }

leftSection
  = "(" whitespace exp:expression whitespace op:operator ")" { return ["leftSection", op, exp]; }

rightSection
  = "(" op:operator whitespace exp:expression whitespace ")" { return ["rightSection", op, exp]; }

section
  = leftSection
  / rightSection

block
  = innerExpression
  / section
  / atom

operator
  = opsymbol
  / "`" id:letterid "`" { return id; }

variable
  = "\\" id:letterid { return id; }

atom
  = n:number { return ["number", n]; }
  / v:variable { return ["variable", v]; }
  / i:identifier { return ["identifier", i]; }

digit
  = [0-9]

octit
  = [0-7]

hexit
  = [0-9A-Fa-f]

decimal
  = digits:digit+ { return digits.join(""); }

octal
  = octits:octit+ { return octits.join(""); }

hexadecimal
  = hexits:hexit+ { return hexits.join(""); }

decnat
  = dec:decimal { return parseInt(dec, 10); }

octnat
  = ("0o" / "0O") oct:octal { return parseInt(oct, 8); }

hexnat
  = ("0x" / "0X") hex:hexadecimal { return parseInt(hex, 16); }

natural
  = hexnat
  / octnat
  / decnat

exponential
  = [Ee] sign:([+-]?) exp:decimal { return "e" + sign + exp; }

power
  = [Pp] sign:([+-]?) pow:decimal { return Math.pow(2, parseInt(sign + pow, 10)); }

floating
  = ("0x" / "0X") hex:hexadecimal pow:power { return parseInt(hex, 16) * pow; }
  / dec:decimal pow:power { return parseFloat(dec) * pow; }
  / dec:(decimal exponential) { return parseFloat(dec.join("")); }
  / dec:(decimal "." decimal) pow:power { return parseFloat(dec.join("")) * pow; }
  / dec:(decimal "." decimal exponential?) { return parseFloat(dec.join("")); }

number
  = i:natural ![.EePp] { return i; }
  / floating
  / "+" ![+-] n:number { return n; }
  / "-" ![+-] n:number { return -n; }

ascii
  = [\x00-\x7f]

asciiGraphic
  = [!-~]

asciiAlphabet
  = [A-Za-z]

asciiSymbol
  = [!-/:-@\[-`{-~]

symbol
  = ![\[\]()`{},;_"'] s:asciiSymbol { return s; }

graphic
  = asciiGraphic

alphabet
  = asciiAlphabet
  / "_"

alphanum
  = alphabet
  / digit

whitespace
  = whitestuff* { return ""; }

whitestuff
  = whitechar
  / comment
  / ncomment

whitechar
  = " " / "\t"

newline
  = "\r\n" / "\n" / "\r"

newlines
  = (whitespace newline)*

dashes
  = "--" "-"*

comment
  = dashes !symbol (graphic / whitechar)* &newline

opencom
  = "{-"

closecom
  = "-}"

ncomment
  = opencom ANYseq (ncomment ANYseq)+ closecom

ANYseq
  = (!opencom !closecom ANY)+

ANY
  = graphic / whitechar / !ascii .

opsymbol
  = !(dashes !symbol) s:symbol+ { return s.join(""); }
  / ","
  / ";"

letterid
  = idh:alphabet idt:(alphanum / "'")* { return idh + idt.join(""); }

identifier
  = letterid
  / "(" id:opsymbol ")" { return id; }
