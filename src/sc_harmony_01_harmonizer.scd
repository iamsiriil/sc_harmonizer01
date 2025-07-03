/**************************************************************************************
- HARMONY 01 / Harmonizer
**************************************************************************************/
(
~harmonizeProg = #{ |progression, durations, direction = "line", sustain = true, logger = false, dump = false|
	var midiRange, triads, data, progState, rules, ruleKeys;
	var return = Array.fill(2, {Array.new(4)});
	var parsedChords = Dictionary.new();

	~logger = logger;
	~loggerCount = 0;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~harmonizeProg: Function Call".format(~loggerCount).postln; };

	#midiRange, triads, data, progState, rules, ruleKeys = ~dictionaries;

	if (progression.size != durations.size) {
		"Progression and Durations arrays are NOT of same size.".throw;
	} {
		progState[\direction] = direction;
		progState[\durations] = durations;
		progState[\progression] = progression;
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

	if (dump) {
		~dumpData.(midiRange, triads, progState, rules, ruleKeys);
	};

	if (sustain) {
		~sustainCommonTones.(progState);
	} {
		progState[\result].do { |v|
			return[0].add(v);
			return[1].add(progState[\durations]);
		};
		return;
	};
};
)