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
ZhihuLinkKeyImport::usage="";
ZhihuLinkKeyExport::usage="";
ZhihuKeyObject::usage="";
(* ::Section:: *)
(*程序包正体*)
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*ZhihuKeyObject*)
ZhihuCookieTransform::usage="ZhihuCookieTransform[cookieraw_] takes a string of cookie and convert it into a List of Association.";
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
ZhihuCookieVerify::usage="Input ANYTHING and check whether it's a valid cookie sequence.";
ZhihuCookieVerify[cookie_]:=Block[
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
];
(* ::Subsubsection:: *)
(*Import & Export*)
If[
	Head[$ZhihuLinkDirectory]===Symbol,
	$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}],
	$ZhihuLinkCookieFile=FileNameJoin[{$ZhihuLinkDirectory,"cookie_storage"}]
];

ZhihuLinkKeyExport::usage="Export a association (usually symbolize a series of cookies) into $ZhihuLinkCookieFile after simple encryption.";
ZhihuLinkKeyImport::usage="Import cookies from $ZhihuLinkCookieFile.";

ExportCookies[asso_Association]:=(
	If[FileExistsQ@$ZhihuLinkCookieFile,DeleteFile[$ZhihuLinkCookieFile]];
	BinaryWrite[
		$ZhihuLinkCookieFile,
		Encrypt[GenerateSymmetricKey[Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",Method->"RC4"],BinarySerialize@asso]["Data"]
	];
	Close[$ZhihuLinkCookieFile];
);
ImportCookies[]:=If[FileExistsQ@$ZhihuLinkCookieFile,
	BinaryDeserialize@Decrypt[
		GenerateSymmetricKey[Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",Method->"RC4"],
		ByteArray@BinaryReadList@$ZhihuLinkCookieFile
	],
	$Failed
];

(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];
EndPackage[]