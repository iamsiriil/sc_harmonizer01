/**************************************************************************************
- HARMONY 01 / Rule Enforcement and Tests
**************************************************************************************/
(
// Check chord position: Root, first inversion, second inversion

~checkChordPosition = #{ |nextChord, cipher, chords, rules|
	var bassNote = ~getNoteDegree.(nextChord[0], cipher, chords);

	~runLogger.("~checkChordPosition");

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

	~runLogger.("~checkNoteDuplicate");

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
	var index = [0, 0], result = false;
	var octaves = [12, 24, 36];
	var i = 0, j;

	~runLogger.("~checkParallelOctaves");

	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			if (octaves.includes((currChord[i] - currChord[j]).abs)) { index = [i, j] };
			j = j + 1;
		};
		i = i + 1;
	};

	if (index == [0, 0]) {
		result = false;
	}{
		result = (
			((currChord[index[1]] - currChord[index[0]]).abs ==
			(nextChord[index[1]] - nextChord[index[0]]).abs) &&
			(currChord[index[1]] != nextChord[index[1]])
		);
	};
	result.not;
};

/*************************************************************************************/
// Check for parallel fifths

~checkParallelFifths = #{ |nextChord, currChord, numVoices|
	var index = Array.new(6), result = false;
	var fifths = [7, 19, 31, 43];
	var i = 0, j;

	~runLogger.("~checkParallelFifths");

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
			((currChord[i[1]] - currChord[i[0]]).abs ==
			(nextChord[i[1]] - nextChord[i[0]]).abs) &&
			(currChord[i[1]] != nextChord[i[1]])
		);
	};
	result.not;
};

/*************************************************************************************/
// Check range between voices

~checkVoiceSpacing = #{ |nextChord, i, rules|
	var cross, n;

	~runLogger.("~checkVoiceSpacing");

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

~chordIsValid = #{ |data, rules|
	var nextCipher = data[\state][\nextCipher];
	var currChord = data[\state][\currChord];
	var nextChord = data[\state][\nextChord];
	var numVoices = data[\voice][\number];
	var chords = data[\chords];
	var result = true;

	~runLogger.("~chordIsValid");

	if (rules[\enforceChordPosition]) {
		result = result && ~checkChordPosition.(nextChord, nextCipher, chords, rules);
	};
	if (rules[\enforceNoteDuplicate]) {
		result = result && ~checkNoteDuplicate.(nextChord, nextCipher, chords, rules);
	};
	if (rules[\enforceParallelOctaves]) {
		result = result && ~checkParallelOctaves.(nextChord, currChord, numVoices);
	};
	if (rules[\enforceParallelFifths]) {
		result = result && ~checkParallelFifths.(nextChord, currChord, numVoices);
	};
	for (1, 3) { |i|
		result = result && ~checkVoiceSpacing.(nextChord, i, rules);
	};
	result;
};

/*************************************************************************************/

~toggleRules = { |toggle, rules|

	~runLogger.("~toggleRules");

	toggle.do { |r|
		rules[r[0]] = r[1];
	};
};
)