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

~ciphers = ['Cd', 'Cm', 'CM', 'CA', 'C#d', 'C#m', 'C#M', 'C#A', 'Dd', 'Dm', 'DM', 'DA', 'Ebd', 'Ebm', 'EbM', 'EbA', 'Ed', 'Em', 'EM', 'EA', 'Fd', 'Fm', 'FM', 'FA', 'F#d', 'F#m', 'F#M', 'F#A', 'Gd', 'Gm', 'GM', 'GA', 'G#d', 'G#m', 'AbM', 'AbA', 'Ad', 'Am', 'AM', 'AA', 'Bbd', 'Bbm', 'BbM', 'BbA', 'Bd', 'Bm', 'BM', 'BA'];

~flags = [\enforceVoiceCrossProhibition,
	\enforceMelodicIntervals,
	\enforceVocalRange,
	\enforceCommonTones,
	\enforceParallelOctaves,
	\enforceParallelFifths,
	\enforceNoteDuplicate,
	\enforceChordPosition
];

~firstChords = (
	'Cd': [[60, 63, 66, 72], [48, 60, 66, 75]],
	'Cm': [[60, 63, 67, 72], [48, 60, 67, 75]],
	'CM': [[60, 64, 67, 72], [48, 60, 67, 76]],
	'CA': [[60, 64, 68, 72], [48, 60, 68, 76]],
	'C#d':[[49, 52, 55, 61], [49, 61, 67, 76]],
	'C#m':[[49, 52, 56, 61], [49, 61, 68, 76]],
	'C#M':[[49, 53, 56, 61], [49, 61, 68, 77]],
	'C#A':[[49, 53, 57, 61], [49, 61, 69, 77]],
	'Dd': [[50, 53, 56, 62], [50, 62, 68, 77]],
	'Dm': [[50, 53, 57, 62], [50, 62, 69, 77]],
	'DM': [[50, 54, 57, 62], [50, 62, 69, 78]],
	'DA': [[50, 54, 58, 62], [50, 62, 70, 78]]
);

~test_GNCPrintResults = { |ciphers, flags, results|

	"".padRight(5).post;
	flags.do { |f| "| % ".format(f).padRight(f.asString.size + 2).post; };
	"".postln;

	ciphers.do { |c, i|
		"%".format(c).padRight(5).post;

		flags.do { |f, j|
			"| %".format(results[j][i]).padRight(f.asString.size + 3).post;
		};
		"".postln;
	}
};

~test_GNCChords = { |triads, voiceData, chordData, chordState, rules, ciphers, firstChords|
	var chordProg = ~getProgression.(triads);
	var dict = Dictionary.new();
	var column = Array.new(ciphers.size);

	~logger = false;
	~loggerCount = 0;

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	firstChords.do { |c, i|
		"\nTEST: chord #%: %".format(i, c).postln;
		chordState[\currChord] = c;

		ciphers.do { |k|
			chordState[\nextCipher] = k;
			chordState[\nextChord] = Array.fill(4, {0});
			chordState[\validNextChords] = Array.new(20);

			~getValidNotes.(chordData[\chords], chordState, voiceData, rules);

			~getNextChords.(voiceData, chordData[\chords], chordState, rules, 0);

			column.add(chordState[\validNextChords].size.copy);

			/*if (chordState[\validNextChords].isEmpty) {

				"cipher: % ".format(k).padRight(12).post;
				"| %".format(chordState[\validNextChords]).postln;

			} {
				"cipher: % ".format(k).padRight(12).post;
				"| %".format(chordState[\validNextChords].size).postln;
			};*/
		};
	};
	~resetRules.(rules);
	column;
};

~test_GNCChords.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, ~ciphers, ~firstChords);

~test_GNCFlags = { |triads, voiceData, chordData, chordState, rules, ciphers, firstChords, flags|
	var results = Array.fill(flags.size, {Array.new(flags.size)});

	flags.do { |f, i|
		"\nTEST | flag %: false".format(f).postln;

		rules[f] = false;

		results.put(i, ~test_GNCChords.(triads, voiceData, chordData, chordState, rules, ciphers, firstChords));
		//~resetRules.(rules);
	};
	results;
};
~results = ~test_GNCFlags.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, ~ciphers, ~firstChords, ~flags);
)
~results.do { |r| r.postln };

~test_GNCPrintResults.(~ciphers, ~flags, ~results);

~ciphers = ['Cd', 'Cm', 'CM', 'CA', 'C#d', 'C#m', 'C#M', 'C#A', 'Dd', 'Dm', 'DM', 'DA', 'Ebd', 'Ebm', 'EbM', 'EbA', 'Ed', 'Em', 'EM', 'EA', 'Fd', 'Fm', 'FM', 'FA', 'F#d', 'F#m', 'F#M', 'F#A', 'Gd', 'Gm', 'GM', 'GA', 'G#d', 'G#m', 'AbM', 'AbA', 'Ad', 'Am', 'AM', 'AA', 'Bbd', 'Bbm', 'BbM', 'BbA', 'Bd', 'Bm', 'BM', 'BA'];

~ciphers.do { |c| ~triads.keys.includes(c).postln };

\enforceMelodicIntervals.asString.size