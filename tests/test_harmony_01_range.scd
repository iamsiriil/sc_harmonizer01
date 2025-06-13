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
/*~test_getChordDegreeArray = { |fixtures, triads, chordData|
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
};*/

~test_getChordDegreeArray = { |fixtures, triads, data|
	var chords = data[\chords];
	var result = true;

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~getChordDegreeArrays\n".postln;

	fixtures.do { |p|
		chords[\midi] = ~getChordDegreeArrays.(triads, p);

		p.do { |c, i|
			result = result && (chords[\midi][c][\notes].asArray == triads[c][\notes]);

			~test_resultMessage.(result, "~getChordDegreeArrays", ["prog: %".format(p), 37], i);
		};
		~resetDataDict.(data);
	};
	nil;
};

/*************************************************************************************/
// TEST: ~getChordVocalRange

/*~test_GCVRSubroutine = { |voiceData, chordData, chordState, i|
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
};*/

~test_GCVRSubroutine = { |voice, chords, state, i|
	var cipher = state[\nextCipher];
	var result = true;

	state[\validNotes] = ~getChordVocalRange.(voice, chords[\midi][cipher][\notes]);

	voice[\names].do { |v|

		if ((state[\validNotes][v].asArray.first >= voice[\range][v][0]) &&
			(state[\validNotes][v].asArray.last <= voice[\range][v][1])) {
			result = result && true;
		} {
			result = result && false;
		};
	};

	~test_resultMessage.(result, "~getChordVocalRange", ["chord: %".format(state[\nextCipher]), 13], i);
	nil;
};

~test_getChordVocalRange = { |fixtures, triads, data|

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~getChordVocalRange\n".postln;

	fixtures.do { |p, i|
		data[\chords][\midi] = ~getChordDegreeArrays.(triads, p);
		data[\state][\nextCipher] = p[0];

		~test_GCVRSubroutine.(data[\voice], data[\chords], data[\state], i);
	};
	~resetDataDict.(data);
	nil;
};

/*************************************************************************************/
// TEST: ~resolveMelodicIntervals

/*~test_RMISubroutine = { |voiceData, chordState, exclude, i|
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
};*/

~test_RMISubroutine = { |voice, state, exclude, i|
	var refRange = state[\validNotes].copy;
	var result = true;

	~resolveMelodicIntervals.(voice, state[\currChord], state[\validNotes]);

	voice[\names].do { |v, j|
		result = result && ((refRange[v] -- state[\validNotes][v]) == exclude[j]);
	};

	~test_resultMessage.(result, "~resolveMelodicIntervals", nil, i);
	nil;
};

~test_resolveMelodicIntervals = { |fixtures, triads, data|
	var chords;

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~resolveMelodicIntervals\n".postln;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1];

		chords = ~getChordDegreeArrays.(triads, f[\chordProg]);
		data[\state][\currChord] = f[\chord];
		data[\state][\validNotes] = ~getChordVocalRange.(data[\voice], chords[cipher][\notes]);

		~test_RMISubroutine.(data[\voice], data[\state], f[\exclude], i);

		~resetDataDict.(data);
	};
	nil;
};

/*************************************************************************************/
// TEST: ~resolveCommonTones

/*~test_RCTSubroutine = { |voiceData, chordState, functions, message, i, verbose|
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
};*/

~test_RCTSubroutine = { |voice, state, functions, message, i, verbose|
	var refRange = state[\validNotes].copy;
	var result = true;

	~resolveCommonTones.(voice, state[\currChord], state[\validNotes]);

	state[\names].do { |v, j|
		result = result && functions[j].(state[\validNotes][v].size);
	};

	~test_resultMessage.(result, "~resolveCommonTones", [message, 15], i);
	if (verbose) {
		~test_RCTVerbose.(voice[\names], state[\validNotes], refRange);
	};
	nil;
};

~test_resolveCommonTones = { |fixtures, triads, data, verbose|
	var chords;

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~resolveCommonTones\n".postln;

	fixtures.do { |f, i|
		var cipher = f[\chordProg][1];

		chords = ~getChordDegreeArrays.(triads, f[\chordProg]);
		data[\state][\currChord] = f[\chord];
		data[\state][\validNotes] = ~getChordVocalRange.(data[\voice], chords[cipher][\notes]);

		~test_RCTSubroutine.(data[\voice], data[\state], f[\functions], f[\message], i, verbose);

		~resetDataDict.(data);
	};
	nil;
};
)

(
~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data);
~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data);
~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data);
~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, false);
)