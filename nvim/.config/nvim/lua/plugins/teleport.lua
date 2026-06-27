return {
  "arsyhiy/teleport.nvim",

  config = function()
    local teleport = require("teleport")

    teleport.setup({
      mode = "project",
      state_file = vim.fn.stdpath("state") .. "/teleport_last_dir",
    })

    vim.api.nvim_create_user_command("Q", function()
      local file = vim.api.nvim_buf_get_name(0)

      local dir
      if file == "" then
        dir = vim.loop.cwd()
      else
        dir = vim.fn.fnamemodify(file, ":p:h")
      end

      vim.fn.writefile({ dir .. "|Q" }, teleport.config.state_file)

      vim.cmd("qa!")
    end, {})
  end,
}
