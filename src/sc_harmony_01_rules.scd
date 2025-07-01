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
	var index = [0, 0], result = false;
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

~setRules = { |progState, chordDict, test = false|
	var dict = Dictionary.new();

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~setRules: Function Call".format(~loggerCount).postln; };

	progState[\progression].size.do { |i|
		var arr = Array.new(10);

		if (i == 0) {
			arr.add([\enforceMelodicIntervals, false]);
			arr.add([\enforceCommonTones, false]);
			arr.add([\enforceParallelOctaves, false]);
			arr.add([\enforceParallelFifths, false]);
		};

		if ((chordDict[i][\distance] == 6) && (test == false)) {
			arr.add([\enforceMelodicIntervals, false]);
			arr.add([\enforceParallelOctaves, false]);
			arr.add([\enforceParallelFifths, false]);
		};
		dict[i] = arr;
	};
	progState[\ruleEnforcement] = dict;
};

/*************************************************************************************/

~toggleRules = { |toggle, rules|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~toggleRules: Function Call".format(~loggerCount).postln; };

	toggle.do { |r|
		rules[r[0]] = r[1];
	};
};

/**************************************************************************************
Progression Rules
**************************************************************************************/

~checkChord = { |progState, i|
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~checkChord: Function Call".format(~loggerCount).postln; };

	progState[\result][i].postln;
	if (i == 0) {
		result = result && (progState[\result][i][0] != progState[\result][i][1]);
	};
	if ((i > 1) && (progState[\direction] == "up")) {
		result = result && (progState[\result][i][3] >= progState[\result][i - 1][3]);
	};
	if ((i > 1) && (progState[\direction] == "down")) {
		result = result && (progState[\result][i][3] <= progState[\result][i - 1][3]);
	};
	if ((i > 1) && (progState[\direction] == "line")) {
		var min = progState[\result][0][3] - 4;
		var max = progState[\result][0][3] + 4;
		result = result && ((progState[\result][i][3] >= min) && (progState[\result][i][3] <= max));
	};
	result.postln;
};

/*************************************************************************************/

~checkDirection = { |progState|
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkDirection: Function Call".format(~loggerCount).postln; };

	case
	{ progState[\direction] == "up" } {
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] >= progState[\result][i - 1][3]);
			}
		};
	}
	{ progState[\direction] == "down" } {
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] <= progState[\result][i - 1][3]);
			}
		};
	};
	result;
};

~progIsValid = { |progState|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~progIsValid: Function Call".format(~loggerCount).postln; };

	~checkDirection.(progState).postln;
};
)
