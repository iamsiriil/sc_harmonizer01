/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/

~backtrackChords = { |data, rules, i|
	var voice = data[\voice][\names][i];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~backtrackChords: Function Call".format(~loggerCount).postln; };

	if (i == data[\voice][\number]) {
		if (~chordIsValid.(data[\chords], data[\state], data[\voice][\number], rules)) {
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

~getFirstChords = { |data, progState, rules, i|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getFirstChords: Function Call".format(~loggerCount).postln; };

	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);

	if (progState[\ruleEnforcement][i].notEmpty) {
		~toggleRules.(progState[\ruleEnforcement][i], rules);
	};

	~getValidNotes.(data, rules);
	~backtrackChords.(data, rules, i);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/

~getNextChords = { |data, progState, rules, i|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	data[\state][\nextChord] = Array.fill(4, {0});
	data[\state][\validNextChords] = Array.new(20);
	data[\state][\currChord] = progState[\result][i - 1];

	if (progState[\ruleEnforcement][i].notEmpty) {
		~toggleRules.(progState[\ruleEnforcement][i], rules);
	};
	~getValidNotes.(data, rules);
	~backtrackChords.(data, rules, 0);

	~resetRules.(rules);

	data[\state][\validNextChords];
};

/*************************************************************************************/

~backtrackProg = { |data, progState, rules, i|
	var result;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getProgression: Function Call".format(~loggerCount).postln; };

	data[\state][\nextCipher] = progState[\progression][i];

	block { |return|

		if (i == progState[\progression].size) {
			result = true;
			return.value(result);
		};

		if (i == 0) {
			progState[\validChords][i] = ~getFirstChords.(data, progState, rules, i);
		};

		if (((i > 0) && (i < progState[\progression].size)) && progState[\validChords][i].isNil) {

			progState[\validChords][i] = ~getNextChords.(data, progState, rules, i);
		};

		progState[\validChords][i].do { |c|

			data[\state][\currChord] = c;
			progState[\result][i] = c;

			result = ~backtrackProg.(data, progState, rules, i + 1);
			if (result) {
				return.value(result);
			} {
				progState[\result][i] = [];
			}
		};
		result = false;
		return.value(result);
	};
	result;
};

/*************************************************************************************/

~harmonizeProg = { |progression, durations, logger = false|
	var parsedChords = Dictionary.new();
	var progState = ~progState;
	var triads = ~triads;
	var rules = ~rules;
	var data = ~data;

	~logger = logger;
	~loggerCount = 0;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~harmonizeProg: Function Call".format(~loggerCount).postln; };

	progState[\progression] = progression;
	progState[\durations] = durations;

	data[\chords] = ~getChordDegreeArrays.(triads, progState[\progression]);
	data[\state][\nextChord] = Array.fill(4, {0});

	progState[\result] = Array.fill(progState[\progression].size, {[]});
	progState[\validChords] = Dictionary.new();

	~progParser.(progState[\progression], parsedChords);
	~setRules.(progState, parsedChords);

	if (~backtrackProg.(data, progState, rules, 0)) {
		progState[\result].flop;
	} {
		"HarmonizeProg was NOT able to generate a progression".throw;
	}
};
)
