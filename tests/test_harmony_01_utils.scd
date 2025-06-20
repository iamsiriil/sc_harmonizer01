/**************************************************************************************
- HARMONY 01 / Test utility Functions
**************************************************************************************/
(
~test_getFirstChordsArray = { |triads, data, rules, firstCipher|
	var chordProg = [firstCipher];

	data[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	data[\state][\nextCipher] = firstCipher;
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	~getFirstChords.(data, rules, 0);
	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/

~test_getNextChordsArray = { |triads, data, rules, fixtures, firstCipher, nextCipher, open = true|
	var chordProg = [firstCipher, nextCipher];
	var n = if (open) { 1 } { 0 };

	data[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	data[\state][\currChord] = fixtures[\firstChords][firstCipher][n];
	data[\state][\nextCipher] = nextCipher;
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	~getValidNotes.(data, rules);

	~getNextChords.(data, rules, 0);
	~resetRules.(rules);

	data[\state][\validNextChords];
};
)
