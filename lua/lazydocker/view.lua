local class = require("lazydocker.common.class")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local config = require("lazydocker.config")

local View = class({})

function View:init()
	self.is_open = false
end

function View:set_listeners()
	local function set_keymap(key)
		return self.popup:map("n", key, function()
			self.popup:off("BufLeave")
			self.popup:unmount()
		end, { silent = true, noremap = true })
	end

	self.popup:on(event.BufLeave, function()
		self.popup.unmount()
	end)

	set_keymap("<esc>")
	set_keymap("q")
end

function View:render()
	return vim.api.nvim_buf_set_lines(self.popup, 0, 1, false, { "Hello, LazyDocker" })
end

function View:open()
	self.popup = Popup(config.options.popup_window)
	self.set_listeners(self)
	self.popup:mount()
	return self.render(self)
end

function View:close()
	self.popup:off("BufLeave")
	self.popup:unmount()
end

function View:toggle()
	if self.is_open == false then
		self.is_open = true
		return self.open(self)
	else
		self.is_open = false
		self.close(self)
	end
end

return View
