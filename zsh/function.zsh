clip() {
    printf "\033]52;c;%s\033\\" "$(base64 -w0)"
}

fn() {
    local file
    file=$(fd --type f --hidden | fzf --preview 'bat --color=always {}') || return
    nvim "$file"
}

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

zy() {
	zi
	y
}

fy() {
	yazi "$(fzf)"
}

add() {
    if [[ $# -ne 1 ]]; then
        echo "用法: add <配置路径>"
        return 1
    fi

    local src="${1/#\~/$HOME}"
    src="$(realpath -e -- "$src")" || return 1

    case "$src" in
        "$HOME"/*) ;;
        *)
            echo "错误：只允许 HOME 下的路径"
            return 1
            ;;
    esac

    local rel="${src#"$HOME"/}"
    local name="${rel##*/}"
    local pkg="$HOME/.dotfiles/$name"
    local dest="$pkg/$rel"

    [[ -e "$pkg" ]] && {
        echo "错误：包已存在：$pkg"
        return 1
    }

    [[ -e "$dest" || -L "$dest" ]] && {
        echo "错误：目标已存在：$dest"
        return 1
    }

    mkdir -p "$(dirname "$dest")" || return 1

    mv -- "$src" "$dest" || return 1
    ln -s -- "$dest" "$src" || {
        mv -- "$dest" "$src"
        return 1
    }

    echo "真实文件：$dest"
    echo "符号链接：$src"
}



