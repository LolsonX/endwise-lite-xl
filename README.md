# Endwise plugin for Lite XL editor

Plugin that provides automatic adding of words to end block of codes. (Ex. Ruby if ... end or do ... end syntax)

To use it repo files to __endwise/__ directory to your plugins folder or
or clone repo to Your plugins directory (default `$HOME/.config/lite-xl/plugins`)
```sh
git clone https://github.com/LolsonX/endwise-lite-xl endwise
```
** Remember to always keep files in directory named __endwise/__ otherwise plugin will not work**
## Features
  * Add end for diffrent languages
  * Allow to create new rules in Your init.lua file
  * Enable only for languages You want it to work

## Examples

### Simple config to start given language
```lua
local _endwise = require "plugins.endwise" -- sets up everything properly during startup
local config = require "core.config"

config.plugins.endwise.enable("Ruby")
```
### Add custom rules to languages
```lua
local _endwise = require "plugins.endwise" -- sets up everything properly during startup
local config = require "core.config"

config.plugins.endwise.add({
  name = "Ruby",
  enabled = true,
  filename = ".rb$",
  addition = "end",
  words = { "module", "class", "def", "if", "unless", "case", "while", "until", "begin", "do" },
  -- :word: is used to substitute for each word from words list
  patterns = { "^%s*(:word:).*$", -- :word: starts the line
               "^%s*%a*%s*(=)%s*(:word:).*$" -- :word: is first word after = sign
  },
  -- excludes are regexp that cannot be matched like for example Ruby3.0 endless method definition
  excludes = { "^%s*(def)%s+%a+%s*(=).*$", -- endless method definition
               "%s+(end)%s*$" -- line ending with end word
  }
})

```

## How it works
Plugin changes the behaviour of __doc:newline__ command. When You start lite-xl with this plugin enabled You will see that in log:
`[INFO] Replacing existing command "doc:newline" at $PATH_TO_LITE_XL/core/command.lua:49`
It attaches new behaviour after original command so it should not break normal behaviour.

## TODO
 - [x] Append end after correct patterns
 - [x] Do not append end after excluded pattern
 - [x] Add possibility to add new languages via init.lua
 - Languages
   - [x] Add support for Ruby
   - [x] Add support for Lua
   - [ ] Add support for Elixir
   - [ ] Add support for Crystal
   
## Notes
  * I am not Lua developer to be fair i know a little bit about it, but i wanted to use Ruby with lite xl end this plugin
  helps in it
  * If You find any bug or see possible improvement (especially in terms of patterns) feel free to open a PR or Issue
  * Thanks to creators of following repositories and pieces of code. I used them as an example and it helped me to create this:
    * ![lite-xl-lsp](https://github.com/lite-xl/lite-xl-lsp)
    * ![autoinsert](https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/autoinsert.lua)
  * Inspired by ![vim-endwise](https://github.com/tpope/vim-endwise)
