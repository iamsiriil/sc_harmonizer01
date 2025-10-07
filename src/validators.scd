/**************************************************************************************
- HARMONY 01 / Validators
**************************************************************************************/
(
~testProgression = #{ |prog|

	~runLogger.("~testProgression");

	if (prog.isKindOf(Array).not) {
		Error("Progression must be of type Array.\n").throw;
	};
	if (prog.any({ |c| c.isKindOf(Symbol).not })) {
		Error("Chord ciphers must be of type Symbol.\n").throw;
	};
	if (prog.any({ |c| ~triads.keys.includes(c).not })) {
		Error("Progression contains invalid ciphers. See ~triads.keys for reference.\n").throw;
	};
	nil;
};

/*************************************************************************************/

~testDurations = #{ |dur|

	~runLogger.("~testDurations");

	if (dur.isKindOf(Array).not) {
		Error("Durations must be of type Array.\n").throw;
	};
	if (dur.any({ |c| c.isKindOf(Number).not })) {
		Error("Duration values must be of type Number.\n").throw;
	};
	if (dur.any({ |c| c <= 0 })) {
		Error("Duration values must be greater than 0.\n").throw;
	};
	nil;
};

/*************************************************************************************/

~testDirection = #{ |dir|
	var validDirections = Set["up", "down", "line"]; // Change to symbols

	~runLogger.("~testDirection");

	if (dir.isKindOf(String).not) { // Kind of Symbols
		Error("Direction must be of type String.\n").throw; // of type Symbol
	};
	if (validDirections.includes(dir).not) {
		Error("% is not a valid direction. Try \"up\", \"down\" or \"line\".\n".format(dir)).throw; // change "" to ''
	};
	nil;
};

/*************************************************************************************/

~testOutputFormat = #{ |out, sus|
	var validOutput = Set['chord', 'voice'];

	~runLogger.("~testOutputFormat");

	if (out.isKindOf(Symbol).not) {
		Error("Out must be of type Symbol.\n").throw;
	};
	if (validOutput.includes(out).not) {
		Error("% is not a valid output format. Try \'chord\' or \'voice\'.\n").throw;
	};
	if ((sus == true) && (out == 'chord')) {
		Error("Sustain is not compatible with 'chord' output setting. Change to 'voice'.\n").throw;
	};
	nil;
};

/*************************************************************************************/
// Change variable names to shorter version. add out.
~testArguments = #{ |prog, dur, dir, out, sus, scr, log| //prog, dur, dir, out, sus, scr, log

	~runLogger.("~testArguments");

	if (dur.notNil) {
		if (prog.isEmpty || dur.isEmpty) {
			Error("Progression and durations arrays must not be empty.\n").throw;
		};
		if (prog.size != dur.size) {
			Error("Progression and durations arrays must be of same length.\n").throw;
		};

		~testDurations.(dur);
	} {
		if (prog.isEmpty) {
			Error("Progression and durations arrays must not be empty.\n").throw;
		};
	};

	// Further tests on progresison, durations and direction
	~testProgression.(prog);
	~testDirection.(dir);
	~testOutputFormat.(out, sus);

	// Test sustain, score and logger
	if (sus.isKindOf(Boolean).not || scr.isKindOf(Boolean).not || log.isKindOf(Boolean).not) {
		Error("Parameters sustain, score and logger must be of type Boolean.\n").throw;
	};
	nil;
};
)