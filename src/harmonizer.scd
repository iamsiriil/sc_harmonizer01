/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(
~initData = #{ |prog, dur, dir, out, sus, data, progState|
	var parsedChords, progSize = prog.size;

	~runLogger.("~initData");

	if (dur.isNil && (out == 'voice')) {
		progState[\durations] = Array.fill(prog.size, {1});
	} {
		progState[\durations] = dur;
	};

	if ((sus == true) && (prog.size == 1)) {
		"WARNING: Sustain is not applicable to progressions of size 1 and will be set to FALSE.\n".postln;
		progState[\sustain] = false;
	} {
		progState[\sustain] = sus;
	};

	// Copy progression, direction and output format to progState
	progState[\progression]  = prog;
	progState[\direction]    = dir;
	progState[\output]       = out;

	// Initialize data structures for \validChords, \result and \nextChord
	progState[\validChords]  = Dictionary.new();
	progState[\result]       = Array.fill(progSize, {[]});
	data[\state][\nextChord] = Array.fill(4, {0});

	// Collect necessary chord data from static library
	data[\chords] = ~getChordDegreeArrays.(~triads, prog);

	// Parse progression and collect data into progState
	parsedChords = Dictionary.new();
	~progParser.(prog, parsedChords);
	~setRules.(progState, parsedChords);
	nil;
};

/*************************************************************************************/

~handleResult = #{ |progState|

	~runLogger.("~handleResult");

	case
	{ progState[\output] == 'chord' } {
		progState[\dump] = progState[\result];
		progState[\return] = progState[\result];
	}
	{ progState[\output] == 'voice' } {
		progState[\dump]   = progState[\result];
		progState[\return] = Array.fill(2, {Array.new(4)});

		progState[\result] = progState[\result].flop;

		progState[\result].do { |v|
			progState[\return][0].add(v);
			progState[\return][1].add(progState[\durations]);
		};
	};

	// Handle sustain
	if (progState[\sustain] && (progState[\progression].size > 1)) {
		progState[\return] = ~sustainCommonTones.(progState);
	};
	nil;
};

/*************************************************************************************/
/*
Handles backtrack by calling ~getChords directly, if progression size == 1,
otherwise calls ~backtrackProg.
*/
~handleBacktrack = { |data, progState, rules|

	~runLogger.("~handleBacktrack");

	if (progState[\progression].size == 1) {

		data[\state][\nextCipher] = progState[\progression][0];
		progState[\result] = [~getChords.(data, progState, rules, 0).choose];

	} {
		if (~backtrackProg.(data, progState, rules, 0) == false) {
			Error("HarmonizeProg was not able to harmonize %.\n".format(progState[\progression])).throw;
		};
	};

	~handleResult.(progState);
	nil;
};

/*************************************************************************************/

~harmonizeProg = #{
	arg prog,      // Progression
	dur = nil,     // Duration (not mandatory)
	dir = "line",  // Direction (options: "up", "down" and "line")
	out = 'voice', // Output format (arrays per voice or per chord)
	uni = false,   // Enforce unison prohibition
	sus = true,    // Sustain common tones
	scr = false,   // Export score
	log = true;    // Logger

	var progState = ~progState;
	var rules     = ~rules;
	var data      = ~data;

	~logger = log.if({ ~loggerCount = 0; true }, { false });  // Set logger
	~runLogger.("~harmonizeProg");

	~testArguments.(prog, dur, dir, out, uni, sus, scr, log); // Test arguments
	~initData.(prog, dur, dir, out, sus, data, progState);    // Initialize data

	if (uni == true) {
		rules[\enforceUnisonProhibition] = true;
	};

	~handleBacktrack.(data, progState, rules);

	if (scr) { ~dumpData.(~midiRange, ~triads, progState, rules, ~ruleKeys) };

	progState[\return];
};
)
