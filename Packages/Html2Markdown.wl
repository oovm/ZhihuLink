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
Html2Markdown::usage = "将HTML转化为Markdown格式的方案集合.";
H2MD::usage = "将HTML转化为Markdown格式.\r
	Module->\"Zhihu\", 针对知乎回答的转换方案\r
	Module->\"Zhuanlan\", 针对知乎专栏的转换方案\r
	Module->\"WordPress\", 针对 wp 的转换方案\r
";
$DirectoryH2MD::usage = "打开 Html2Markdown 的缓存目录.";
XMLShow::usage = "";
(* ::Section:: *)
(*程序包正体*)
Begin["`Html2Markdown`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
$dir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","Html2Markdown"}];
Quiet@CreateDirectory[$dir];
$DirectoryH2MD[]:=SystemOpen@$dir;
Options[H2MD]={Module->"Zhihu",Save->False};
H2MD[input_String,OptionsPattern[]]:=Switch[
	OptionValue[Module],
	"Zhihu",ZhihuH2MD[input],
	"Zhuanlan",ZhuanlanH2MD[input]
];
(* ::Subsubsection:: *)
(*ZhihuH2MD*)
Options[ZhihuH2MD]={Debug->False};
ZhihuH2MD[input_String,OptionsPattern[]]:=Block[
	{
		pre=input,(*pre=StringReplace[raw["content"],"figure"->"body"];*)
		xml,yu,body
	},
	xml=ImportString[pre,{"HTML","XMLObject"}];
	yu=xml/.{
		XMLElement["h1",{},{h__}]:>StringJoin["\n# ",h,"\n"],
		XMLElement["h2",{},{h__}]:>StringJoin["\n## ",h,"\n"],
		XMLElement["h3",{},{h__}]:>StringJoin["\n### ",h,"\n"],
		XMLElement["h4",{},{h__}]:>StringJoin["\n#### ",h,"\n"],
		XMLElement["h5",{},{h__}]:>StringJoin["\n##### ",h,"\n"],
		XMLElement["h6",{},{h__}]:>StringJoin["\n###### ",h,"\n"],
		XMLElement["a",{___,"href"->url_,___},{f_}]:>StringJoin["[",f,"](",url,")"],(*超链接*)
		XMLElement["b",{},{b__}]:>StringJoin["**",b,"**"],(*粗体标识*)
		XMLElement["figure",{},{}]->Nothing,
		XMLElement["figcaption",{},{}]->Nothing,
		XMLElement["noscript",___]->Nothing,
		XMLElement["img",{___,"data-actualsrc"->img__,___},{}]:>StringJoin["![](",img,")"],
		XMLElement["img",{"src"->__,"alt"->tex__,__},{}]:>StringJoin["$",tex,"$"],(*TeX 行内公式*)
		XMLElement["p",{},{XMLElement["img",{"src"->__,"alt"->tex__,__},{}]}]:>StringJoin["\n$$",tex,"$$\n"],(*TeX 行间公式*)

		XMLElement["br",___]:>"\n",
		XMLElement["hr",___]:>"\n---\n"
	};
	body=Part[yu/.{
		XMLElement["p",{},{para___}]:>StringJoin["\n",para,"\n"],(*段落标识*)
		XMLElement["blockquote",{},q_]:>StringJoin@Riffle[q,"> ",{1,-1,3}],

		XMLElement["ul",{},{ul__}]:>StringJoin["\n",ul,"\n"],
		XMLElement["div",___,{XMLElement["pre",{},{raw_}]}]:>raw,
		XMLElement["li",{},{li__}]:>StringJoin["> ",li,"\n"],
		XMLElement["code",___,{__,code_}]:>StringJoin["\n```\n",code,"```\n"]
	},2,3,1];
	If[OptionValue[Debug],
		Return[body],
		StringJoin[ToString/@body[[3]]]
	]
];
(* ::Subsubsection:: *)
(*XMLShow*)
XMLNote[XMLElement[tag_,attributes_,data_], m_Integer]:=Cell[CellGroupData[
	{
		Cell[TextData[StyleBox[tag,FontFamily->"Swiss",FontWeight->"Bold",FontSize->15]]],
		Sequence@@(XMLNote[#1,m]&)/@attributes,
		Sequence@@(XMLNote[#1,m+30]&)/@data
	},Open],
	CellMargins->{{m,Inherited},{Inherited,Inherited}}
];
XMLNote[{an_String,a_String}->v_String,m_Integer]:=Cell[TextData[
	{
		StyleBox[an,FontColor->Hue[0.6]]," ",
		StyleBox[a,FontWeight->"Bold"]," = ",
		StyleBox[v,Background->GrayLevel[0.8]]
	}
],
	CellMargins->{{m+5,Inherited},{Inherited,Inherited}}
];
XMLNote[a_String->v_String,m_Integer]:=Cell[TextData[
	{
		StyleBox[a,FontWeight->"Bold"]," = ",
		StyleBox[v,Background->GrayLevel[0.8]]
	}],
	CellMargins->{{m+5,Inherited},{Inherited,Inherited}}
];
XMLNote[s_String,m_Integer]:=Cell[s,Background->GrayLevel[0.9],CellMargins->{{m+25,Inherited},{Inherited,Inherited}}];
XMLShow[input_String]:=NotebookPut@Notebook[
	{XMLNote[ImportString[input,{"HTML","XMLObject"}][[2]],0]},
	CellGrouping->"Manual"
];
(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];