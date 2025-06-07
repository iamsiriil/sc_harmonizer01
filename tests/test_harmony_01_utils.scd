(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"./test_harmony_01_fixtures.scd".loadRelative;
)

/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures / Tests
**************************************************************************************/
// Fixtures

// Chord progressions for ~getChordDegreePairs and ~getChordDegreeArrays
(
~chordProg = [
	[['CM', 2]],
	[['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]],
	[['F#m', 1], ['EM', 1], ['C#A', 1], ['Bm', 2], ['Ed', 1], ['F#m']],
	[['Ebm', 1], ['Gm', 1], ['BA', 1], ['BbM', 2], ['Dm', 1], ['Ebm']],
	[['AbM', 1], ['C#m', 1], ['EbM', 1], ['Bm', 2], ['Gd', 1], ['G#m']]
];

)

/*************************************************************************************/
// Test ~getChordDegreePairs
(
~test_getChordDegreePairs = {
	var triadKeys = ~triads.keys; // Get all keys from ~triads
	var getSymbols, dict, result = true;

	"\nFunction: ~getChordDegreePairs".postln;

	"\nTEST #1 : Set of ciphers in progression, is subset of ~triads.keys:".postln;
	~chordProg.do { |p, i|
		getSymbols = (p.collect { |a| a[0]});
		result = result && getSymbols.isSubsetOf(triadKeys);

		if (result) {
			"TEST #1 : Pogression #% : PASSED".format(i).postln;
		} {
			"TEST #1 : Pogression #% : FAILED".format(i).postln;
		};
	};
	result = true;


	"\nTEST #2 : Set of keys from returned dictionary is subset of ~triads.keys:".postln;
	~chordProg.do { |p, i|
		~chordData[\chordProg] = p;

		dict = ~getChordDegreePairs.();
		result = result && dict.keys.isSubsetOf(triadKeys);

		if (result) {
			"TEST #2 : Pogression #% : PASSED".format(i).postln;
		} {
			"TEST #2 : Pogression #% : FAILED".format(i).postln;
		};
	};
	~chordData[\chordProg] = nil; dict = nil; result = true; // Reset variables after test


	"\nTEST #3 : Pairing of midi note numbers and scale degrees is correct:".postln;
	~chordProg.do { |p, i|
		~chordData[\chordProg] = p;

		dict = ~getChordDegreePairs.();
		10.do {
			var key = dict.keys.choose;
			var pair = dict[key].choose;
			var notes = ~triads[key][\notes];
			var degree = ~triads[key][\degree].wrapExtend(notes.size);

			result = result && (degree[notes.indexOf(pair[0])] == pair[1]);
		};
		if (result) {
			"TEST #3 : Pogression #% : PASSED".format(i).postln;
		} {
			"TEST #3 : Pogression #% : FAILED".format(i).postln;
		};
	};
	~chordData[\chordProg] = nil; dict = nil; result = true; // Reset variables after test
};
~test_getChordDegreePairs.();
)

(
~test_getChordDegreeArray = { |chordProgs|

	chordProgs.do { |p|
		var dict = ~getChordDegreeArrays.(~triads, p);

		p.do { |c|
			"Test: %".format(c[0]).post;
			if (dict[c[0]][\notes] == ~triads[c[0]][\notes]) {
				": Passed".postln;
			} {
				": Failed".postln;
			}
		}
	};
};
~test_getChordDegreeArray.(~chordProg);
)

/*************************************************************************************/
// TEST: ~getChordVocalRange
(
~test_GCVRSubroutine = { |chordState, voiceData, i|
	var result = true;

	voiceData[\voiceNames].do { |v|

		if ((chordState[\validNotes][v].asArray.first >= voiceData[\voiceRange][v][0]) &&
			(chordState[\validNotes][v].asArray.last <= voiceData[\voiceRange][v][1])) {
			result = result && true;
		} {
			result = result && false;
		};
	};

	"TEST #% ".format(i).padRight(9).post;
	"| ~getChordVocalRange | ".post;
	"chord: % ".format(chordState[\nextCipher]).padRight(12).post;

	if (result) {
		"| PASSED".postln;
	} {
		"| FAILED".postln;
	};
};

~test_getChordVocalRange = { |triads, voiceData, chordData, chordState|
	var prog = ~test_GVCRFixtures.(triads);

	~logger = false;
	~loggerCount = 0;

	prog.do { |p, i|
		chordData[\chordProg] = p;
		chordData[\chords] = ~getChordDegreeArrays.(triads, chordData[\chordProg]);
		chordState[\nextCipher] = p.unbubble[0];

		chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][chordState[\nextCipher]][\notes]);

		~test_GCVRSubroutine.(chordState, voiceData, i);
	};
	~resetChordData.(chordData); ~resetChordState.(chordState);
	nil;
};

~test_getChordVocalRange.(~triads, ~voiceData, ~chordData, ~chordState);
)

/*************************************************************************************/
// TEST: ~resolveMelodicIntervals
(
~test_RMISubroutine = { |voiceData, chordState, exclude, i|
	var refRange = chordState[\validNotes].copy;
	var result = true;

	~resolveMelodicIntervals.(voiceData, chordState[\validNotes], chordState[\currChord]);

	voiceData[\voiceNames].do { |v, j|
		result = result && ((refRange[v] -- chordState[\validNotes][v]) == exclude[j]);
	};

	"TEST #% | ~resolveMelodicIntervals | ".format(i).post;

	if (result) {
		"PASSED".postln;
	} {
		"FAILED".postln;
	};
	nil;
};

~test_resolveMelodicIntervals = { |fixtures, triads, voiceData, chordData, chordState|

	~logger = false;
	~loggerCount = 0;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1][0];

		chordData[\chords] = ~getChordDegreeArrays.(triads, f[\chordProg]);
		chordState[\currChord] = f[\chord];
		chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][cipher][\notes]);

		~test_RMISubroutine.(voiceData, chordState, f[\exclude], i);

		~resetChordData.(chordData); ~resetChordState.(chordState);
	};
	nil;
};

~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
)

/*************************************************************************************/
// TEST: ~resolveCommonTones
(
~test_RCTSubroutine = { |voiceData, chordState, functions, i|
	var refRange = chordState[\validNotes].copy;
	var result = true;

	~resolveCommonTones.(voiceData, chordState[\validNotes], chordState[\currChord]);

	voiceData[\voiceNames].do { |v|
		"%: %".format(v, refRange[v].asArray).padRight(30).post;
		"| %".format(chordState[\validNotes][v].asArray).postln;
	};

	voiceData[\voiceNames].do { |v, j|
		result = result && functions[j].(chordState[\validNotes][v].size);
	};

	if (result) {
		"PASSED".postln;
	} {
		"FAILED".postln;
	}

};

~test_resolveCommonTones = { |fixtures, triads, voiceData, chordData, chordState|

	~logger = false;
	~loggerCount = 0;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1][0];

		~chordData[\chords] = ~getChordDegreeArrays.(triads, f[\chordProg]);
		~chordState[\currChord] = f[\chord];
		~chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][cipher][\notes]);

		~test_RCTSubroutine.(voiceData, chordState, f[\functions], i);

		~resetChordData.(chordData); ~resetChordState.(chordState);
	};
	nil;
};
~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
)
