# epoc.nvim

#### Lazy

```lua
{
  'cowboy8625/epoc.nvim',
  config = function()
    require('epoc').setup {
      date_format = "%m/%d/%Y %H:%M %p", -- default
    }
  end
},
```

#### Commands

`EpochTimeConvertToClipboard`
`EpochTimeCurrentToClipboard`
`EpochTimeConvertAndPopup`
