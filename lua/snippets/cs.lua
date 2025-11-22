local rep = require("luasnip.extras").rep
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local function get_namespace()
	local filepath = vim.fn.expand("%:p")
	local dirname = vim.fn.fnamemodify(filepath, ":p:h")
	local project_root = nil
	local project_name = nil

	-- Walk up from current directory to find a .csproj
	while dirname ~= "/" do
		local csproj = vim.fn.glob(dirname .. "/*.csproj")
		if csproj ~= "" then
			project_root = dirname
			project_name = vim.fn.fnamemodify(csproj, ":t:r")
			break
		end
		dirname = vim.fn.fnamemodify(dirname, ":h")
	end

	-- fallback
	if not project_root then
		return "MyNamespace"
	end

	-- Relative path from project root to file
	local relative = filepath:sub(#project_root + 2):gsub("%.cs$", "")
	local folders = {}

	for part in relative:gmatch("[^/\\]+") do
		table.insert(folders, part)
	end

	table.remove(folders) -- remove the filename
	local sub = table.concat(folders, ".")

	if #sub > 0 then
		return project_name .. "." .. sub
	else
		return project_name
	end
end

-- auto class name from file name
local function get_classname()
	return vim.fn.expand("%:t:r")
end

return {
	-- Console.WriteLine
	s("cw", fmt("Console.WriteLine({});", { i(1, '"text"') })),

	-- for loop
	s(
		"for",
		fmt(
			[[
    for (int {} = 0; {} < {}; {}++)
    {{
        {}
    }}
  ]],
			{
				i(1, "i"),
				rep(1),
				i(2, "n"),
				rep(1),
				i(3, "// body"),
			}
		)
	),

	-- try-catch
	s(
		"try",
		fmt(
			[[
    try
    {{
        {}
    }}
    catch (Exception ex)
    {{
        Console.WriteLine(ex.Message);
    }}
  ]],
			{ i(1, "// risky code") }
		)
	),

	s(
		"class",
		fmt(
			[[
    namespace {}
    {{
        public class {}
        {{
            {}
        }}
    }}
  ]],
			{
				f(get_namespace),
				f(get_classname),
				i(1, "//code"),
			}
		)
	),

	s(
		"interface",
		fmt(
			[[
    namespace {}
    {{
        public interface {}
        {{
            {}
        }}
    }}
  ]],
			{
				f(get_namespace),
				f(get_classname),
				i(1, "//code"),
			}
		)
	),

	s(
		"main",
		fmt(
			[[
    public static void Main(String[] args)
    {{
        {}
    }}
  ]],
			{
				i(1, "// your code here"),
			}
		)
	),
}
