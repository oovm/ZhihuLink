Begin["ZhihuLink`Directory`"];

$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];
(*防止未创建缓存文件夹导致的问题*)
Quiet[CreateDirectory/@{$ZhihuLinkMarkdown}];
$ZhihuLinkMarkdown=FileNameJoin[{$UserBaseDirectory,"ApplicationData","HTML2Markdown","Zhihu"}];
End[];

Get["ZhihuLink`ZhihuLink`"]