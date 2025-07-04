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

/*************************************************************************************/

~mergeNotes = { |prog, dur, nprog, ndur, new, i|
	var result;

	//~runLogger.("~mergeNotes");

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
	var temp = Array.new(4);
	var return = Array.fill(2, {Array.new(4)});

	~runLogger.("~sustainCommonTones");

	progState[\result].do { |v|
		var nprog = Array.new(v.size);
		var ndur = Array.new(v.size);

		temp.add(~mergeNotes.(v, progState[\durations], nprog, ndur, 0, 0));
	};
	temp.do { |i|
		return[0].add(i[0]);
		return[1].add(i[1]);
	};
	return;
};

/*************************************************************************************/

~dumpProg = { |data, progState, name|
	var path = PathName.new("../data/scdump/dump%.txt".format(name).resolveRelative);
	var file = File(path.fullPath, "a");

	~runLogger.("~dumpProg");

	file.write("%\n".format(data[\voice][\number]));

	progState[\result].flop.do { |v|
		file.write("%\n".format(v));
		file.write("%\n".format(progState[\durations]));
	};

	progState[\progression].size.do { |i|
		file.write("%\n".format(i));
		progState[\ruleEnforcement][i].do { |r|
			file.write("%\n".format(r));
		};
	};

	file.close;
};
)
