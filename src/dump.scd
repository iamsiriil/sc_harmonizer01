/**************************************************************************************
- HARMONY 01 / Data dump
**************************************************************************************/
(
~srcDir = PathName(thisProcess.nowExecutingPath).parentPath;
~rootDir = PathName(~srcDir).parentPath;
~pyDir = ~repoDir +/+ "score/python";

~pyDir = ~pyDir.standardizePath;

~pythonExe = {
	var venvLinux = ~pyDir +/+ "venv/bin/python3";
	var venvMac   = ~pyDir +/+ "venv/bin/python3";
	var venvWin   = ~pyDir +/+ "venv\bin\python.exe";

	case
	{ (thisProcess.platform.name == \windows) && File.exists(venvWin) } { venvWin }
	{ thisProcess.platform.name == \windows }                           { "py -3" }
	{ File.exists(venvLinux) }                                          { venvLinux }
	{ File.exists(venvMac) }                                            { venvMac }
	{ "python3" }

}.value;

~dumpTxt = ~pyDir +/+ "dump.txt";
~getScorePy = ~pyDir +/+ "getscore.py";

~q = { |s| s.asString.quote };

/*************************************************************************************/

~dumpChords = { |midiRange, triads, progState, file|
	var names, notes;

	file.write("%\n".format(progState[\progression].size));

	progState[\progression].do { |p, i|

		names = triads[p][\names].wrapExtend(triads[p][\notes].size);
		notes = triads[p][\notes];

		progState[\dump][i].do { |n|
			file.write("%% ".format(names[notes.indexOf(n)], midiRange[\octave][n].last ));
		};
		file.write("\n");
	};
};

/*************************************************************************************/

~dumpRules = { |progState, rules, ruleKeys, file|
	var temp = Dictionary.new();

	~resetRules.(rules);

	progState[\progression].do { |c, i|

		file.write("%\n".format(c));
		ruleKeys.do { |k|
			temp[k] = rules[k];
		};

		progState[\ruleEnforcement][i].do { |r|
			temp[r[0]] = r[1];
		};

		ruleKeys.do { |k|
			file.write("%: %\n".format(k, temp[k]));
		};
	};
};

/*************************************************************************************/

~dumpData = { |midiRange, triads, progState, rules, ruleKeys|
	/*var path_txt = PathName.new("../score/python/dump.txt".resolveRelative);
	var path_py3 = PathName.new("../score/python/venv/bin/python3".resolveRelative);
	var path_py = PathName.new("../score/python/getscore.py".resolveRelative);*/
	var file = File.new(~dumpTxt, "w");

	~dumpChords.(midiRange, triads, progState, file);
	~dumpRules.(progState, rules, ruleKeys, file);

	file.close;

	//"% %".format(path_py3.fullPath, path_py.fullPath).unixCmd;
	"% %".format(~q.(~pythonExe), ~q.(~getScorePy)).unixCmd;
};
)
