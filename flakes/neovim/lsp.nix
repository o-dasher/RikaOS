{
  # Shared metadata for direct LSP clients. Packages are resolved by consumers.
  servers = {
    efm-langserver = {
      package = "efm-langserver";
      executable = "efm-langserver";
      fileExtensions = {
        ".sh" = "shellscript";
        ".bash" = "shellscript";
        ".c" = "c";
        ".cpp" = "cpp";
        ".h" = "c";
        ".hpp" = "cpp";
        ".rs" = "rust";
        ".py" = "python";
        ".php" = "php";
        ".yaml" = "yaml";
        ".yml" = "yaml";
        ".nix" = "nix";
      };
    };
    bash-language-server = {
      package = "bash-language-server";
      executable = "bash-language-server";
      args = [ "start" ];
      fileExtensions = {
        ".sh" = "shellscript";
        ".bash" = "shellscript";
      };
    };
    clangd = {
      package = "clang-tools";
      executable = "clangd";
      fileExtensions = {
        ".c" = "c";
        ".cpp" = "cpp";
        ".h" = "c";
        ".hpp" = "cpp";
      };
    };
    lua-language-server = {
      package = "lua-language-server";
      executable = "lua-language-server";
      fileExtensions = { ".lua" = "lua"; };
    };
    nixd = {
      package = "nixd";
      executable = "nixd";
      fileExtensions = { ".nix" = "nix"; };
    };
    phpactor = {
      package = "phpactor";
      executable = "phpactor";
      args = [ "language-server" ];
      fileExtensions = { ".php" = "php"; };
    };
    pyright-langserver = {
      package = "pyright";
      executable = "pyright-langserver";
      args = [ "--stdio" ];
      fileExtensions = { ".py" = "python"; };
    };
    rust-analyzer = {
      package = "rust-analyzer";
      executable = "rust-analyzer";
      fileExtensions = { ".rs" = "rust"; };
    };
    svelteserver = {
      package = "svelte-language-server";
      executable = "svelteserver";
      args = [ "--stdio" ];
      fileExtensions = { ".svelte" = "svelte"; };
    };
    tailwindcss-language-server = {
      package = "tailwindcss-language-server";
      executable = "tailwindcss-language-server";
      args = [ "--stdio" ];
      fileExtensions = { ".css" = "css"; };
    };
    typescript-language-server = {
      package = "typescript-language-server";
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
      package = "vscode-css-languageserver";
      executable = "vscode-css-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".css" = "css"; };
    };
    vscode-html-language-server = {
      package = "vscode-html-languageserver";
      executable = "vscode-html-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".html" = "html"; };
    };
    vscode-json-language-server = {
      package = "vscode-json-languageserver";
      executable = "vscode-json-languageserver";
      args = [ "--stdio" ];
      fileExtensions = { ".json" = "json"; };
    };
    texlab = {
      package = "texlab";
      executable = "texlab";
      fileExtensions = { ".tex" = "latex"; };
    };
    tinymist = {
      package = "tinymist";
      executable = "tinymist";
      args = [ "lsp" ];
      fileExtensions = { ".typ" = "typst"; };
    };
    yaml-language-server = {
      package = "yaml-language-server";
      executable = "yaml-language-server";
      args = [ "--stdio" ];
      fileExtensions = {
        ".yaml" = "yaml";
        ".yml" = "yaml";
      };
    };
  };
}
