-- Em ~/.config/nvim/lua/plugins/lsp.lua

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = (function()
            --- Encontra a raiz do projeto procurando para cima por um marcador.
            local function find_project_root(start_path, marker)
              local path = start_path
              local sep = package.config:sub(1, 1)
              while path ~= sep and path ~= "" and path ~= nil do
                if vim.fn.filereadable(path .. sep .. marker) == 1 then
                  return path -- Encontramos a raiz!
                end
                path = vim.fn.fnamemodify(path, ":h")
              end
              return nil -- Não encontrou
            end

            -- Executa a busca pelo nosso marcador
            local project_root = find_project_root(vim.fn.getcwd(), ".ros_docker_project")

            if project_root then
              local wrapper_script = project_root .. "/clangd-wrapper.sh"
              vim.notify("LSP: Projeto ROS Docker encontrado. Usando: " .. wrapper_script, vim.log.levels.INFO)
              return { wrapper_script }
            end

            -- Caso contrário, usa o clangd padrão gerido pelo Mason/Neovim
            vim.notify("LSP: Usando clangd local.", vim.log.levels.INFO)
            return { "clangd" }
          end)(),
        },
        -- ... outros servidores
      },
    },
  },
}
