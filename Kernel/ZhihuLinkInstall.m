Begin["ZhihuLinkInstall`"];
time=Now;
(*check encode, this file must use ASCII or say English*)
If[$CharacterEncoding=!="UTF-8",
	$CharacterEncoding="UTF-8";
	Print[{
		Style["$CharacterEncoding has changed to UTF-8 to avoid problems.",Red],
		Style["Because ZhihuLink was written under UTF-8"]
	}//TableForm];
	st=OpenAppend[FindFile["init.m"]];
	WriteString[st,"$CharacterEncoding=\"UTF8\";"];
	Close[st];
];
(*check directory*)
$zdir=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}]
Quiet[CreateDirectory/@{
	$zdir,
	FileNameJoin[{$zdir,"stats"}],
	FileNameJoin[{$zdir,"user"}],
	FileNameJoin[{$zdir,"follow"}],
	FileNameJoin[{$zdir,"post"}]
}];
(*delete old and install new*)
get=HTTPRequest["https://api.github.com/repos/wjxway/ZhihuLink-Mathematica/releases/latest/assets"];
api=Check[Association@URLExecute[get, TimeConstraint->5.12],
	Style["Connect to github.com timeout! Please check your internet.",Red];
	Abort[]
];
download=SortBy[
	"browser_download_url"/.api["assets"],
	ToExpression[StringSplit[#,{"-","."}][[-2]]]&
]//First;
Echo[download,"Now downloading from: \n"];
olds=PacletFind["ZhihuLink"];
If[olds=!={},
	Echo[Map[#["Location"]&,paclets]//TableForm,"Uninstall local paclets: \n"];
	Map[PacletUninstall,olds]
];
ver=PacletInstall[download,IgnoreVersion->True];
Echo[ver,"Success installing new Vision!\n"];
Echo[Now-time,"Time used: "];
End[];
Clear["ZhihuLinkInstall`*"];
CellPrint@Cell["<<ZhihuLink`","Output",CellAutoOverwrite->True]