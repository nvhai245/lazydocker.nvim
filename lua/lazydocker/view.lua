local class = require("lazydocker.common.class")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local config = require("lazydocker.config")

local View = class({})

function View:init()
	self.popup = Popup(config.options.popup_window)
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

function View:exec()
	vim.api.nvim_buf_set_lines(self.popup, 0, 1, false, { "Hello, LazyDocker" })
end

function View:open()
	self.set_listeners(self)
	self.popup:mount()
	self.render(self)
end

function View:close()
	self.popup:off("BufLeave")
	self.popup:unmount()
end

function View:toggle()
	if self.is_open == false then
		self.open(self)
		self.is_open = true
	else
		self.close(self)
		self.is_open = false
	end
end

return View
