/**************************************************************************************
- HARMONY 01 / Utility Functions
**************************************************************************************/
(
// Get the corresponding degree of a note, given a cipher

~getNoteDegree = #{ |note, cipher, chords|
	var notes = chords[cipher][\notes].asArray;
	var degree = chords[cipher][\degree];

	~runLogger.("~getNoteDegree");

	degree[notes.indexOf(note)];
};

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord

~getChordNotesDegree = #{ |currChord, cipher, chords|
	var degreeArray = Array.new(4);

	~runLogger.("~getChordNotesDegree");

	currChord.do { |n|
		degreeArray.add(~getNoteDegree.(n, cipher, chords));
	};
	degreeArray;
};

/*************************************************************************************/
// list of note names (e.g. C)

~getNoteName = #{ |note|

	~runLogger.("~getNoteName");

	note.collect { |n| ~midiRange[\name][n] };
};

/*************************************************************************************/
// list of note names, with respective octave number (e.g. C4)

~getNoteNameOct = #{ |note|

	~runLogger.("~getNoteNameOct");

	note.collect { |n| ~midiRange[\octave][n] };
};

/*************************************************************************************/

~getChordNoteNameOct = #{ |chord, midiRange|

	~runLogger.("~getChordNoteNameOct");

	chord.collect { |n| midiRange[\octave][n] };
};
)
