(* ::Package:: *)

BeginPackage["ZhihuLink`"];


SessionActiveQ::usage = "Help Function for WebTools`";
GetCurrentURL::usage = "Help Function for WebTools`";

ZhihuLinkLogin::usage = "Try to login:
ZhihuLinkLogin[] will open a login panel.
ZhihuLinkLogin[Automatic] will login automatically with pre-set username and password.";

GetCookie::usage = "GetCookie of current session";


Begin["Private`"];


$WebToolsStatus = False;
$ZhihuUsername;
$ZhihuPassword;


ZhihuTryLogin[un_, pw_, delay_ : 1.] :=
	(
	(*I hate stupid users!!!Actually These code are fully redundant!!!!*)
		If[!SessionActiveQ[], Return@$Canceled];
		If[GetCurrentURL[] === "https://www.zhihu.com/", Return@True];
		
		WebTools`wtTypeElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/div[1]/div[2]/div[1]/input"], un];
		WebTools`wtTypeElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/div[2]/div/div[1]/input"], pw];
		WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/button"]];
		Pause@delay;
		GetCurrentURL[] === "https://www.zhihu.com/"
	);



End[];


WebToolsInit[] := If[!Private`$WebToolsStatus, Private`$WebToolsStatus = True;Needs["WebTools`"];WebTools`wtInstallWebTools[];];


(*Help Functions which should actually be in WebTools!!!!!!!!!!!!!!!!!!!!*)
SessionActiveQ[] := If[TimeConstrained[WebTools`wtJavascriptExecute[""], .05] =!= Null, 1, 0];
GetCurrentURL[] := WebTools`wtJavascriptExecute["return window.location.href;"];


ZhihuLinkLogin[] := Block[
	{temp, successq = False, firstq = True},
	WebToolsInit[];
	WebTools`wtStartWebSession[];
	WebTools`wtOpenWebPage["http://www.zhihu.com/"];
	WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[2]/span"]];
	While[!successq,
		firstq = False;
		(*Bump out a dialog*)
		temp = AuthenticationDialog[{"Phone Number", "Password"},
			WindowTitle -> "Login Zhihu.com",
			AppearanceRules -> <|"Description" -> If[firstq, "Please Login Using Zhihu Account", "Incorrect Phone number/Password!"]|>];
		(*Check return status and try to login*)
		If[temp === $Canceled, Return@False, successq = ZhihuTryLogin[temp["Phone Number"], temp["Password"]]];
		(*If browser window closed, quit!*)
		If[successq === $Canceled, Return@False]
	];
	Private`$ZhihuUsername = temp["Phone Number"];
	Private`$ZhihuPassword = temp["Password"];
	Return@True
];


ZhihuLinkLogin[Automatic] :=
	If[Head[Private`$ZhihuUsername] === Head[Private`$ZhihuPassword] === String,
	(*Once logged in*)
		WebTools`wtStartWebSession[];
		WebTools`wtOpenWebPage["http://www.zhihu.com/"];
		WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[2]/span"]];
		ZhihuTryLogin[Private`$ZhihuUsername, Private`$ZhihuPassword],
	(*Nope*)
		ZhihuLinkLogin[]
	];


GetCookie[] := Association@Flatten[StringCases[#, StartOfString ~~ Shortest[name___] ~~ "=" ~~ content___ ~~ EndOfString :> (name -> content)]& /@ StringSplit[WebTools`wtJavascriptExecute["return document.cookie;"], "; "]];


ZhihuLinkLogin[];


GetCookie[]
(* ::Section:: *)
(*From Firefox's Cookie File*)



(* ::Section:: *)
(*Save Cookies*)


(* ::Text:: *)
(*Save cookie in multiple places, including:*)
(*	1. $ZhihuLinkCookieFile in SSD*)
(*	2. $ZhihuLinkCookies in Memory*)
(*	3. $ZhihuLinkAuth for authentication in Memory*)
(*	4. Return value*)


SaveCookies::usage = "Save cookies everywhere!";


SaveCookies[] := Block[
	{cookies = OpenCookieDialog[]},
	If[cookies === $Canceled, $Failed,
		ExportCookies[cookies];
		$ZhihuLinkCookies = cookies;
		$ZhihuLinkAuth = "Bearer " <> Select[cookie, #["Name"] == "z_c0"&][[1]]["Content"];
		cookies]
];


(* ::Section:: *)
(*End Package*)



Needs["DatabaseLink`"];
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





SetFirefoxDirectory::filenf = "Improperly set directory!";
SetFirefoxDirectory::usage = "
	Set directory to firefox's cookie file.\n
	Please select A FOLDER instead of the cookie itself.\n
	Typical Usage:\n
	\t	SetFirefoxDirectory[Automatic]: Automatically set directory, might fail in some cases.\n
	\t	SetFirefoxDirectory[]: Open a window for selection.\n
	\t	SetFirefoxDirectory[dir_String]: Direct input.
";

EstablishCookieSQLConnection::usage = "Establish SQL connction to cookie file";
GetRawCookies::usage = "Do not use, use GetCookies instead.";
GetCookies::usage = "Get cookies used by Zhihu and return in a Association form.";
FirefoxSetCookie::usage = "
	A bit of all-in-one function to import firefox's cookie file.\n
	Typical Usage: FirefoxSetCookie[Automatic]
";


SetFirefoxDirectory[dir_String] := Block[
	{r},
	If[FileExistsQ@dir && Length[r = TimeConstrained[Flatten@StringCases[Import@dir, ___ ~~ "cookies.sqlite"], 1, {}]] != 0,
		$FirefoxCookieFile = FileNameJoin[{dir, r[[1]]}],
		Message[SetFirefoxDirectory::filenf];
		$Failed
	]
];

(*Needs to be updated according to OS*)
SetFirefoxDirectory[Automatic] := SetFirefoxDirectory[FileNameJoin[{$HomeDirectory, "AppData\\Roaming\\Mozilla\\Firefox\\Profiles"}]];

SetFirefoxDirectory[] := SetFirefoxDirectory[SystemDialogInput["Directory", $HomeDirectory]];


EstablishCookieSQLConnection[] := (
	If[Head[$CookieSQLConnection] === Symbol,
		CloseSQLConnection@$CookieSQLConnection
	];
	$CookieSQLConnection = OpenSQLConnection[JDBC["SQLite", $FirefoxCookieFile], "Name" -> "cookie"];
);


GetRawCookies[] := Select[
	SQLSelect[$CookieSQLConnection, {"moz_cookies"}, {
		SQLColumn[{"moz_cookies", "baseDomain"}],
		SQLColumn[{"moz_cookies", "host"}],
		SQLColumn[{"moz_cookies", "Path"}],
		SQLColumn[{"moz_cookies", "name"}],
		SQLColumn[{"moz_cookies", "value"}],
		SQLColumn[{"moz_cookies", "expiry"}],
		SQLColumn[{"moz_cookies", "isHTTPOnly"
		}]}], First@# == "zhihu.com"&];


GetCookies[] := <|
	"Domain" -> If[StringTake[#2, 1] === ".", StringTake[#2, {2, -1}], #2],
	"Path" -> #3,
	"Name" -> #4,
	"Content" -> #5,
	"ExpirationDate" -> FromUnixTime@#6,
	"AllowSubdomains" -> True,
	"ConnectionType" -> All,
	"ScriptAccessible" -> #7
|>& @@@ GetRawCookies[];





(* ::Section:: *)
(*Select Cookies Dialog*)


OpenCookieDialog::usage = "Open a Dialog to Import cookies using multiple methods.";


(* ::Subsection:: *)
(*Segments*)


MainPanel[] := Column[
	{
		Style["Please Select a Method\n   to Load Cookies", 20],
		Button[Column[{Style["", 15], Style["Load From Firefox", 30, Bold], Style["(Recommended)", 15]}, Alignment -> Center], cookietemp = FirefoxSetCookie[Automatic];mode = If[cookietemp === <||>, "FirefoxManual", "FirefoxAuto"], ImageSize -> {300, 100}],
		Button[Style["Load From File", 30, Bold], mode = "File", ImageSize -> {300, 100}],
		Button[Style["Manual Enter", 30, Bold], mode = "Manual", ImageSize -> {300, 100}]
	},
	Alignment -> Center
];


FirefoxPanelAuto[] := Column[
	{
		Style["Firefox Cookies Found!\n", 25],
		Button[Style["Confirm", 30, Bold], DialogReturn@cookietemp, ImageSize -> {300, 50}],
		Button[Style["Manually Set Directory", 20], mode = "FirefoxManual", ImageSize -> {300, 30}],
		Button[Style["Back to Main Menu", 20], mode = "Main", ImageSize -> {300, 30}]
	}
];


FirefoxPanelManual[] := DynamicModule[
	{directory = "", text = "Please Set Directory Above", temp = <||>}, Column[{
		Style["Firefox cookie not found,\nPlease manually set directory.", 18],
		Hyperlink["How to Set Directory?", "https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data"],
		FileNameSetter[Dynamic[directory], "Directory", Appearance -> Graphics[{GrayLevel[.9], Rectangle[{-3, -1}, {3, 1}], Black, Text[Style["Set Directory", 30, Bold], {0, 0}]}, PlotRange -> {{-3, 3}, {-1, 1}}, ImageSize -> {300, 100}]
			, ImageSize -> {300, 100}],
		Dynamic[text],
		Button[Style["Confirm", 30, Bold], If[(temp = FirefoxSetCookie[directory]) =!= <||>, DialogReturn@temp, text = "Directory Invalid!"], ImageSize -> {300, 50}],
		Button[Style["Back to Main Menu", 20], mode = "Main", ImageSize -> {300, 30}]
	}]
];


FilePanel[] := DynamicModule[
	{temp},
	If[VerifyCookieStatus[temp = ImportCookies[]],
		Column[{
			Style["Cookies Found!", 20],
			Button[Style["Confirm", 30, Bold], DialogReturn[temp], ImageSize -> {300, 50}],
			Button[Style["Back to Main Menu", 20], mode = "Main", ImageSize -> {300, 30}]
		}],
		Column[{
			Style["Cookies Invalid!", 20],
			Button[Style["Back to Main Menu", 25, Bold], mode = "Main", ImageSize -> {300, 50}]
		}]]
];


ManualPanel[] := DynamicModule[
	{cookieraw = "", text = "Please Input Cookie Texts Above"},
	Column[{
		Style["Please Manually Input Cookie", 20],
		Hyperlink["Help Me!", "https://github.com/wjxway/ZhihuLink-Mathematica/blob/master/Resources/doc/login.md"],
		Pane[InputField[Dynamic@cookieraw, String, ImageSize -> 280, FieldSize -> {Automatic, {1, Infinity}}, Appearance -> "Frameless", ContinuousAction -> True, ContinuousAction -> True], ImageSize -> {300, 200}, Scrollbars -> {False, True}],
		Dynamic@text,
		Button[Style["Confirm", 30, Bold], If[VerifyCookieStatus[ProcessRawCookie[cookieraw]], DialogReturn@ProcessRawCookie[cookieraw], cookieraw = "";text = "Input Invalid!"], ImageSize -> {300, 50}],
		Button[Style["Back to Main Menu", 20], mode = "Main", ImageSize -> {300, 30}]
	}]
];


(* ::Subsection:: *)
(*All-in-All*)


(* ::Text:: *)
(*Note that this function will return only the cookie itself or $Canceled*)


OpenCookieDialog[] := Block[
	{mode = "Main", successful = False, cookietemp = <||>},
	DialogInput[
		Dynamic@Switch[mode,
			"Main", MainPanel[],
			"FirefoxAuto", FirefoxPanelAuto[],
			"FirefoxManual", FirefoxPanelManual[],
			"File", FilePanel[],
			"Manual", ManualPanel[]
		]
	]
];

