$ZhihuLinkMarkdown::usage = "ZhihuLink \:7684\:7f13\:5b58\:76ee\:5f55.";$ZhihuLinkDirectory::usage = "ZhihuLink \:7684\:7f13\:5b58\:76ee\:5f55.";$ZhihuCookie::usage = "";$ZhihuAuth::usage = "";ZhihuLinkInit::usage = "";
Begin["`Private`"];
$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];$ZhihuLinkMarkdown=FileNameJoin[{$UserBaseDirectory,"ApplicationData","HTML2Markdown","Zhihu"}];ZhihuConnectCookie::usage="";ZhihuLinkInit[] :=Block[{zc0},$ZhihuCookie = Import[FindFile["zhihu.cookie"]];zc0=Select[StringSplit[StringDelete[$ZhihuCookie," "],";"],StringTake[#,5]=="z_c0="&];$ZhihuAuth="Bearer "<>StringTake[First@zc0,6;;-1];];
End[];
SetAttributes[{},{Protected,ReadProtected}];