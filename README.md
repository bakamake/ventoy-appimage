# Ventoy AppImage

将 [Ventoy 官方 Linux 归档](https://github.com/ventoy/Ventoy/releases) 放入 AppImage。`AppRun` 将上游目录复制到宿主临时目录，再从该目录启动 `VentoyGUI.x86_64`；GUI 自行通过 `pkexec` 请求权限。复制目录避免提权后的进程无法访问仅向启动用户开放的 AppImage FUSE 挂载。进程退出后清理临时目录；不额外打包系统库。

```sh
./update-ventoy.sh
image=$(ls -t Ventoy-*-x86_64.AppImage | head -1)
version=${image#Ventoy-}
version=${version%-x86_64.AppImage}
git add .
git commit -m "Package Ventoy $version"
git tag "v$version"
git push origin master
git push origin "v$version"
```

脚本自动查询上游最新正式版，并根据本地已有标签递增打包修订号；无需传版本参数。构建临时文件在打包结束后清理；仓库根目录保留 AppImage，推送标签后 Action 将其发布到 Release。
