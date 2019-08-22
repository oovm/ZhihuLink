(* ::Package:: *)
(* ::Title:: *)
(*ZhihuLinkGet*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(* Created by the Wolfram Workbench 12 Mar 2018 *)
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
ZhihuUser::usage = "";
ZhihuUserAnswer::usage = "";
ZhihuUserArticle::usage = "";
ZhihuUserFollowingFavlist::usage = "";
ZhihuUserFollowingColumn::usage = "";
ZhihuUserFollowingTopic::usage = "";
ZhihuUserFollowingQuestion::usage = "";
ZhihuUserFollower::usage = "";
ZhihuUserFollowee::usage = "";
ZhihuTopicFollower::usage = "";
ZhihuTopicEssence::usage = "";
ZhihuTopicAnswerer::usage = "";
(* ::Section:: *)
(*程序包正体*)
Begin["`ZhihuLinkGet`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*$APIURL*)
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
		|>,

		"Essence" -> <|(*精华*)
			"Path" -> StringTemplate["api/v4/topics/`id`/feeds/essence"]
		|>,

		"TopQuestions" -> <|(*精华问题*)
			"Path" -> StringTemplate["api/v4/topics/`id`/feeds/top_question"]
		|>,

		"TimelineQuestions" -> <|(*最新问题*)
			"Path" -> StringTemplate["api/v4/topics/`id`/feeds/timeline_question"]
		|>,

		"BestAnswerers" -> <|(*优秀答主*)
			"Path" -> StringTemplate["api/v4/topics/`id`/best_answerers"]
		|>,

		"TopActivities" -> <|(*精华动态*)
			"Path" -> StringTemplate["api/v4/topics/`id`/feeds/top_activity"]
		|>,

		"TimelineActivities" -> <|(*最新动态*)
			"Path" -> StringTemplate["api/v4/topics/`id`/feeds/timeline_activity"]
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
(* ::Subsubsection:: *)
(*ZhihuGet*)
ExportJSON[cat_, item_, name_String, content_,OptionsPattern[{"CustomSavePath" -> None}]] :=Module[
	{path},
	If[(path = OptionValue["CustomSavePath"]) === None,
		path = FileNameJoin[{$ZhihuLinkDirectory, cat, item}],
		path = FileNameJoin[{$ZhihuLinkDirectory, path}]
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

Options[ZhihuGetRaw] = {
	"offset" -> 0,
	"limit" -> 20,
	"Extension" -> Nothing
};
ZhihuGetRaw[cat_String, item_String, id_String,OptionsPattern[]] :=
	GeneralUtilities`ToAssociations[
		URLExecute[
			HTTPRequest[<|
				"Scheme" -> $APIURL[cat]["Scheme"],
				"Domain" -> $APIURL[cat]["Domain"],
				"Headers" -> {"authorization" -> $ZhihuAuth},
				"Cookies" -> $ZhihuCookie,
				"Path" -> {Evaluate[$APIURL[cat][item]["Path"][<|"id" -> id|>]]},
				"Query" -> {
					"limit" -> OptionValue@"limit",
					"offset" -> OptionValue@"offset",
					Sequence@@OptionValue["Extension"]
				}
			|>],
			Authentication -> None,
			Interactive -> False
		]
	];

ZhihuGetRaw[url_String, OptionsPattern[]] :=
	GeneralUtilities`ToAssociations[
		URLExecute[
			HTTPRequest[url,<|
				"Headers" -> {"authorization" -> $ZhihuAuth},
				"Cookies" -> $ZhihuCookie
			|>],
			Authentication -> None,
			Interactive -> False
		]
	];

Options[ZhihuGet] = {
	"Save" -> True,
	"CustomSavePath" -> None,
	"CustomFilename" -> None,
	"Extension" -> Nothing
};
ZhihuGet[cat_String, item_String, name_String, OptionsPattern[]] := Module[
	{current, data = {}, exportname, curURL,saveQ = OptionValue["Save"]},
	(*Not implemented error*)
	If[! (KeyExistsQ[$APIURL, cat] && KeyExistsQ[$APIURL[cat], item]),Return[$Failed]];
	current = ZhihuGetRaw[cat, item, name,"Extension" -> OptionValue["Extension"]];
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
			current = ZhihuGetRaw[curURL];
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
(* ::Subsubsection:: *)
(*ZhihuUser*)
Options[ZhihuUser]={Extension->None,Save->True};
ZhihuUser[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "Answers", id,
	"CustomSavePath" -> "user",
	"CustomFilename" -> StringTemplate["`id`.user.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"follower_count,voteup_count,favorited_count,thanked_count",
			Max,"include"->"follower_count,voteup_count,favorited_count,thanked_count,following_question_count,
				following_count,answer_count,articles_count,question_count,logs_count,favorite_count,
				following_favlists_count,columns_count,pins_count",
			All,"include"->"locations,employments,gender,educations,business,voteup_count,thanked_Count,
				follower_count,following_count,cover_url,following_topic_count,following_question_count,
				following_favlists_count,following_columns_count,avatar_hue,answer_count,articles_count,
				pins_count,question_count,columns_count,commercial_question_count,favorite_count,favorited_count,
				logs_count,included_answers_count,included_articles_count,included_text,message_thread_token,
				account_status,is_active,is_bind_phone,is_force_renamed,is_bind_sina,is_privacy_protected,
				sina_weibo_url,sina_weibo_name,show_sina_weibo,is_blocking,is_blocked,is_following,is_followed,
				is_org_createpin_white_user,mutual_followees_count,vote_to_count,vote_from_count,thank_to_count,
				thank_from_count,thanked_count,description,hosted_live_count,participated_live_count,allow_message,
				industry_category,org_name,org_homepage,badge[?(type=best_answerer)].topics",
			_,  "include"-> OptionValue[Extension]
		]
	},
	"Save"->OptionValue[Save]
];
Options[ZhihuUserAnswer]={Extension->None,SortBy->"created",Save->True};
ZhihuUserAnswer[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "Answers", id,
	"CustomSavePath" -> "post",
	"CustomFilename" -> StringTemplate["`id`.user.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].content,voteup_count",
			All,"include"->"data[*].is_normal,suggest_edit,comment_count,can_comment,content,voteup_count,
				reshipment_settings,comment_permission,mark_infos,created_time,updated_time,relationship,
				voting,is_author,is_thanked,is_nothelp,upvoted_followees",
			_,  "include"->OptionValue[Extension]
		],
		"sort_by"->OptionValue[SortBy]
	},
	"Save"->OptionValue[Save]
];
Options[ZhihuUserArticle]={Extension->None,SortBy->"created",Save->True};
ZhihuUserArticle[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "Articles", id,
	"CustomSavePath" -> "post",
	"CustomFilename" -> StringTemplate["`id`.article.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].content,voteup_count",
			All,"include"->"data[*].is_normal,suggest_edit,comment_count,can_comment,content,
				voteup_count,comment_permission,created,updated,voting,upvoted_followees",
			_,  "include"->OptionValue[Extension]
		],
		"sort_by"->OptionValue[SortBy]
	},
	"Save"->OptionValue[Save]
];
(* ::Subsubsection:: *)
(*ZhihuUserFollow*)
Options[ZhihuUserFollowee]={Save->True,Extension->None};
ZhihuUserFollowee[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "Followees", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.followees.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].follower_count,voteup_count,favorited_count,thanked_count",
			All,"include"->"data[*].answer_count", (*todo: filter line 301*)
			_,  "include"->OptionValue[Extension]
		]
	},
	"Save"->OptionValue[Save]
];
Options[ZhihuUserFollower]={Save->True,Extension->None};
ZhihuUserFollower[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "Followers", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.followers.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Extension" -> {
		Switch[OptionValue[Extension],
			None,Nothing,
			Min,"include"->"data[*].follower_count,voteup_count,favorited_count,thanked_count",
			All,"include"->"data[*].answer_count", (*todo: filter line 301*)
			_,  "include"->OptionValue[Extension]
		]
	},
	"Save"->OptionValue[Save]
];
Options[ZhihuUserFollowingQuestion]={Save->True};
ZhihuUserFollowingQuestion[id_,OptionsPattern[]] := ZhihuGet["Members", "FollowingQuestions", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.questions.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuUserFollowingTopic]={Save->True};
ZhihuUserFollowingTopic[id_,OptionsPattern[]] := ZhihuGet["Members", "FollowingTopics", id,
	"CustomSavePath" -> "follow", 
	"CustomFilename" -> StringTemplate["`id`.topics.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuUserFollowingColumn]={Save->True};
ZhihuUserFollowingColumn[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "FollowingColumns", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.columns.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuUserFollowingFavlist]={Save->True};
ZhihuUserFollowingFavlist[id_,OptionsPattern[]] := ZhihuGet[
	"Members", "FollowingFavlists", id,
	"CustomSavePath" -> "follow",
	"CustomFilename" -> StringTemplate["`id`.favlists.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
(*Topic*)
Options[ZhihuTopicFollower]={Save->True};
ZhihuTopicFollower[id_,OptionsPattern[]] := ZhihuGet[
	"Topics", "Followers", id,
	"CustomSavePath" -> "topic",
	"CustomFilename" -> StringTemplate["`id`.followers.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuTopicEssence]={Save->True};
ZhihuTopicEssence[id_,OptionsPattern[]] := ZhihuGet[
	"Topics", "Essence", id,
	"CustomSavePath" -> "topic",
	"CustomFilename" -> StringTemplate["`id`.essence.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
Options[ZhihuTopicAnswerer]={Save->True};
ZhihuTopicAnswerer[id_,OptionsPattern[]] := ZhihuGet[
	"Topics", "BestAnswerers", id,
	"CustomSavePath" -> "topic",
	"CustomFilename" -> StringTemplate["`id`.answerers.`ts`"][<|"id" -> id, "ts" -> ts[] |>],
	"Save"->OptionValue[Save]
];
(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];