export EDITOR=nvim
export VISUAL=nvim
export PATH=$PATH:/home/kotori/.local/share/pnpm/bin:/home/kotori/.local/bin
# export SYSTEMD_PAGER=cat
export MANGOHUD=0
. "$HOME/.cargo/env"

export GOROOT=/usr/local/go
export GOPATH=$HOME/.golang
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
export PATH="$HOME/.flutter/bin:$PATH"
export QT_IM_MODULE=fcitx
export QT_QPA_PLATFORMTHEME=gnome

export XMODIFIERS=@im=fcitx

# export GTK_THEME=TokyoNight
export GTK_IM_MODULE=fcitx
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
# export PROTON_ENABLE_WAYLAND=1
export JM_OPTION_PATH="$HOME/.config/jmcomic.yml"

