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

	progression.do { |c|

		~testDataType.("%".format(c), c, Symbol);

		if (Set[c].isSubsetOf(~triads.keys).not) {
			Error("% is not a valid cipher.\n".format(c)).throw;
		}
	};
	nil;
};

/*************************************************************************************/

~testDurations = #{ |durations|

	~testDataType.("Durations", durations, Array);

	durations.do { |n|

		~testDataType.("Duration", n, Number);

		if (n <= 0) {
			Error("The values provided must be greater than 0.\n").throw;
		};
	};
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

	~testProgression.(progression);
	~testDurations.(durations);
	~testDirection.(direction);

	// test sustain, score and logger
	~testDataType.("Sustain", sustain, Boolean);
	~testDataType.("Score", score, Boolean);
	~testDataType.("Logger", logger, Boolean);

	if (progression.size != durations.size) {
		Error("Progression and durations arrays must be of same length.\n").throw;
	}
};
)