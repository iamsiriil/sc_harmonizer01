/**************************************************************************************
- HARMONY 01 / Data dump
**************************************************************************************/
(
/*~srcDir = PathName(thisProcess.nowExecutingPath).parentPath;
~rootDir = PathName(~srcDir).parentPath;

~pyDir = ~rootDir +/+ "score/python";
~pyDir = ~pyDir.standardizePath;

~dumpTxt = (~pyDir +/+ "dump.txt").standardizePath;
~getScorePy = (~pyDir +/+ "getscore.py").standardizePath;*/

/*************************************************************************************/

~pythonExe = {
	var venvLinux = ~pyDir +/+ "venv/bin/python3";
	var venvMac   = ~pyDir +/+ "venv/bin/python3";
	var venvWin   = ~pyDir +/+ "venv/bin/python.exe";

	case
	{ (thisProcess.platform.name == \windows) && File.exists(venvWin) } { venvWin }
	{ thisProcess.platform.name == \windows }                           { "py -3" }
	{ File.exists(venvLinux) }                                          { venvLinux }
	{ File.exists(venvMac) }                                            { venvMac }
	{ "python3" }

}.value;

/*************************************************************************************/

~dumpChords = { |midiRange, triads, progState, file|
	var names, notes;

	"dumpChords".postln;

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

		if (c.asString.last == $A) {
			c = c.asString[0..c.asString.size - 2] ++ "+";
			file.write("%\n".format(c));
		} {
			file.write("%\n".format(c));
		};

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
	var file = File.new(~dumpTxt, "w");

	~dumpChords.(midiRange, triads, progState, file);
	~dumpRules.(progState, rules, ruleKeys, file);

	file.close;

	"% %".format(~pythonExe.asString, ~getScorePy.asString).unixCmd;
};
)
