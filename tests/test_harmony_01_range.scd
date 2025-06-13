/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures / Tests
**************************************************************************************/
(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_dicts.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_range.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"./test_harmony_01_fixtures.scd".loadRelative;
"./test_harmony_01_message.scd".loadRelative;
)
/*************************************************************************************/
// TEST: ~getChordDegreeArrays
(
~test_getChordDegreeArray = { |fixtures, triads, chordData|
	var result = true;

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~getChordDegreeArrays\n".postln;

	fixtures.do { |p|
		chordData[\chords] = ~getChordDegreeArrays.(triads, p);

		p.do { |c, i|
			result = result && (chordData[\chords][c][\notes].asArray == triads[c][\notes]);

			~test_resultMessage.(result, "~getChordDegreeArrays", ["prog: %".format(p), 37], i);
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

	~test_resultMessage.(result, "~getChordVocalRange", ["chord: %".format(chordState[\nextCipher]), 13], i);
	nil;
};

~test_getChordVocalRange = { |fixtures, triads, voiceData, chordData, chordState|

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~getChordVocalRange\n".postln;

	fixtures.do { |p, i|
		chordData[\chords] = ~getChordDegreeArrays.(triads, p);
		chordState[\nextCipher] = p[0];

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

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~resolveMelodicIntervals\n".postln;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1];

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

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~resolveCommonTones\n".postln;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1];

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
~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~chordData);
~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~voiceData, ~chordData, ~chordState, verbose: false);
)