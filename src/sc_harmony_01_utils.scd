/**************************************************************************************
- HARMONY 01 / Utility Functions and Data Structures
**************************************************************************************/
// Data Structures
(
// Dictionary containing information about the voices
~voiceData = Dictionary[
	// Range of each voice, from lowest note, to highest
	\voiceRange -> Dictionary[
		\bas -> [40, 60],
		\ten -> [48, 67],
		\alt -> [55, 74],
		\spn -> [60, 81]
	],
	// Allowed melodic intervals
	\invalidIntervals -> Dictionary[
		// All except tritone and sevenths. Spn, alt and ten, one octave. Bass, two
		\bas -> [6, 10, 11, 18, 22, 23],
		\ten -> [6, 10, 11],
		\alt -> [6, 10, 11],
		\spn -> [6, 10, 11]
	],
	// Number of voices
	\numVoices -> 4,
	// Reference names for each of the voices
	\voiceNames -> ['bas', 'ten', 'alt', 'spn']
];

// Data structure containing sets of necessary chords and the chord progression to be played
~chordData = Dictionary[
	\chords        -> nil,        // Dictionary with arrays
	\chordProg     -> nil,         // 2D Array
	\totalDuration -> nil
];

// Data structure containing the state of chords as they're built and played'
~chordState = Dictionary[
	\currChord       -> nil,  // Array
	\nextChord       -> nil,  // Array
	\validNotes      -> nil,  // OrderedIdentitySet with arrays ??
	\nextValidChords -> nil,  // OrderedIdentitySet
	\lastValidChords -> nil,  // OrderedIdentitySet
	\nextCipher      -> nil   // Symbol
];

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
		dict[\notes] = triads[c][\notes].as(OrderedIdentitySet).postln;
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
			voiceData[\invalidIntervals][v].includes((n - currChord[i]))
		};
	};
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

~getValidNotes = #{ |chords, chordState, voiceData|
	var nextCipher = chordState[\nextCipher].postln;
	var currChord = chordState[\currChord].postln;
	var validNotes;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getValidNotes: Function Call".format(~loggerCount).postln; };

	validNotes = ~getChordVocalRange.(voiceData, chords[nextCipher][\notes]);

	if (~enforceMelodicIntervals == true) {
		~resolveMelodicIntervals.(voiceData, validNotes, currChord);
	};
	if (~enforceCommonTones == true) {
		~resolveCommonTones.(voiceData, validNotes, currChord);
	};
	chordState[\validNotes] = validNotes;
	nil;
};

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher

~getNoteDegree = #{ |note, cipher, chords|
	var notes = chords[cipher][\notes].asArray;
	var degree = chords[cipher][\degree];

	note.postln;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getNoteDegree: Function Call".format(~loggerCount).postln; };

	degree[notes.indexOf(note)];
};

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord

~getChordNotesDegree = #{ |currChord, cipher, chords|
	var degreeArray = Array.new(4);

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordNotesDegree: Function Call".format(~loggerCount).postln; };

	currChord.do { |n|
		degreeArray.add(~getNoteDegree.(n, cipher, chords));
	};
	degreeArray;
};

/*************************************************************************************/
// list of note names (e.g. C)

~getNoteName = #{ |note|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getNoteName: Function Call".format(~loggerCount).postln; };

	note.collect { |n| ~midiRange[\name][n] };
};

/*************************************************************************************/
// list of note names, with respective octave number (e.g. C4)

~getNoteNameOct = #{ |note|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getNoteNameOct: Function Call".format(~loggerCount).postln; };

	note.collect { |n| ~midiRange[\octave][n] };
};

/*************************************************************************************/
// Resets ~chordData dictionary values to nil
~resetChordDicts = #{

	~chordData[\chords]    = nil;
	~chordData[\chordProg] = nil;

	~chordState[\currChord]       = nil;
	~chordState[\nextChord]       = nil;
	~chordState[\validNotes]      = nil;
	~chordState[\nextValidChords] = nil;
	~chordState[\lastValidChords] = nil;
	~chordState[\nextCipher]      = nil;

	nil;
};
)
