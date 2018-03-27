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
BeginPackage["ZhihuLinkCookies`"];
$ZhihuKeys::usage="";
ZhihuKeys::usage="";
ZhihuKeyImport::usage="Import cookies from file.";
ZhihuKeyExport::usage="Export a association (usually symbolize a series of cookies) into file after simple encryption.";
ZhihuKeyObject::usage="";
ZhihuKeyVerify::usage="验证当前 key 的可用性.";
ZhihuKeyAdd::usage = "";
ZhihuCookieTransform::usage="ZhihuCookieTransform[cookieraw_] takes a string of cookie and convert it into a List of Association.";
ZhihuCookiesGetMe::usage="";
ZhihuCookiesTimeCheck::usage="";
(* ::Section:: *)
(*程序包正体*)
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
$Get=(
	Once@Get["Authentication`"];
	Once@Get["GeneralUtilities`"];
);
(* ::Subsubsection:: *)
(*ZhihuKeyObject*)
ZhihuCookieTransform[cookieraw_String]:=Flatten@StringCases[
	StringSplit[cookieraw,";"],
	StartOfString~~name:Shortest[__]~~"="~~content__~~EndOfString:><|
		"Name"->StringDelete[name," "],
		"Content"->content
	|>
];
ZhihuCookiesGetMe[cookie_,auth_]:=Block[
	{req=HTTPRequest[
		"https://api.zhihu.com/people/self",
		<|
			"Headers"-><|"authorization"->auth|>,
			"Cookies"->cookie,
			"Query"->{"include"->"gender,voteup_count,follower_count,account_status"}
		|>]},
	GeneralUtilities`ToAssociations@URLExecute[req,Authentication->None,Interactive->False]
]//Quiet;
ZhihuCookiesTimeCheck[t_]:=Piecewise[
	{
		{Text@Style["\[Checkmark] Success!",Darker@Green],QuantityMagnitude@t<3*86400},
		{Text@Style["\[Times] Fail !!",Red],QuantityMagnitude@t>86400*25}
	},Text@Style["\[Diameter] Need Refresh",Purple]
];
Format[ZhihuKeyObject[___],OutputForm]:=Print@Style["Illegal Operation!",Darker@Red];
Format[ZhihuKeyObject[___],InputForm]:=Print@Style["Illegal Operation!",Darker@Red];
ZhihuKeyObjectQ[asc_?AssociationQ]:=AllTrue[{"Key","Time"},KeyExistsQ[asc,#]&];
ZhihuKeyObjectQ[_]=False;
ZhihuKeyObject/:MakeBoxes[obj:ZhihuKeyObject[asc_?ZhihuKeyObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"KeyID: ",Style[Hash@asc["Key"],DigitBlock->5,NumberSeparator->"-"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Remark: ",asc["Mark"]}],SpanFromLeft}
	};
	below={
		{BoxForm`SummaryItem[{"Site: ",Hyperlink["https://Zhihu.com"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Date: ",asc["Time"]}],SpanFromLeft}
	};
	BoxForm`ArrangeSummaryBox[
		"SecuredAuthenticationKey",
		obj,
		Show[Authentication`SecuredAuthenticationKey`PackagePrivate`noauthicon,ImageSize->32],
		above,
		below,
		form,
		"Interpretable"->Automatic
	]
];
ZhihuKeyObject[ass_][name_]:=Lookup[ass,name];
(* ::Subsubsection:: *)
(*ZhihuKeyObject*)
ZhihuKeyVerify::usage="Input ANYTHING and check whether it's a valid cookie sequence.";
ZhihuKeyVerify[cookie_]:=Block[
	{req,get},
	Switch[Head@cookie,
		String,ZhihuCookieTransform@cookie,
		List,cookie,
		ZhihuKeyObject,cookie["Key"],
		_,Return["UnknowKey"]
	];
	req=HTTPRequest[
		"http://www.zhihu.com/api/v4/members/vapor-vx/activities",
		<|
			"Headers"-><|"authorization"->"Bearer "<>Select[cookie,#["Name"]=="z_c0"&][[1]]["Content"]|>,
			"Cookies"->cookie,
			"Query"->{"limit"->20}
		|>];
	get=URLExecute[req,Authentication->None,Interactive->False];
	Switch[get["error","code"],
		100,Print@Text@Style["验证失败, 请刷新此 cookie",Darker@Red];False,
		40352,Print@Text@Style["该账号已被限制, 请手动登陆解除限制",Darker@Red];False,
		_,True
	]
];
(* ::Subsubsection:: *)
(*Import & Export*)
ZhihuKeyExport[ass_]:=Block[
	{file=FileNameJoin[{$ZhihuLinkDirectory,"key.wxf"}]},
	If[FileExistsQ@file,DeleteFile@file];
	BinaryWrite[file,BinarySerialize[$ZhihuKeys,PerformanceGoal->"Speed"]];
	Close[file];
];
ZhihuKeyImport[]:= Block[
	{file=FileNameJoin[{$ZhihuLinkDirectory,"key.wxf"}]},
	If[FileExistsQ@file,
		BinaryDeserialize@ReadByteArray[file],
		Print["no such file"];$Failed
	]
];

ZhihuKeyAddDialog[]:=Block[
	{},
	$CookieDialog$=None;
	$MarkDialog$=None;
	DialogInput[{
		TextCell["粘贴你的 Cookies"],
		Pane[InputField[
			Dynamic@$CookieDialog$,
			String,FieldSize->{31,{7,Infinity}},
			ContinuousAction->True
		],ImageSize->{400,400/GoldenRatio^2},Scrollbars->{False,True}],
		TextCell["备注信息,比如可以填你的用户名(可不填)"],
		InputField[Dynamic@$MarkDialog$,String,FieldSize->32.5],
		DefaultButton[DialogReturn["Success"]]
	},WindowTitle->"需要Token"];
	{$CookieDialog$,$MarkDialog$}
];

Options[ZhihuKeyAdd]={Key->"ZhihuLink",Check->True};
ZhihuKeyAdd[OptionsPattern[]]:=Block[
	{keyR, now, ass, cookie, mark, keyE},
	{cookie,mark}=ZhihuKeyAddDialog[];
	keyR=ZhihuCookieTransform@cookie;
	If[OptionValue[Check],
		If[!ZhihuKeyVerify@keyR,Return[$Failed]];
	];
	keyE=Encrypt[OptionValue[Key],keyR];
	now=DateString@Now;
	ass=<|
		"Key"->ZhihuKeyObject[<|"Key"->keyE,"Time"->now,"Mark"->mark|>],
		"ID"->Style[Hash@keyR,DigitBlock->5,NumberSeparator->"-"],
		"Time"->now,
		"State"->If[OptionValue[Check],
			Style["\[Checkmark] Verified!",Darker@Green],
			Style["\[Times] Unknow",Darker@Red]
		],
		"Mark"->mark
	|>;
	$ZhihuKeys=ZhihuKeyImport[];
	If[$ZhihuKeys===$Failed,$ZhihuKeys={}];
	$ZhihuKeys=DeleteDuplicatesBy[Join[$ZhihuKeys,{ass}],#["ID"]&];
	ZhihuKeyExport[$ZhihuKeys];
	Echo[
		Text@Style[Hash@keyR,Darker@Blue,DigitBlock->5,NumberSeparator->"-"],
		"Successfully Add:\n"
	];
];



(* ::Subsubsection:: *)
(*ZhihuKeys*)
ZhihuKeys[]:=Block[
	{ks},
	$ZhihuKeys=ZhihuKeyImport[];
	If[$ZhihuKeys===$Failed,
		Text@Style["你没有已储存的 Key!",Darker@Red]//Print;
		Return[$Canceled]
	];
	ks=ReverseSort[$ZhihuKeys,#["Time"]&];
	MapIndexed[#1/.ZhihuKeyObject[x_]->First@#2&,ks]//Dataset
];
ZhihuKeys["List"]:=Block[
	{ks},
	$ZhihuKeys=ZhihuKeyImport[];
	If[$ZhihuKeys===$Failed,
		Text@Style["你没有已储存的 Key!",Darker@Red]//Print;
		Return[$Canceled]
	];
	#["Key"]&/@$ZhihuKeys
];



(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[]