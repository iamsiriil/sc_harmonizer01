/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/
// Check chord position: Root, first inversion, second inversion

~checkChordPosition = #{ |nextChord, cipher, chords, rules|
	var bassNote = ~getNoteDegree.(nextChord[0], cipher, chords);

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkChordPosition: Function Call".format(~loggerCount).postln; };

	if (rules[\enforceChordPosition]) {

		case
		{ rules[\enforceRootPosition] } {
			bassNote == "Rt";
		}
		{ rules[\enforceFirstInversion] } {
			bassNote.contains("3");
		}
		{ rules[\enforceSecondInversion] } {
			bassNote.contains("5");
		};
	} {
		true;
	};
};

/*************************************************************************************/
// Checks wich degree gets repeated inside the chord,
// and if chord is complete (e.g. All triad notes are present).

~checkNoteDuplicate = #{ |nextChord, cipher, chords, rules|
	var degrees, chordAsSet, degreesAsSet;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkNoteDuplicate: Function Call".format(~loggerCount).postln; };

	degrees = ~getChordNotesDegree.(nextChord, cipher, chords);

	degreesAsSet = chords[cipher][\degree].asSet;
	chordAsSet = degrees.asSet;

	if (chordAsSet == degreesAsSet) { // Checks if chord is complete

		if (rules[\enforceNoteDuplicate]) {

			case
			{ rules[\enforceRootDuplicate] } {
				(degrees.count({ |item| item == "Rt" }) == 2);
			}
			{ rules[\enforceThirdDuplicate] } {
				(degrees.count({ |item| item.contains("3") }) == 2);
			}
			{ rules[\enforceFifthDuplicate] } {
				(degrees.count({ |item| item.contains("5") }) == 2);
			}
		} {
			true;
		};
	} {
		false;
	};
};


/*************************************************************************************/
// Check for parallel octaves

~checkParallelOctaves = #{ |nextChord, currChord, numVoices|
	var index, result = false;
	var octaves = [12, 24, 36];
	var i = 0, j;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkParallelOctaves: Function Call".format(~loggerCount).postln; };

	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			if (octaves.includes((currChord[i] - currChord[j]).abs)) { index = [i, j] };
			j = j + 1;
		};
		i = i + 1;
	};

	result = (
		(currChord[index[1]] - currChord[index[0]]).abs ==
		(nextChord[index[1]] - nextChord[index[0]]).abs
	);
	result.not;
};

/*************************************************************************************/
// Check for parallel fifths

~checkParallelFifths = #{ |nextChord, currChord, numVoices|
	var index = Array.new(6), result = false;
	var fifths = [7, 19, 31, 43];
	var i = 0, j;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkParallelFifths: Function Call".format(~loggerCount).postln; };

	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			if (fifths.includes((currChord[i] - currChord[j]).abs)) { index.add([i, j]) };
			j = j + 1;
		};
		i = i + 1;
	};

	index.do { |i|
		result = result || (
			(currChord[i[1]] - currChord[i[0]]).abs ==
			(nextChord[i[1]] - nextChord[i[0]]).abs
		);
	};
	result.not;
};

/*************************************************************************************/
// Check range between voices

~checkVoiceSpacing = #{ |nextChord, i, rules|
	var cross, n;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkVoiceSpacing: Function Call".format(~loggerCount).postln; };

	if (i > 0) {
		n = (nextChord[i] - nextChord[i - 1]);

		cross = if (rules[\enforceVoiceCrossProhibition]) {
			(n >= 0);
		} {
			(n >= -4);
		};

		switch(i)
		{ 1 } { cross && (n <= 24) }
		{ 2 } { cross && (n <= 12) }
		{ 3 } { cross && (n <= 12) }
	} {
		true;
	};
};

/*************************************************************************************/
// Final check before chord gets added to validNextChord array

~chordIsValid = #{ |chords, chordState, numVoices, rules|
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~chordIsValid: Function Call".format(~loggerCount).postln; };

	if (rules[\enforceChordPosition]) {
		result = result && ~checkChordPosition.(chordState[\nextChord], chordState[\nextCipher], chords, rules);
	};
	if (rules[\enforceNoteDuplicate]) {
		result = result && ~checkNoteDuplicate.(chordState[\nextChord], chordState[\nextCipher], chords, rules);
	};
	if (rules[\enforceParallelOctaves]) {
		result = result && ~checkParallelOctaves.(chordState[\nextChord], chordState[\currChord], numVoices);
	};
	if (rules[\enforceParallelFifths]) {
		result = result && ~checkParallelFifths.(chordState[\nextChord], chordState[\currChord], numVoices);
	};
	for (1, 3) { |i|
		result = result && ~checkVoiceSpacing.(chordState[\nextChord], i, rules);
	};
	result;
};

/*************************************************************************************/
// Toggle rules

~toggleRules = #{ |count, rules|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~toggleRules: Function Call".format(~loggerCount).postln; };

	"~toggleCount = %".format(~toggleCount).postln;
	switch(count)
	{ 0 } { // Root position with third duplicate
		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = true;
		rules[\enforceFifthDuplicate] = false;
	}
	{ 1 } { // Root position with fifth duplicate
		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = false;
		rules[\enforceFifthDuplicate] = true;
	}
	{ 2 } { // First inversion with root duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = true;
		rules[\enforceSecondInversion] = false;

		rules[\enforceRootDuplicate] = true;
		rules[\enforceThirdDuplicate] = false;
		rules[\enforceFifthDuplicate] = false;
	}
	{ 3 } { // First inversion with third duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = true;
		rules[\enforceSecondInversion] = false;

		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = true;
		rules[\enforceFifthDuplicate] = false;
	}
	{ 4 } { // First inversion with fifth duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = true;
		rules[\enforceSecondInversion] = false;

		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = false;
		rules[\enforceFifthDuplicate] = true;
	}
	{ 5 } { // Second inversion with root duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = false;
		rules[\enforceSecondInversion] = true;

		rules[\enforceRootDuplicate] = true;
		rules[\enforceThirdDuplicate] = false;
		rules[\enforceFifthDuplicate] = false;
	}
	{ 6 } { // Second inversion with third duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = false;
		rules[\enforceSecondInversion] = true;

		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = true;
		rules[\enforceFifthDuplicate] = false;
	}
	{ 7 } { // Second inversion with fifth duplicate
		rules[\enforceRootPosition] = false;
		rules[\enforceFirstInversion] = false;
		rules[\enforceSecondInversion] = true;

		rules[\enforceRootDuplicate] = false;
		rules[\enforceThirdDuplicate] = false;
		rules[\enforceFifthDuplicate] = true;
	}
	{ 8 } { // Any duplication and position, no parallel checks
		rules[\enforceNoteDuplicate] = false;
		rules[\enforceChordPosition] = false;

		rules[\enforceParallelOctaves] = false;
		rules[\enforceParallelfifths] = false;
	};

	rules[\toggleCount] = rules[\toggleCount] + 1;
	nil;
};
)
