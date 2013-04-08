assert = require "assert"
parser = require "./parser"

testcase = [
  ["42", ["constructor", ["number", 42], []]]
  ["-42", ["constructor", ["number", -42], []]]
  ["0x4f", ["constructor", ["number", 0x4f], []]]
  ["-0x4f", ["constructor", ["number", -0x4f], []]]
  ["1p10", ["constructor", ["number", 1024], []]]
  ["1p-10", ["constructor", ["number", 1/1024], []]]
  ["0o127", ["constructor", ["number", 0o127], []]]
  ["hello", ["constructor", ["identifier", "hello"], []]]
  ["(+)", ["constructor", ["identifier", "+"], []]]
  ["\\x", ["constructor", ["variable", "x"], []]]
  ["x + 2", ["operator", "+", ["constructor", ["identifier", "x"], []], ["constructor", ["number", 2], []]]]
  ["f $", ["layoutOperator", "$", ["constructor", ["identifier", "f"], []]]]
]

eq = (x, y) ->
  JSON.stringify(x) is JSON.stringify(y)

console.log "Checking parser"
assert.ok parser

check = (x) ->
  a = x[0]
  b = x[1]
  c = parser.parse a, "expression"
  console.log "Testing #{a}"
  assert.ok eq b, c

for v in testcase
  check(v)
