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
var chordProg = [['Dm', 1], ['AM', 1]];
var validNotes = Dictionary.new(), chords = Dictionary.new();

~logger = true;
~loggerCount = 0;

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg).postln;

//~currChord = [[60, 64, 67, 72], [48, 55, 64, 72]];

//~chordState[\currChord] = ~currChord[0];
~chordState[\nextChord] = Array.fill(4, {0});
~chordState[\nextCipher] = 'Dm';
~chordState[\validNextChords] = Array.new(20);

~rules[\enforceParallelOctaves] = false;
~rules[\enforceParallelFifths] = false;
~rules[\enforceCommonTones] = false;

~rules[\toggleCount] = 0;
~resetRules.(~rules);

~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData, ~rules);

~getFirstChords.(~voiceData, ~chordData[\chords], ~chordState, ~rules, 0).postln;

~chordState[\validNextChords].do { |c| (~getChordNoteNameOct.(c, ~midiRange)).postln };

~chordState[\validNextChords].do { |c|
	c = c.asSet;
	"% is subset of %: ".format(c, ~chordState[\nextCipher]).post;
	c.isSubsetOf(~triads[~chordState[\nextCipher]][\notes]).postln;
};
)
(
~test_GNCChords = { |fixtures, triads, voiceData, chordData, chordState, rules|
	var chordProg = ~getProgression.(triads);
	var dict = Dictionary.new();
	var column = Array.new(fixtures[\ciphers].size);

	~logger = false;
	~loggerCount = 0;

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	fixtures[\firstChords]['Ed'].do { |c, i|
		"\nTEST: chord #%: %".format(i, c).postln;
		chordState[\currChord] = c;

		fixtures[\ciphers].do { |k|
			chordState[\nextCipher] = k;
			chordState[\nextChord] = Array.fill(4, {0});
			chordState[\validNextChords] = Array.new(20);

			~getValidNotes.(chordData[\chords], chordState, voiceData, rules);

			~getNextChords.(voiceData, chordData[\chords], chordState, rules, 0);

			column.add(chordState[\validNextChords].size.copy);

			if (chordState[\validNextChords].isEmpty) {

				"cipher: % ".format(k).padRight(12).post;
				"| %".format(chordState[\validNextChords]).postln;

			} {
				"cipher: % ".format(k).padRight(12).post;
				"| %".format(chordState[\validNextChords].size).postln;
			};
		};
	};
	~resetRules.(rules);
	column;
};

~test_GNCChords.(~test_GNCFixtures, ~triads, ~voiceData, ~chordData, ~chordState, ~rules);
)

~test_GNCFixtures[\firstChords]['F#d']
(
~test_GNCFlags = { |fixtures, triads, voiceData, chordData, chordState, rules|
	var results = Array.fill(fixtures[\flags].size, {Array.new(fixtures[\flags].size)});

	fixtures[\flags].do { |f, i|
		"\nTEST | flag %: false".format(f).postln;

		rules[f] = false;

		results.put(i, ~test_GNCChords.(fixtures, triads, voiceData, chordData, chordState, rules));
	};
	results;
};
~results = ~test_GNCFlags.(~test_GNCFixtures, ~triads, ~voiceData, ~chordData, ~chordState, ~rules);
)
~results.do { |r| r.postln };

~test_GNCPrintResults.(~ciphers, ~flags, ~results);
