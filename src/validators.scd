/**************************************************************************************
- HARMONY 01 / Validators
**************************************************************************************/
(
~testProgression = #{ |progression|

	if (progression.isKindOf(Array).not) {
		Error("Progression must be of type Array.\n").throw;
	};
	if (progression.any({ |c| c.isKindOf(Symbol).not })) {
		Error("Chord ciphers must be of type Symbol.\n").throw;
	};
	if (progression.any({ |c| ~triads.keys.includes(c).not })) {
		Error("Progression contains invalid ciphers. See ~triads.keys for reference.\n").throw;
	};
	nil;
};

/*************************************************************************************/

~testDurations = #{ |durations|

	if (durations.isKindOf(Array).not) {
		Error("Durations must be of type Array.\n").throw;
	};
	if (durations.any({ |c| c.isKindOf(Number).not })) {
		Error("Duration values must be of type Number.\n").throw;
	};
	if (durations.any({ |c| c <= 0 })) {
		Error("Duration values must be greater than 0.\n").throw;
	};
	nil;
};

/*************************************************************************************/

~testDirection = #{ |direction|
	var validDirections = Set["up", "down", "line"]; // Change to symbols

	if (direction.isKindOf(String).not) { // Kind of Symbols
		Error("Direction must be of type String.\n").throw; // of type Symbol
	};
	if (validDirections.includes(direction).not) {
		Error("% is not a valid direction. Try \"up\", \"down\" or \"line\".\n".format(direction)).throw; // change "" to ''
	};
	nil;
};

/*************************************************************************************/

~testOutputFormat = #{ |out, sus|
	var validOutput = Set['chord', 'voice'];

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

~testArguments = #{ |progression, durations, direction, sustain, score, logger| //prog, dur, dir, out, sus, scr, log

	/*if (durations.notNil) {
		if (progression.isEmpty || durations.isEmpty) {
			Error("Progression and durations arrays must not be empty.\n").throw;
		};
		if (progression.size != durations.size) {
			Error("Progression and durations arrays must be of same length.\n").throw;
		};

		~testDurations.(durations);
	} {
		if (progression.isEmpty) {
			Error("Progression and durations arrays must not be empty.\n").throw;
		};
	}*/

	// Remove the conditions below
	// Test progression and durations for length and empty arrays
	if (progression.isEmpty || durations.isEmpty) {
		Error("Progression and durations arrays must not be empty.\n").throw;
	};
	if (progression.size != durations.size) {
		Error("Progression and durations arrays must be of same length.\n").throw;
	};

	// Further tests on progresison, durations and direction
	~testProgression.(progression);
	~testDurations.(durations); // Remove function call
	~testDirection.(direction);
	//~testOutputFormat.(out);

	// Test sustain, score and logger
	if (sustain.isKindOf(Boolean).not || score.isKindOf(Boolean).not || logger.isKindOf(Boolean).not) {
		Error("Parameters sustain, score and logger must be of type Boolean.\n").throw;
	};
	nil;
};
)