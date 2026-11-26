# Ventoy AppImage

将 [Ventoy 官方 Linux 归档](https://github.com/ventoy/Ventoy/releases) 原样放入 AppImage；`AppRun` 切换至 Ventoy 目录后启动 `VentoyGUI.x86_64`。不额外打包系统库，不改变 Ventoy 的磁盘操作与提权方式。

```sh
./update-ventoy.sh 1.1.18
git add .
git commit -m 'Package Ventoy 1.1.18'
git tag v1.1.18
git push origin master
git push origin v1.1.18
```

不传版本参数时，脚本取上游最新正式版。临时文件在打包结束后清理；仓库根目录保留 AppImage，推送标签后 Action 将其发布到 Release。
