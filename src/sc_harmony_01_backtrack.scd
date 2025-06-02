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

~getNextChords02 = {
	arg numVoices, nextChord, validNextChords, validNotes, i;
	var isValid;
	var voice = ~voiceData[\voiceNames][i];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords02: Function Call".format(~loggerCount).postln; };
	"i: % | nextChord: %".format(i, nextChord).postln;

	if (i == numVoices) {
		if (~chordIsValid.(nextChord)) {
			nextChord.postln;
			validNextChords.add(nextChord.copy);
		}
	} {
		if ((i > 0) && (~chordState[\validNotes][v].size == 1)) {
			nextChord.put(i, ~chordState[\validNotes][v].asArray.at(0));
			~getNextChords02.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
		};

		~chordState[\validNotes][voice].do { |note|

			nextChord.put(i, note);

			isValid = ~checkVoiceSpacing.(nextChord, i);
			if (isValid) {
				~getNextChords02.(numVoices, nextChord, validNextChords, validNotes, (i + 1));
			} {
				nextChord.put(i, 0);
			};
		};
		nil;//validNextChords;
	};
};


/*************************************************************************************/

~harmonizeProg = { |firstChord, progression|
	var chordProg = ~chordData[\chordProg].copy;
	var remainingProg = chordProg.drop(1);
	var validChords = Array.fill(chordProg.size, {[]});

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
			found = ~getNextChords02.(4, buildChord, ~chordState[\nextValidChords], ~chordState[\validNotes], 0);
			(found == false) && (attempts < maxAttempts) && (~toggleCount < 8)
		} {
			~toggleRules.(~toggleCount);
		};

		if(found == false) {
			~chordState[\currChord] = validChords[i].next;
			//Error("No valid chord found for % after % attempts (toggleCount: %)".format(
				//c[0], attempts, ~toggleCount
			//)).throw;
		} {
			"Current chord: %".format(c[0]).postln;
			validChords[i] = ~chordState[\nextValidChords].iter;
			//~chordState[\nextValidChord] = ~chordState[\nextValidChord].iter;
			~chordState[\currChord] = validChords[i].next.postln;
			progression.add(~chordState[\currChord].copy);
		};

		//~chordState[\currChord] = ~chordState[\nextValidChords].choose;
	};

	progression;
};
)