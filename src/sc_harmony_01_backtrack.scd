/**************************************************************************************
- HARMONY 01 / Backtracking
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/

~getNextChords = { |voiceData, chordData, chordState, rules, i|
	var voice = voiceData[\voiceNames][i];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~getNextChords: Function Call".format(~loggerCount).postln; };

	if (i == voiceData[\numVoices]) {
		if (~chordIsValid.(chordData[\chords], chordState, voiceData[\numVoices], rules)) {
			chordState[\validNextChords].add(chordState[\nextChord].copy);
		}
	} {
		if ((i > 0) && (chordState[\validNotes][v].size == 1)) {
			chordState[\nextChord].put(i, chordState[\validNotes][v].asArray.at(0));
			~getNextChords.(voiceData, chordData, chordState, rules, (i + 1));
		};

		chordState[\validNotes][voice].do { |note|

			chordState[\nextChord].put(i, note);

			if (~checkVoiceSpacing.(chordState[\nextChord], i, rules)) {
				~getNextChords.(voiceData, chordData, chordState, rules, (i + 1));
			} {
				chordState[\nextChord].put(i, 0);
			};
		};
	};
	chordState[\validNextChords];
};


/*************************************************************************************/

~getFirstChords = { |voiceData, chordData, chordState, rules, i|

	rules[\enforceMelodicIntervals] = false;
	rules[\enforceCommonTones] = false;
	rules[\enforceParallelOctaves] = false;
	rules[\enforceParallelFifths] = false;

	~getValidNotes.(chordData[\chords], chordState, voiceData, rules);

	~getNextChords.(voiceData, chordData, chordState, rules, i);

	~resetRules.(rules);

	chordState[\validNextChords];
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