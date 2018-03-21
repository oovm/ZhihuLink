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
ZhihuKeyImport::usage="Import cookies from file.";
ZhihuKeyExport::usage="Export a association (usually symbolize a series of cookies) into file after simple encryption.";
ZhihuKeyObject::usage="";
ZhihuKeyVerify::usage="验证当前 key 的可用性.";
ZhihuKeyAdd::usage = "";
ZhihuCookieTransform::usage="ZhihuCookieTransform[cookieraw_] takes a string of cookie and convert it into a List of Association.";
(* ::Section:: *)
(*程序包正体*)
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
Needs["Authentication`"];
(* ::Subsubsection:: *)
(*ZhihuKeyObject*)
ZhihuCookieTransform[cookieraw_String]:=Flatten@StringCases[
	StringSplit[cookieraw,";"],
	StartOfString~~name:Shortest[__]~~"="~~content__~~EndOfString:><|
		"Name"->StringDelete[name," "],
		"Content"->content
	|>
];
Format[ZhihuKeyObject[___],OutputForm]:=Print@Style["Illegal Operation!",Darker@Red];
Format[ZhihuKeyObject[___],InputForm]:=Print@Style["Illegal Operation!",Darker@Red];
ZhihuKeyObjectQ[asc_?AssociationQ]:=AllTrue[{"Key","Time"},KeyExistsQ[asc,#]&];
ZhihuKeyObjectQ[_]=False;
ZhihuKeyObject/:MakeBoxes[obj:ZhihuKeyObject[asc_?ZhihuKeyObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"KeyID: ",Style[Hash@asc["Key"],DigitBlock->5,NumberSeparator->"-"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Date: ",asc["Time"]}],SpanFromLeft}
	};
	below={
		{BoxForm`SummaryItem[{"Site: ",Hyperlink["https://Zhihu.com"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Remark: ",asc["Mark"]}],SpanFromLeft}
	};
	BoxForm`ArrangeSummaryBox[
		"ZhihuKey",
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
ZhihuKeyVerify[cookie_]:=Check[Block[
	{req,get},
	Switch[Head@cookie,
		String,ProcessRawCookie@cookie,
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
],Print@Text@Style["未知错误",Darker@Red];False];
(* ::Subsubsection:: *)
(*Import & Export*)
Options[ZhihuKeyExport]={Key->None};
ZhihuKeyExport[ass_,OptionsPattern[]]:=Block[
	{file=FileNameJoin[{$ZhihuLinkDirectory,"key.wxf"}]},
	BinaryWrite[
		file,
		BinarySerialize[Encrypt[
			Switch[OptionValue[Key],
				None,Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",
				_,OptionValue[Key]
			], ass],PerformanceGoal->"Speed"]
	];
	Close[file];
];
Options[ZhihuKeyImport]={Key->None,Message->True};
ZhihuKeyImport[OptionsPattern[]]:= Block[
	{file=FileNameJoin[{$ZhihuLinkDirectory,"key.wxf"}]},
	If[FileExistsQ@file,
		Decrypt[
			Switch[OptionValue[Key],
				None,Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",
				_,OptionValue[Key]
			],
			BinaryDeserialize@ByteArray@BinaryReadList@file
		],
		If[OptionValue[Message],Print["no such file"];];
		$Failed
	]
];

ZhihuKeyAddDialog[]:=Block[
	{},
	$CookieDialog$=None;
	$MarkDialog$=None;
	DialogInput[{
		TextCell["粘贴你的 Cookies"],InputField[Dynamic@$CookieDialog$,String,FieldSize->100,ImageSize->{400,400/GoldenRatio^2}],
		TextCell["备注信息,比如可以填你的用户名(可不填)"],
		InputField[Dynamic@$MarkDialog$,String,FieldSize->32.5]
		,DefaultButton[DialogReturn["Success"]]
	},WindowTitle->"需要Token"];
	{$CookieDialog$,$MarkDialog$}
];


Options[ZhihuKeyAdd]={Key->None,Check->True};
ZhihuKeyAdd[OptionsPattern[]]:=Block[
	{key,now,ass,cookie,mark},
	{cookie,mark}=ZhihuKeyAddDialog[];
	key=ZhihuCookieTransform@cookie;
	If[OptionValue[Check],
		If[!ZhihuKeyVerify@key,Return[$Failed]];
	];
	now=DateString@Now;
	ass=<|
		"Key"->ZhihuKeyObject[<|"Key"->key,"Time"->now,"Mark"->mark|>],
		"ID"->Style[Hash@key,DigitBlock->5,NumberSeparator->"-"],
		"Time"->now,
		"State"->If[OptionValue[Check],
			Text@Style["\[Checkmark] Verified!",Darker@Green],
			Text@Style["\[Chi] Unknow",Darker@Red]
		],
		"Mark"->mark
	|>;
	If[Head@$ZhihuKeys===Symbol,
		$ZhihuKeys=ZhihuKeyImport[Message->False,Key->OptionValue[Key]];
		If[$ZhihuKeys===$Failed,$ZhihuKeys={}]
	];
	DeleteDuplicatesBy[AppendTo[$ZhihuKeys,ass],#["ID"]&];
	ZhihuKeyExport[$ZhihuKeys,Key->OptionValue[Key]];
	Echo[
		Text@Style[Hash@key,Darker@Blue,DigitBlock->5,NumberSeparator->"-"],
		"Successfully Add:\n"
	];
];
(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[]