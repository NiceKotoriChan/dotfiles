deb() {
    emulate -L zsh
    setopt pipefail

    if (( $# != 1 )); then
        echo "用法：gdeb <owner/repo>" >&2
        return 1
    fi

    local repo="$1"
    local arch="$(dpkg --print-architecture)"
    local api="https://api.github.com/repos/${repo}/releases/latest"
    local json url tmpdir pkg_arch

    for cmd in curl jq dpkg-deb; do
        if ! command -v "$cmd" >/dev/null; then
            echo "缺少依赖：$cmd" >&2
            return 1
        fi
    done

    echo "仓库：$repo"
    echo "系统架构：$arch"
    echo "正在查询最新 Release..."

    json="$(curl -fsSL "$api")" || return 1

    url="$(
        jq -er --arg arch "$arch" '
            [
                .assets[]
                | select(.name | endswith(".deb"))
                | select(.name | test("_" + $arch + "\\.deb$"))
                | .browser_download_url
            ]
            | if length > 0 then .[0]
              else error("没有找到匹配架构的 deb 包")
              end
        ' <<< "$json"
    )" || return 1

    tmpdir="$(mktemp -d)" || return 1
    trap 'rm -rf -- "$tmpdir"' EXIT

    echo "下载地址：$url"

    if ! curl -fL --retry 3 -o "$tmpdir/package.deb" "$url"; then
        return 1
    fi

    if ! dpkg-deb --info "$tmpdir/package.deb" >/dev/null; then
        echo "无效的 deb 软件包" >&2
        return 1
    fi

    pkg_arch="$(dpkg-deb -f "$tmpdir/package.deb" Architecture)" || return 1

    if [[ "$pkg_arch" != "$arch" && "$pkg_arch" != all ]]; then
        echo "架构不匹配：软件包为 $pkg_arch，系统为 $arch" >&2
        return 1
    fi

    dpkg-deb -f "$tmpdir/package.deb" Package Version Architecture

    echo "开始安装..."
    sudo dpkg -i "$tmpdir/package.deb"
}
