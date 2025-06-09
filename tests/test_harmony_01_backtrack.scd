/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"../src/sc_harmony_01_backtrack.scd".loadRelative;
"../src/sc_harmony_01_range.scd".loadRelative;
"../src/sc_harmony_01_dicts.scd".loadRelative;
"./test_harmony_01_fixtures.scd".loadRelative;
)
/*************************************************************************************/
(
//var buildChord = Array.fill(4, {0}).postln;
//var validNextChords = Array.new(20);
var chordProg = [['CM', 1], ['Dm', 1]];
var validNotes = Dictionary.new(), chords = Dictionary.new();

~logger = true;
~loggerCount = 0;

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg).postln;

~currChord = [[60, 64, 67, 72], [48, 55, 64, 72]];

~chordState[\currChord] = ~currChord[0];
~chordState[\nextChord] = Array.fill(4, {0});
~chordState[\nextCipher] = 'Dm';
~chordState[\validNextChords] = Array.new(20);

~rules[\enforceParallelOctaves] = false;
~rules[\enforceParallelFifths] = false;
~rules[\enforceCommonTones] = false;

~rules[\toggleCount] = 0;
~resetRules.(~rules);

~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData, ~rules);

~getNextChords.(~voiceData, ~chordData[\chords], ~chordState, ~rules, 0);

~chordState[\validNextChords].do { |c| (~getChordNoteNameOct.(c, ~midiRange)).postln };

~chordState[\validNextChords].do { |c|
	c = c.asSet;
	"% is subset of %: ".format(c, ~chordState[\nextCipher]).post;
	c.isSubsetOf(~triads[~chordState[\nextCipher]][\notes]).postln;
};
)
(
~getProgression = { |triads|
	var prog = Array.new(triads.keys.size);

	triads.keys.do { |k|
		var temp = [k, 1];
		prog.add(temp);
	};
	prog;
};

~test_GNC = { |triads, voiceData, chordData, chordState, rules|
	var chordProg = ~getProgression.(triads);
	var chords = [[60, 64, 67, 72], [48, 55, 64, 72]];
	var dict = Dictionary.new();

	~logger = false;
	~loggerCount = 0;

	rules[\enforceParallelFifths] = true;
	rules[\enforceParallelOctaves] = true;
	rules[\enforceNoteDuplicate] = true;
	rules[\enforceCommonTones] = false;
	rules[\enforceMelodicIntervals] = false;

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chords.do { |c, i|
		"\nTEST: chord #%: %".format(i, c).postln;
		chordState[\currChord] = c;

		triads.keys.do { |k|
			chordState[\nextCipher] = k;
			chordState[\nextChord] = Array.fill(4, {0});
			chordState[\validNextChords] = Array.new(20);

			~getValidNotes.(chordData[\chords], chordState, voiceData, rules);

			~getNextChords.(voiceData, chordData[\chords], chordState, rules, 0);

			if (chordState[\validNextChords].isEmpty) {

				"cipher: % ".format(k).padRight(12).post;
				"| %".format(chordState[\validNextChords]).postln;
			};
		};
	};
	~resetRules.(rules);
};

~test_GNC.(~triads, ~voiceData, ~chordData, ~chordState, ~rules);
)
