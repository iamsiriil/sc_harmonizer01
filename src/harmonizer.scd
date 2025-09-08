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

~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, score = false, logger = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});

	// Test input arguments
	~testArguments.(progression, durations, direction, sustain, score, logger);

	// Set logger
	~logger = logger; ~loggerCount = 0;
	~runLogger.("~harmonizeProg");

	// Get necessary dictionaries for data storage
	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;

	// Initialize data
	~initData.(progression, durations, direction, data, progState);

	// This secction needs revision
	if (~backtrackProg.(data, progState, rules, 0)) {
		progState[\dump] = progState[\result];
		progState[\result] = progState[\result].flop;
	} {
		Error("HarmonizeProg was NOT able to harmonize %.\n").format(progression).throw;
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
