local epoc = require("epoc")
vim.api.nvim_create_user_command("EpochTimeConvertToClipboard", epoc.convert_epoch_time_under_cursor_into_clipboard, {})
vim.api.nvim_create_user_command("EpochTimeCurrentToClipboard", epoc.current_time_to_epoc_time, {})
vim.api.nvim_create_user_command("EpochTimeConvertAndPopup", epoc.convert_and_popup, {})
