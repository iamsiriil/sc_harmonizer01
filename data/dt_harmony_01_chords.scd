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
~an_getChordData = { |triads, data, rules, fixtures|
	var store = Array.new(fixtures[\ciphers].size);

	~logger = false;
	~loggerCount = 0;

	fixtures[\ciphers][0..5].do { |c1|
		var array = Array.new(fixtures[\ciphers].size);

		fixtures[\ciphers].do { |c2|
			~test_getNextChordsArray.(triads, data, rules, fixtures, c1, c2);
			"ci: % | c2: % | nextChords: %".format(c1, c2, data[\state][\validNextChords]).postln;
			array.add(data[\state][\validNextChords].size);
		};
		store.add(array.copy);
	};
	~resetRules.(rules);
	store;
};
~results = ~an_getChordData.(~triads, ~data, ~rules, ~test_GNCFixtures);
)

~results.do { |n| n.postln; };
(
~createHeader = { |array|
	var string = ",";

	array.do { |c, i|
		string = string ++ c;
		if (i < (array.size - 1)) {
			string = string ++ ",";
		}
	};
	string;
};
~createHeader.(~test_GNCFixtures[\ciphers]);
)

