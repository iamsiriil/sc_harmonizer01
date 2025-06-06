(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
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

~commonTones = [
	[[48, 55, 64, 72], []]
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
// Returns an array os single chord progressions, with all the triads
~getProg = { |triads|
	var prog = Array.new(triads.keys.size);

	triads.keys.do { |k|
		var temp = [[k, 1]];
		prog.add(temp);
	};
	prog;
};

~test_GCVRSubroutine = { |chordState, voiceData, i|
	var result = true;

	"TEST #% | ~getChordVocalRange | chord: % | ".format(i, chordState[\nextCipher]).post;

	voiceData[\voiceNames].do { |v|

		if ((chordState[\validNotes][v].asArray.first >= voiceData[\voiceRange][v][0]) &&
			(chordState[\validNotes][v].asArray.last <= voiceData[\voiceRange][v][1])) {
			result = result && true;
		} {
			result = result && false;
		};
	};

	if (result) {
		"PASSED".postln;
	} {
		"FAILED".postln;
	};
};

~test_getChordVocalRange = { |triads, voiceData, chordData, chordState|
	var prog = ~getProg.(triads);

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
~test_RMIFixtures = [
	[
		[['CM', 1], ['DM', 1]],
		[48, 55, 60, 64],
		[
			OrderedIdentitySet[42, 54],
			OrderedIdentitySet[66],
			OrderedIdentitySet[66],
			OrderedIdentitySet[74]
		]
	],
	[
		[['DM', 1], ['Cm', 1]],
		[50, 57, 62, 66],
		[
			OrderedIdentitySet[60],
			OrderedIdentitySet[51, 63, 67],
			OrderedIdentitySet[72],
			OrderedIdentitySet[60, 72]
		]
	],
	[
		[['Em', 1], ['Ebm', 1]],
		[40, 59, 67, 76],
		[
			OrderedIdentitySet[46, 51, 58],
			OrderedIdentitySet[],
			OrderedIdentitySet[],
			OrderedIdentitySet[66, 70]
		]
	]
];
~test_RMIFixtures[2][2];
	/*
	[[['Dm', 1], ['C#m', 1]],[50, 57, 62, 65], 'C#m','bas', OrderedIdentitySet[40, 44, 56]],
	[[['Em', 1], ['BbM', 1]],[52, 59, 64, 67], 'BbM','bas', OrderedIdentitySet[41, 46, 58]]*/
//];

~test_RMISubroutine = { |voiceData, chordState, exclude, i|
	var refRange = chordState[\validNotes].copy;
	var result = true;

	"TEST #% | ~resolveMelodicIntervals | ".format(i).post;

	~resolveMelodicIntervals.(voiceData, chordState[\validNotes], chordState[\currChord]);

	"refRange:".postln;
	voiceData[\voiceNames].do { |v| refRange[v].postln };
	"validNotes:".postln;
	voiceData[\voiceNames].do { |v| chordState[\validNotes][v].postln };

	voiceData[\voiceNames].do { |v, j|
		result = result && ((refRange[v] -- chordState[\validNotes][v]) == exclude[j]);
	};

	if (result) {
		"PASSED".postln;
	} {
		"FAILED".postln;
	}
};

~test_resolveMelodicIntervals = { |fixtures, triads, voiceData, chordData, chordState|

	~logger = false;
	~loggerCount = 0;

	fixtures.do { |f, i|

		chordData[\chordProg] = f[0];
		chordData[\chords] = ~getChordDegreeArrays.(triads, f[0]);
		chordState[\nextCipher] = f[0][1][0];
		chordState[\currChord] = f[1];
		chordState[\validNotes] = ~getChordVocalRange.(voiceData, chordData[\chords][f[0][1][0]][\notes]);

		~test_RMISubroutine.(voiceData, chordState, f[2], i);

		~resetChordData.(chordData); ~resetChordState.(chordState);
	};
	nil;
};

~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~voiceData, ~chordData, ~chordState);
)
(Set[1, 2, 3, 4] -- Set[1, 2, 3, 4]) == Set[]
/*************************************************************************************/
// TEST: ~resolveCommonTones
(
var chordProg = [['CM', 1], ['Am', 1]];
var nextCipher = 'Am';
var currChord = [48, 55, 64, 72];

~loggerCount = 0;
~resetChordDicts.();

~test_resolveCommonTone = {
	// chordProg
	// getChordDegreeArrays
	// nextCipher
	// currChord
	// getChordVocalRange

	~resetChordData.(chordData);
	~resetChordState.(chordState);

	~chordData[\chordProg] = ;
	~chordData[\chords] = ;
	~chordState[\nextCipher] = ;
	~chordState[\currChord] = ;
	~chordState[\validNotes] = ;
};

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg);
~chordState[\currChord] = currChord;
~chordState[\nextCipher] = nextCipher;
~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData);
)

~chordState[\validNotes][\bas].postln;
