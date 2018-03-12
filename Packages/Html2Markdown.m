Html2Markdown::usage = "将HTML转化为Markdown格式的方案集合.";
H2MD::usage = "将HTML转化为Markdown格式.\r
	Module->Zhihu, 针对知乎回答的转换方案\r
	Module->Zhuanlan, 针对知乎专栏的转换方案\r
	Module->WordPress, 针对 wp 的转换方案\r
";
$DirectoryH2MD::usage = "打开 Html2Markdown 的缓存目录.";
Begin["`Private`"];
$dir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","Html2Markdown"}];
Quiet@CreateDirectory[$dir];
$DirectoryH2MD[]:=SystemOpen@$dir;
Options[H2MD]={Module->Zhihu,Save->False};
H2MD[input_String,OptionsPattern[]]:=Block[
	{output},
	output=Switch[
		OptionValue[Module],
		Zhihu,
			ZhihuRule`ZhihuH2MD[input],
		Zhuanlan,
			ZhuanlanRule`ZhuanlanH2MD[input]
	];
	If[OptionValue[Save],Export[]]
];
Begin["ZhihuRule`"];
ruleTexline=XMLElement["img",{"src"->__,"alt"->tex__,__},{}]:>StringJoin["$",tex,"$"];
ruleTexdisplay=XMLElement["p",{},{XMLElement["img",{"src"->__,"alt"->tex__,__},{}]}]:>StringJoin["\n$$",tex,"$$\n"];
rulePara=XMLElement["p",{},{para__}]:>StringJoin["\n",para,"\n"];
ruleHr=XMLElement["hr",{},{}]:>"\n---\n";
ruleF=XMLElement["figure",{},{}]:>Nothing;
ruleS=XMLElement["noscript",___]:>Nothing;
ruleImg=XMLElement["img",{___,"data-original"->img__,___},{}]:>StringJoin["![](",img,")"];
ruleLi=XMLElement["li",{},{li__}]:>StringJoin["> ",li,"\n"];
ruleUl=XMLElement["ul",{},{ul__}]:>StringJoin["\n",ul,"\n"];
ZhihuH2MD[input_String]:=Block[
	{xml,yu},
	xml=ImportString[input,{"HTML","XMLObject"}];
	yu=xml/.{ruleTexdisplay,ruleTexline,ruleImg,ruleLi};
	body=Part[yu/.{rulePara,ruleHr,ruleF,ruleS,ruleUl},2,3,1];
	StringJoin[ToString/@body[[3]]]
];
End[];
End[];