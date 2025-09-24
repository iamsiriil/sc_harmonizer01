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

	progState[\dump] = progState[\result];
	progState[\result] = progState[\result].flop;

	progState[\return] = Array.fill(2, {Array.new(4)});

	progState[\result].do { |v|
		progState[\return][0].add(v);
		progState[\return][1].add(progState[\durations]);
	};
	nil;
};

/*************************************************************************************/

~handleSustain = #{ |progState|
	progState[\return] = ~sustainCommonTones.(progState);
	nil;
};

/*************************************************************************************/

~harmonizeProg = #{
	arg prog, dur, dir = "line", sus = true, scr = false, log = false;
	var progState = ~progState;
	var rules     = ~rules;
	var data      = ~data;

	~testArguments.(prog, dur, dir, sus, scr, log);           // Test input arguments

	~logger = log.if({ ~loggerCount = 0; true }, { false });  // Set logger
	~runLogger.("~harmonizeProg");

	~initData.(prog, dur, dir, data, progState);              // Initialize data

	if (~backtrackProg.(data, progState, rules, 0)) {
		~handleResult.(progState);
	} {
		Error("HarmonizeProg was not able to harmonize %.\n".format(prog)).throw;
	};

	if (scr) { ~dumpData.(~midiRange, ~triads, progState, rules, ~ruleKeys) };

	if (sus) { ~handleSustain.(progState) };

	progState[\return];
};
)
