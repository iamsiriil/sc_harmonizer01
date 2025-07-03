/**************************************************************************************
- HARMONY 01 / Range Functions
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/
// Get all chord notes, within MIDI range, and respective degrees as two separate arrays

~getChordDegreeArrays = #{ |triads, chordProg|
	var ciphers, dictChords, dict;

	~runLogger.("~getChordDegreeArrays");

	ciphers = chordProg.asSet;
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
// Get all chord notes for each vocal range

~getChordVocalRange = #{ |voiceData, midiChord|
	var voiceRange, dict, notes;

	~runLogger.("~getChordVocalRange");

	dict = Dictionary.new();

	voiceData[\names].do { |v|
		voiceRange = voiceData[\range][v];
		dict[v] = (midiChord & (voiceRange[0]..voiceRange[1]));
	};
	dict;
};

/*************************************************************************************/
// Ensure only valid melodic intervals are played between chords

~resolveMelodicIntervals = #{ |voiceData, currChord, validNotes|

	~runLogger.("~resolveMelodicIntervals");

	voiceData[\names].do { |v, i|
		validNotes[v] = validNotes[v].reject { |n|
			voiceData[\invalidIntervals][v].includes((n - currChord[i]).abs);
		};
	};
	nil;
};

/*************************************************************************************/
// Remove valid notes other than common tones from respective voices

~resolveCommonTones = #{ |voiceData, currChord, validNotes|

	~runLogger.("~resolveCommonTones");

	voiceData[\names].do { |v, i|
		var set = [currChord[i]];

		if ((set.isSubsetOf(validNotes[v])) && (i > 0)) {
			validNotes[v] = (validNotes[v] & set);
		};
	};
	nil;
};

/*************************************************************************************/
// Get valid notes

~getValidNotes = #{ |data, rules|
	var nextCipher = data[\state][\nextCipher];
	var chords = data[\chords];
	var validNotes = Dictionary.new();

	~runLogger.("~getValidNotes");

	validNotes = ~getChordVocalRange.(data[\voice], chords[nextCipher][\notes]);

	if (rules[\enforceMelodicIntervals]) {
		~resolveMelodicIntervals.(data[\voice], data[\state][\currChord], validNotes);
	};
	if (rules[\enforceCommonTones]) {
		~resolveCommonTones.(data[\voice], data[\state][\currChord], validNotes);
	};
	data[\state][\validNotes] = validNotes;
	nil;
};
)
