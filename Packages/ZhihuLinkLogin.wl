(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: ZhihuLink *)
(* :Context: ZhihuLink` *)
(* :Author: 28059 *)
(* :Date: 2018-03-20 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 28059 *)
(* :Keywords: *)
(* :Discussion: *)

FirefoxSetCookie::usage="";
Begin["`ZhihuLink`"];
(* ::Text:: *)
(*A bit of all-in-one stuffs*)


FirefoxSetCookie[directory_]:=Quiet@Block[
	{temp},
	If[SetFirefoxDirectory[directory]=!=$Failed&&Quiet[Check[EstablishCookieSQLConnection[];temp=GetCookies[],$Failed]]=!=$Failed&&VerifyCookieStatus[temp],
		temp,
		<||>
	]
];
(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{},
	{Protected,ReadProtected}
];