/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(

~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, score = false, logger = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});
	var parsedChords = Dictionary.new();

	~logger = logger;
	~loggerCount = 0;
	~runLogger.("~harmonizeProg");

	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;

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
