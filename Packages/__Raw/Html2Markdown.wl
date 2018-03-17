(* ::Package:: *)
(* ::Title:: *)
(*Html2Markdown*)
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
BeginPackage["Html2Markdown`"];
Html2Markdown::usage = "将HTML转化为Markdown格式的方案集合.";
H2MD::usage = "将HTML转化为Markdown格式.\r
	Module->\"Zhihu\", 针对知乎回答的转换方案\r
	Module->\"Zhuanlan\", 针对知乎专栏的转换方案\r
	Module->\"WordPress\", 针对 wp 的转换方案\r
";
$DirectoryH2MD::usage = "打开 Html2Markdown 的缓存目录.";
(* ::Section:: *)
(*程序包正体*)
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
$dir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","Html2Markdown"}];
Quiet@CreateDirectory[$dir];
$DirectoryH2MD[]:=SystemOpen@$dir;
Options[H2MD]={Module->"Zhihu",Save->False};
H2MD[input_String,OptionsPattern[]]:=Switch[
	OptionValue[Module],
	"Zhihu",
		ZhihuRule`ZhihuH2MD[input],
	"Zhuanlan",
		ZhuanlanRule`ZhuanlanH2MD[input]
];
(* ::Subsubsection:: *)
(*ZhihuRule*)
Begin["ZhihuRule`"];
	(*tex 行内公式*)
	ruleTexline=XMLElement["img",{"src"->__,"alt"->tex__,__},{}]:>StringJoin["$",tex,"$"];
	(*tex 行间公式*)
	ruleTexdisplay=XMLElement["p",{},{XMLElement["img",{"src"->__,"alt"->tex__,__},{}]}]:>StringJoin["\n$$",tex,"$$\n"];
	(*p 段落模式*)
	rulePara=XMLElement["p",{},{para__}]:>StringJoin["\n",para,"\n"];
	(*hr 分割线*)
	ruleHr=XMLElement["hr",{},{}]:>"\n---\n";
	(*mma 解析异常*)
	ruleF=XMLElement["figure",{},{}]:>Nothing;
	(*noscript 渣画质*)
	ruleS=XMLElement["noscript",___]:>Nothing;
	(*img 源画质*)
	ruleImg1=XMLElement["img",{___,"data-original"->img__,___},{}]:>StringJoin["![](",img,")"];
	ruleImg2=XMLElement["img",{___,"data-actualsrc"->img__,___},{}]:>StringJoin["![](",img,")"];
	(*引用格式*)
	ruleLi=XMLElement["li",{},{li__}]:>StringJoin["> ",li,"\n"];
	ruleUl=XMLElement["ul",{},{ul__}]:>StringJoin["\n",ul,"\n"];
	ruleBq=XMLElement["blockquote",{},q_]:>StringJoin@Riffle[q,"> ",{1,-1,3}];
	(*图片下文字*)
	ruleFc=XMLElement["figcaption",{},{}]:>"\n图注:";
	(*超链接*)
	ruleA=XMLElement["a",{___,"href"->url_,___},{f__}]:>StringJoin["[",f,"](",url,")"];
	(*空行*)
	ruleBr=XMLElement["br",___]:>"\n";
	(*代码格式*)
	ruleCode1=XMLElement["code",___,{__,code_}]:>StringJoin["\n```\n",code,"```\n"];
	ruleCode2=XMLElement["div",___,{XMLElement["pre",{},{raw_}]}]:>raw;
	(*EndRules*)
Options[ZhihuH2MD]={Debug->False};
ZhihuH2MD[input_String,OptionsPattern[]]:=Block[
	{xml,yu,body},
	xml=ImportString[input,{"HTML","XMLObject"}];
	yu=xml/.{ruleTexdisplay,ruleTexline,ruleImg1,ruleImg2,ruleLi,ruleA,ruleFc,ruleBr,ruleCode1};
	body=Part[yu/.{rulePara,ruleHr,ruleF,ruleS,ruleUl,ruleCode2,ruleBq},2,3,1];
	If[OptionValue[Debug],
		Return[body],
		StringJoin[ToString/@body[[3]]]
	]
];
End[];



End[];

EndPackage[]