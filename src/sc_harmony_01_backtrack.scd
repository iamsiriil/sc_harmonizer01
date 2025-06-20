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
)
