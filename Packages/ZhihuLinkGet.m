 (* Wolfram Language Package *)

(* Created by the Wolfram Workbench 12 Mar 2018 *)

(* Exported symbols added here with SymbolName::usage *)

ZhihuLinkGetRaw::usage = "";
ZhihuLinkGet::usage = "";

Begin["`Private`"]
(* Implementation of the package *)

Needs["GeneralUtilities`"];

$APIURL = <|
"Miscellaneous" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*用户信息*)

"Profile" -> <|"Path" -> StringTemplate["api/v4/members/`id`"],
"RequireAuth" -> False|>,
(*话题信息*)

"Topic" -> <|"Path" -> StringTemplate["api/v4/topics/`id`"],
"RequireAuth" -> False|>,
(*问题信息*)

"Question" -> <|
"Path" -> StringTemplate["api/v4/questions/`id`"],
"RequireAuth" -> False|>,
(*回答信息*)

"Answer" -> <|"Path" -> StringTemplate["api/v4/answers/`id`"],
"RequireAuth" -> False|>,
(*私信*)

"Messages" -> <|"Path" -> StringTemplate["api/v4/messages"],
"RequireAuth" -> True|>,
(*通知*)

"Notifications" -> <|
"Path" -> StringTemplate["api/v4/default-notifications"],
"RequireAuth" -> True|>
|>,
"Members" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*关注的人*)

"Followees" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/followees"],
"RequireAuth" -> False|>,
(*关注者*)

"Followers" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/followers"],
"RequireAuth" -> False|>,
(*关注的问题*)

"FollowingQuestions" -> <|
"Path" ->
StringTemplate["api/v4/members/`id`/following-questions"],
"RequireAuth" -> False|>,
(*关注的话题*)

"FollowingTopics" -> <|
"Path" ->
StringTemplate[
               "api/v4/members/`id`/following-topic-contributions"],
"RequireAuth" -> False|>,
(*关注的专栏*)

"FollowingColumns" -> <|
"Path" ->
StringTemplate["api/v4/members/`id`/following-columns"],
"RequireAuth" -> False|>,
(*关注的收藏夹*)

"FollowingFavlists" -> <|
"Path" ->
StringTemplate["api/v4/members/`id`/following-favlists"],
"RequireAuth" -> False|>,
(*提问*)

"Questions" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/questions"],
"RequireAuth" -> False|>,
(*回答*)

"Answers" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/answers"],
"RequireAuth" -> False|>,
(*想法*)

"Pins" -> <|"Path" -> StringTemplate["api/v4/members/`id`/pins"],
"RequireAuth" -> False|>,
(*文章*)

"Articles" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/articles"],
"RequireAuth" -> False|>,
(*专栏*)

"Columns" -> <|
"Path" ->
StringTemplate["api/v4/members/`id`/column-contributions"],
"RequireAuth" -> False|>,
(*收藏*)

"Favlists" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/favlists"],
"RequireAuth" -> False|>,
(*动态*)

"Activities" -> <|
"Path" -> StringTemplate["api/v4/members/`id`/activities"],
"RequireAuth" -> True|>
|>,
"Questions" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*关注者*)

"Followers" -> <|
"Path" ->
StringTemplate["api/v4/questions/`id`/concerned_followers"],
"RequireAuth" -> False|>,
(*评论*)

"Comments" -> <|
"Path" -> StringTemplate["api/v4/questions/`id`/comments"],
"RequireAuth" -> False|>,(*被邀请的人*)

"Invitees" -> <|
"Path" -> StringTemplate["api/v4/questions/`id`/invitees"],
"RequireAuth" -> False|>,(*可能被邀请的人*)

"InvitationCandidates" -> <|
"Path" ->
StringTemplate["api/v4/questions/`id`/invitation-candidates"],
"RequireAuth" -> False|>
|>,
"Answers" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*点赞者*)

"Upvoters" -> <|
"Path" ->
StringTemplate["api/v4/answers/`id`/concerned_upvoters"],
"RequireAuth" -> False|>,
(*评论*)

"Comments" -> <|
"Path" -> StringTemplate["api/v4/answers/`id`/comments"],
"RequireAuth" -> False|>
|>,
"Pins" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*评论*)

"Comments" -> <|
"Path" -> StringTemplate["api/v4/pins/`id`/comments"],
"RequireAuth" -> False|>
|>,
"Topics" -> <|
"Scheme" -> "https",
"Domain" -> "www.zhihu.com",
(*关注者*)

"Followers" -> <|
"Path" -> StringTemplate["api/v4/topics/`id`/followers"],
"RequireAuth" -> False|>
|>,
"Articles" -> <|
"Scheme" -> "https",
"Domain" -> "zhuanlan.zhihu.com",
(*点赞者*)

"Upvoters" -> <|
"Path" -> StringTemplate["api/posts/`id`/likers"],
"RequireAuth" -> False|>,
(*文章评论*)

"Comments" -> <|
"Path" -> StringTemplate["api/posts/`id`/comments"],
"RequireAuth" -> False|>
|>,
"Columns" -> <|
"Scheme" -> "https",
"Domain" -> "zhuanlan.zhihu.com",
(*关注者*)

"Followers" -> <|
"Path" -> StringTemplate["api/columns/`id`/followers"],
"RequireAuth" -> False|>,
(*文章*)

"Posts" -> <|"Path" -> StringTemplate["api/columns/`id`/posts"],
"RequireAuth" -> False|>
|>
|>;

ZhihuLinkGetInit[] :=
Module[{},
       $ZhihuCookie = Import[FindFile["zhihu.cookie"]];
       $ZhihuAuth = Import[FindFile["zhihu.auth"]];
       ];

ExportJSON[cat_, item_, name_String, content_,
           OptionsPattern[{"CustomSavePath" -> None}]] :=
Module[{path},
       If[(path = OptionValue["CustomSavePath"]) == None,
          path = FileNameJoin[{cat, item}]];
       If[! DirectoryQ[path], CreateDirectory[path]];
       Export[FileNameJoin[{path, name <> ".json"}], content]
       ];

ts[] := ToString@IntegerPart[1000 AbsoluteTime@Now];

FixURL[url_String, "Members",
       "FollowingQuestions" | "Answers" | "Questions" | "Articles" |
       "Columns" | "FollowingColumns"] :=
"https://www.zhihu.com/api/v4" <> StringDrop[url, 21];

FixURL[url_String, _, _] := url;

ZhihuLinkGetRaw[cat_String, item_String, id_String, offset_: 0, limit_: 20] :=
GeneralUtilities`ToAssociations[
                                URLExecute[
                                           HTTPRequest[<|
                                                       "Scheme" -> $APIURL[cat]["Scheme"],
                                                       "Domain" -> $APIURL[cat]["Domain"],
                                                       "Headers" -> {"Cookie" -> $ZhihuCookie,
                                                           "authorization" -> If[$APIURL[cat][item]["RequireAuth"], $ZhihuAuth, Nothing]},
                                                       "Path" -> {Evaluate[$APIURL[cat][item]["Path"][<|"id" -> id|>]]},
                                                       "Query" -> {"limit" -> limit, "offset" -> offset}
                                                       |>],
                                           Authentication -> None]
                                ];

ZhihuLinkGetRaw[url_String, requireAuthQ_: False] :=
GeneralUtilities`ToAssociations[URLExecute[HTTPRequest[url,
                                                       <|"Headers" -> {
                                                           "Cookie" -> $ZhihuCookie,
                                                           "authorization" -> If[requireAuthQ, $ZhihuAuth, Nothing]}
                                                       |>],
                                           Authentication -> None]
                                ];

ZhihuLinkGet[cat_String, item_String, name_String,
             OptionsPattern[{"CustomSavePath" -> None,
    "CustomFilename" -> None}]] :=

Module[{current, data = {}, exportname, curURL},
       (*Not implemented error*)
       
       If[! (KeyExistsQ[$APIURL, cat] && KeyExistsQ[$APIURL[cat], item]),
          Return[$Failed]];
       current = ZhihuLinkGetRaw[cat, item, name];
       If[(exportname = OptionValue["CustomFilename"]) == None,
          exportname = name];
       If[! KeyExistsQ[current, "paging"],
          (*no paging, direct export*)
          
          ExportJSON[cat, item, exportname, current,
                     "CustomSavePath" -> OptionValue["CustomSavePath"]],
          (*with paging, using next to fetch all*)
          
          data = Join[data, current["data"]];
          While[! current["paging"]["is_end"],
                curURL = FixURL[current["paging"]["next"], cat, item];
                current = ZhihuLinkGetRaw[curURL];
                If[AssociationQ[current],
                   data = Join[data, current["data"]],
                   Echo[
                        StringTemplate["Unable to read from: `url`."][<|
                                                                      "url" -> curURL|>]]];
                ];
          ExportJSON[cat, item, exportname, data,
                     "CustomSavePath" -> OptionValue["CustomSavePath"]]
          ]
       ];

ZhihuLinkUserAnswer[id_] :=
ZhihuLinkGet["Members", "Answers", id, "CustomSavePath" -> "post",
             "CustomFilename" ->
             StringTemplate["`id`.answer.`ts`"][<|"id" -> id, "ts" -> ts[] |>]];

ZhihuLinkUserArticle[id_] :=
ZhihuLinkGet["Members", "Articles", id, "CustomSavePath" -> "post",
             "CustomFilename" ->
             StringTemplate["`id`.article.`ts`"][<|"id" -> id, "ts" -> ts[] |>]];

End[]


