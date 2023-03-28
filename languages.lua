local languages = {
  -- Ruby support
  -- Status: Works
  { 
    name = "Ruby",
    enabled = false,
    filename = ".rb$",
    addition = "end",
    words = { "module", "class", "def", "if", "unless", "case", "while", "until", "begin", "do" },
    -- :word: is used to substitute for each word from words list
    patterns = { "^%s*(:word:).*$", -- :word: starts the line
                 "(:word:)%s+|%s*.+%s*|%s*$",
                 "^%s*%a*%s*(=)%s*(:word:).*$" -- :word: is first word after = sign ex. multiline ternary operator
    },
    -- excludes are regexp that cannot be matched like for example Ruby3.0 endless method definition
    excludes = { "^%s*(def)%s+%a+%s*(=).*$", -- endless method definition
                 "%s+(end)%s*$" -- line ending with end word
    }
  },
  -- Elixir support
  -- Status: Not working
  { 
    name = "Elixir",
    enabled = false,
    filename = ".ex$",
    addition = "end",
    words = { "do", "fn" },
    -- :word: is used to substitute for each word from words list
    patterns = {}, -- :word: starts the line
    excludes = {}
  },
  -- Lua support
  -- Status: Works
  { 
    name = "Lua",
    enabled = false,
    filename = ".lua$",
    addition = "end",
    words = { "do", "function", "then" },
    -- :word: is used to substitute for each word from words list
    patterns = { ":word:%s*$", "^%s*function.*$", "=%s*:word:%s*.*$" }, -- :word: ends the line, or line starts with function
    excludes = { "%s+(end)%s*$" }
  },
  -- Crystal support
  -- Status: Untested
  { 
    name = "Crystal",
    enabled = false,
    filename = ".cr$",
    addition = "end",
    words = { "module", "class", "lib", "macro", "struct", "union", "enum", "def", "if",
              "unless", "ifdef", "case", "while", "until", "for", "begin", "do" },
    -- :word: is used to substitute for each word from words list
    patterns = {"^%s*(:word:).*$", -- :word: starts the line
                 "^%s*%a*%s*(=)%s*(:word:).*$"
    }, -- :word: starts the line
    excludes = {}
  },
}

return languages
