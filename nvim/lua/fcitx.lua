local M = {}

-- 保存每个 buffer 的输入法状态
M.states = {}

-- 获取输入法状态
local function get_im_state()
	local enabled = vim.fn.system("fcitx5-remote"):gsub("\n", "")
	local name = vim.fn.system("fcitx5-remote -n"):gsub("\n", "")

	return {
		enabled = enabled == "2",
		name = name,
	}
end

-- 设置输入法
local function set_im_state(state)
	if not state then
		return
	end

	if state.name ~= "" then
		vim.fn.system("fcitx5-remote -s " .. state.name)
	end

	if state.enabled then
		vim.fn.system("fcitx5-remote -o")
	else
		vim.fn.system("fcitx5-remote -c")
	end
end

-- 离开 Insert
local function leave_insert()
	local buf = vim.api.nvim_get_current_buf()

	-- 保存当前状态
	M.states[buf] = get_im_state()

	-- 强制关闭输入法
	vim.fn.system("fcitx5-remote -c")
end

-- 进入 Insert
local function enter_insert()
	local buf = vim.api.nvim_get_current_buf()

	-- 恢复状态
	set_im_state(M.states[buf])
end

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = leave_insert,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = enter_insert,
})

return M
