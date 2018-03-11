Begin["`ZhihuLinkInstall`"];
(*检查是否创建缓存文件*)
$zdir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];
$sd=FileNameJoin[{$zdir,"stats"}];
$fd=FileNameJoin[{$zdir,"follows"}];
Quiet[CreateDirectory/@{$zdir,$sd,$fd}];
(*删除旧版本并安装新版本*)
paclets = PacletFind["PacletTemplate"];
Map[PacletUninstall,paclets];
PacletInstall[$LastestPaclet, IgnoreVersion -> True];
End[];