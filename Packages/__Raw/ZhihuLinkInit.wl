(* ::Package:: *)
(* ::Title:: *)
(*ZhihuLink*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(**)
(* ::Text:: *)
(*Creation Date: 2018-03-12*)
(*Copyright: Mozilla Public License Version 2.0*)
(* ::Program:: *)
(*1.软件产品再发布时包含一份原始许可声明和版权声明。*)
(*2.提供快速的专利授权。*)
(*3.不得使用其原始商标。*)
(*4.如果修改了源代码，包含一份代码修改说明。*)
(* ::Section:: *)
(*函数说明*)
BeginPackage["ZhihuLinkInit`"];
(* ::Section:: *)
(*程序包正体*)
$ZhihuLinkMarkdown::usage = "ZhihuLink 的缓存目录.";
$ZhihuLinkDirectory::usage = "ZhihuLink 的缓存目录.";
$ZhihuCookie::usage = "";
$ZhihuAuth::usage = "";
ZhihuConnect::usage="";
ZhihuUser::usage="";
(* ::Subsection::Closed:: *)
(*主设置*)
Begin["`Private`"];

$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];
$ZhihuLinkMarkdown=FileNameJoin[{$UserBaseDirectory,"ApplicationData","HTML2Markdown","Zhihu"}];

ZhihuConnectCookie[cookie_String]:=Block[
	{zc0,auth,me,img},
	zc0=Select[StringSplit[StringDelete[cookie," "],";"],StringTake[#,5]=="z_c0="&];
	auth="Bearer "<>StringTake[First@zc0,6;;-1];
	me=ZhihuCookiesGetMe[cookie,auth];
	Switch[me["error","code"],
		100,Text@Style["验证失败, 请刷新此 cookie",Darker@Red]//Return,
		40352,Text@Style["该账号已被限制, 请手动登陆解除限制",Darker@Red]//Return,
		_,Text@Style["Login Successfully!",Darker@Green]//Print
	];
	img=ImageResize[URLExecute[StringTake[me["avatar_url"],1;;-6]<>"r.jpg","jpg"],52];
	ZhihuLinkUserObject[<|
		"cookies"->cookie,
		"auth"->auth,
		"user"->me["url_token"],
		"img"->img,
		"time"->Now
	|>]
];
ZhihuConnectCookie[cookie_List,auth_String]:=Block[
	{me,img},
	me=ZhihuCookiesGetMe[cookie,auth];
	Switch[me["error","code"],
		100,Text@Style["验证失败, 请刷新此 cookie",Darker@Red]//Return,
		40352,Text@Style["该账号已被限制, 请手动登陆解除限制",Darker@Red]//Return,
		_,Text@Style["Login Successfully!",Darker@Green]//Print
	];
	img=ImageResize[URLExecute[StringTake[me["avatar_url"],1;;-6]<>"r.jpg","jpg"],52];
	ZhihuLinkUserObject[<|
		"cookies"->cookie,
		"auth"->auth,
		"user"->me["url_token"],
		"img"->img,
		"time"->Now
	|>]
];
Options[ZhihuConnect]={Key->"ZhihuLink"};
ZhihuConnect[id_Integer:1,OptionsPattern[]]:=Block[
	{cookie,auth,ks,key},
	If[Head@$ZhihuKeys===Symbol,
		Text@Style["请先查看你拥有的 Key!",Darker@Red]//Print;
		Return[$Canceled]
	];
	key=ReverseSort[$ZhihuKeys,#["Time"]&][[id]];
	cookie=Decrypt[OptionValue[Key],key["Key"]["Key"]];
	auth="Bearer "<>Select[cookie,#["Name"]=="z_c0"&][[1]]["Content"];
	ZhihuConnectCookie[cookie,auth]
];
ZhihuConnect[key_,OptionsPattern[]]:=Block[
	{cookie,auth,ks},
	cookie=Decrypt[OptionValue[Key],key["Key"]];
	auth="Bearer "<>Select[cookie,#["Name"]=="z_c0"&][[1]]["Content"];
	ZhihuConnectCookie[cookie,auth]
];
Options[ZhihuUser]={Key->"ZhihuLink"};
ZhihuUser[id_Integer:1,OptionsPattern[]]:=Block[
	{ks,key},
	$ZhihuKeys=ZhihuKeyImport[];
	If[$ZhihuKeys===$Failed,
		Text@Style["你没有已储存的 Key!",Darker@Red]//Print;
		Return[$Canceled]
	];
	ks=ReverseSort[$ZhihuKeys,#["Time"]&];
	key=Check[ks[[id]],Print@Text@Style["无此编号",Darker@Red];Return[$Canceled]];
	$ZhihuCookie=Decrypt[OptionValue[Key],key["Key"]["Key"]];
	$ZhihuAuth="Bearer "<>Select[$ZhihuCookie,#["Name"]=="z_c0"&][[1]]["Content"];
	Echo[Text@Style[key["ID"],Darker@Green],"当前加载 KeyID: "];
];
ZhihuUser[key_,OptionsPattern[]]:=Block[
	{},
	$ZhihuCookie=Decrypt[OptionValue[Key],key["Key"]];
	$ZhihuAuth="Bearer "<>Select[$ZhihuCookie,#["Name"]=="z_c0"&][[1]]["Content"];
	Echo[Text@Style[key["ID"],Darker@Green],"当前加载 KeyID: "];
];

(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[]