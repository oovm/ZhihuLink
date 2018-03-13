(*win下可能无法工作 path=DirectoryName[$InputFileName]*)
path=ParentDirectory@DirectoryName@ExpandFileName[First[$ScriptCommandLine]];
Print["workspace: \n",path];Print["\n"];
(*更新模块源码*)
rawPath=FileNameJoin@{path,"Packages","__Raw"};
all=Select[FileNames["*",rawPath],StringPart[#,-1]=="l"&];
drule={
	"\n","\r","\t","EndPackage[]",
	RegularExpression["BeginPackage\\[((.*?))\\];"],
	RegularExpression["\\(\\*[\\w\\W]*?\\*\\)"]
};
build[file_]:=Block[
	{mpkg,name},
	mpkg=StringDelete[Import[file,"Text"],drule];
	name=FileNameJoin@{ParentDirectory@rawPath,FileBaseName[file]<>".m"};
	Export[name,mpkg,"List"];
	Print["Building: "<>FileBaseName[file]]
]//Quiet;
build/@all;
(*更新版本号*)
info=FileNameJoin@{path,"PacletInfo.m"};
foo=StringReplace[#,"."~~n:DigitCharacter..~~"\"":>"."~~ToString[ToExpression[n]+1]~~"\""]&;
infoN=StringReplace[Import[info,"String"],
	"Version"~~x__~~"WolframVersion":>"Version"~~foo[x]~~"WolframVersion"
];
Export[info,infoN,"String"];