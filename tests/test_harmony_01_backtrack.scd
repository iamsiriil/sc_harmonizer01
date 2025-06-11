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

//~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData, ~rules);

~getFirstChords.(~voiceData, ~chordData, ~chordState, ~rules, 0).postln;

~chordState[\validNextChords].do { |c| (~getChordNoteNameOct.(c, ~midiRange)).postln };

~chordState[\validNextChords].do { |c|
	c = c.asSet;
	"% is subset of %: ".format(c, ~chordState[\nextCipher]).post;
	c.isSubsetOf(~triads[~chordState[\nextCipher]][\notes]).postln;
};
)
/*************************************************************************************/
(
// Checks if chord notes belong to the given cipher

~test_GFCSubroutine00 = { |triads, chordState|
	var set, result = true;

	"\nTEST #00: Notes belong to Chord".postln;

	chordState[\validNextChords].do { |c|
		set = c.asSet;
		result = result && set.isSubsetOf(triads[chordState[\nextCipher]][\notes]);
	};
	~test_resultMessage.(result, "~getFirstChords", nil, 0);
	nil;
};

// Checks if chords are complete
~test_GFCSubroutine01 = { |triads, voiceData, chordData, chordState|
	var set, result = true;

	"\nTEST #01: Chord is complete".postln;

	chordState[\validNextChords].do { |c|
		set = ~getChordNotesDegree.(c, chordState[\nextCipher], chordData[\chords]).asSet;
		result = result && (set == triads[chordState[\nextCipher]][\degree].asSet);
	};
	~test_resultMessage.(result, "~getFirstChords", nil, 1);
	nil;
};

// Checks whether chord notes are within range
~test_GFCSubroutine02 = { |voiceData, chordState|
	var voiceRange = voiceData[\voiceRange];
	var result;

	"\nTEST #02: Notes are within range".postln;

	chordState[\validNextChords].do { |c, i|
		result = true;

		voiceData[\voiceNames].do { |v, j|
			result = result && ((c[j] >= voiceRange[v][0]) && (c[j] <= voiceRange[v][1]));
		};
		~test_resultMessage.(result, "~getFirstChords", nil, i);
	};
	nil;
};

~test_GFCSubroutine03 = { |chordState, rules|
	var cross, result, n;

	"\nTEST #03: Spacing is correct".postln;

	cross = if (rules[\enforceVoiceCrossProhibition]) {
			(_ >= 0);
		} {
			(_ >= -4);
		};

	chordState[\validNextChords].do { |c, i|
		result = true;

		for(1, 3) { |j|
			n = (c[j] - c[j - 1]).abs;

			if (j == 1){
				result = result && (cross.(n) && (n <= 24));
			} {
				result = result && (cross.(n) && (n <= 12));
			};
		};
		~test_resultMessage.(result, "~getFirstChords", nil, i);
		nil;
	};
};

~test_getFirstChord = { |triads, voiceData, chordData, chordState, rules, firstCipher|
	var chordProg = [[firstCipher, 1]];

	~logger = false;
	~loggerCount = 0;

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chordState[\nextCipher] = firstCipher;
	chordState[\nextChord] = Array.fill(4, {0});
	chordState[\validNextChords] = Array.new(20);

	~getFirstChords.(voiceData, chordData, chordState, rules, 0);
	~resetRules.(rules);

	//chordState[\validNextChords];
	~test_GFCSubroutine00.(triads, chordState);
	~test_GFCSubroutine01.(triads, voiceData, chordData, chordState);
	~test_GFCSubroutine02.(voiceData, chordState);
	~test_GFCSubroutine03.(chordState, rules);
};
~test_getFirstChord.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, 'Dm');
)

/*************************************************************************************/

(
~test_GNCChords = { |triads, voiceData, chordData, chordState, rules, fixtures|
	var chordProg = ~getProgression.(triads);
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

			~getNextChords.(voiceData, chordData, chordState, rules, 0);

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
	column.postln;
};

~test_GNCChords.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, ~test_GNCFixtures);
)

/*************************************************************************************/

(
~test_GNCFlags = { |triads, voiceData, chordData, chordState, rules, fixtures|
	var results = Array.fill(fixtures[\flags].size, {Array.new(fixtures[\flags].size)});

	fixtures[\flags].do { |f, i|
		"\nTEST | flag %: false".format(f).postln;

		rules[f] = false;

		results.put(i, ~test_GNCChords.(triads, voiceData, chordData, chordState, rules, fixtures));
	};
	results;
};

~results = ~test_GNCFlags.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, ~test_GNCFixtures);
~test_GNCPrintResults.(~ciphers, ~flags, ~results);
)
~results.size