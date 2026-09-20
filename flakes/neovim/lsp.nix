{ pkgs, ... }:
{
  # Server executable name -> list of supported file extensions
  servers = {
    # Bash
    bash-language-server = [
      ".sh"
      ".bash"
    ];

    # C and CPP
    clangd = [
      ".c"
      ".cpp"
      ".h"
      ".hpp"
    ];

    # Lua
    lua-language-server = [ ".lua" ];

    # Nix
    nixd = [ ".nix" ];

    # C-sharp
    omnisharp = [ ".cs" ];

    # PHP
    phpactor = [ ".php" ];

    # Python
    pyright-langserver = [ ".py" ];

    # Rust
    rust-analyzer = [ ".rs" ];

    # Typescript / Svelte
    svelteserver = [ ".svelte" ];
    typescript-language-server = [
      ".ts"
      ".tsx"
      ".js"
      ".jsx"
    ];

    # Web development
    tailwindcss-language-server = [ ".css" ];
    vscode-css-language-server = [ ".css" ];
    vscode-html-language-server = [ ".html" ];
    vscode-json-language-server = [ ".json" ];

    # latex
    texlab = [ ".tex" ];

    # Typst
    tinymist = [ ".typ" ];

    # Yaml
    yaml-language-server = [
      ".yaml"
      ".yml"
    ];
  };

  # The nixpkgs packages providing all of the above language servers
  packages = with pkgs; [
    # Bash
    bash-language-server

    # Lua
    lua-language-server

    # Yaml
    yaml-language-server

    # C-sharp
    omnisharp-roslyn

    # Rust
    rust-analyzer

    # C and CPP
    llvmPackages.clang-tools

    # Nix
    nixd

    # Python
    pyright

    # PHP
    phpactor

    # Web development
    tailwindcss-language-server
    vscode-langservers-extracted

    # Typescript
    svelte-language-server
    typescript-language-server

    # latex
    texlab

    # Typst
    tinymist
  ];
}
