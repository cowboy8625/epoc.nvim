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

- `EpochTimeConvertToClipboard` takes epoch time under the cursor and turns it into a string
- `EpochTimeCurrentToClipboard` takes the current time and turns it into a epoch time
- `EpochTimeConvertAndPopup` same as `EpochTimeConvertToClipboard` but opens a popup with the converted time
<br>![image](https://github.com/cowboy8625/epoc.nvim/assets/43012445/70699986-5b7e-4f22-9b95-9d29eb2abc69)
