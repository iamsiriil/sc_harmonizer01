/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/

~getNextChords = { |data, rules, i|
	var voice = data[\voice][\names][i];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	if (i == data[\voice][\number]) {
		if (~chordIsValid.(data[\chords], data[\state], data[\voice][\number], rules)) {
			data[\state][\validNextChords].add(data[\state][\nextChord].copy);
		}
	} {
		if ((i > 0) && (data[\state][\validNotes][v].size == 1)) {
			data[\state][\nextChord].put(i, data[\state][\validNotes][v].asArray.at(0));
			~getNextChords.(data, rules, (i + 1));
		};

		data[\state][\validNotes][voice].do { |note|

			data[\state][\nextChord].put(i, note);

			if (~checkVoiceSpacing.(data[\state][\nextChord], i, rules)) {
				~getNextChords.(data, rules, (i + 1));
			} {
				data[\state][\nextChord].put(i, 0);
			};
		};
	};
	data[\state][\validNextChords];
};


/*************************************************************************************/

~getFirstChords = { |data, rules, i|

	rules[\enforceMelodicIntervals] = false;
	rules[\enforceCommonTones] = false;
	rules[\enforceParallelOctaves] = false;
	rules[\enforceParallelFifths] = false;

	~getValidNotes.(data, rules);

	~getNextChords.(data, rules, i);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/

~getProgression = { |data, progState, rules, i|
	var result;

	data[\state][\nextCipher] = progState[\progression][i];

	block { |return|

		if (i == progState[\progression].size && ~progIsValid.(progState[\result])) {
			result = true;
			return.value(result);
		};

		if (i == 0) {

			/*if (progState[\ruleEnforcement][i].notEmpty) {
				progState[\ruleEnforcement][i].do { |r|
					rules[r[0]] = r[1];
				};
			};*/

			~getFirstChords.(data, rules, 0);
			progState[\validChords][i] = data[\state][\validNextChords];

			~resetRules.(rules);
		};

		if ((i > 0 && i < progState[\progression].size) && progState[\validChords][i].isNil) {

			if (progState[\ruleEnforcement][i].notEmpty) {
				progState[\ruleEnforcement][i].do { |r|
					rules[r[0]] = r[1];
				};
			};

			~getValidNotes.(data, rules);
			~getNextChords.(data, rules, 0);
			progState[\validChords][i] = data[\state][\validNextChords];

			~resetRules.(rules);
		};

		progState[\validChords][i].do { |c|

			progState[\result][i] = c;
			if (~progIsValid.(progState[\result])) {
				result = ~getProgression.(data, progState, rules, i + 1);
				if (result) {
					return.value(result);
				}
			} {
				progState[\result][i] = [];
			};
		};
		result = false;
		return.value(result);
	};
	result;
};
)
