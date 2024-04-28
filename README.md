# 😜 FunMock
Library with one function to help creating tests with TestEZ

# 📥 Installation
using Wally: ``FunMock = "sumer9999dev/funmock@1.0.0"``

RBXM: download from github releases!

# ❔ Documentation
Import FunMock:
```lua
local FunMock = require(path.to.FunMock)
```
Create mock function with one line: 
```lua
local fn = FunMock()
```
Usage:
```lua
-- implement one time
fn:implement_once(function(...) print(...) end)

fn('Hello', 'World!')
fn()  -- will do nothing

-- implement forever
fn:implement(function(...) print(...) end)

fn('Hello', 'World!')
fn('Hello!')  -- will always work!

-- implement helpers
fn:return_once(1)  -- will return value once
fn:return_forever(1)  -- will return value everytime
fn:return_self()  -- will return self


-- checks!
local calls = fn.calls  -- contains all calls in matrix format: {[call_count]: {...arguments}}
print(calls[1][1])  -- will return first argument of first call

print(fn:first_call())  -- will return first call or nil
print(fn:last_call())  -- will return last call or nil

print(fn.called_times)  -- called_times contains count of calls

print(fn:called_with('Hello', 'World!'))  -- will return boolean, checks whether the function was called with such arguments
print(fn:returned('anything'))  -- will return boolean, checks whether the function was returned this values
print(fn:throwed_with('error'))  -- will return boolean, is function throwed that error or not

print(fn:called())  -- boolean, is function called or not
print(fn:throwed())  -- boolean, is function throwed an error or not

fn:reset()  -- to fully reset function
```

# 🔧 Credits
Created by **sumer_real** for MelonBytes Studio!

Inspired by the mock function of **jest**.