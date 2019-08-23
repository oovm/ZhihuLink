(*win下可能无法工作 path=DirectoryName[$InputFileName]*)
path=ParentDirectory@DirectoryName@ExpandFileName[First[$ScriptCommandLine]];
Print["workspace: \n",path];Print["\n"];
(*更新模块源码*)
rawPath=FileNameJoin@{path,"Packages","__Raw"};
all=Select[FileNames["*",rawPath],StringPart[#,-1]=="l"&];
ruleD={
	"\n","\r","\t","EndPackage[]",
	RegularExpression["BeginPackage\\[((.*?))\\];"],RegularExpression["\\(\\*[\\w\\W]*?\\*\\)"]
};
ruleR={
	"Begin[\"`Private`\"];":>"\nBegin[\"`Private`\"];\n",
	"End[];":>"\nEnd[];\n"
};
build[file_]:=Block[
	{mpkg,name},
	mpkg=StringDelete[Import[file,"Text"],ruleD];
	name=FileNameJoin@{ParentDirectory@rawPath,FileBaseName[file]<>".m"};
	Export[name,StringReplace[mpkg,ruleR],"String"];
	Print["Building: "<>FileBaseName[file]]
]//Quiet;
build/@all;
(*更新版本号*)
info=FileNameJoin@{path,"PacletInfo.m"};
foo=StringReplace[#,"."~~n:DigitCharacter..~~"\"":>"."~~ToString[ToExpression[n]+1]~~"\""]&;
infoN=StringReplace[Import[info,"String"],"Version"~~x__~~"\",":>"Version"~~foo[x]~~"\","];
Export[info,infoN,"String"];