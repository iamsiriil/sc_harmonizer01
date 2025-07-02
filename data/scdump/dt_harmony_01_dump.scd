/**************************************************************************************
- HARMONY 01 / Data dump
**************************************************************************************/
(
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
	var path = PathName.new("./dump.txt".resolveRelative);
	var file = File.new(path.fullPath, "w");

	~dumpChords.(~midiRange, ~triads, ~progState, file);
	~dumpRules.(~progState, ~rules, ~ruleKeys, file);

	file.close;
};
)

~dumpData.();
