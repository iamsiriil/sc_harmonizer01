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

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getFirstChords: Function Call".format(~loggerCount).postln; };

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

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getProgression: Function Call".format(~loggerCount).postln; };

	data[\state][\nextCipher] = progState[\progression][i].postln;

	block { |return|

		if (i == progState[\progression].size) { //&& ~progIsValid.(progState[\result])) {
			result = true;
			return.value(result);
		};

		if (i == 0) {

			/*if (progState[\ruleEnforcement][i].notEmpty) {
				progState[\ruleEnforcement][i].do { |r|
					rules[r[0]] = r[1];
				};
			};*/

			data[\state][\nextChord] = Array.fill(4, {0});
			data[\state][\validNextChords] = Array.new(20);

			~getFirstChords.(data, rules, 0);
			progState[\validChords][i] = data[\state][\validNextChords].postln;

			~resetRules.(rules);
		};

		if (((i > 0) && (i < progState[\progression].size)) && progState[\validChords][i].isNil) {

			if (progState[\ruleEnforcement][i].notEmpty) {
				progState[\ruleEnforcement][i].do { |r|
					rules[r[0]] = r[1];
				};
			};

			data[\state][\nextChord] = Array.fill(4, {0});
			data[\state][\validNextChords] = Array.new(20);
			data[\state][\currChord] = progState[\result][i - 1].postln;

			~getValidNotes.(data, rules);
			~getNextChords.(data, rules, 0);
			progState[\validChords][i] = data[\state][\validNextChords].postln;

			~resetRules.(rules);
		};

		progState[\validChords][i].do { |c|

			data[\state][\currChord] = c;
			progState[\result][i] = c;

			//if (~progIsValid.(progState[\result])) {
				result = ~getProgression.(data, progState, rules, i + 1);
				if (result) {
					return.value(result);
				}
			/*} {
				progState[\result][i] = [];
			};*/
		};
		result = false;
		return.value(result);
	};
	result;
};

/*************************************************************************************/

~harmonizeProg = { |triads, data, progState, rules|
	var chords = Dictionary.new();

	progState[\result] = Array.fill(progState[\progression].size, {[]});
	progState[\validChords] = Dictionary.new();
	data[\state][\nextChord] = Array.fill(4, {0});

	data[\chords] = ~getChordDegreeArrays.(triads, progState[\progression]);

	~progParser.(progState[\progression], chords);
	chords[1].postln;
	~ruleToggler.(progState, chords);

	progState[\ruleEnforcement][1].postln;
	~getProgression.(data, progState, rules, 0);

};
)
