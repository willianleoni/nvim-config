-- ARQUIVO CORRIGIDO: nvim/lua/configs/lspconfig.lua

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = { "clangd", "pyright", "html", "cssls", "lua_ls" }

for _, server in pairs(servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if server == "clangd" then
    -- A variável 'ros_project_root' já contém o caminho para a raiz do seu projeto.
    local ros_project_root = lspconfig.util.root_pattern ".ros_docker_project"(vim.fn.getcwd())

    if ros_project_root then
      print "Projeto ROS 2 (Docker) detectado. Usando clangd via wrapper."
      -- ## A MUDANÇA ESTÁ AQUI ##
      -- Construímos o caminho para o wrapper usando a raiz do projeto encontrada.
      opts.cmd = { ros_project_root .. "/clangd-wrapper.sh" }
      opts.root_dir = ros_project_root
    else
      print "Nenhum projeto ROS 2 detectado. Usando clangd padrão."
    end
  end

  if server == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    }
  end

  lspconfig[server].setup(opts)
end

-- A configuração de como os diagnósticos são exibidos permanece a mesma
vim.diagnostic.config {
  virtual_text = {
    spacing = 4,
    prefix = "✗",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
