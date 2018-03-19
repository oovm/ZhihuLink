(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: ZhihuLinkObject *)
(* :Context: ZhihuLinkObject` *)
(* :Author: 28059 *)
(* :Date: 2018-03-19 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 28059 *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["ZhihuLinkObject`"];
ZhihuLinkObject::usage="";

Begin["`Object`"];

$ZhihuLinkIcon=Import[DirectoryName@FindFile["ZhihuLink`ZhihuLinkLoader`"]<>"ZhihuLinkLogo.png"];
ZhihuLinkUserObjectQ[asc_?AssociationQ]:=AllTrue[{"cookies","auth","user","valid"},KeyExistsQ[asc,#]&];
ZhihuLinkUserObjectQ[_]=False;
ZhihuLinkUserObject/:MakeBoxes[obj:ZhihuLinkUserObject[asc_?ZhihuLinkUserObjectQ],form:(StandardForm|TraditionalForm)]:=Module[
	{above,below},
	above={
		{BoxForm`SummaryItem[{"KeyID: ",Hash@asc["cookies"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"User: ",asc["user"]}],SpanFromLeft},
		{BoxForm`SummaryItem[{"Validity: ",asc["valid"]}],SpanFromLeft}
	};
	below={};
	BoxForm`ArrangeSummaryBox[
		"ServiceObject",
		obj,
		ImageResize[$ZhihuLinkIcon,48],
		above,
		below,
		form,
		"Interpretable"->Automatic
	]
];


(* Todo: 换成用户头像
ZhihuLinkUserObject[<|
	"cookies"->$ZhihuCookie,
	"auth"->$ZhihuAuth,
	"user"->Text@Style["GalAster",Darker@Blue],
	"valid"->Text@Style["Success!",Darker@Green]
|>]
*)


End[];

EndPackage[];