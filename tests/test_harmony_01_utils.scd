(
"../sc_harmony_01_lib.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
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
~test_resolveCommonTones = {
	~logger = true;
	~loggerCount = 0;

	~enforceRootPosition = false;

	~chordData[\chordProg] = [['CM', 2], ['DM', 2]];
	~chordState[\currChord] = [48, 55, 60, 64];
	~chordState[\nextCipher] = 'DM';


	~getChordDegreeArrays.();
	~getChordVocalRange.();

	~resolveCommonTones.();
};
~test_resolveCommonTones.();
~chordState[\validNotes][\spn];
)






















