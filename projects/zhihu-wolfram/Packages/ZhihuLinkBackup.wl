(* ::Package:: *)

(* ::Title:: *)
(*ZhihuLinkBackup*)


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


ZhihuAnswerBackup::ussage = "";
ZhihuArticleBackup::ussage = "";


(* ::Section:: *)
(*程序包正体*)


Begin["`ZhihuLinkBackup`"];

Options[Answer2MD] = {Debug -> False, MetaInformation -> True};
Answer2MD[post_, OptionsPattern[]] := Block[
	{md, name},
	md = {
		"title: " <> post["question", "title"],
		"author: " <> post["author", "name"],
		"date: " <> DateString@FromUnixTime[post["created_time"]],
		"---",
		Sequence @@ If[OptionValue[MetaInformation],
			{
				"url: " <> StringTemplate["https://www.zhihu.com/question/`q`/answer/`a`"][<|"q" -> post["question", "id"], "a" -> post["id"]|>],
				"last_modify: " <> DateString@FromUnixTime[post["updated_time"]],
				"author_id: " <> post["author", "url_token"],
				"voteup: " <> ToString@post["voteup_count"],
				"now_time: " <> DateString@Now,
				"---"
			},
			Nothing
		],
		H2MD[post["content"], Module -> "Zhihu"]
	};
	If[OptionValue[Debug],
		Return[md],
		name = StringDelete[StringJoin[post["author", "name"], "-", post["question", "title"], ".md"], {"？", "，"}];
		Export[FileNameJoin[{$ZhihuLinkMarkdown, name}], md, "Text"]
	]
];
Options[ZhihuAnswerBackup] = {MetaInformation -> True, Times -> True};
ZhihuAnswerBackup[id_String, OptionsPattern[]] := Block[
	{i = 1, n, get, now = Now},
	Print@Style[Text["正在抓取 " <> id <> " 的回答"], Blue];
	get = ZhihuUserAnswer[id, Extension -> Min, Save -> False];
	Print@Style[Text["共抓取到 " <> ToString[Length@get] <> " 个回答, 转换中....."], Brown];
	Monitor[
		Table[Answer2MD[n, MetaInformation -> OptionValue[MetaInformation]];i++, {n, get}],
		Grid[{
			{Text[Style["Question: ", Darker[Blue, 0.66]]], Style[Text[n["question", "title"]], Red]},
			{Text[Style["Progress: ", Darker[Blue, 0.66]]], ProgressIndicator[i / Length@get]}
		}, Alignment -> Left, Dividers -> Center]
	];
	If[OptionValue[Times], Echo[Now - now, "Time Used: "]];
];

Options[Article2MD] = {Debug -> False, MetaInformation -> True};
Article2MD[post_, OptionsPattern[]] := Block[
	{md, name},
	md = {
		"title: " <> post["title"],
		"author: " <> post["author", "name"],
		"date: " <> DateString@FromUnixTime[post["created"]],
		"---",
		Sequence @@ If[OptionValue[MetaInformation],
			{
				"url: " <> post["url"],
				"last_modify: " <> DateString@FromUnixTime[post["updated"]],
				"author_id: " <> post["author", "url_token"],
				"vote: " <> ToString@post["voteup_count"],
				"now_time: " <> DateString@Now,
				StringJoin["![](", post["image_url"], ")"],
				"---"
			}, Nothing],
		H2MD[post["content"], Module -> "Zhihu"]
	};
	If[OptionValue[Debug],
		Return[md],
		name = StringDelete[
			StringJoin[post["author", "name"], "-", post["title"], ".md"], {"？", "，"}
		];
		Export[FileNameJoin[{$ZhihuLinkMarkdown, name}], md, "Text"]
	]
];
Options[ZhihuArticleBackup] = {MetaInformation -> True, Times -> True};
ZhihuArticleBackup[id_String, OptionsPattern[]] := Block[
	{i = 1, n, get, now = Now},
	Print@Style[Text["正在抓取 " <> id <> " 的文章"], Blue];
	get = ZhihuUserArticle[id, Extension -> Min, Save -> False];
	Print@Style[Text["共抓取到 " <> ToString[Length@get] <> " 篇文章, 转换中....."], Brown];
	Monitor[
		Table[Article2MD[n, MetaInformation -> OptionValue[MetaInformation]];i++, {n, get}],
		Grid[{
			{Text[Style["Article: ", Darker[Blue, 0.66]]], Style[Text[n["title"]], Green]},
			{Text[Style["Progress: ", Darker[Blue, 0.66]]], ProgressIndicator[i / Length@get]}
		}, Alignment -> Left, Dividers -> Center]
	];
	If[OptionValue[Times], Echo[Now - now, "Time Used: "]];
];



(* ::Subsection::Closed:: *)
(*附加设置*)


End[];
SetAttributes[
	{},
	{Protected, ReadProtected}
];