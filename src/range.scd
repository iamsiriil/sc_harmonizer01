/**************************************************************************************
- HARMONY 01 / Range Functions
**************************************************************************************/
(
/*
~getChordDegreeArrays gathers all chord note sequences and respective degrees,
across the MIDI range, as two separate arrays
*/

~getChordDegreeArrays = #{ |triads, chordProg|
	var ciphers, dictChords, dict;

	~runLogger.("~getChordDegreeArrays");

	ciphers = chordProg.asSet;
	dictChords = Dictionary.new();

	ciphers.do { |c|
		dict = Dictionary.new();
		dict[\notes] = triads[c][\notes].as(OrderedIdentitySet);                 // Converts to set to facilitate operations over note range
		dict[\degree] = (triads[c][\degree].wrapExtend(triads[c][\notes].size)); // Extends degree name over the length of 'notes'

		dictChords[c] = dict;
	};
	dictChords;
};

/*************************************************************************************/
/*
~getChordVocalRange gathers all chord notes within each vocal range
*/

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
/*
~resolveMelodicInterval ensure only valid melodic intervals are played between chords
*/

~resolveMelodicIntervals = #{ |voiceData, currChord, validNotes|

	~runLogger.("~resolveMelodicIntervals");

	voiceData[\names].do { |v, i|
		validNotes[v] = validNotes[v].select { |n|
			voiceData[\validIntervals][v].includes((n - currChord[i]).abs);
		};
	};
	nil;
};

/*************************************************************************************/
/*
~resolveCommonTones ensures only common tones are present as valid candidate,
for each of the voices, depending on note present in previous chord
*/

~resolveCommonTones = #{ |voiceData, currChord, validNotes|

	~runLogger.("~resolveCommonTones");

	voiceData[\names].do { |v, i|
		var set = [currChord[i]];

		if ((set.isSubsetOf(validNotes[v]))) { // && (i > 0)
			validNotes[v] = (validNotes[v] & set);
		};
	};
	nil;
};

/*************************************************************************************/
/*
~getValidNotes manages valid candidate notes depending on rule settings
*/

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
