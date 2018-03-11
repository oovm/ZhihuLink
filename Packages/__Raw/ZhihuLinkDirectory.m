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
BeginPackage["ZhihuLinkDirectory`"]
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
$ZhihuLinkDirectory::usage = "打开 ZhihuLink 的缓存目录.";
Begin["`Private`"];
$zdir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}];
$sd=FileNameJoin[{$zdir,"stats"}];
$fd=FileNameJoin[{$zdir,"follows"}];
Quiet@If[
	CreateDirectory[$zdir]===$Failed,
	Nothing,
	CreateDirectory/@{$sd,$fd}
];
$ZhihuLinkDirectory[]:=SystemOpen@$zdir;
(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;
SetAttributes[
	{$ZhihuLinkDirectory},
	{Protected,ReadProtected}
];
EndPackage[];
