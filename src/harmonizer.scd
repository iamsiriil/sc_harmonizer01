/**************************************************************************************
- HARMONY 01 / Harmonizer

-> TEST ARGUMENTS

PROGRESSION:
- array of symbols
- symbols must be member of set ~triads.keys

DURATIONS:
- array of numbers (int, float)
- numbers must be greater that 0
- both progression and durations must be of same length

DIRECTION:
- string
- value must be member of set { "up", "down", "line" }

SUSTAIN, SCORE and LOGGER:
- boolean

**************************************************************************************/
(
~testDataType = { |parameter, data, class|

	if ((data.isKindOf(class)).not) {
		Error("% is not an instance of %.\n".format(parameter, class)).throw;
	};
	nil;
};

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

~testDirection = #{ |direction|
	var validDirections = Set["up", "down", "line"];

	~testDataType.("Direction", direction, String);

	if (Set[direction].isSubsetOf(validDirections).not) {
		Error("% is not a valid direction. Try \"up\", \"down\" or \"line\".\n".format(direction)).throw;
	};
	nil;
};

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

/*************************************************************************************/

~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, score = false, logger = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});
	var parsedChords = Dictionary.new();

	~testArguments.(progression, durations, direction, sustain, score, logger);

	// if (logger) {~logger = logger; ~loggerCount = 0};

	~logger = logger;
	~loggerCount = 0;
	~runLogger.("~harmonizeProg");

	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;

	// Program should only run if all arguments are valid
	// initData.(...);

	if (progression.size == durations.size) {
		progState[\direction] = direction;
		progState[\durations] = durations;
		progState[\progression] = progression;
	} {
		"Progression and Durations arrays are NOT of same size.".throw;
	};

	progState[\validChords] = Dictionary.new();
	progState[\result] = Array.fill(progression.size, {[]});

	data[\state][\nextChord] = Array.fill(4, {0});
	data[\chords] = ~getChordDegreeArrays.(triads, progression);

	~progParser.(progression, parsedChords);
	~setRules.(progState, parsedChords);

	if (~backtrackProg.(data, progState, rules, 0)) {
		progState[\dump] = progState[\result];
		progState[\result] = progState[\result].flop;
	} {
		"HarmonizeProg was NOT able to harmonize the progression".throw;
	};

	if (score) {
		~dumpData.(midiRange, triads, progState, rules, ruleKeys);
	};

	if (sustain) {
		~sustainCommonTones.(progState);
	} {
		progState[\result].do { |v|
			return[0].add(v);
			return[1].add(progState[\durations]);
		};
		return.postln;
	};
};
)
