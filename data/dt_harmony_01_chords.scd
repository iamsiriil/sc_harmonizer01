/**************************************************************************************
- HARMONY 01 / Data gathering functions
**************************************************************************************/
(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"../src/sc_harmony_01_backtrack.scd".loadRelative;
"../src/sc_harmony_01_range.scd".loadRelative;
"../src/sc_harmony_01_dicts.scd".loadRelative;
"../tests/test_harmony_01_fixtures.scd".loadRelative;
"../tests/test_harmony_01_utils.scd".loadRelative;
)
/*************************************************************************************/

(
var name = "TestFile.csv";
var path = PathName.new("csv/%".format(~name).resolveRelative);
var file;

file = File(~path.fullPath, "a");

10.do { |n| file.write("This is line number %\n".format(n)) };

file.close;
)

(
~an_getChordData = { |triads, voiceData, chordData, chordState, rules, fixtures|
	var data = Array.fill(fixtures[\ciphers].size, {Array.new(fixtures[\ciphers].size)});

	~logger = false;
	~loggerCount = 0;

	fixtures[\ciphers].do { |c1|

		fixtures[\ciphers].do { |c2|
			~test_getNextChordsArray.(triads, voiceData, chordData, chordState, rules, fixtures, c1, c2);
			"ci: % | c2: % | nextChords: %".format(c1, c2, chordState[\validNextChords]).postln;
		};
	};
	~resetRules.(rules);
};
~an_getChordData.(~triads, ~voiceData, ~chordData, ~chordState, ~rules, ~test_GNCFixtures);
)

0.asSymbol
~dict = Dictionary[\0->"one", \1->"two"];
~dict[1.asSymbol]