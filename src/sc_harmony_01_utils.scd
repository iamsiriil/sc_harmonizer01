/**************************************************************************************
- HARMONY 01 / Utility Functions
**************************************************************************************/
(
~logger = true;

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher

~getNoteDegree = #{ |note, cipher, chords|
	var notes = chords[cipher][\notes].asArray;
	var degree = chords[cipher][\degree];

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

~getChordNoteNameOct = #{ |chord, midiRange|

	chord.collect { |n| midiRange[\octave][n] };
};

/*************************************************************************************/

~mergeNotes = { |prog, dur, nprog, ndur, new, i|
	var result;

	block { |return|

		if (i == (prog.size)) {
			result = [nprog, ndur];
			return.value(result);
		};

		if (i == 0) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		};

		if ((i > 0) && (new != prog[i])) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		} {
			ndur[ndur.size - 1] = ndur[ndur.size - 1] + dur[i];
		};

		result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
		return.value(result);

	};
	result;
};

/*************************************************************************************/

~sustainCommonTones = { |progState|
	var result = Array.new(4);

	progState[\result].do { |v|
		var nprog = Array.new(v.size);
		var ndur = Array.new(v.size);

		result.add(~mergeNotes.(v, progState[\durations], nprog, ndur, 0, 0));
	};
	result;
};
)
