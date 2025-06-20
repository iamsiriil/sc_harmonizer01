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
~an_getChordData = { |triads, data, rules, fixtures|
	var store = Array.new(fixtures[\ciphers].size);

	~logger = false;
	~loggerCount = 0;

	fixtures[\ciphers].do { |c1|
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

(
~printHeader = { |ciphers, results, file|
	var string = ",";

	results.size.do { |i|
		string = string ++ ciphers[i];
		if (i < (results.size - 1)) {
			string = string ++ ",";
		}
	};
	string = string ++ "\n";
	file.write(string);
};

~printRows = { |ciphers, results, file|

	ciphers.do { |c, i|
		var string = "";

		string = c ++ ",";

		results.do { |r, j|
			string = string ++ r[i];
			if (j < (results.size - 1)) {
				string = string ++ ",";
			};
		};
		string = string ++ "\n";
		file.write(string);
	};
};

~getCSV = { |ciphers, results, fileName|
	var path = PathName.new("csv/%".format(fileName).resolveRelative);
	var file = File(path.fullPath, "a");

	~printHeader.(ciphers, results, file);
	~printRows.(ciphers, results, file);

	file.close;
};
~getCSV.(~test_GNCFixtures[\ciphers], ~results, "chordData00.csv");
)

