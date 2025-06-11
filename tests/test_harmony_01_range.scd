/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures / Tests
**************************************************************************************/
(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"./test_harmony_01_fixtures.scd".loadRelative;
"./test_harmony_01_message.scd".loadRelative;
)
/*************************************************************************************/
// TEST: ~getChordDegreePairs

(
~test_getChordDegreePairs = { |chordProg, triads, chordData|
	var triadKeys = triads.keys; // Get all keys from ~triads
	var getSymbols, dict, result = true;

	"\nFunction: ~getChordDegreePairs".postln;

	"Set of ciphers in progression, is subset of ~triads.keys:".postln;
	chordProg.do { |p, i|
		getSymbols = (p.collect { |a| a[0]});
		result = result && getSymbols.isSubsetOf(triadKeys);

		~test_resultMessage.(result, "~getChordDegreePairs", nil, i);
	};
	result = true;

	"\nSet of keys from returned dictionary is subset of ~triads.keys:".postln;
	chordProg.do { |p, i|
		chordData[\chordProg] = p;

		dict = ~getChordDegreePairs.(triads, p);
		result = result && dict.keys.isSubsetOf(triadKeys);

		~test_resultMessage.(result, "~getChordDegreePairs", nil, i);

	};
	~resetChordData.(chordData); dict = nil; result = true; // Reset variables after test

	"\nPairing of midi note numbers and scale degrees is correct:".postln;
	chordProg.do { |p, i|
		chordData[\chordProg] = p;

		dict = ~getChordDegreePairs.(triads, p);
		10.do {
			var key = dict.keys.choose;
			var pair = dict[key].choose;
			var notes = triads[key][\notes];
			var degree = triads[key][\degree].wrapExtend(notes.size);

			result = result && (degree[notes.indexOf(pair[0])] == pair[1]);
		};

		~test_resultMessage.(result, "~getChordDegreePairs", nil, i);
	};
	~resetChordData.(chordData); dict = nil; result = true; // Reset variables after test
	nil;
};

/*************************************************************************************/
// TEST: ~getChordDegreeArrays

~test_getChordDegreeArray = { |chordProgs, triads, chordData|
	var result = true;

	"\nFunction: ~getChordDegreeArrays".postln;

	chordProgs.do { |p|
		var prog = p.collect{ |i| i[0] };
		chordData[\chords] = ~getChordDegreeArrays.(triads, p);

		prog.do { |c, i|
			result = result && (chordData[\chords][c][\notes].asArray == triads[c][\notes]);

			~test_resultMessage.(result, "~getChordDegreeArrays", ["prog: %".format(prog), 37], i);
		};
		~resetChordData.(chordData);
	};
	nil;
};

/*************************************************************************************/
// TEST: ~getChordVocalRange

~test_GCVRSubroutine = { |voiceData, chordData, chordState, i|
	var result = true;

	chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][chordState[\nextCipher]][\notes]);

	voiceData[\voiceNames].do { |v|

		if ((chordState[\validNotes][v].asArray.first >= voiceData[\voiceRange][v][0]) &&
			(chordState[\validNotes][v].asArray.last <= voiceData[\voiceRange][v][1])) {
			result = result && true;
		} {
			result = result && false;
		};
	};

	~test_resultMessage.(result, "~getChordVocalRange", ["chord: %".format(chordState[\nextCipher]), 12], i);
	nil;
};

~test_getChordVocalRange = { |triads, voiceData, chordData, chordState|
	var prog = ~test_GVCRFixtures.(triads);

	"\nFunction: ~getChordVocalRange".postln;

	~logger = false;
	~loggerCount = 0;

	prog.do { |p, i|
		chordData[\chordProg] = p;
		chordData[\chords] = ~getChordDegreeArrays.(triads, chordData[\chordProg]);
		chordState[\nextCipher] = p.unbubble[0];

		~test_GCVRSubroutine.(voiceData, chordData, chordState, i);
	};
	~resetChordData.(chordData); ~resetChordState.(chordState);
	nil;
};

/*************************************************************************************/
// TEST: ~resolveMelodicIntervals

~test_RMISubroutine = { |voiceData, chordState, exclude, i|
	var refRange = chordState[\validNotes].copy;
	var result = true;

	~resolveMelodicIntervals.(voiceData, chordState[\validNotes], chordState[\currChord]);

	voiceData[\voiceNames].do { |v, j|
		result = result && ((refRange[v] -- chordState[\validNotes][v]) == exclude[j]);
	};

	~test_resultMessage.(result, "~resolveMelodicIntervals", nil, i);
	nil;
};

~test_resolveMelodicIntervals = { |fixtures, triads, voiceData, chordData, chordState|

	"\nFunction: ~resolveMelodicIntervals".postln;

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

/*************************************************************************************/
// TEST: ~resolveCommonTones

~test_RCTSubroutine = { |voiceData, chordState, functions, message, i, verbose|
	var refRange = chordState[\validNotes].copy;
	var result = true;

	~resolveCommonTones.(voiceData, chordState[\validNotes], chordState[\currChord]);

	voiceData[\voiceNames].do { |v, j|
		result = result && functions[j].(chordState[\validNotes][v].size);
	};

	~test_resultMessage.(result, "~resolveCommonTones", [message, 15], i);
	if (verbose) {
		~test_RCTVerbose.(voiceData[\voiceNames], chordState[\validNotes], refRange);
	};
	nil;
};

~test_resolveCommonTones = { |fixtures, triads, voiceData, chordData, chordState, verbose|

	"\nFunction: ~resolveCommonTones".postln;

	~logger = false;
	~loggerCount = 0;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1][0];

		~chordData[\chords] = ~getChordDegreeArrays.(triads, f[\chordProg]);
		~chordState[\currChord] = f[\chord];
		~chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][cipher][\notes]);

		~test_RCTSubroutine.(voiceData, chordState, f[\functions], f[\message], i, verbose);

		~resetChordData.(chordData); ~resetChordState.(chordState);
	};
	nil;
};
)

(
~test_getChordDegreePairs.(~test_GCDFixture, ~triads, ~chordData);
~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~chordData);
~test_getChordVocalRange.(~triads, ~voiceData, ~chordData, ~chordState);
~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~voiceData, ~chordData, ~chordState, verbose: false);
~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
)