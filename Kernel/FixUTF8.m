(* ::Package:: *)

SetDirectory@NotebookDirectory[];


files=FileNames["*.wl",FileNameJoin[{ParentDirectory[],"Packages"}]];
$FixRule=char:RegularExpression["\\\\:.{4}"]:>ToString@ToExpression@char;
FixFile[name_String]:=Export[name,StringReplace[Import[name,"Text"],$FixRule],"Text"];
FixFile/@files
