{
  # Server executable name -> list of supported file extensions
  servers = {
    # EFM diagnostics and formatting bridge
    efm-langserver = [
      ".sh"
      ".bash"
      ".c"
      ".cpp"
      ".h"
      ".hpp"
      ".rs"
      ".py"
      ".php"
      ".yaml"
      ".yml"
      ".nix"
    ];

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

    # LaTeX
    texlab = [ ".tex" ];

    # Typst
    tinymist = [ ".typ" ];

    # YAML
    yaml-language-server = [
      ".yaml"
      ".yml"
    ];
  };
}
