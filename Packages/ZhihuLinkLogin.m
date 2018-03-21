FirefoxSetCookie::usage="";
Begin["`Private`"];
FirefoxSetCookie[directory_]:=Quiet@Block[{temp},If[SetFirefoxDirectory[directory]=!=$Failed&&Quiet[Check[EstablishCookieSQLConnection[];temp=GetCookies[],$Failed]]=!=$Failed&&VerifyCookieStatus[temp],temp,<||>]];
End[];
