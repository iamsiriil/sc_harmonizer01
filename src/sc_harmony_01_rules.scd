/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/
// Enforcement flags
(
~enforceVoiceCrossProhibition = true;  // Enforced in ~checkVoiceRange, during backtrack
~enforceMelodicIntervals      = true;  // Enforced in ~getValidNotes, before backtrack
~enforceVocalRange            = true;  // Enforced in ~getValidNotes, before backtrack
~enforceCommonTones           = true;  // Enforced in ~getValidNotes, before backtrack

~enforceParallelOctaves       = true;  // Enforced in ~chordIsValid, during backtrack
~enforceParallelFifths        = true;  // Enforced in ~chordIsValid, during backtrack

~enforceNoteDuplicate         = true;  // Enforced in ~chordIsValid, during backtrack
// Note duplication enforcement flags: 1 true to 2 false
~enforceRootDuplicate         = true;  // Enforced in ~checkNoteDuplicate, during backtrack
~enforceThirdDuplicate        = false; // Enforced in ~checkNoteDuplicate, during backtrack
~enforceFifthDuplicate        = false; // Enforced in ~checkNoteDuplicate, during backtrack

~enforceChordPosition         = true;  // Enforced in ~chordIsValid, during backtrack
// Chord position enforcement flags: 1 true to 2 false
~enforceRootPosition          = true;  // Enforced in ~checkChordPosition, during backtrack
~enforceFirstInversion        = false; // Enforced in ~checkChordPosition, during backtrack
~enforceSecondInversion       = false; // Enforced in ~checkChordPosition, during backtrack

// Toggle rules counter
~toggleCount = 0;

~logger = true;

/*************************************************************************************/
// Check chord position: Root, first inversion, second inversion

~checkChordPosition = #{ |nextChord|
	var bassNote = ~getNoteDegree.(nextChord[0]);

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkChordPosition: Function Call".format(~loggerCount).postln; };

	if (~enforceChordPosition == true) {

		case
		{ ~enforceRootPosition == true } {
			bassNote == "Rt";
		}
		{ ~enforceFirstInversion == true } {
			bassNote.contains("3");
		}
		{ ~enforceSecondInversion == true } {
			bassNote.contains("5");
		};
	} {
		true;
	};
};

/*************************************************************************************/
// Check range between voices

~checkVoiceSpacing = #{ |nextChord, i|
	var cross, n;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkVoiceSpacing: Function Call".format(~loggerCount).postln; };

	if (i > 0) {
		n = (nextChord[i] - nextChord[i - 1]);

		cross = if (~enforceVoiceCrossProhibition == true) {
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
// Check for parallel octaves

~checkParallelOctaves = #{ |nextChord|
	var currChord = ~chordState[\currChord];
	var numVoices = ~voiceData[\numVoices];
	var index, result;
	var octaves = [12, 24, 36];

	var i = 0, j;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkParallelOctaves: Function Call".format(~loggerCount).postln; };

	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			octaves.do { |oct|
				if ((currChord[j] - currChord[i]) == oct) { index = [i, j] };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	result = (
		(currChord[index[1]] - currChord[index[0]]) ==
		(nextChord[index[1]] - nextChord[index[0]])
	);
	result.not;
};

/*************************************************************************************/
// Check for parallel fifths

~checkParallelFifths = #{ |nextChord|
	var currChord = ~chordState[\currChord];
	var numVoices = ~voiceData[\numVoices];
	var index = Array.new(4), result = false;
	var fifths = [7, 19, 31, 43];

	var i = 0, j;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkParallelFifths: Function Call".format(~loggerCount).postln; };

	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			fifths.do { |n|
				if ((currChord[j] - currChord[i]) == n) { index.add([i, j]) };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	index.do { |i|
		result = result ||
		((currChord[i[1]] - currChord[i[0]]) ==
		(nextChord[i[1]] - nextChord[i[0]]));
	};
	result.not;
};

/*************************************************************************************/
// Checks wich degree gets repeated inside the chord,
// and if chord is complete (e.g. All triad notes are present).

~checkNoteDuplicate = #{ |nextChord|
	var degrees, chordAsSet, degreesAsSet;
	var cipher = ~chordState[\nextCipher];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkNoteDuplicate: Function Call".format(~loggerCount).postln; };

	degrees = ~getChordNotesDegree.(nextChord);

	degreesAsSet = ~chordData[\chords][cipher][\degree].asSet;
	chordAsSet = degrees.asSet;

	if (chordAsSet == degreesAsSet) {

		if (~enforceNoteDuplicate == true) {

			case
			{ ~enforceRootDuplicate == true } {
				(degrees.count({ |item| item == "Rt" }) == 2);
			}
			{ ~enforceThirdDuplicate == true } {
				(degrees.count({ |item| item.contains("3") }) == 2);
			}
			{ ~enforceFifthDuplicate == true } {
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
// Final check before chord gets added to validNextChord array

~chordIsValid = #{ |nextChord|
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~chordIsValid: Function Call".format(~loggerCount).postln; };

	if (~enforceChordPosition == true) {
		result = result && ~checkChordPosition.(nextChord);
	};
	if (~enforceNoteDuplicate == true) {
		result = result && ~checkNoteDuplicate.(nextChord);
	};
	if (~enforceParallelOctaves == true) {
		result = result && ~checkParallelOctaves.(nextChord);
	};
	if (~enforceParallelFifths == true) {
		result = result && ~checkParallelFifths.(nextChord);
	};
	for (1, 3) { |i|
		result = result && ~checkVoiceSpacing.(nextChord, i);
	};
	result;
};

/*************************************************************************************/
// Toggle rules

~toggleRules = #{ |count|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~toggleRules: Function Call".format(~loggerCount).postln; };

	"~toggleCount = %".format(~toggleCount).postln;
	switch(count)
	{ 0 } { // Root position with third duplicate
		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = true;
		~enforceFifthDuplicate = false;
	}
	{ 1 } { // Root position with fifth duplicate
		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = false;
		~enforceFifthDuplicate = true;
	}
	{ 2 } { // First inversion with root duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = true;
		~enforceSecondInversion = false;

		~enforceRootDuplicate = true;
		~enforceThirdDuplicate = false;
		~enforceFifthDuplicate = false;
	}
	{ 3 } { // First inversion with third duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = true;
		~enforceSecondInversion = false;

		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = true;
		~enforceFifthDuplicate = false;
	}
	{ 4 } { // First inversion with fifth duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = true;
		~enforceSecondInversion = false;

		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = false;
		~enforceFifthDuplicate = true;
	}
	{ 5 } { // Second inversion with root duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = false;
		~enforceSecondInversion = true;

		~enforceRootDuplicate = true;
		~enforceThirdDuplicate = false;
		~enforceFifthDuplicate = false;
	}
	{ 6 } { // Second inversion with third duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = false;
		~enforceSecondInversion = true;

		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = true;
		~enforceFifthDuplicate = false;
	}
	{ 7 } { // Second inversion with fifth duplicate
		~enforceRootPosition = false;
		~enforceFirstInversion = false;
		~enforceSecondInversion = true;

		~enforceRootDuplicate = false;
		~enforceThirdDuplicate = false;
		~enforceFifthDuplicate = true;
	}
	{ 8 } { // Any duplication and position, no parallel checks
		~enforceNoteDuplicate = false;
		~enforceChordPosition = false;

		~enforceParallelOctaves = false;
		~enforceParallelfifths = false;
	};

	~toggleCount = ~toggleCount + 1;
	nil;
};

/*************************************************************************************/
// Reset rules

~resetRules = #{

	~enforceVoiceCrossProhibition = true;
	~enforceMelodicIntervals      = true;
	~enforceVocalRange            = true;
	~enforceParallelOctaves       = true;
	~enforceParallelFifths        = true;
	~enforceNoteDuplicate         = true;
	~enforceRootDuplicate         = true;
	~enforceThirdDuplicate        = false;
	~enforceFifthDuplicate        = false;
	~enforceChordPosition         = true;
	~enforceRootPosition          = true;
	~enforceFirstInversion        = false;
	~enforceSecondInversion       = false;
	~enforceCommonTone            = true;

	~toggleCount = 0;
	nil;
};
)
