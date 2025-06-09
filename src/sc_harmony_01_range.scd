/**************************************************************************************
- HARMONY 01 / Range Functions
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/
// Get all chord notes, within MIDI range, and respective degrees as two separate arrays

~getChordDegreeArrays = #{ |triads, chordProg|
	var ciphers, dictChords, dict;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordDegreeArrays: Function Call".format(~loggerCount).postln; };

	ciphers = (chordProg.collect { |c| c[0] }).asSet;
	dictChords = Dictionary.new();

	ciphers.do { |c|
		dict = Dictionary.new();
		dict[\notes] = triads[c][\notes].as(OrderedIdentitySet);
		dict[\degree] = (triads[c][\degree].wrapExtend(triads[c][\notes].size));

		dictChords[c] = dict;
	};
	dictChords;
};

/*************************************************************************************/
// Get chord notes, within MIDI range, and respective degrees, as paired arrays

~getChordDegreePairs = { |triads, chordProg|
	var chords, dict;

	chords = (chordProg.collect { |c| c[0] }).asSet;    // Separate ciphers from durations
	dict = Dictionary.new();

	chords.do { |c|
		var notes;

		notes = triads[c][\notes] +++ triads[c][\degree].bubble(1);
		dict[c] = notes;
	};
	dict;
};

/*************************************************************************************/
// Get all chord notes for each vocal range

~getChordVocalRange = #{ |voiceData, chordNotes|
	var voiceRange, dict, notes;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordVocalRange: Function Call".format(~loggerCount).postln; };

	dict = Dictionary.new();

	voiceData[\voiceNames].do { |v|
		voiceRange = voiceData[\voiceRange][v];
		dict[v] = (chordNotes & (voiceRange[0]..voiceRange[1]));
	};
	dict;
};

/*************************************************************************************/
// Ensure only valid melodic intervals are played between chords

~resolveMelodicIntervals = #{ |voiceData, validNotes, currChord|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~resolveMelodicIntervals: Function Call".format(~loggerCount).postln; };

	voiceData[\voiceNames].do { |v, i|
		validNotes[v] = validNotes[v].reject { |n|
			voiceData[\invalidIntervals][v].includes((n - currChord[i]).abs);
		};
	};
	nil;
};

/*************************************************************************************/
// Remove valid notes other than common tones from respective voices

~resolveCommonTones = #{ |voiceData, validNotes, currChord|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~resolveCommonTones: Function Call".format(~loggerCount).postln; };

	voiceData[\voiceNames].do { |v, i|
		var set = [currChord[i]];

		if ((set.isSubsetOf(validNotes[v])) && (i > 0)) {
			validNotes[v] = (validNotes[v] & set);
		};
	};
	nil;
};

/*************************************************************************************/
// Get valid notes

~getValidNotes = #{ |chords, chordState, voiceData, rules|
	var nextCipher = chordState[\nextCipher];
	var currChord = chordState[\currChord];
	var validNotes = Dictionary.new();

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getValidNotes: Function Call".format(~loggerCount).postln; };

	validNotes = ~getChordVocalRange.(voiceData, chords[nextCipher][\notes]);

	if (rules[\enforceMelodicIntervals] == true) {
		~resolveMelodicIntervals.(voiceData, validNotes, currChord);
	};
	if (rules[\enforceCommonTones] == true) {
		~resolveCommonTones.(voiceData, validNotes, currChord);
	};
	chordState[\validNotes] = validNotes;
	nil;
};
)
