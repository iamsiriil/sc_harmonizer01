/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/

~backtrackChords = #{ |data, rules, i|
	var voice = data[\voice][\names][i];

	~runLogger.("~backtrackChords");

	if (i == data[\voice][\number]) {
		if (~chordIsValid.(data, rules)) {
			data[\state][\validNextChords].add(data[\state][\nextChord].copy);
		}
	} {
		if ((i > 0) && (data[\state][\validNotes][v].size == 1)) {
			data[\state][\nextChord].put(i, data[\state][\validNotes][v].asArray.at(0));
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

~getFirstChords = #{ |data, progState, rules, i|

	~runLogger.(~getFirstChords);

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

~backtrackProg = #{ |data, progState, rules, i|
	var result;

	~runLogger.("~backtrackProg");

	block { |return|

		if ((i == progState[\progression].size)) {
			result = if (~progIsValid.(progState)) { true } { false };
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
