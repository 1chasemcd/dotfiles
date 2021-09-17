-- Remove tmux keys from help
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- return table for adding mouse shortcuts to help menu
return {
    ["layout"] = {{
        modifiers = {"Super", "Control"},
        keys = {
            ["mouse"]="resize window"
        }
    },
    {
        modifiers = {"Super", "Shift"},
        keys = {
            ["mouse"]="move window"
        }
    }}
}

