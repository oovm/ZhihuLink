(* ::Package:: *)

(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 12 Mar 2018 *)

BeginPackage["ZhihuLinkGet`"];
(* Exported symbols added here with SymbolName::usage *) 

ZhihuLinkGetRaw::usage = "";
ZhihuLinkGet::usage = "";
ZhihuLinkUserAnswer::usage = "";
ZhihuLinkUserArticle::usage = "";
ZhihuLinkUserFollowingFavlist::usage = "";
ZhihuLinkUserFollowingColumn::usage = "";
ZhihuLinkUserFollowingTopic::usage = "";
ZhihuLinkUserFollowingQuestion::usage = "";
ZhihuLinkUserFollower::usage = "";
ZhihuLinkUserFollowee::usage = "";

Begin["`Private`"];
(* Implementation of the package *)

$APIURL = <|
	"Miscellaneous" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Profile" -> <|(*用户信息*)
			"Path" -> StringTemplate["api/v4/members/`id`"]
		|>,

		"Topic" -> <|(*话题信息*)
			"Path" -> StringTemplate["api/v4/topics/`id`"]
		|>,

		"Question" -> <|(*问题信息*)
			"Path" -> StringTemplate["api/v4/questions/`id`"]
		|>,

		"Answer" -> <|(*回答信息*)
			"Path" -> StringTemplate["api/v4/answers/`id`"]
		|>,

		"Messages" -> <|(*私信*)
			"Path" -> StringTemplate["api/v4/messages"]
		|>,

		"Notifications" -> <|(*通知*)
			"Path" -> StringTemplate["api/v4/default-notifications"]
		|>
	|>,
	"Members" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Followees" -> <|(*关注的人*)
			"Path" -> StringTemplate["api/v4/members/`id`/followees"]
		|>,

		"Followers" -> <|(*关注者*)
			"Path" -> StringTemplate["api/v4/members/`id`/followers"]
		|>,

		"FollowingQuestions" -> <|(*关注的问题*)
			"Path" -> StringTemplate["api/v4/members/`id`/following-questions"]
		|>,

		"FollowingTopics" -> <|(*关注的话题*)
			"Path" -> StringTemplate["api/v4/members/`id`/following-topic-contributions"]
		|>,

		"FollowingColumns" -> <|(*关注的专栏*)
			"Path" -> StringTemplate["api/v4/members/`id`/following-columns"]
		|>,

		"FollowingFavlists" -> <|(*关注的收藏夹*)
			"Path" -> StringTemplate["api/v4/members/`id`/following-favlists"]
		|>,

		"Questions" -> <|(*提问*)
			"Path" -> StringTemplate["api/v4/members/`id`/questions"]
		|>,

		"Answers" -> <|(*回答*)
			"Path" -> StringTemplate["api/v4/members/`id`/answers"]
		|>,

		"Pins" -> <|(*想法*)
			"Path" -> StringTemplate["api/v4/members/`id`/pins"]
		|>,

		"Articles" -> <|(*文章*)
			"Path" -> StringTemplate["api/v4/members/`id`/articles"]
		|>,

		"Columns" -> <|(*专栏*)
			"Path" -> StringTemplate["api/v4/members/`id`/column-contributions"]
		|>,

		"Favlists" -> <|(*收藏*)
			"Path" -> StringTemplate["api/v4/members/`id`/favlists"]
		|>,

		"Activities" -> <|(*动态*)
			"Path" -> StringTemplate["api/v4/members/`id`/activities"]
		|>
	|>,
	"Questions" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Followers" -> <|(*关注者*)
			"Path" -> StringTemplate["api/v4/questions/`id`/concerned_followers"]
		|>,

		"Comments" -> <|(*评论*)
			"Path" -> StringTemplate["api/v4/questions/`id`/comments"]
		|>,

		"Invitees" -> <|(*被邀请的人*)
			"Path" -> StringTemplate["api/v4/questions/`id`/invitees"]
		|>,

		"InvitationCandidates" -> <|(*可能被邀请的人*)
			"Path" ->StringTemplate["api/v4/questions/`id`/invitation-candidates"]
		|>
	|>,
	"Answers" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Upvoters" -> <|(*点赞者*)
			"Path" ->StringTemplate["api/v4/answers/`id`/concerned_upvoters"]
		|>,

		"Comments" -> <|(*评论*)
			"Path" -> StringTemplate["api/v4/answers/`id`/comments"]
		|>
	|>,
	"Pins" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Comments" -> <|(*评论*)
			"Path" -> StringTemplate["api/v4/pins/`id`/comments"]
		|>
	|>,
	"Topics" -> <|
		"Scheme" -> "https",
		"Domain" -> "www.zhihu.com",

		"Followers" -> <|(*关注者*)
			"Path" -> StringTemplate["api/v4/topics/`id`/followers"]
		|>
	|>,
	"Articles" -> <|
		"Scheme" -> "https",
		"Domain" -> "zhuanlan.zhihu.com",

		"Upvoters" -> <|(*点赞者*)
			"Path" -> StringTemplate["api/posts/`id`/likers"]
		|>,


		"Comments" -> <|(*文章评论*)
			"Path" -> StringTemplate["api/posts/`id`/comments"]
		|>
	|>,
	"Columns" -> <|
		"Scheme" -> "https",
		"Domain" -> "zhuanlan.zhihu.com",

		"Followers" -> <|(*关注者*)
			"Path" -> StringTemplate["api/columns/`id`/followers"]
		|>,

		"Posts" -> <|(*文章*)
			"Path" -> StringTemplate["api/columns/`id`/posts"]
		|>
	|>
|>;


ExportJSON[cat_, item_, name_String, content_,
	OptionsPattern[{"CustomSavePath" -> None}]] :=Module[
	{path},
	If[(path = OptionValue["CustomSavePath"]) === None,
		path = FileNameJoin[{$ZhihuLinkDirectory, cat, item}],
		path = FileNameJoin[{$ZhihuLinkDir, path}]
	];
	If[! DirectoryQ[path], CreateDirectory[path]];
	Export[FileNameJoin[{path, name <> ".json"}], content]
];
  
ts[] := ToString@IntegerPart[1000 AbsoluteTime@Now];

FixURL[url_String,
	"Members","FollowingQuestions" | "Answers" | "Questions" |
     "Articles" |"Columns" | "FollowingColumns"
] := "https://www.zhihu.com/api/v4" <> StringDrop[url, 21];
  
FixURL[url_String, _, _] := url;

Options[ZhihuLinkGetRaw] = {
	"offset" -> 0,
	"limit" -> 20,
	"Extension" -> Nothing
};
ZhihuLinkGetRaw[cat_String, item_String, id_String,OptionsPattern[]] :=
	GeneralUtilities`ToAssociations[
		URLExecute[
			HTTPRequest[<|
				"Scheme" -> $APIURL[cat]["Scheme"],
				"Domain" -> $APIURL[cat]["Domain"],
				"Headers" -> {"authorization" -> $ZhihuLinkAuth}, 
				"Cookies" -> $ZhihuLinkCookies,
				"Path" -> {Evaluate[$APIURL[cat][item]["Path"][<|"id" -> id|>]]},
				"Query" -> {
					"limit" -> OptionValue@"limit",
					"offset" -> OptionValue@"offset",
					Sequence@@OptionValue["Extension"]
				}
			|>], Authentication -> None]
	];

ZhihuLinkGetRaw[url_String, OptionsPattern[]] :=
	GeneralUtilities`ToAssociations[
		URLExecute[
			HTTPRequest[url,<|
				"Headers" -> {"authorization" -> $ZhihuLinkAuth}, 
				"Cookies" -> $ZhihuLinkCookies
			|>], Authentication -> None]
	];

Options[ZhihuLinkGet] = {
	"Save" -> True,
	"CustomSavePath" -> None,
	"CustomFilename" -> None,
	"Extension" -> Nothing
};
ZhihuLinkGet[cat_String, item_String, name_String, OptionsPattern[]] := Module[
	{current, data = {}, exportname, curURL,saveQ = OptionValue["Save"]},
	(*Not implemented error*)
	If[! (KeyExistsQ[$APIURL, cat] && KeyExistsQ[$APIURL[cat], item]),Return[$Failed]];
	current = ZhihuLinkGetRaw[cat, item, name,"Extension" -> OptionValue["Extension"]];
	If[(exportname = OptionValue["CustomFilename"]) == None,exportname = name];
	If[! KeyExistsQ[current, "paging"],
		(*no paging, direct export or save*)
		If[!saveQ,
			current,
			ExportJSON[cat, item, exportname, current,"CustomSavePath" -> OptionValue["CustomSavePath"]]
		],
		(*with paging, using next to fetch all*)
		data = Join[data, current["data"]];
		While[! current["paging"]["is_end"],
			curURL = FixURL[current["paging"]["next"], cat, item];
			current = ZhihuLinkGetRaw[curURL];
			If[AssociationQ[current],data = Join[data, current["data"]],
				Echo[StringTemplate["Unable to read from: `url`."][<|"url" -> curURL|>]]
			];
		];
		If[!saveQ,
			data,
			ExportJSON[cat, item, exportname, data,	"CustomSavePath" -> OptionValue["CustomSavePath"]]
		]
	]
];

(* ?????????????????????????????????? *)
Options[ZhihuLinkUserAnswer]={Extension->None,SortBy->"created",Save->True};
ZhihuLinkUserAnswer[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "Answers", id,
	"CustomSavePath" -> "post",
	"CustomFilename" -> StringTemplate["`id`.answer.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].content,voteup_count",
			All,"include"->"data[*].is_normal,suggest_edit,comment_count,can_comment,
				content,voteup_count,reshipment_settings,comment_permission,mark_infos,created_time,updated_time,
				relationship,voting,is_author,is_thanked,is_nothelp,upvoted_followees",
			_,OptionValue[Extension]
		],
		"sort_by"->OptionValue[SortBy]
	},
	"Save"->OptionValue[Save]
];

Options[ZhihuLinkUserArticle]={Extension->None,SortBy->"created",Save->True};
ZhihuLinkUserArticle[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "Articles", id,
	"CustomSavePath" -> "post",
	"CustomFilename" -> StringTemplate["`id`.article.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].content,voteup_count",
			All,"include"->"data[*].is_normal,suggest_edit,comment_count,can_comment,
				content,voteup_count,comment_permission,created,updated,
				voting,upvoted_followees", 
			_,OptionValue[Extension]
		],
		"sort_by"->OptionValue[SortBy]
	},
	"Save"->OptionValue[Save]
];

(*#13*)
Options[ZhihuLinkUserFollowee]={Save->True};
ZhihuLinkUserFollowee[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "Followees", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.followees.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuLinkUserFollower]={Save->True};
ZhihuLinkUserFollower[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "Followers", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.followers.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuLinkUserFollowingQuestion]={Save->True};
ZhihuLinkUserFollowingQuestion[id_,OptionsPattern[]] := ZhihuLinkGet["Members", "FollowingQuestions", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.questions.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuLinkUserFollowingTopic]={Save->True};
ZhihuLinkUserFollowingTopic[id_,OptionsPattern[]] := ZhihuLinkGet["Members", "FollowingTopics", id,
	"CustomSavePath" -> "follow", 
	"CustomFilename" -> StringTemplate["`id`.topics.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuLinkUserFollowingColumn]={Save->True};
ZhihuLinkUserFollowingColumn[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "FollowingColumns", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.columns.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuLinkUserFollowingFavlist]={Save->True};
ZhihuLinkUserFollowingFavlist[id_,OptionsPattern[]] := ZhihuLinkGet[
	"Members", "FollowingFavlists", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.favlists.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];

End[];

EndPackage[]