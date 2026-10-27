vim.api.nvim_create_user_command("Tidy", function()
	local unused = vim.iter(vim.pack.get())
		:filter(function(plugin)
			return not plugin.active
		end)
		:map(function(plugin)
			return plugin.spec.name
		end)
		:totable()

	if #unused == 0 then
		print("No inactive plugins to remove")
		return
	end

	vim.pack.del(unused)
	print("Removed plugins: " .. table.concat(unused, ", "))
end, {
	desc = "Remove inactive vim.pack plugins",
})
