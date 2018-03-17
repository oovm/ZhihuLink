(* ::Package:: *)

(* Wolfram Language Package *)

(* Created by the Wolfram Workbench 12 Mar 2018 *)

BeginPackage["ZhihuLinkGet`"]
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
     (*\:7528\:6237\:4fe1\:606f*)
     
     "Profile" -> <|"Path" -> StringTemplate["api/v4/members/`id`"], 
       "RequireAuth" -> False|>,
     (*\:8bdd\:9898\:4fe1\:606f*)
     
     "Topic" -> <|"Path" -> StringTemplate["api/v4/topics/`id`"], 
       "RequireAuth" -> False|>,
     (*\:95ee\:9898\:4fe1\:606f*)
     
     "Question" -> <|
       "Path" -> StringTemplate["api/v4/questions/`id`"], 
       "RequireAuth" -> False|>,
     (*\:56de\:7b54\:4fe1\:606f*)
     
     "Answer" -> <|"Path" -> StringTemplate["api/v4/answers/`id`"], 
       "RequireAuth" -> False|>,
     (*\:79c1\:4fe1*)
     
     "Messages" -> <|"Path" -> StringTemplate["api/v4/messages"], 
       "RequireAuth" -> True|>,
     (*\:901a\:77e5*)
     
     "Notifications" -> <|
       "Path" -> StringTemplate["api/v4/default-notifications"], 
       "RequireAuth" -> True|>
     |>,
   "Members" -> <|
     "Scheme" -> "https",
     "Domain" -> "www.zhihu.com",
     (*\:5173\:6ce8\:7684\:4eba*)
     
     "Followees" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/followees"], 
       "RequireAuth" -> False|>,
     (*\:5173\:6ce8\:8005*)
     
     "Followers" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/followers"], 
       "RequireAuth" -> False|>,
     (*\:5173\:6ce8\:7684\:95ee\:9898*)
     
     "FollowingQuestions" -> <|
       "Path" -> 
        StringTemplate["api/v4/members/`id`/following-questions"], 
       "RequireAuth" -> False|>,
     (*\:5173\:6ce8\:7684\:8bdd\:9898*)
     
     "FollowingTopics" -> <|
       "Path" -> 
        StringTemplate[
         "api/v4/members/`id`/following-topic-contributions"], 
       "RequireAuth" -> False|>,
     (*\:5173\:6ce8\:7684\:4e13\:680f*)
     
     "FollowingColumns" -> <|
       "Path" -> 
        StringTemplate["api/v4/members/`id`/following-columns"], 
       "RequireAuth" -> False|>,
     (*\:5173\:6ce8\:7684\:6536\:85cf\:5939*)
     
     "FollowingFavlists" -> <|
       "Path" -> 
        StringTemplate["api/v4/members/`id`/following-favlists"], 
       "RequireAuth" -> False|>,
     (*\:63d0\:95ee*)
     
     "Questions" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/questions"], 
       "RequireAuth" -> False|>,
     (*\:56de\:7b54*)
     
     "Answers" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/answers"], 
       "RequireAuth" -> False|>,
     (*\:60f3\:6cd5*)
     
     "Pins" -> <|"Path" -> StringTemplate["api/v4/members/`id`/pins"],
        "RequireAuth" -> False|>,
     (*\:6587\:7ae0*)
     
     "Articles" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/articles"], 
       "RequireAuth" -> False|>,
     (*\:4e13\:680f*)
     
     "Columns" -> <|
       "Path" -> 
        StringTemplate["api/v4/members/`id`/column-contributions"], 
       "RequireAuth" -> False|>,
     (*\:6536\:85cf*)
     
     "Favlists" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/favlists"], 
       "RequireAuth" -> False|>,
     (*\:52a8\:6001*)
     
     "Activities" -> <|
       "Path" -> StringTemplate["api/v4/members/`id`/activities"], 
       "RequireAuth" -> True|>
     |>,
   "Questions" -> <|
     "Scheme" -> "https",
     "Domain" -> "www.zhihu.com",
     (*\:5173\:6ce8\:8005*)
     
     "Followers" -> <|
       "Path" -> 
        StringTemplate["api/v4/questions/`id`/concerned_followers"], 
       "RequireAuth" -> False|>,
     (*\:8bc4\:8bba*)
     
     "Comments" -> <|
       "Path" -> StringTemplate["api/v4/questions/`id`/comments"], 
       "RequireAuth" -> False|>,(*\:88ab\:9080\:8bf7\:7684\:4eba*)
     
     "Invitees" -> <|
       "Path" -> StringTemplate["api/v4/questions/`id`/invitees"], 
       "RequireAuth" -> False|>,(*\:53ef\:80fd\:88ab\:9080\:8bf7\:7684\:4eba*)
     
     "InvitationCandidates" -> <|
       "Path" -> 
        StringTemplate["api/v4/questions/`id`/invitation-candidates"],
        "RequireAuth" -> False|>
     |>,
   "Answers" -> <|
     "Scheme" -> "https",
     "Domain" -> "www.zhihu.com",
     (*\:70b9\:8d5e\:8005*)
     
     "Upvoters" -> <|
       "Path" -> 
        StringTemplate["api/v4/answers/`id`/concerned_upvoters"], 
       "RequireAuth" -> False|>,
     (*\:8bc4\:8bba*)
     
     "Comments" -> <|
       "Path" -> StringTemplate["api/v4/answers/`id`/comments"], 
       "RequireAuth" -> False|>
     |>,
   "Pins" -> <|
     "Scheme" -> "https",
     "Domain" -> "www.zhihu.com",
     (*\:8bc4\:8bba*)
     
     "Comments" -> <|
       "Path" -> StringTemplate["api/v4/pins/`id`/comments"], 
       "RequireAuth" -> False|>
     |>,
   "Topics" -> <|
     "Scheme" -> "https",
     "Domain" -> "www.zhihu.com",
     (*\:5173\:6ce8\:8005*)
     
     "Followers" -> <|
       "Path" -> StringTemplate["api/v4/topics/`id`/followers"], 
       "RequireAuth" -> False|>
     |>,
   "Articles" -> <|
     "Scheme" -> "https",
     "Domain" -> "zhuanlan.zhihu.com",
     (*\:70b9\:8d5e\:8005*)
     
     "Upvoters" -> <|
       "Path" -> StringTemplate["api/posts/`id`/likers"], 
       "RequireAuth" -> False|>,
     (*\:6587\:7ae0\:8bc4\:8bba*)
     
     "Comments" -> <|
       "Path" -> StringTemplate["api/posts/`id`/comments"], 
       "RequireAuth" -> False|>
     |>,
   "Columns" -> <|
     "Scheme" -> "https",
     "Domain" -> "zhuanlan.zhihu.com",
     (*\:5173\:6ce8\:8005*)
     
     "Followers" -> <|
       "Path" -> StringTemplate["api/columns/`id`/followers"], 
       "RequireAuth" -> False|>,
     (*\:6587\:7ae0*)
     
     "Posts" -> <|"Path" -> StringTemplate["api/columns/`id`/posts"], 
       "RequireAuth" -> False|>
     |>
   |>;

ZhihuLinkGetInit[] :=
  Module[{},
   $ZhihuCookie = Import[FindFile["zhihu.cookie"]]; 
   $ZhihuAuth = 
	 "Bearer " <> 
	  StringCases[$ZhihuCookie, 
	    "z_c0" ~~ Shortest[__] ~~ "\"" ~~ Shortest[auth__] ~~ "\"" :> 
	     auth][[1]];
   ];
   
ExportJSON[cat_, item_, name_String, content_, 
   OptionsPattern[{"CustomSavePath" -> None}]] := 
  Module[{path}, 
   If[(path = OptionValue["CustomSavePath"]) == None, 
    path = FileNameJoin[{$ZhihuLinkDir, cat, item}]];
   If[! DirectoryQ[path], CreateDirectory[path]]; 
   Export[FileNameJoin[{path, name <> ".json"}], content]
   ];
  
ts[] := ToString@IntegerPart[1000 AbsoluteTime@Now];

FixURL[url_String, "Members", 
   "FollowingQuestions" | "Answers" | "Questions" | "Articles" | 
    "Columns" | "FollowingColumns"] := 
    "https://www.zhihu.com/api/v4" <> StringDrop[url, 21];
  
FixURL[url_String, _, _] := url;

Options[ZhihuLinkGetRaw] = {"offset" -> 0, "limit" -> 20, 
   "Extension" -> Nothing, "RequireAuth" -> False};
ZhihuLinkGetRaw[cat_String, item_String, id_String, 
   OptionsPattern[]] := 
  GeneralUtilities`ToAssociations[
   URLExecute[
    HTTPRequest[<|
      		"Scheme" -> $APIURL[cat]["Scheme"],
      		"Domain" -> $APIURL[cat]["Domain"],
      		"Headers" -> {"Cookie" -> $ZhihuCookie, 
        "authorization" -> 
         If[$APIURL[cat][item]["RequireAuth"], $ZhihuAuth, Nothing]},
      "Path" -> {Evaluate[$APIURL[cat][item]["Path"][<|"id" -> id|>]]},
      "Query" -> {"limit" -> OptionValue@"limit", 
        "offset" -> OptionValue@"offset", OptionValue["Extension"]}
      	|>], Authentication -> None]];
  
ZhihuLinkGetRaw[url_String, OptionsPattern[]] := 
  GeneralUtilities`ToAssociations[
   URLExecute[
    HTTPRequest[
     url, <|	
      "Headers" -> {"Cookie" -> $ZhihuCookie, 
        "authorization" -> 
         If[OptionValue["RequireAuth"], $ZhihuAuth, Nothing]}
      	|>], Authentication -> None]];
  
Options[ZhihuLinkGet] = {"Save" -> True, "CustomSavePath" -> None, 
   "CustomFilename" -> None, "Extension" -> Nothing};
ZhihuLinkGet[cat_String, item_String, name_String, OptionsPattern[]] :=

    Module[{current, data = {}, exportname, curURL, 
    saveQ = OptionValue["Save"]},
   (*Not implemented error*)
   
   If[! (KeyExistsQ[$APIURL, cat] && KeyExistsQ[$APIURL[cat], item]), 
    Return[$Failed]];
   current = 
    ZhihuLinkGetRaw[cat, item, name, 
     "Extension" -> OptionValue["Extension"]];
   If[(exportname = OptionValue["CustomFilename"]) == None, 
    exportname = name];
   If[! KeyExistsQ[current, "paging"],
    (*no paging, direct export or save*)
    If[! saveQ,
     current,
     ExportJSON[cat, item, exportname, current, 
      "CustomSavePath" -> OptionValue["CustomSavePath"]]]
    ,
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
    If[! saveQ,
     data,
     ExportJSON[cat, item, exportname, data, 
      "CustomSavePath" -> OptionValue["CustomSavePath"]]]
    ]
   ];
   
ZhihuLinkUserAnswer[id_] := 
  ZhihuLinkGet["Members", "Answers", id, "CustomSavePath" -> "post", 
   "CustomFilename" -> 
    StringTemplate["`id`.answer.`ts`"][<|"id" -> id, "ts" -> ts[] |>]];
    
ZhihuLinkUserArticle[id_] := 
  ZhihuLinkGet["Members", "Articles", id, "CustomSavePath" -> "post", 
   "CustomFilename" -> 
    StringTemplate["`id`.article.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];
      
ZhihuLinkUserFollowee[id_] := 
  ZhihuLinkGet["Members", "Followees", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.followees.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];
      
ZhihuLinkUserFollower[id_] := 
  ZhihuLinkGet["Members", "Followers", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.followers.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];
      
ZhihuLinkUserFollowingQuestion[id_] := 
  ZhihuLinkGet["Members", "FollowingQuestions", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.questions.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];
      
ZhihuLinkUserFollowingTopic[id_] := 
  ZhihuLinkGet["Members", "FollowingTopics", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.topics.`ts`"][<|"id" -> id, "ts" -> ts[] |>]];
    
ZhihuLinkUserFollowingColumn[id_] := 
  ZhihuLinkGet["Members", "FollowingColumns", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.columns.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];
      
ZhihuLinkUserFollowingFavlist[id_] := 
  ZhihuLinkGet["Members", "FollowingFavlists", id, 
   "CustomSavePath" -> "follow", 
   "CustomFilename" -> 
    StringTemplate["`id`.favlists.`ts`"][<|"id" -> id, 
      "ts" -> ts[] |>]];

End[]

EndPackage[]


