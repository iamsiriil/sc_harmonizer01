/**************************************************************************************
- HARMONY 01 / Test messages
**************************************************************************************/
(
~test_resultMessage = { |result, function, message, i|
	"TEST #%".format(i).padRight(9).post;
	"| %".format(function).padRight(27).post;

	if (message.notNil) {
		"| %".format(message[0]).padRight(message[1]).post;
	};

	if (result) {
		"| PASSED".postln;
	} {
		"| FAILED".postln;
	};
};

~test_RCTVerbose = { |voiceNames, validNotes, refRange|

	voiceNames.do { |v|
		"%: %".format(v, refRange[v].asArray).padRight(30).post;
		"| %".format(validNotes[v].asArray).postln;
	};
	"".postln;
};

~test_GNCPrintResults = { |ciphers, flags, results|

	"".padRight(5).post;
	flags.do { |f| "| % ".format(f).padRight(f.asString.size + 2).post; };
	"".postln;

	ciphers.do { |c, i|
		"%".format(c).padRight(5).post;

		flags.do { |f, j|
			"| %".format(results[j][i]).padRight(f.asString.size + 3).post;
		};
		"".postln;
	}
};
~sequenceToString = { |sequence|
	sequence.asArray.asString.replace("[", "").replace("]", "");
};

~test_RMIVerbose = { |currChord, refRange, valNotes, voiceNames|

	"\nCurrent Chord: %".format(currChord).postln;

	voiceNames.do { |v, i|
		"% ".format(v).post;
		"| ref: %".format(refRange[v].asArray).padRight(32).post;
		"| val: %".format(valNotes[v].asArray).padRight(26).post;
		"| exc: %".format((refRange[v] -- valNotes[v]).asArray).postln;
	};
};
)