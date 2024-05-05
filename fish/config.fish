starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set CWD $HOME/.config/fish/

function fish_greeting
    echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
    echo (set_color magenta; date)
end

set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.yarn/bin $PATH
set PATH /var/lib/flatpak/exports/bin $PATH

set SDL_VIDEODRIVER wayland
