(* ::Package:: *)

SetDirectory@NotebookDirectory[];


files = FileNames["*.wl", FileNameJoin[{ParentDirectory[], "Packages"}]];
$FixRule = {
	char : RegularExpression["\\\\:.{4}"] :> ParseCharacter@char,
	char : ("\\[" ~~ Shortest[c__] ~~ "]") :> ParseCharacter@char
};
ParseCharacter = With[{t = ToExpression[#, InputForm, Unevaluated]}, SymbolName@t]&;
FixFile[file_String] := Export[file,
	ToCharacterCode[StringReplace[Import[file, "Text"], $FixRule], "UTF-8"],
	"Binary"
];
FixFile /@ files
