(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: Math *)
(* :Context: Math` *)
(* :Author: 28059 *)
(* :Date: 2018-03-27 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 28059 *)
(* :Keywords: *)
(* :Discussion: *)

Gini::usage="";
GiniPlot::usage="";
Begin["`ZhihuLinkMath`"];

Gini[dt_List]:=With[
	{sorted=Accumulate[Sort[dt]],n=N@Length[dt]},
	(2/n)*Mean[MapIndexed[First[#2]-#1&,sorted*(n/Last[sorted])]]
];
Options[GiniPlot]={
	Log->True,
	PlotStyle->{Lighter@Blue,Lighter@Red}
};
GiniPlot[raw_List,OptionsPattern[]]:=Block[
	{
		data=Max[raw]Sort[raw]/Max[Accumulate@raw],
		l,m,p,fi,li,gini,legend,img
	},
	l=Length@data;m=Last@Accumulate@data;
	fi=Interpolation[Accumulate@data,InterpolationOrder->1];
	li=Interpolation[{{0,0},{l,m}},InterpolationOrder->1];
	gini=Row@{
		Style["基尼系数: "],
		Style[#,Blend[{Blue,Red},#/100.],Bold]
	}&[Round[10000Gini[data]]/100.];
	legend=Placed[LineLegend[
		{Lighter@Blue,Lighter@Red},
		{"劳伦兹曲线","绝对の平等"},
		LegendFunction->"Frame",
		LegendLayout->"Column",
		LegendLabel->Placed[gini,Bottom]
	],
		If[OptionValue[Log],{{0.8,0.3},{0.5,1}},{{0.25,0.95},{0.5,1}}]
	];
	img=If[OptionValue[Log],LogPlot,Plot][{fi[x],li[x]},{x,1,l},
		Filling->{1->Bottom,2->{1}},PlotLegends->legend,
		PlotStyle->OptionValue[PlotStyle],AspectRatio->1,
		ImageSize->320
	]
];


(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];