(* ::Package:: *)

(* ::Title:: *)
(*ZhihuLinkCookies*)


(* ::Section:: *)
(*Begin Package*)


BeginPackage["ZhihuLinkCookies`"];


(* ::Section:: *)
(*Verify Cookie Status*)


(* ::Text:: *)
(*A handy trick to check the validity of cookies*)


VerifyCookieStatus::usage="Input ANYTHING and check whether it's a valid cookie sequence."


VerifyCookieStatus[cookie___]:=If[Length@{cookie}!=1||Head[cookie]=!=List||Length@cookie==0||Or@@((Head[#]=!=Association)&/@cookie),False,
FreeQ[Quiet[Check[TimeConstrained[
Keys@GeneralUtilities`ToAssociations[URLExecute[HTTPRequest["http://www.zhihu.com/api/v4/members/vapor-vx/activities",<|"Headers"-><|"authorization"->"Bearer "<>Select[cookie,#["Name"]=="z_c0"&][[1]]["Content"]|>,"Cookies"->cookie,"Query"->{"limit"->50}|>],Authentication->None,Interactive->False]],2,"error"],
"error"]],"error"]]


(* ::Section:: *)
(*Manual Input*)


ProcessRawCookie::usage="ProcessRawCookie[cookieraw_] takes a string of cookie and convert it into a List of Association."


ProcessRawCookie[cookieraw_String]:=Flatten@StringCases[StringSplit[cookieraw,";"],StartOfString~~name:Shortest[__]~~"="~~content__~~EndOfString:><|"Name"->StringDelete[name," "],"Content"->content|>]


(* ::Section:: *)
(*From Saved Logs*)


(* ::Text:: *)
(*Preprocessing*)


If[Head[$ZhihuLinkDirectory]===Symbol,$ZhihuLinkDirectory=FileNameJoin[{$UserBaseDirectory,"ApplicationData","ZhihuLink"}]];
$ZhihuLinkCookieFile=FileNameJoin[{$ZhihuLinkDirectory,"cookie_storage"}];


ExportCookies::usage="Export a association (usually symbolize a series of cookies) into $ZhihuLinkCookieFile after simple encryption.";
ImportCookies::usage="Import cookies from $ZhihuLinkCookieFile."


ExportCookies[asso_Association]:=(If[FileExistsQ@$ZhihuLinkCookieFile,DeleteFile[$ZhihuLinkCookieFile]]BinaryWrite[$ZhihuLinkCookieFile,Encrypt[GenerateSymmetricKey[Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",Method->"RC4"],BinarySerialize@asso]["Data"]];Close[$ZhihuLinkCookieFile];)


ImportCookies[]:=If[FileExistsQ@$ZhihuLinkCookieFile,BinaryDeserialize@Decrypt[GenerateSymmetricKey[Uncompress@"1:eJxTTMoPClZmYGAIycgsVgCikoxUhezUSoW0/CKF5Pz87MxUheKS/KLE9FRFACiWDlA=",Method->"RC4"],ByteArray@BinaryReadList@$ZhihuLinkCookieFile],$Failed]


(* ::Section:: *)
(*From Firefox's Cookie File*)


(* ::Text:: *)
(*A typical evaluation is:*)
(**)
(*	SetFirefoxDirectory[Automatic]*)
(*	EstablishCookieSQLConnection[]*)
(*	GetCookies[]*)
(**)
(*or*)
(**)
(*	FirefoxSetCookie[Automatic]*)


(* ::Text:: *)
(*Preprocessing*)


<<DatabaseLink`


SetFirefoxDirectory::filenf="Improperly set directory!";
SetFirefoxDirectory::usage="Set directory to firefox's cookie file.
Please select A FOLDER instead of the cookie itself.
Typical Usage:
	SetFirefoxDirectory[Automatic]: Automatically set directory, might fail in some cases.
	SetFirefoxDirectory[]: Open a window for selection.
	SetFirefoxDirectory[dir_String]: Direct input.
";

EstablishCookieSQLConnection::usage="Establish SQL connction to cookie file";
GetRawCookies::usage="Do not use, use GetCookies instead.";
GetCookies::usage="Get cookies used by Zhihu and return in a Association form.";
FirefoxSetCookie::usage="A bit of all-in-one function to import firefox's cookie file.
Typical Usage: FirefoxSetCookie[Automatic]"


SetFirefoxDirectory[dir_String]:=
Block[{r},If[FileExistsQ@dir&&Length[r=TimeConstrained[Flatten@StringCases[Import@dir,___~~"cookies.sqlite"],1,{}]]!=0,$FirefoxCookieFile=FileNameJoin[{dir,r[[1]]}],Message[SetFirefoxDirectory::filenf];$Failed]]

(*Needs to be updated according to OS*)
SetFirefoxDirectory[Automatic]:=SetFirefoxDirectory[FileNameJoin[{$HomeDirectory,"AppData\\Roaming\\Mozilla\\Firefox\\Profiles"}]];

SetFirefoxDirectory[]:=SetFirefoxDirectory[SystemDialogInput["Directory",$HomeDirectory]];


EstablishCookieSQLConnection[]:=(If[Head[$CookieSQLConnection]===Symbol,CloseSQLConnection@$CookieSQLConnection];$CookieSQLConnection=OpenSQLConnection[JDBC["SQLite",$FirefoxCookieFile],"Name"->"cookie"];)


GetRawCookies[]:=Select[
SQLSelect[$CookieSQLConnection,{"moz_cookies"},{
	SQLColumn[{"moz_cookies","baseDomain"}],
	SQLColumn[{"moz_cookies","host"}],
	SQLColumn[{"moz_cookies","Path"}],
	SQLColumn[{"moz_cookies","name"}],
	SQLColumn[{"moz_cookies","value"}],
	SQLColumn[{"moz_cookies","expiry"}],
	SQLColumn[{"moz_cookies","isHTTPOnly"
}]}],First@#=="zhihu.com"&]


GetCookies[]:=<|"Domain"->If[StringTake[#2,1]===".",StringTake[#2,{2,-1}],#2],"Path"->#3,"Name"->#4,"Content"->#5,"ExpirationDate"->FromUnixTime@#6,"AllowSubdomains"->True,"ConnectionType"->All,"ScriptAccessible"->#7|>&@@@GetRawCookies[]


(* ::Text:: *)
(*A bit of all-in-one stuffs*)


FirefoxSetCookie[directory_]:=Quiet[Block[{temp},If[SetFirefoxDirectory[directory]=!=$Failed&&Quiet[Check[EstablishCookieSQLConnection[];temp=GetCookies[],$Failed]]=!=$Failed&&VerifyCookieStatus[temp],temp,<||>]]]


(* ::Section:: *)
(*Select Cookies Dialog*)


OpenCookieDialog::usage="Open a Dialog to Import cookies using multiple methods."


(* ::Subsection:: *)
(*Segments*)


MainPanel[]:=Column[{
Style["Please Select a Method\n   to Load Cookies",20],
Button[Column[{Style["",15],Style["Load From Firefox",30,Bold],Style["(Recommended)",15]},Alignment->Center],cookietemp=FirefoxSetCookie[Automatic];mode=If[cookietemp===<||>,"FirefoxManual","FirefoxAuto"],ImageSize->{300,100}],
Button[Style["Load From File",30,Bold],mode="File",ImageSize->{300,100}],
Button[Style["Manual Enter",30,Bold],mode="Manual",ImageSize->{300,100}]
},Alignment->Center]


FirefoxPanelAuto[]:=Column[{
Style["Firefox Cookies Found!\n",25],
Button[Style["Confirm",30,Bold],DialogReturn@cookietemp,ImageSize->{300,50}],
Button[Style["Manually Set Directory",20],mode="FirefoxManual",ImageSize->{300,30}],
Button[Style["Back to Main Menu",20],mode="Main",ImageSize->{300,30}]
}]


FirefoxPanelManual[]:=DynamicModule[{directory="",text="Please Set Directory Above",temp=<||>},Column[{
Style["Firefox cookie not found,\nPlease manually set directory.",18],
Hyperlink["How to Set Directory?", "https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data"],
FileNameSetter[Dynamic[directory],"Directory",Appearance->Graphics[{GrayLevel[.9],Rectangle[{-3,-1},{3,1}],Black,Text[Style["Set Directory",30,Bold],{0,0}]},PlotRange->{{-3,3},{-1,1}},ImageSize->{300,100}]
,ImageSize->{300,100}],
Dynamic[text],
Button[Style["Confirm",30,Bold],If[(temp=FirefoxSetCookie[directory])=!=<||>,DialogReturn@temp,text="Directory Invalid!"],ImageSize->{300,50}],
Button[Style["Back to Main Menu",20],mode="Main",ImageSize->{300,30}]
}]]


FilePanel[]:=DynamicModule[{temp},If[VerifyCookieStatus[temp=ImportCookies[]],
Column[{
Style["Cookies Found!",20],
Button[Style["Confirm",30,Bold],DialogReturn[temp],ImageSize->{300,50}],
Button[Style["Back to Main Menu",20],mode="Main",ImageSize->{300,30}]
}],
Column[{
Style["Cookies Invalid!",20],
Button[Style["Back to Main Menu",25,Bold],mode="Main",ImageSize->{300,50}]
}]]
]


ManualPanel[]:=DynamicModule[{cookieraw="",text="Please Input Cookie Texts Above"},
Column[{
Style["Please Manually Input Cookie",20],
Hyperlink["Help Me!","https://github.com/wjxway/ZhihuLink-Mathematica/blob/master/Resources/doc/login.md"],
Pane[InputField[Dynamic@cookieraw,String,ImageSize->280,FieldSize->{Automatic,{1,Infinity}},Appearance->"Frameless",ContinuousAction->True,ContinuousAction->True],ImageSize->{300,200},Scrollbars->{False,True}],
Dynamic@text,
Button[Style["Confirm",30,Bold],If[VerifyCookieStatus[ProcessRawCookie[cookieraw]],DialogReturn@ProcessRawCookie[cookieraw],cookieraw="";text="Input Invalid!"],ImageSize->{300,50}],
Button[Style["Back to Main Menu",20],mode="Main",ImageSize->{300,30}]
}]
]


(* ::Subsection:: *)
(*All-in-All*)


(* ::Text:: *)
(*Note that this function will return only the cookie itself or $Canceled*)


OpenCookieDialog[]:=Block[{mode="Main",successful=False,cookietemp=<||>},
DialogInput[
Dynamic@Switch[mode,
"Main",MainPanel[],
"FirefoxAuto",FirefoxPanelAuto[],
"FirefoxManual",FirefoxPanelManual[],
"File",FilePanel[],
"Manual",ManualPanel[]
]
]
]


(* ::Section:: *)
(*Save Cookies*)


(* ::Text:: *)
(*Save cookie in multiple places, including:*)
(*	1. $ZhihuLinkCookieFile in SSD*)
(*	2. $ZhihuLinkCookies in Memory*)
(*	3. $ZhihuLinkAuth for authentication in Memory*)
(*	4. Return value*)


SaveCookies::usage="Save cookies everywhere!"


SaveCookies[]:=Block[{cookies=OpenCookieDialog[]},If[cookies===$Canceled,$Failed,
ExportCookies[cookies];
$ZhihuLinkCookies=cookies;
$ZhihuLinkAuth="Bearer "<>Select[cookie,#["Name"]=="z_c0"&][[1]]["Content"];
cookies]]


(* ::Section:: *)
(*End Package*)


EndPackage[]
