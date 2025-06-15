/**************************************************************************************
- HARMONY 01 / Test utility Functions
**************************************************************************************/

(
/*~test_getFirstChordsArray = { |triads, voiceData, chordData, chordState, rules, firstCipher|
	var chordProg = [firstCipher];

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chordState[\nextCipher] = firstCipher;
	chordState[\nextChord] = Array.fill(4, {0});
	chordState[\validNextChords] = Array.new(20);

	~getFirstChords.(voiceData, chordData, chordState, rules, 0);
	~resetRules.(rules);

	chordState[\validNextChords];
};*/

~test_getFirstChordsArray = { |triads, data, rules, firstCipher|
	var chordProg = [firstCipher];

	data[\chords][\midi] = ~getChordDegreeArrays.(triads, chordProg);

	data[\state][\nextCipher] = firstCipher;
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	~getFirstChords.(data, rules, 0);
	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/

/*~test_getNextChordsArray = { |triads, voiceData, chordData, chordState, rules, fixtures, firstCipher, nextCipher|
	var chordProg = [firstCipher, nextCipher];

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chordState[\currChord] = fixtures[\firstChords][firstCipher][1];
	chordState[\nextCipher] = nextCipher;
	chordState[\nextChord] = Array.fill(4, {0});
	chordState[\validNextChords] = Array.new(20);

	~getValidNotes.(chordData[\chords], chordState, voiceData, rules);

	~getNextChords.(voiceData, chordData, chordState, rules, 0);
	~resetRules.(rules);

	chordState[\validNextChords];
};*/

~test_getNextChordsArray = { |triads, data, rules, fixtures, firstCipher, nextCipher|
	var chordProg = [firstCipher, nextCipher];

	data[\chords][\midi] = ~getChordDegreeArrays.(triads, chordProg);

	data[\state][\currChord] = fixtures[\firstChords][firstCipher][1];
	data[\state][\nextCipher] = nextCipher;
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	~getValidNotes.(data, rules);

	~getNextChords.(data, rules, 0);
	~resetRules.(rules);

	data[\state][\validNextChords];
};
)