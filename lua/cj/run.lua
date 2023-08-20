local runInTerminal = function(cmd)
  local nrows = vim.api.nvim_win_get_height(0)
  local ncols = vim.api.nvim_win_get_width(0)
  local term_height = 15
  local pre = term_height .. "sp "
  if ncols / nrows > 2.5 then
    pre = "vs "
  end
  vim.cmd(pre .. "term://" .. cmd .. " | startinsert")
end

local runInDirectory = function(cmd, dir)
  local cwd = vim.fn.getcwd()
  vim.cmd("tcd " .. dir)
  pcall(function()
    runInTerminal(cmd)
  end)
  vim.cmd("tcd " .. cwd)
end

local runPython = function()
  local bd = vim.fn.expand("%:r")
  local root = vim.fs.find({ "pyrightconfig.json", { start = bd, upward = true } })
  if #root > 0 then
    local rd = vim.fs.dirname(root[1])
    local fp = string.sub(bd, #rd + 2)
    local mn = string.gsub(fp, "/", ".")
    runInDirectory("python3 -m " .. mn, rd)
    return true
  end
end

local run = function()
  local home = vim.fn.expand("~")
  local x = vim.fn.expand("%:e")
  local fbn = vim.fn.expand("%:t:r")
  local fn = vim.fn.expand("%:t")
  local fwd = vim.fn.expand("%:h")
  local cwd = vim.fn.getcwd()
  vim.cmd("w")

  local dirTerm = function(cmd)
    runInDirectory(cmd, fwd)
  end

  if vim.tbl_contains({ "c", "cpp" }, x) then
    if cwd == home .. "/documents/dsal" then
      dirTerm("./run " .. fbn)
    else
      dirTerm("g++ -o " .. fbn .. " " .. fn .. "; ./" .. fbn)
    end
  elseif x == "py" then
    if not runPython() then
      dirTerm("python3 " .. fn)
    end
  elseif vim.tbl_contains({ "js", "mjs" }, x) then
    dirTerm("node " .. fn)
  elseif vim.tbl_contains({ "sh", "bash" }, x) then
    dirTerm("bash " .. fn)
  elseif x == "ts" then
    dirTerm("npx ts-node " .. fn)
  elseif x == "rs" then
    dirTerm("rustc -o " .. fbn .. " " .. fn .. "; ./" .. fbn)
  elseif x == "java" then
    dirTerm("javac " .. fn .. " && java " .. fbn)
  elseif x == "lua" then
    dirTerm("lua " .. fn)
  elseif x == "sha256" then
    vim.cmd('w !tr -d "\\n" | sha256sum')
  elseif fn == "termux.properties" then
    vim.cmd("w | !termux-reload-settings")
  end
end

Map({ "n", "i" }, "<M-b>", run)
