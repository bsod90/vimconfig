require("claude-code").setup({
    -- UI Configuration
    window = {
        width = 0.8,
        height = 0.8,
        border = "botright",
    },

    -- Default prompts for common operations
    default_prompts = {
        explain = "Explain the following code:",
        review = "Review the following code and suggest improvements:",
        refactor = "Refactor the following code:",
        fix = "Fix any issues in the following code:",
        document = "Add documentation comments to the following code:",
        test = "Write unit tests for the following code:",
        optimize = "Optimize the following code for performance:",
    },

    -- Keybindings
    keymaps = {
        -- Visual mode mappings (for selected code)
        visual = {
            explain = "<leader>ce",
            review = "<leader>cr",
            refactor = "<leader>cf",
            fix = "<leader>cx",
            document = "<leader>cd",
            test = "<leader>ct",
            optimize = "<leader>co",
            custom = "<leader>cc", -- Custom prompt
        },
        -- Normal mode mappings
        normal = {
            chat = "<leader>ch",    -- Open chat interface
            history = "<leader>cy", -- Show prompt history
            models = "<leader>cm",  -- Switch models
        },
    },
})
