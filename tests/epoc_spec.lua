local epoc = require("epoc")

describe("epoc.nvim", function()
  before_each(function()
    vim.cmd("enew!") -- fresh buffer
    epoc.setup({
      date_format = "%Y-%m-%d %H:%M:%S",
    })
  end)

  describe("get_number_under_cursor", function()
    it("extracts number under cursor", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo 1672531200 bar" })
      vim.api.nvim_win_set_cursor(0, { 1, 10 }) -- inside number

      local num = epoc.get_number_under_cursor()
      assert.are.same(1672531200, num)
    end)

    it("returns nil when no number", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "no numbers here" })
      vim.api.nvim_win_set_cursor(0, { 1, 5 })

      local num = epoc.get_number_under_cursor()
      assert.is_nil(num)
    end)

    it("handles empty line", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
      vim.api.nvim_win_set_cursor(0, { 1, 1 })

      local num = epoc.get_number_under_cursor()
      assert.is_nil(num)
    end)
  end)

  describe("convert_epoch_time_under_cursor_into_clipboard", function()
    it("converts epoch and writes to clipboard", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "1672531200" })
      vim.api.nvim_win_set_cursor(0, { 1, 5 })

      local result = epoc.convert_epoch_time_under_cursor_into_clipboard()

      assert.are.same("2022-12-31 18:00:00", result)

      local reg = vim.fn.getreg("+")
      assert.are.same(result, reg)
    end)

    it("returns nil if no number", function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "abc" })
      vim.api.nvim_win_set_cursor(0, { 1, 1 })

      local result = epoc.convert_epoch_time_under_cursor_into_clipboard()
      assert.is_nil(result)
    end)
  end)

  describe("current_time_to_epoc_time", function()
    it("returns a number and sets clipboard", function()
      local result = epoc.current_time_to_epoc_time()

      assert.is_number(result)

      local reg = tonumber(vim.fn.getreg("+"))
      assert.are.same(result, reg)
    end)
  end)

  describe("popup", function()
    it("creates popup window and buffer", function()
      epoc.popup("hello")

      assert.is_not_nil(epoc.popup_win)
      assert.is_true(vim.api.nvim_win_is_valid(epoc.popup_win))

      assert.is_not_nil(epoc.popup_buf)
      assert.is_true(vim.api.nvim_buf_is_valid(epoc.popup_buf))
    end)

    it("closes popup correctly", function()
      epoc.popup("hello")
      epoc.close_popup()

      print(epoc.popup_buf, epoc.popup_win)
      if epoc.popup_win then
        assert.is_false(vim.api.nvim_win_is_valid(epoc.popup_win))
      end

      if epoc.popup_buf then
        assert.is_false(vim.api.nvim_buf_is_valid(epoc.popup_buf))
      end
    end)
  end)
end)
