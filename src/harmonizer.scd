/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(
~initData = #{ |progression, durations, direction, data, progState|
	var parsedChords, progSize = progression.size;

	~runLogger.("~initData");

	/* if (durations.isNil && (out == 'voices')) {
           progState[\durations] = Array.fill(progression.size, {1});
       } {
           progState[\durations] = durations;
       }*/

	// Copy progression, durations and direction to progState
	progState[\progression]  = progression;
	progState[\durations]    = durations; // Remove attribution
	progState[\direction]    = direction;
	//progState[\output]     = out; -> voices/chords

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

	~runLogger.("~handleResult");

	// Since output format depend on arg out, one chord progressions can be returned as voices or chord

	/*case
	{ out == 'chord' } {
		progState[\dump] = progState[\result];
		progState[\return] = progState[\result];
	}
	{ out == 'voice' } {
		progState[\dump]   = progState[\result];
		progState[\return] = Array.fill(2, {Array.new(4)});

		progState[\result] = progState[\result].flop;

		progState[\result].do { |v|
			progState[\return][0].add(v);
			progState[\return][1].add(progState[\durations]);
		};
	}*/

	if (progState[\progression].size == 1) {

		progState[\dump]   = progState[\result];
		progState[\return] = Array.fill(2);

		progState[\return] = progState[\result];
		//progState[\return][0] = progState[\result];
		//progState[\return][1] = progState[\durations];
	} {
		// per-voice return format
		progState[\dump]   = progState[\result];
		progState[\return] = Array.fill(2, {Array.new(4)});

		progState[\result] = progState[\result].flop;

		progState[\result].do { |v|
			progState[\return][0].add(v);
			progState[\return][1].add(progState[\durations]);
		};
	};
	//progState[\return];
	nil;
};

/*************************************************************************************/

~handleSustain = #{ |progState|

	~runLogger.("~handleSustain");

	progState[\return] = ~sustainCommonTones.(progState);
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
		progState[\result] = [~getChords.(data, progState, rules, 0).choose].postln;

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
	arg prog,
	dur = nil,
	dir = "line",  // Symbol intead of string
	out = 'voice', // Options voices/chords
	sus = true,
	scr = false,
	log = false;

	var progState = ~progState;
	var rules     = ~rules;
	var data      = ~data;

	~testArguments.(prog, dur, dir, sus, scr, log);           // Test input arguments

	~logger = log.if({ ~loggerCount = 0; true }, { false });  // Set logger
	~runLogger.("~harmonizeProg");

	~initData.(prog, dur, dir, data, progState);              // Initialize data
	~handleBacktrack.(data, progState, rules);

	if (scr) { ~dumpData.(~midiRange, ~triads, progState, rules, ~ruleKeys) };

	if (sus && (prog.size > 1)) { ~handleSustain.(progState) };

	progState[\return];
};
)
