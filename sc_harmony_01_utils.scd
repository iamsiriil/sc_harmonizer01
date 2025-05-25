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
	\validIntervals -> Dictionary[
		// All except tritone and sevenths. Spn, alt and ten, one octave. Bass, two
		\bas -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12, 13, 14,15, 16, 17, 19, 20, 21, 24],
		\ten -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\alt -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\spn -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12]
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

~getChordDegreeArrays = #{
	var chordProg = ~chordData[\chordProg];
	var ciphers, dictChords, dict;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordDegreeArrays: Function Call".format(~loggerCount).postln; };

	ciphers = chordProg.collect { |c| c[0] };
	ciphers = ciphers.asSet;

	"ciphers: %".format(ciphers).postln;
	dictChords = Dictionary.new();

	ciphers.do { |c|
		"c: %".format(c).postln;
		dict = Dictionary.new();
		dict[\notes] = ~triads[c][\notes].postln;
		dict[\degree] = (~triads[c][\degree].wrapExtend(~triads[c][\notes].size));

		dictChords[c] = dict;
	};
	~chordData[\chords] = dictChords;
	nil;
};

/*************************************************************************************/
// Get chord notes, within MIDI range, and respective degrees, as paired arrays

~getChordDegreePairs = { |chordProg|
	//var chordProg = ~chordData[\chordProg];
	var chords, dict;

	chords = chordProg.collect { |c| c[0] };    // Separate ciphers from durations
	chords.asSet;                               // Remove duplicates

	dict = Dictionary.new();

	chords.do { |c|
		var notes;

		notes = ~triads[c][\notes] +++ ~triads[c][\degree].bubble(1);
		dict[c] = notes;
	};
	dict;
};

/*************************************************************************************/
// Get all chord notes for each vocal range

~getChordVocalRange = #{
	var cipher = ~chordState[\nextCipher].postln;
	var voices = ~voiceData[\voiceNames];
	var chordNotes = ~chordData[\chords][cipher][\notes].as(OrderedIdentitySet);
	var voiceRange, dict;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordVocalRange: Function Call".format(~loggerCount).postln; };

	dict = Dictionary.new();

	voices.do { |v|
		voiceRange = ~voiceData[\voiceRange][v];
		dict[v] = chordNotes & (voiceRange[0]..voiceRange[1]);
	};
	~chordState[\validNotes] = dict;
	nil;
};

/*************************************************************************************/
// Ensure only valid melodic intervals are played between chords

~resolveMelodicIntervals = {

};

/*************************************************************************************/
// Remove valid notes other than common tones from respective voices

~resolveCommonTones = #{
	var currChord = ~chordState[\currChord];
	var validNotes = ~chordState[\validNotes];
	var voiceNames = ~voiceData[\voiceNames];

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~resolveCommonTones: Function Call".format(~loggerCount).postln; };

	//if (~enforceRootPosition == true) {
		voiceNames = voiceNames.drop(1);
		currChord = currChord.drop(1);
	//};

	voiceNames.do { |v, i|
		var set = [currChord[i]];
		if (set.isSubsetOf(~chordState[\validNotes][v])) {
			~chordState[\validNotes][v] = (~chordState[\validNotes][v] & set);
		};
	};
	nil;
};

/*************************************************************************************/
// Get valid notes

~getValidNotes = #{

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getValidNotes: Function Call".format(~loggerCount).postln; };

	~getChordVocalRange.();

	/*if (~enforceMelodicIntervals == true) {
		~resolveMelodicIntervals.();
	};*/
	if (~enforceCommonTones == true) {
		~resolveCommonTones.();
	};
	nil;
};

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher

~getNoteDegree = #{ |note|
	var cipher = ~chordState[\nextCipher];
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];


	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getNoteDegree: Function Call".format(~loggerCount).postln; };
	//"note: %".format(note).postln;

	degree[notes.indexOf(note)];
};

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord

~getChordNotesDegree = #{ |chord|
	var degreeArray = Array.new(4);

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~getChordNotesDegree: Function Call".format(~loggerCount).postln; };

	chord.do { |n, i|
		degreeArray.add(~getNoteDegree.(n));
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
