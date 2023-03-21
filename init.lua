-- mod-version:3
local DocView = require "core.docview"
local config = require "core.config"
local common = require "core.common"
local core = require "core"
local command = require "core.command"
local languages = require "plugins.endwise.languages"

local add = function(lang_settings)
  table.insert(config.plugins.endwise.languages, lang_settings)
  core.log("Endwise: Added " .. lang_settings.name)
end

local enable = function(name)
  local index = nil
  for idx, lang in ipairs(config.plugins.endwise.languages) do
    if lang.name == name then index = idx end
  end

  if index == nil then
    core.log("[Error] Endwise: Config for " .. name .. " not found.")
    return
  end

  config.plugins.endwise.languages[index].enabled = true
  core.log("Endwise: Enabled endwise for: " .. name)
end

config.plugins.endwise = common.merge({
  enabled = true,
  languages = languages,
  enable = enable,
  add = add,
  -- The config specification used by the settings gui
  conf_spec = {
    description = "Activates auto appending end by default.",
    path = "enabled",
    type = "toggle",
    default = true
  }
}, config.plugins.endwise)

local new_line_command = command.map["doc:newline"]
local match_any_pattern = function(text, patterns, substitutions)
  for _, pattern in ipairs(patterns) do
    for _, substitute in ipairs(substitutions) do
      local to_check = pattern:gsub(":word:", substitute)
      if(common.match_pattern(text, to_check)) then
        return true
      end
    end
  end
  return false
end

command.add("core.docview", {
  -- modify current newline command to extend it functionality to be able to
  -- add addition in new line
  ["doc:newline"] = function(dv)
    new_line_command.perform(dv)
    if config.plugins.endwise.enabled then
      local matched = false
      local filename = dv.doc.filename or ""
      for _, settings in ipairs(config.plugins.endwise.languages) do
        if filename:match(settings.filename) then
          matched = settings
          break
        end
      end

      -- return early if not match file found or matching file is disabled
      if not matched then return end
      if not matched.enabled then return end

      local last_line = dv.doc.lines[dv.last_line1]
      local pattern_matched = match_any_pattern(last_line, matched.patterns, matched.words)
      local exclude_matched = match_any_pattern(last_line, matched.excludes, matched.words)
      if pattern_matched and not exclude_matched then
        local _, indentation_level = last_line:gsub(dv.doc:get_indent_string(), "")
        local indentation = dv.doc:get_indent_string():rep(indentation_level) or ""
        local append = indentation .. matched.addition
        DocView.on_text_input(dv, "\n" .. append)
        dv.doc:move_to(-(#append + 1))
        DocView.on_text_input(dv, dv.doc:get_indent_string())
      end
    end
  end
})


command.add(nil, {
  ["endwise:toggle"] = function()
    config.plugins.endwise.enabled = not config.plugins.endwise.enabled
    if config.plugins.endwise.enabled then
      core.log("Endwise: on")
    else
      core.log("Endwise: off")
    end
  end
})
