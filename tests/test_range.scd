/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures / Tests
**************************************************************************************/
// Test ~getChordDegreeArrays
(
~test_getChordDegreeArray = { |fixtures, triads, data|
	var result = true;

	~logger = false;
	~loggerCount = 0;

	"\nFunction: ~getChordDegreeArrays\n".postln;

	fixtures.do { |p|
		data[\chords] = ~getChordDegreeArrays.(triads, p);

		p.do { |c, i|
			result = result && (data[\chords][c][\notes].asArray == triads[c][\notes]);

			~test_resultMessage.(result, "~getChordDegreeArrays", ["prog: %".format(p), 37], i);
		};
		~resetDataDict.(data);
	};
	nil;
};

/*************************************************************************************/
// Test ~getChordVocalRange

~test_GCVRSubroutine = { |voice, chords, state, i|
	var cipher = state[\nextCipher];
	var result = true;

	state[\validNotes] = ~getChordVocalRange.(voice, chords[cipher][\notes]);

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
		data[\chords] = ~getChordDegreeArrays.(triads, p);
		data[\state][\nextCipher] = p[0];

		~test_GCVRSubroutine.(data[\voice], data[\chords], data[\state], i);
	};
	~resetDataDict.(data);
	nil;
};

/*************************************************************************************/
// Test ~resolveMelodicIntervals

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
// Test ~resolveCommonTones

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
