/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
/*
~backtrackChords takes, for each voice, a set of valid candidate notes
and returns the collection of all valid chords.
*/

// Turn ~backtrackChords into a Routine that returns one chord at a time, instead of generating
// all possible chords. Once it reaches the end it returns Nil. (?)

~backtrackChords = #{ |data, rules, i|
	var voice = data[\voice][\names][i];

	~runLogger.("~backtrackChords");

	if (i == data[\voice][\number]) {
		if (~chordIsValid.(data, rules)) {
			data[\state][\validNextChords].add(data[\state][\nextChord].copy);
		}
	} {
		// A single candidate note means a common tone is repeated.
		// In this case, we assign the note and skip directly to the next voice.

		if ((i > 0) && (data[\state][\validNotes][voice].size == 1)) {
			data[\state][\nextChord].put(i, data[\state][\validNotes][voice].asArray.at(0)); // use currChord[i]
			~backtrackChords.(data, rules, (i + 1));
		};

		data[\state][\validNotes][voice].do { |note|

			data[\state][\nextChord].put(i, note);

			if (~checkVoiceSpacing.(data[\state][\nextChord], i, rules)) {
				~backtrackChords.(data, rules, (i + 1));
			} {
				data[\state][\nextChord].put(i, 0);
			};
		};
	};
	data[\state][\validNextChords];
};

/*************************************************************************************/

~getChords = #{ |data, progState, rules, i|

	~runLogger.("~getChords");

	if (i > 0) {
		data[\state][\currChord] = progState[\result][i - 1];
	};

	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	if (progState[\ruleEnforcement][i].notEmpty) {
		~toggleRules.(progState[\ruleEnforcement][i], rules);
	};

	~getValidNotes.(data, rules);

	// Toggle rules to create a bias twards keeping note duplication, chord position and common tones
	// possibly create a loop that keeps calling ~getChords until all possibilities are exausted

	// NOTE DUPLICATION
	// 1. duplicate root
	// 2. duplicate third
	// 3. duplicate fifth

	// CHORD POSITION
	// If chord positions are not specified in the chord symbols (CM/E)
	// 1. Try root position
	// 2. Try first inversion
	// 3. Only in special occasions try second or third inversions

	// COMMON TONES
	// To be kept if possible, if not, try other notes

/*

while {data[\state][\validNextChords].isEmpty/.notNil (?) && ~toggleRules.(rules, ...).notNil } { // ---> ~toggleRules as Routine (?)
    ~backtrackChords.(data, rules, 0);
};

*/
	~backtrackChords.(data, rules, 0);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/
/*
~backtrackProg walks the progression provided to ~harmonizeProg and, via the
wrapper ~getChord, invokes ~backtrackChords to produce, for each chord
cipher in the progression, a list of valid candidate chords. Returns true if
the completed progression satisfies all rules.
*/

~backtrackProg = #{ |data, progState, rules, i|
	var result;

	~runLogger.("~backtrackProg");

	block { |return|

		if ((i == progState[\progression].size)) {
			result = ~progIsValid.(progState);
			return.value(result);
		};

		data[\state][\nextCipher] = progState[\progression][i];

		if (progState[\validChords][i].isNil) {

			progState[\validChords][i] = ~getChords.(data, progState, rules, i);

			if (progState[\validChords][i].isEmpty) {
				progState[\validChords][i] = nil;
				result = false;
				return.value(result);
			}
		};

		progState[\validChords][i].do { |c|

			progState[\result][i] = c;

			if (~checkChord.(progState, i) == true) {
				result = ~backtrackProg.(data, progState, rules, i + 1);
				if (result) {
					return.value(result);
				};
			} {
				progState[\result][i] = [];
			};
		};
		progState[\validChords][i] = nil;
		result = false;
		return.value(result);
	};
	result;
};
)
