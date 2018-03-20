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
ZhihuLinkInit::usage = "";

(* ::Subsection::Closed:: *)
(*主设置*)
Begin["`Private`"];
$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];
$ZhihuLinkMarkdown=FileNameJoin[{$UserBaseDirectory,"ApplicationData","HTML2Markdown","Zhihu"}];


ZhihuLinkInit[] :=Block[
	{zc0},
	$ZhihuCookie = Import[FindFile["zhihu.cookie"]];
	zc0=Select[StringSplit[StringDelete[$ZhihuCookie," "],";"],StringTake[#,5]=="z_c0="&];
	$ZhihuAuth="Bearer "<>StringTake[First@zc0,6;;-1];
];


(*
ZhihuLinkGetCheck[];
If[FindFile["zhihu.cookie"] === $Failed,
	$ZhihuCookie = "";
	"未检测到 zhihu.cookie 文件\n
	请使用 ZhihuCookiesReset[] 设置你的cookies.",
	$ZhihuCookie = Import@FindFile["zhihu.cookie"]
];
ZhihuCookiesReset[]:=CreateDialog[{
	TextCell["粘贴你的Cookies(不需要是字符型)"],
	InputField[Dynamic[$ZhihuCookies],String,ImageSize->{400,400/GoldenRatio^2}],
	DefaultButton[DialogReturn[$ZhihuCookies]]
},
	WindowTitle->"需要Token"
];

*)
(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[];
