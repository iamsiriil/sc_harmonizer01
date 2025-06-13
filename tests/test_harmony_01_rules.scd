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

	dict = ~getChordDegreeArrays.(triads, ['CM']);

	fixtures[\flags].do { |f, i|

		~test_CCPSubroutine.(f, fixtures[\chords], fixtures[\expect], dict, rules, i);
 	};
	nil;
};

/*************************************************************************************/
// TEST ~checkVoiceSpacing

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

/*************************************************************************************/
// Test ~checkParallelOctaves

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

/*************************************************************************************/
// Test ~checkParallelFifths

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

/*************************************************************************************/
// Test Note Duplicates

~test_CNDSubroutine = { |dict, chords, cipher, rules|
	var flagRD, flagTD, flagFD, flagND;
	var result = true;

	~testCounter = 0;

	dict[\flags]. do { |f, i|

		#flagRD, flagTD, flagFD = f[0];
		flagND = f[1];

		rules[\enforceNoteDuplicate]  = flagND;
		rules[\enforceRootDuplicate]  = flagRD;
		rules[\enforceThirdDuplicate] = flagTD;
		rules[\enforceFifthDuplicate] = flagFD;

		dict[\chords].do { |c|
			result = result && ~checkNoteDuplicate.(c, cipher, chords, rules);
		};

		result = (result == dict[\expect][i]);
		~test_resultMessage.(result, "~checkNoteDuplicate", [dict[\message], 32], ~testCounter);
		~testCounter = ~testCounter + 1;

		~resetRules.(rules);
 	};
	nil;
};

~test_checkNoteDuplicate = { |fixtures, triads, rules|
	var chords = Dictionary.new();

	chords = ~getChordDegreeArrays.(triads, ['CM', 'FM', 'GM', 'CM']);

	fixtures.do { |d|

		~test_CNDSubroutine.(d, chords, 'CM', rules);
	};
	nil;
};
)

(
~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~voiceData);
~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~voiceData);
~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules);
)











