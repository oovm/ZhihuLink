(* ::Package:: *)

BeginPackage["ZhihuLink`"];


SessionActiveQ::usage="Help Function for WebTools`";
GetCurrentURL::usage="Help Function for WebTools`";

ZhihuLinkLogin::usage="Try to login:
ZhihuLinkLogin[] will open a login panel.
ZhihuLinkLogin[Automatic] will login automatically with pre-set username and password.";

GetCookie::usage="GetCookie of current session";


Begin["Private`"];


$WebToolsStatus=False;
$ZhihuUsername;
$ZhihuPassword;


ZhihuTryLogin[un_,pw_,delay_:1.]:=
(
(*I hate stupid users!!!Actually These code are fully redundant!!!!*)
If[!SessionActiveQ[],Return@$Canceled];
If[GetCurrentURL[]==="https://www.zhihu.com/",Return@True];

WebTools`wtTypeElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/div[1]/div[2]/div[1]/input"],un];
WebTools`wtTypeElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/div[2]/div/div[1]/input"],pw];
WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[1]/form/button"]];
Pause@delay;
GetCurrentURL[]==="https://www.zhihu.com/"
)



End[];


WebToolsInit[]:=If[!Private`$WebToolsStatus, Private`$WebToolsStatus=True;Needs["WebTools`"];WebTools`wtInstallWebTools[];]


(*Help Functions which should actually be in WebTools!!!!!!!!!!!!!!!!!!!!*)
SessionActiveQ[]:=If[TimeConstrained[WebTools`wtJavascriptExecute[""],.05]=!=Null,1,0];
GetCurrentURL[]:=WebTools`wtJavascriptExecute["return window.location.href;"];


ZhihuLinkLogin[]:=
Block[{temp,successq=False,firstq=True},
WebToolsInit[];
WebTools`wtStartWebSession[];
WebTools`wtOpenWebPage["http://www.zhihu.com/"];
WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[2]/span"]];
While[!successq,
firstq=False;
(*Bump out a dialog*)
temp=AuthenticationDialog[{"Phone Number","Password"},
WindowTitle -> "Login Zhihu.com",
AppearanceRules-><|"Description" ->If[firstq,"Please Login Using Zhihu Account","Incorrect Phone number/Password!"]|>];
(*Check return status and try to login*)
If[temp===$Canceled,Return@False,successq=ZhihuTryLogin[temp["Phone Number"],temp["Password"]]];
(*If browser window closed, quit!*)
If[successq===$Canceled,Return@False]
];
Private`$ZhihuUsername=temp["Phone Number"];
Private`$ZhihuPassword=temp["Password"];
Return@True
]


ZhihuLinkLogin[Automatic]:=
If[Head[Private`$ZhihuUsername]===Head[Private`$ZhihuPassword]===String,
(*Once logged in*)
WebTools`wtStartWebSession[];
WebTools`wtOpenWebPage["http://www.zhihu.com/"];
WebTools`wtClickElement[WebTools`wtXPath["//*[@id=\"root\"]/div/main/div/div/div/div[2]/div[2]/span"]];
ZhihuTryLogin[Private`$ZhihuUsername,Private`$ZhihuPassword],
(*Nope*)
ZhihuLinkLogin[]
]


GetCookie[]:=Association@Flatten[StringCases[#,StartOfString~~Shortest[name___]~~"="~~content___~~EndOfString:>(name->content)]&/@StringSplit[WebTools`wtJavascriptExecute["return document.cookie;"],"; "]]


ZhihuLinkLogin[]


GetCookie[]
