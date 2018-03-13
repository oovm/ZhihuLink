(*win下可能无法工作 path=DirectoryName[$InputFileName]*)
path=ParentDirectory@DirectoryName@ExpandFileName[First[$ScriptCommandLine]];
Print["workspace: \n",path];Print["\n"];
(*更新模块源码*)
rawPath=FileNameJoin@{path,"Packages","__Raw"};
all=Select[FileNames["*",rawPath],StringPart[#,-1]=="l"&];
dQ=Or@@{
	#=="",
	StringPart[#,{1,2}]==={"(","*"}&&StringPart[#,{-2,-1}]==={"*",")"},
	StringContainsQ[#,"BeginPackage"..]||StringContainsQ[#,"EndPackage"..]
}&;
build[file_]:=Block[
	{mpkg,name},
	mpkg=DeleteCases[Import[file,"List",CharacterEncoding->"UTF8"],_?dQ];
	name=FileNameJoin@{ParentDirectory@rawPath,FileBaseName[file]<>".m"};
	Export[name,mpkg,"List"];
	Print["Building: "<>FileBaseName[file]]
]//Quiet;
build/@all;
(*更新版本号*)
info=FileNameJoin@{path,"PacletInfo.m"};
foo=Block[{v},
	v=StringSplit[#,{"\"","."}][[-2]];
	StringJoin[ToString/@{" -> \"0.0.",ToExpression[v]+1,"\", "}]
]&;
infoN=StringReplace[Import[info,"String"],
	"Version"~~x__~~"WolframVersion":>"Version"~~foo[x]~~"WolframVersion"
];
Export[info,infoN,"String"];