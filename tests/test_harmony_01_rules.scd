/**************************************************************************************
- HARMONY 01 / Test rules
**************************************************************************************/
(
"../src/sc_harmony_01_rules.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_range.scd".loadRelative;
"../src/sc_harmony_01_dicts.scd".loadRelative;
"../src/sc_harmony_01_lib.scd".loadRelative;
"./test_harmony_01_message.scd".loadRelative;
"./test_harmony_01_fixtures.scd".loadRelative;
)

(


~voiceData[\voiceRange];
// Test voice spacing

~test_CNDData = (
	\chordSetRD: (
		\message: "Chord Set #1: Root duplicate",
		\chords: [[48, 60, 64, 67], [48, 55, 60, 64], [48, 64, 67, 72], [52, 60, 72, 79], [52, 60, 67, 72], [52, 55, 60, 72]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],  // Expect: true
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],  // Expect: false
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],  // Expect: false
			[[true, true, true], false, "Test #4: Flags: RD true; TD true; FD true; ND false"]     // Expect: true
		],
		\expect: [true, false, false, true]    // Expected return for flags: [RD, TD, FD, ND]
	),
	\chordSetTD: (
		\message: "Chord Set #2: Third duplicate",
		\chords: [[40, 52, 60, 67], [40, 55, 64, 72], [40, 55, 60, 64], [48, 52, 64, 67], [48, 52, 55, 64], [48, 55, 64, 76]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],     // Expect: false
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],     // Expect: true
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],     // Expect: false
			[[false, false, false], false, "Test #4: Flags: RD false; TD false; FD false; ND false"]  // Expect: true
		],
		\expect: [false, true, false, true]    // Expected return for flags: [RD, TD, FD, ND]
	),
	\chordSetFD: (
		\message: "Chord Set #3: Fifth duplicate",
		\chords: [[43, 55, 60, 64], [43, 60, 67, 76], [43, 60, 64, 67], [48, 55, 67, 76], [48, 55, 64, 67], [48, 52, 55, 67]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],    // Expect: false
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],    // Expect: false
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],    // Expect: true
			[[false, true, false], false, "Test #4: Flags: RD false; TD true; FD false; ND false"]   // Expect: true
		],
		\expect: [false, false, true, true]    // Expected return for flags: [RD, TD, FD, ND]
	)
);
)
/*************************************************************************************/
// TEST ~checkChordPosition
(
~test_CCPSubroutine = { |flags, chords, expect, dict, rules, i|
	var flagRP, flagFI, flagSI, flagCP;
	var result = true;

	#flagRP, flagFI, flagSI = flags[0];
	flagCP = flags[1];

	rules[\enforceChordPosition]   = flagCP;
	rules[\enforceRootPosition]    = flagRP;
	rules[\enforceFirstInversion]  = flagFI;
	rules[\enforceSecondInversion] = flagSI;

	chords.do { |a, j|

		a.do { |c|
			result = result && ~checkChordPosition.(c, 'CM', dict, rules);
		};

		result = (result == expect[j][i]);
		~test_resultMessage.(result, "~checkChordPosition", nil, i);
	};
	~resetRules.(rules);
	nil;
};

~test_checkChordPosition = { |fixtures, triads, rules|
	var dict = Dictionary.new();
	var result = true;

	~logger = false;
	~loggerCount = 0;

	dict = ~getChordDegreeArrays.(triads, [['CM', 2]]);

	fixtures[\flags].do { |f, i|

		~test_CCPSubroutine.(f, fixtures[\chords], fixtures[\expect], dict, rules, i);
 	};
	nil;
};
~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
)

/*************************************************************************************/
// TEST ~checkVoiceSpacing
(
~test_CVRSubroutine = { |fixture, rules, i|
	var flag = fixture[1][0];
	var expect = fixture[1][1];
	var result = true;

	rules[\enforceVoiceCrossProhibition] = flag;

	fixture[0].do { |c|
		c.do { |n, j|
			result = result && ~checkVoiceSpacing.(c, j, rules);
		};
	};

	result = (result == expect);
	~test_resultMessage.(result, "~checkVoiceSpacing", nil, i);

	~resetRules.(rules);
	nil;
};

~test_checkVoiceRange = { |fixtures, rules|

	~logger = false;
	~loggerCount = 0;

	fixtures.do { |f, i|
		~test_CVRSubroutine.(f, rules, i);
	};
	nil;
};
~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
)

/*************************************************************************************/
// Test ~checkParallelOctaves
(
~test_CPOSubroutine = { |fChord, sChord, numVoices|
	var expect = sChord[1], result;

	~testCounter = 0;

	fChord.do { |c, i|
		result = ~checkParallelOctaves.(sChord[0][i], c, numVoices);
		result = (result == expect);

		~test_resultMessage.(result, "~checkParallelOctaves", nil, ~testCounter);
		~testCounter = ~testCounter + 1;
	};
	nil;
};

~test_checkParallelOctaves = { |fixtures, rules, voiceData|

	~logger = false;
	~loggerCount = 0;

	~test_CPOSubroutine.(fixtures[\fChord], fixtures[\sChordPO], voiceData[\numVoices]);
	~test_CPOSubroutine.(fixtures[\fChord], fixtures[\sChordVL], voiceData[\numVoices]);

	~resetRules.(rules);
	nil;
};
~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~voiceData);
)

/*************************************************************************************/
// Test ~checkParallelFifths
(
~test_CPFSubroutine = { |fChord, sChord, numVoices|
	var expect = sChord[1], result;

	~testCounter = 0;

	fChord.do { |c, i|
		result = ~checkParallelFifths.(sChord[0][i], c, numVoices);
		result = (result == expect);

		~test_resultMessage.(result, "~checkParallelFifths", nil, ~testCounter);
		~testCounter = ~testCounter + 1;
	};
	nil;
};

~test_checkParallelFifths = { |fixtures, rules, voiceData|

	~logger = false;
	~loggerCount = 0;

	~test_CPFSubroutine.(fixtures[\fChord], fixtures[\sChordPF], voiceData[\numVoices]);
	~test_CPFSubroutine.(fixtures[\fChord], fixtures[\sChordVL], voiceData[\numVoices]);

	nil;
};
~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~voiceData);
)

/*************************************************************************************/
// Test Note Duplicates
(
~test_CNDSubroutine = { |dict|
	var result = true;
	var chords = dict[\chords];
	var expect = dict[\expect];

	dict[\flags]. do { |f, i|
		var flagRD, flagTD, flagFD, flagND;

		#flagRD, flagTD, flagFD = f[0];
		flagND = f[1];

		~enforceNoteDuplicate  = flagND;
		~enforceRootDuplicate  = flagRD;
		~enforceThirdDuplicate = flagTD;
		~enforceFifthDuplicate = flagFD;

		chords.do { |c|
			result = result && ~checkNoteDuplicate.(c);
		};
		if (result == expect[i]) {
			"TEST #% | expected: % got: % | PASSED".format(i, expect[i], result).postln;
		} {
			"TEST #% | expected: % got: % | FAILED".format(i, expect[i], result).postln;
		};
		flagRD = flagTD = flagFD = flagND = nil;
		result = true;
		~resetRules.();
 	};
	nil;
};

~test_checkNoteDuplicate = {
	var result;

	"\nTEST : ~checkNoteDuplicate".format().postln;

	~chordState[\nextCipher] = 'CM';
	~chordData[\chordProg] = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 2]];
	~getChordDegreeArrays.();

	~test_CNDData.do { |dict|

		"\n%\n".format(dict[\message]).postln;
		~test_CNDSubroutine.(dict);
	};
	nil;
};

~test_checkNoteDuplicate.();
)

(
~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~voiceData);
~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~voiceData);
)











