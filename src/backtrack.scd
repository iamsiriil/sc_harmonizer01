/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
//~logger = true;

/*************************************************************************************/
/*
~backtrackChords takes, for each voice, a set of valid candidate notes
and returns the collection of all valid chords.

Parameters:
- data: structure holding state and voice/note data
- rules: validation rule set
- i: index of the voice being processed

Returns:
- Array of valid next chords in data[\state][\validNextChords]
*/

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
			data[\state][\nextChord].put(i, data[\state][\validNotes][voice].asArray.at(0));
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
/*
~getFirstChords is a wrapper around ~backtrackChords and prepares
the data needed for the backtracking process.

First chords have a special rule profile because they are not tested
against a previous chord.
*/

~getFirstChords = #{ |data, progState, rules, i|

	~runLogger.("~getFirstChords");

	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	if (progState[\ruleEnforcement][i].notEmpty) {
		~toggleRules.(progState[\ruleEnforcement][i], rules);
	};

	~getValidNotes.(data, rules);
	~backtrackChords.(data, rules, 0);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/
/*
~getNextChords is a wrapper around ~backtrackChords and prepares
the data needed for the backtracking process.

Identical to ~getFirstChords, except that \currChord is set to the
previous chord stored in progState[\result].

OBSERVATIONS:
-> ~getFirstChords and ~getNextChords could be merged by conditionally
   setting \currChord when i > 0.

-> \currChord might be redundant if you always read the last assigned
   chord from progState[\result].
*/

~getNextChords = #{ |data, progState, rules, i|

	~runLogger.("~getNextChords");

	data[\state][\currChord] = progState[\result][i - 1];
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	if (progState[\ruleEnforcement][i].notEmpty) {
		~toggleRules.(progState[\ruleEnforcement][i], rules);
	};

	~getValidNotes.(data, rules);
	~backtrackChords.(data, rules, 0);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/
/*
~backtrackProg walks the progression provided to ~harmonizeProg and, via the
wrappers (~getFirstChords / ~getNextChords), invokes ~backtrackChords to
produce, for each chord cipher in the progression, the list of valid candidate
chords. Returns true if the completed progression satisfies all rules.
*/

~backtrackProg = #{ |data, progState, rules, i|
	var result;

	~runLogger.("~backtrackProg");

	block { |return|

		if ((i == progState[\progression].size)) {
			//result = if (~progIsValid.(progState)) { true } { false };
			result = ~progIsValid.(progState);
			return.value(result);
		};

		data[\state][\nextCipher] = progState[\progression][i];

		if (progState[\validChords][i].isNil) {
			if (i == 0) {
				progState[\validChords][i] = ~getFirstChords.(data, progState, rules, i);
			} {
				progState[\validChords][i] = ~getNextChords.(data, progState, rules, i);
			};

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
