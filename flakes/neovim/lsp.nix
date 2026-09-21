{
  # Shared metadata for direct LSP clients.
  servers = {
    bash-language-server = {
      executable = "bash-language-server";
      args = [ "start" ];
      fileExtensions = {
        ".sh" = "shellscript";
        ".bash" = "shellscript";
      };
    };
    clangd = {
      executable = "clangd";
      fileExtensions = {
        ".c" = "c";
        ".cpp" = "cpp";
        ".h" = "c";
        ".hpp" = "cpp";
      };
    };
    lua-language-server = {
      executable = "lua-language-server";
      fileExtensions = { ".lua" = "lua"; };
    };
    nixd = {
      executable = "nixd";
      fileExtensions = { ".nix" = "nix"; };
    };
    phpactor = {
      executable = "phpactor";
      args = [ "language-server" ];
      fileExtensions = { ".php" = "php"; };
    };
    pyright-langserver = {
      executable = "pyright-langserver";
      args = [ "--stdio" ];
      fileExtensions = { ".py" = "python"; };
    };
    rust-analyzer = {
      executable = "rust-analyzer";
      fileExtensions = { ".rs" = "rust"; };
    };
    svelteserver = {
      executable = "svelteserver";
      args = [ "--stdio" ];
      fileExtensions = { ".svelte" = "svelte"; };
    };
    tailwindcss-language-server = {
      executable = "tailwindcss-language-server";
      args = [ "--stdio" ];
      fileExtensions = { ".css" = "css"; };
    };
    typescript-language-server = {
      executable = "typescript-language-server";
      args = [ "--stdio" ];
      fileExtensions = {
        ".ts" = "typescript";
        ".tsx" = "typescriptreact";
        ".js" = "javascript";
        ".jsx" = "javascriptreact";
      };
    };
    vscode-css-language-server = {
      executable = "vscode-css-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".css" = "css"; };
    };
    vscode-html-language-server = {
      executable = "vscode-html-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".html" = "html"; };
    };
    vscode-json-language-server = {
      executable = "vscode-json-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".json" = "json"; };
    };
    texlab = {
      executable = "texlab";
      fileExtensions = { ".tex" = "latex"; };
    };
    tinymist = {
      executable = "tinymist";
      args = [ "lsp" ];
      fileExtensions = { ".typ" = "typst"; };
    };
    yaml-language-server = {
      executable = "yaml-language-server";
      args = [ "--stdio" ];
      fileExtensions = {
        ".yaml" = "yaml";
        ".yml" = "yaml";
      };
    };
  };
}
