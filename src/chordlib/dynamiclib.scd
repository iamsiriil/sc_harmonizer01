/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
/*
Reference dictionary for parsed chords (C79/E)

~parsed = Dictionary[
   \root       -> ['C', nil, 0],
   \bass       -> 'E',
   \type       -> 'M3m7',
   \extensions -> ['M9'],
   \distance   -> 0,
   \names      -> ['C', 'D', 'E', 'G', 'Bb']
   \degrees    -> ['Rt', 'M9', 'M3', 'P5', 'm7'],
   \notes      -> [0, 2, 4, 7, 10, ...],
]
*/
/****************************************************************************************/
(
~resolveAccidents = { |note, root, chord, i|
	var noteIndex = ~noteNames[0].indexOf(note.asSymbol);
	var ref, dif;

	"~resolveAccidents: Function Call".postln;

	// Cb and B# require special treatment
	case
	{ (root[0] == "B") && (root[1] == "#") && (note == "B")} {
		ref = -1;
	}
	{ (note == "C") && ((chord[i] == 11) || (chord[i] == 10)) } {
		ref = 12;
	}
	{ (note == "B") && ((chord[i] == 12) || (chord[i] == 13)) } {
		ref = 11;
	}
	{
		if ((chord[i] >= 12)) {
			ref = (~noteNames[1][noteIndex] + 12);
		} {
			ref = ~noteNames[1][noteIndex];
		};
	};

	dif = (chord[i] - ref);

	if (dif.abs >= 3){
		Error("Tripple flats/sharps are NOT allowed.\n".format(note)).throw;
	};

	case
	{ dif.isPositive } { dif.do {note = note ++ "#"} }
	{ dif.isNegative } { dif.abs.do {note = note ++ "b"} };

	note;
};

/****************************************************************************************/

~getChordNoteNames = { |root, chord|
	var offset, tranChord, noteNames, rootIndex;

	"~getChordNoteNames: Function Call".postln;

	tranChord = (chord + root[2]);                 // Transpose chord

	// Get note name offsets
	case
	{ chord == [0, 2, 7] } { offset = [0, 1, 4] }     // Special handling of sus2 chords
	{ chord == [0, 5, 7] } { offset = [0, 3, 4] }     // Special handling of sus4 chords
	{ chord.size == 3 }    { offset = [0, 2, 4] }     // Index offsets for triads
	{ chord.size == 4 }    { offset = [0, 2, 4, 6] }; // Index offsets for seventh chords

	rootIndex = ~noteNames[0].indexOf(root[0].asSymbol);
	noteNames = ~noteNames[0].wrapAt(rootIndex + offset);

	noteNames.do { |n, i| noteNames[i] = n.asString };

	noteNames.do { |n, i|
		noteNames[i] = ~resolveAccidents.(n, root, tranChord, i).postln;
	};

	[tranChord, noteNames];
};

/****************************************************************************************/

~getIntervalDegree = { |note1, note2|
	var startIndex, ct, i;

	"~getIntervalDegree: Function Call".postln;

	note1 = note1[0];
	note2 = note2[0];

	startIndex = ~noteNames[0].indexOf(note1.asSymbol);

	ct = 1;
	i = startIndex;
	while { (~noteNames[0][i] != note2.asSymbol) && (ct <= 6) } {

		if (~noteNames[0][i] != note2.asSymbol) {
			ct = ct + 1;
		};
		i = (i + 1) % ~noteNames[0].size;
	};
	ct;
};

/****************************************************************************************/

~getIntervalType = { |degree, midiNote1, midiNote2|
	var dif = (midiNote2 - midiNote1);
	var type, sub;

	"~getIntervalType: Function Call".postln;

	switch (degree)
	{ 2 } { sub = 0 }
	{ 3 } { sub = 2 }
	{ 4 } { sub = 4 }
	{ 5 } { sub = 6 }
	{ 6 } { sub = 7 }
	{ 7 } { sub = 9 };

	dif = (dif - sub);

	case
	{ (degree == 2) || (degree == 3) || (degree == 6) || (degree == 7) } {

		switch (dif)
		{ 0 } { type = "d" }
		{ 1 } { type = "m" }
		{ 2 } { type = "M" }
		{ 3 } { type = "A" }
	}
	{ (degree == 4) || (degree == 5) } {

		switch (dif)
		{ 0 } { type = "d" }
		{ 1 } { type = "P" }
		{ 2 } { type = "A" }
	};
	type;
};

/****************************************************************************************/

~getChordDegrees = { |notes, names|
	var arr = Array.new(notes.size);
	var deg, type;

	"~getChordDegrees: Function Call".postln;

	notes.do { |n, i|
		if (i == 0) {
			arr.add("Rt");
		} {
			deg  = ~getIntervalDegree.(names[0], names[i]);
			type = ~getIntervalType.(deg, notes[0], notes[i]);

			arr.add(type ++ deg);
		}
	};
	arr;
};

/****************************************************************************************/
~wrapFirstOctave = { |notes, names, degrees|
	var dict = Dictionary.new;

	"~wrapFirstOctave: Function Call".postln;

	notes.do { |n, i|

		if (n >= 12) {
			notes[i]  = n - 12;
			names     = names.rotate(1);
			degrees   = degrees.rotate(1);
		}
	};
	notes.sort;

	dict[\notes] = ~extendMidiRange.(notes);
	dict[\names] = names;
	dict[\degrees] = degrees;

	dict;
};

/****************************************************************************************/

~getChordRange = { |root, symbol, ansi = false|
	var dict = Dictionary.new(4);
	var chord = ~chords[symbol];
	var temp, deg, accident;

	"~getChordRange: Function Call".postln;

	temp = ~getChordNoteNames.(root, chord);
	deg  = ~getChordDegrees.(temp[0], temp[1]);

	dict = ~wrapFirstOctave.(temp[0], temp[1], deg);

	if (ansi) {
		~namesToAnsi.(temp[1]);
		accident = ~asAnsiChar.(root[1]);
	} {
		accident = root[1].postln;
	};

	if (root[1].isNil) {
		dict[\symbol]  = root[0] ++ symbol;
	} {
		dict[\symbol]  = root[0] ++ accident ++ symbol;
	};

	dict;
};

/****************************************************************************************/

~root = ~parseRoot.("C#");
~dict = ~getChordRange.(~root, \m3d5M7, true);

~dict[\notes].postln;
~dict[\names].postln;
~dict[\degrees].postln;
~dict[\symbol].postln;
)
