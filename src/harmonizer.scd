/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(
~initData = #{ |progression, durations, direction, data, progState|
	var parsedChords = Dictionary.new();
	var progSize = progression.size;

	progState[\progression] = progression;
	progState[\durations] = durations;
	progState[\direction] = direction;

	progState[\validChords] = Dictionary.new();
	progState[\result] = Array.fill(progSize, {[]});
	data[\state][\nextChord] = Array.fill(4, {0});
	data[\chords] = ~getChordDegreeArrays.(~triads, progression);

	~progParser.(progression, parsedChords);
	~setRules.(progState, parsedChords);
};

/*************************************************************************************/

~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, score = false, logger = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});

	//~testArguments.(progression, durations, direction, sustain, score, logger);

	~logger = logger; ~loggerCount = 0;
	~runLogger.("~harmonizeProg");


	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;


	~initData.(progression, durations, direction, data, progState);


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
