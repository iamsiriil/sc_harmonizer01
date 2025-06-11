/**************************************************************************************
- HARMONY 01 / Test utility Functions
**************************************************************************************/

(
~test_getFirstChordsArray = { |triads, voiceData, chordData, chordState, rules, firstCipher|
	var chordProg = [[firstCipher, 1]];

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chordState[\nextCipher] = firstCipher;
	chordState[\nextChord] = Array.fill(4, {0});
	chordState[\validNextChords] = Array.new(20);

	~getFirstChords.(voiceData, chordData, chordState, rules, 0);
	~resetRules.(rules);

	chordState[\validNextChords];
};

/*************************************************************************************/

~test_getNextChordsArray = { |triads, voiceData, chordData, chordState, rules, fixtures, firstCipher, nextCipher|
	var chordProg = [[firstCipher, 1], [nextCipher, 1]];

	chordData[\chords] = ~getChordDegreeArrays.(triads, chordProg);

	chordState[\currChord] = fixtures[\firstChords][firstCipher][1];
	chordState[\nextCipher] = nextCipher;
	chordState[\nextChord] = Array.fill(4, {0});
	chordState[\validNextChords] = Array.new(20);

	~getFirstChords.(voiceData, chordData, chordState, rules, 0);
	~resetRules.(rules);

	chordState[\validNextChords];
};
)