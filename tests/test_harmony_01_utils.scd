(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
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

(
~test_getChordVocalRange = { |chord|

};

~chordData[\chords] = ~getChordDegreeArrays.(~triads, ~chordProg[1]);
~nextCipher = 'FM';
~getChordVocalRange.(~voiceData, ~chordData[\chords][~nextCipher][\notes])
)

(
var chordProg = [['CM', 1], ['Am', 1]];
var nextCipher = 'Am';
var currChord = [48, 55, 64, 72];
~loggerCount = 0;

~test_resolveCommonTone = {

};
~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg);
//~chordState[\validNotes] = ~getChordVocalRange.(~voiceData, ~chordData[\chords][nextCipher][\notes]);
//~resolveCommonTones.(~voiceData, ~chordState[\validNotes], currChord);
~chordState[\currChord] = currChord;
~chordState[\nextCipher] = nextCipher;
~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData);
)

~chordState[\validNotes][\bas]



(
var invalidIntervals = [6, 10, 11, 18, 22, 23];
var currChord = [41, 53, 60, 69];
var chordProg = [['FM', 1], ['GM', 1]];
var nextCipher = 'GM';
~resetChordDicts.();

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg);
~chordState[\validNotes] = ~getChordVocalRange.(~voiceData, ~chordData[\chords][nextCipher][\notes]);

~resolveMelodicIntervals.(~voiceData, ~chordState[\validNotes], currChord);
)

~chordState[\validNotes][\spn]

~invalidIntervals = [6, 10, 11, 18, 22, 23];
~invalidIntervals;
~currChord = [41, 53, 60, 69];
~chordState[\validNotes][\ten] = ~chordState[\validNotes][\ten].reject { |n| ~invalidIntervals.includes((n - ~currChord[1]).abs)}
~chordState[\validNotes][\ten]



