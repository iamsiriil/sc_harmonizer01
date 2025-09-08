/**************************************************************************************
- HARMONY 01 / Validators

-> TEST ARGUMENTS

PROGRESSION:
- Array of symbols
- Array cannot be empty
- Symbols must be member of set ~triads.keys

DURATIONS:
- Array of numbers (int, float)
- Array cannot be empy
- Numbers must be greater than 0
- Both progression and durations must be of same length

DIRECTION:
- String
- Value must be member of set { "up", "down", "line" }

SUSTAIN, SCORE and LOGGER:
- Boolean

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
	var validDirections = Set["up", "down", "line"];

	if (direction.isKindOf(String).not) {
		Error("Direction must be of type String.\n").throw;
	};
	if (validDirections.includes(direction).not) {
		Error("% is not a valid direction. Try \"up\", \"down\" or \"line\".\n".format(direction)).throw;
	};
	nil;
};

/*************************************************************************************/

~testArguments = #{ |progression, durations, direction, sustain, score, logger|

	// Test progression and durations for length and empty arrays
	if (progression.isEmpty || durations.isEmpty) {
		Error("Progression and durations arrays must not be empty.\n").throw;
	};
	if (progression.size != durations.size) {
		Error("Progression and durations arrays must be of same length.\n").throw;
	};

	// Further tests on progresison, durations and direction
	~testProgression.(progression);
	~testDurations.(durations);
	~testDirection.(direction);

	// Test sustain, score and logger
	if (sustain.isKindOf(Boolean).not || score.isKindOf(Boolean).not || logger.isKindOf(Boolean).not) {
		Error("Parameters sustain, score and logger must be of type Boolean.\n").throw;
	};
	nil;
};
)