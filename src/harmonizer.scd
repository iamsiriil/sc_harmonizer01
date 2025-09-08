/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(
~initData = #{ |progression, durations, direction, data, progState|
	var parsedChords, progSize = progression.size;

	// Copy progression, durations and direction to progState
	progState[\progression]  = progression;
	progState[\durations]    = durations;
	progState[\direction]    = direction;

	// Initialize data structures for \validChords, \result and \nextChord
	progState[\validChords]  = Dictionary.new();
	progState[\result]       = Array.fill(progSize, {[]});
	data[\state][\nextChord] = Array.fill(4, {0});

	// Collect necessary chord data from static library
	data[\chords] = ~getChordDegreeArrays.(~triads, progression);

	// Parse progression and collect data into progState
	parsedChords = Dictionary.new();
	~progParser.(progression, parsedChords);
	~setRules.(progState, parsedChords);
	nil;
};

/*************************************************************************************/

~handleResult = #{ |progState|
	var temp = Array.fill(2, {Array.new(4)});

	progState[\dump] = progState[\result];
	progState[\result] = progState[\result].flop.postln;

	progState[\result].do { |v|
		temp[0].add(v);
		temp[1].add(progState[\durations]);
	};

	progState[\return] = Array.fill(2, {Array.new(4)});
	progState[\return] = temp;
	nil;
};

/*************************************************************************************/

~handleSustain = { |progState|
	progState[\return] = ~sustainCommonTones.(progState);
};

/*************************************************************************************/

~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, score = false, logger = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});

	~testArguments.(progression, durations, direction, sustain, score, logger); // Test input arguments

	~logger = logger; ~loggerCount = 0;                                         // Set logger
	~runLogger.("~harmonizeProg");

	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;       // Get necessary dictionaries for data storage

	~initData.(progression, durations, direction, data, progState);             // Initialize data


	// This secction needs revision
	if (~backtrackProg.(data, progState, rules, 0)) {
		~handleResult.(progState);
		//progState[\dump] = progState[\result];
		//progState[\result] = progState[\result].flop;
	} {
		Error("HarmonizeProg was not able to harmonize %.\n").format(progression).throw;
	};

	if (score) {
		~dumpData.(midiRange, triads, progState, rules, ruleKeys);
	};

	if (sustain) {
		~handleSustain.(progState);
		//~sustainCommonTones.(progState);
	}; /*{
		progState[\result].do { |v|
			return[0].add(v);
			return[1].add(progState[\durations]);
		};
		return.postln;
	};*/
	progState[\return];
};
)
