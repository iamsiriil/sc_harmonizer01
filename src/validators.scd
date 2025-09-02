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
~testDataType = #{ |parameter, data, class|

	if ((data.isKindOf(class)).not) {
		Error("% is not an instance of %.\n".format(parameter, class)).throw;
	};
	nil;
};

/*************************************************************************************/

~testProgression = #{ |progression|

	~testDataType.("Progression", progression, Array);

	if (progression.any({ |c| c.isKindOf(Symbol).not })) {
		Error("Chord ciphers must be Symbols.\n").throw;
	};

	if (progression.any({ |c| ~triads.includes(c) })) {
		Error("Progression contains invalid ciphers.\n").throw;
	};

	/*progression.do { |c|

		~testDataType.("%".format(c), c, Symbol);

		if (Set[c].isSubsetOf(~triads.keys).not) {
			Error("% is not a valid cipher.\n".format(c)).throw;
		}
	};*/
	nil;
};

/*************************************************************************************/

~testDurations = #{ |durations|

	~testDataType.("Durations", durations, Array);

	if (durations.any({ |c| c.isKindOf(Number).not })) {
		Error("Duration values must be of type Integer or Float.\n").throw;
	};

	if (durations.any({ |c| c <= 0 })) {
		Error("The values provided must be greater than 0.\n").throw;
	};

	/*durations.do { |n|

		~testDataType.("Duration", n, Number);

		if (n <= 0) {
			Error("The values provided must be greater than 0.\n").throw;
		};
	};*/
	nil;
};

/*************************************************************************************/

~testDirection = #{ |direction|
	var validDirections = Set["up", "down", "line"];

	~testDataType.("Direction", direction, String);

	if (Set[direction].isSubsetOf(validDirections).not) {
		Error("% is not a valid direction. Try \"up\", \"down\" or \"line\".\n".format(direction)).throw;
	};
	nil;
};

/*************************************************************************************/

~testArguments = #{ |progression, durations, direction, sustain, score, logger|

	if (progression.isEmpty || durations.isEmpty) {
		Error("progression and durations Arrays must not be empty.\n").throw;
	};

	if (progression.size != durations.size) {
		Error("progression and durations arrays must be of same length.\n").throw;
	};
	~testProgression.(progression);
	~testDurations.(durations);
	~testDirection.(direction);

	// test sustain, score and logger
	if (sustain.isKindOf(Boolean).not || score.isKindOf(Boolean).not || logger.isKindOf(Boolean).not) {
		Error("sustain, score and logger must be of type Boolean.\n").throw;
	};

	/*~testDataType.("Sustain", sustain, Boolean);
	~testDataType.("Score", score, Boolean);
	~testDataType.("Logger", logger, Boolean);*/
	nil;
};
)