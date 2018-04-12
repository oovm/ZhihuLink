(* ::Package:: *)
(* ::Title:: *)
(*ZhihuLinkObject*)
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
BeginPackage["ZhihuLinkObject`"];
ZhihuUserObject::usage="";
CookiesGetMe::usage="";
$ZhihuLinkIcon::usage="";
(* ::Section:: *)
(*程序包正体*)
$ZhihuLinkIcon=Import[DirectoryName@FindFile["ZhihuLink`ZhihuLinkLoader`"]<>"ZhihuLinkLogo.png"];
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*ZhihuUserObject*)
Format[ZhihuUserObject[___],OutputForm]:="ZhihuUserObject[<>]";
Format[ZhihuUserObject[___],InputForm]:="ZhihuUserObject[<>]";
ZhihuUserObjectQ[asc_?AssociationQ]:=AllTrue[{"cookies","auth","user"},KeyExistsQ[asc,#]&];
ZhihuUserObjectQ[_]=False;
ZhihuUserObject/:MakeBoxes[obj:ZhihuUserObject[asc_?ZhihuUserObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"KeyID: ",Style[Hash@asc["cookies"], DigitBlock -> 5, NumberSeparator -> "-"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"User: ",Text@Style[asc["user"],Darker@Blue]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Validity: ",ZhihuCookiesTimeCheck[Now-asc["time"]]}],SpanFromLeft}
	};
	below={};
	BoxForm`ArrangeSummaryBox[
		"ServiceObject",
		obj,
		asc["img"],
		above,
		below,
		form,
		"Interpretable"->Automatic
	]
];

(* ::Subsubsection:: *)
(*ObjectPost*)
Answer2Data[post_]:=Block[
	{title=post["question","title"],qa,link},
	qa=<|"q"->post["question","id"],"a"->post["id"]|>;
	link=StringTemplate["https://www.zhihu.com/question/`q`/answer/`a`"][qa];
	<|
		"title"->Hyperlink[title,link],
		"vote"->post["voteup_count"],
		"comment"->post["comment_count"],
		"created time"->FromUnixTime@post["created_time"]
	|>
];
Article2Data[post_]:=Block[
	{title=post["title"],link=post["url"]},
	<|
		"title"->Hyperlink[title,link],
		"vote"->post["voteup_count"],
		"comment"->post["comment_count"],
		"created time"->FromUnixTime@post["created"]
	|>
];
Options[ObjectPost]={SortBy->"vote",Times->True,Take->None};
ObjectPost[user_String,OptionsPattern[]]:=Block[
	{ans,art,data,now=Now},
	ans=ZhihuUserAnswer[user,Save->False,Extension->"data[*].voteup_count,comment_count"];
	art=ZhihuUserArticle[user,Save->False,Extension->"data[*].voteup_count,comment_count"];
	data=Reverse@Dataset[Join[Answer2Data/@ans,Article2Data/@art]][SortBy[OptionValue[SortBy]]];
	If[OptionValue[Times],Echo[Now-now,"Time Used: "]];
	If[OptionValue[Take]===None,
		Return@data,
		data[All,OptionValue[Take]]//Normal
	]
];
ZhihuUserObject[ass_]["Post"]:=Block[
	{
		$ZhihuCookie=ass["cookies"],
		$ZhihuAuth=ass["auth"]
	},
	ObjectPost[ass["user"]];
];
ZhihuUserObject[ass_]["Post",ops_List]:=Block[
	{
		$ZhihuCookie=ass["cookies"],
		$ZhihuAuth=ass["auth"]
	},
		ObjectPost@@ops
];
(* ::Subsubsection:: *)
(*ObjectFollow*)
Follow2DataShort[man_]:=Block[
	{link=StringReplace[man["url"],"api/v4/"->""]},
	<|
		"name"->man["name"],
		"id"->Hyperlink[man["url_token"],link],
		"gender"->Switch[man["gender"],
			1,Style["男",Darker@Blue],
			0,Style["女",Pink],
			-1,Style["无",Darker@Green]
		],
		"favor"->man["favorited_count"],
		"fans"->man["follower_count"],
		"thank"->man["thanked_count"],
		"vote"->man["voteup_count"]
	|>
];
Options[ObjectFollow]={Take->False,Extension->False,SortBy->"fans"};
ObjectFollow[name_String,OptionsPattern[]]:=Block[
	{data},
	If[OptionValue[Extension],
		Return["功能未完成"],

		data=ZhihuUserFollowee["GalAster",Save->False,Extension->Min];
		Follow2DataShort/@data//Dataset
	]
];
ZhihuUserObject[ass_]["Follow"]:=Block[
	{
		$ZhihuCookie=Lookup[ass,"cookie"],
		$ZhihuAuth=Lookup[ass,"auth"]
	},
	ObjectFollow[Lookup[ass,"user"]];
];
ZhihuUserObject[ass_]["Follow",ops_List]:=Block[
	{
		$ZhihuCookie=Lookup[ass,"cookie"],
		$ZhihuAuth=Lookup[ass,"auth"]
	},
	ObjectFollow@@ops
];

(* ::Subsubsection:: *)
(*ObjectFavor*)

(* ::Subsubsection:: *)
(*ObjectBackup*)
ObjectBackup[name_,OptionsPattern[]]:=Block[

];


(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[]