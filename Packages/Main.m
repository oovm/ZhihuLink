With[
	{$zdir = FileNameJoin[{$UserBaseDirectory, "ApplicationData", "ZhihuLink"}]},
	(*check encode, this file can only use ASCII*)
	If[$CharacterEncoding =!= "UTF-8",
		$CharacterEncoding = "UTF-8";
		Print[{
			Style["$CharacterEncoding has changed to UTF-8 to avoid problems.", Red],
			Style["Because ZhihuLink was written under UTF-8"]
		} // TableForm];
		st = OpenAppend[FindFile["init.m"]];
		WriteString[st, "$CharacterEncoding=\"UTF-8\";"];
		Close[st];
	];
	(*check directory*)
	Quiet[CreateDirectory /@ {
		$zdir,
		FileNameJoin[{$zdir, "stats"}],
		FileNameJoin[{$zdir, "user"}],
		FileNameJoin[{$zdir, "follow"}],
		FileNameJoin[{$zdir, "post"}]
	}];
]