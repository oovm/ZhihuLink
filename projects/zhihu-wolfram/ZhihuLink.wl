(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*Temp Loading Flag Code*)


Temp`PackageScope`ZhihuLinkLoading`Private`$PackageLoadData =
	If[# === None, <||>, Replace[Quiet@Get@#, Except[_?OptionQ] -> <||>]]&@
		Append[
			FileNames[
				"LoadInfo." ~~ "m" | "wl",
				FileNameJoin@{DirectoryName@$InputFileName, "Config"}
			],
			None
		][[1]];
Temp`PackageScope`ZhihuLinkLoading`Private`$PackageLoadMode =
	Lookup[Temp`PackageScope`ZhihuLinkLoading`Private`$PackageLoadData, "Mode", "Primary"];
Temp`PackageScope`ZhihuLinkLoading`Private`$DependencyLoad =
	TrueQ[Temp`PackageScope`ZhihuLinkLoading`Private`$PackageLoadMode === "Dependency"];


(* ::Subsection:: *)
(*Main*)


If[Temp`PackageScope`ZhihuLinkLoading`Private`$DependencyLoad,
	If[!TrueQ[Evaluate[Symbol["`ZhihuLink`PackageScope`Private`$LoadCompleted"]]],
		Get@FileNameJoin@{DirectoryName@$InputFileName, "ZhihuLinkLoader.wl"}
	],
	If[!TrueQ[Evaluate[Symbol["ZhihuLink`PackageScope`Private`$LoadCompleted"]]],
		<< ZhihuLink`ZhihuLinkLoader`,
		BeginPackage["ZhihuLink`"];
		EndPackage[];
	]
]
