/**************************************************************************************
- HARMONY 01 / Test utility Functions
**************************************************************************************/
(
~test_getFirstChordsArray = { |triads, data, progState, rules, firstCipher|
	var parsedChords = Dictionary.new();

	progState[\progression] = [firstCipher].postln;

	data[\chords] = ~getChordDegreeArrays.(triads, progState[\progression]).postln;
	data[\state][\nextCipher] = firstCipher.postln;

	~progParser.(progState[\progression], parsedChords);
	~setRules.(progState, parsedChords, true);

	~getFirstChords.(data, progState, rules, 0);

	data[\state][\validNextChords];
};

/*************************************************************************************/

~test_getNextChordsArray = { |triads, data, progState, rules, fixtures, firstCipher, nextCipher, open = true|
	var parsedChords = Dictionary.new();
	var n = if (open) { 1 } { 0 };

	progState[\progression] = [firstCipher, nextCipher];
	progState[\result] = [fixtures[\firstChords][firstCipher][n]];

	data[\chords] = ~getChordDegreeArrays.(triads, progState[\progression]);
	data[\state][\nextCipher] = nextCipher;

	~progParser.(progState[\progression], parsedChords);
	~setRules.(progState, parsedChords, false);

	~getNextChords.(data, progState, rules, 0);

	data[\state][\validNextChords];
};

/*************************************************************************************/
// Check chord fixtures for test_getNextChords are correct

~checkFistChord = { |fixtures, triads|

	fixtures[\ciphers].do { |c|

		if (fixtures[\firstChords][c].notNil) {

			fixtures[\firstChords][c].do { |i|

				"%: ".format(c).padRight(5).post;
				i.asSet.isSubsetOf(triads[c][\notes]).postln;
			};
		};
	};
};
)
