return {
    "seblyng/roslyn.nvim",
    vim.lsp.config("roslyn", {
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },
        },
    }),
    filewatching = "auto",   -- or "roslyn" / "off"
    broad_search = false,
    lock_target = false,
    silent = false,
}
