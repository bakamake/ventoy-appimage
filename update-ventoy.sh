#!/usr/bin/env bash
set -euo pipefail

output_dir=$(cd -- "$(dirname -- "$0")" && pwd)
version=$(curl -fsSL https://api.github.com/repos/ventoy/Ventoy/releases/latest | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"].removeprefix("v"))')
revision=$(git -C "$output_dir" tag --list "v${version}-*" | awk -F- '$NF ~ /^[0-9]+$/ && $NF > latest { latest = $NF } END { print latest + 1 }')
package_version="${version}-${revision}"
work=$(mktemp -d "$output_dir/.ventoy-build.XXXXXXXX")
trap 'rm -rf -- "$work"' EXIT

curl -fL --retry 3 -o "$work/ventoy.tar.gz" "https://github.com/ventoy/Ventoy/releases/download/v${version}/ventoy-${version}-linux.tar.gz"
curl -fL --retry 3 -o "$work/quick-sharun" 'https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/main/useful-tools/quick-sharun.sh'
chmod +x "$work/quick-sharun"
mkdir -p "$work/source" "$work/AppDir/lib"
tar -xzf "$work/ventoy.tar.gz" -C "$work/source"
mv "$work/source/ventoy-$version" "$work/AppDir/lib/ventoy"
cp "$work/AppDir/lib/ventoy/WebUI/static/img/VentoyLogo.png" "$work/AppDir/ventoy.png"
cp "$work/AppDir/ventoy.png" "$work/AppDir/.DirIcon"

cat > "$work/AppDir/ventoy.desktop" <<'DESKTOP'
[Desktop Entry]
Name=Ventoy
Exec=ventoy
Icon=ventoy
Type=Application
Categories=System;Utility;
Terminal=false
DESKTOP

cat > "$work/AppDir/AppRun" <<'RUN'
#!/bin/sh
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
run_dir=$(mktemp -d "${TMPDIR:-/tmp}/ventoy.XXXXXXXX") || exit 1
trap 'rm -rf -- "$run_dir"' EXIT
cp -a "$here/lib/ventoy/." "$run_dir/" || exit 1
cd "$run_dir" || exit 1
./VentoyGUI.x86_64 "$@"
RUN
chmod +x "$work/AppDir/AppRun"

cd "$work"
APPDIR="$work/AppDir" OUTPATH="$work" OUTNAME="Ventoy-${package_version}-x86_64.AppImage" ./quick-sharun --make-appimage
image="Ventoy-${package_version}-x86_64.AppImage"
mv -- "$work/$image" "$output_dir/$image"
sha256sum "$output_dir/$image"
printf '打包完成：%s\n' "$output_dir/$image"
