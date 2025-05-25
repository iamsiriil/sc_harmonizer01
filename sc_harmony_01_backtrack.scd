/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~getNextChords = { |buildChord, i|
	var v = ~voiceData[\voiceNames][i];
	var result = nil;

	// Logger
	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	block { |return|

		if (i == 4) {
			if (~chordIsValid.(buildChord)) {
				~chordState[\nextValidChords].add(buildChord.copy).postln;
				result = true;
				return.value(result);
			};
		};

		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
			buildChord[i] = ~chordState[\validNotes][v].asArray.at(0);
			result = ~getNextChords.(buildChord, (i + 1));
			return.value(result);
		};

		~chordState[\validNotes][v].do { |n|

			buildChord[i] = n;

			if (~checkVoiceSpacing.(buildChord, i)) {
				result = ~getNextChords.(buildChord, (i + 1));
				if (result == true) { return.value(result) };
			};

			buildChord[i] = 0;
		};

		result = false;
		return.value(result);
	};
	result;
};

/*************************************************************************************/

~harmonizeProg = { |firstChord, progression|
	var chordProg = ~chordData[\chordProg].copy;
	var remainingProg = chordProg.drop(1);

	progression.add(firstChord.copy);
	~chordState[\currChord] = firstChord;

	remainingProg.do { |c, i|
		var buildChord = Array.fill(4, {0});
		var maxAttempts = 5;
		var attempts = 0;
		var found = false;

		// CRITICAL RESETS
		~resetRules.();
		~chordState[\nextValidChords] = Array.new(50);
		~toggleCount = 0;

		~chordState[\nextCipher] = c[0];
		~getValidNotes.();

		while {
			attempts = attempts + 1;
			found = ~getNextChords.(buildChord, 0);
			(found == false) && (attempts < maxAttempts) && (~toggleCount < 8)
		} {
			~toggleRules.(~toggleCount);
		};

		if(found.not) {
			Error("No valid chord found for % after % attempts (toggleCount: %)".format(
				c[0], attempts, ~toggleCount
			)).throw;
		};

		~chordState[\currChord] = ~chordState[\nextValidChords].choose;
		progression.add(~chordState[\currChord].copy);
	};

	progression;
};
)