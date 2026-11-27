# Ventoy AppImage

将 [Ventoy 官方 Linux 归档](https://github.com/ventoy/Ventoy/releases) 放入 AppImage。`AppRun` 将上游目录复制到宿主临时目录，再从该目录启动 `VentoyGUI.x86_64`；GUI 自行通过 `pkexec` 请求权限。复制目录避免提权后的进程无法访问仅向启动用户开放的 AppImage FUSE 挂载。进程退出后清理临时目录；不额外打包系统库。

```sh
./update-ventoy.sh 1.1.18 1
git add .
git commit -m 'Package Ventoy 1.1.18-1'
git tag v1.1.18-1
git push origin master
git push origin v1.1.18-1
```

第一个参数是上游版本，第二个参数是打包修订号；不传时分别取上游最新正式版和 `1`。构建临时文件在打包结束后清理；仓库根目录保留 AppImage，推送标签后 Action 将其发布到 Release。
