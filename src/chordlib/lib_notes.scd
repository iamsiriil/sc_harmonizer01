/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
~getOctave = {};

/****************************************************************************************/

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

~getChordNoteNames = { |root, chord, intOffset = nil|
	var offset, tranChord, noteNames, rootIndex;

	"~getChordNoteNames: Function Call".postln;

	"chord: % | root[2]: %".format(chord, root[2]).postln;
	tranChord = (chord + root[2]);                    // Transpose chord

	// Get note name offsets
	case
	{ chord == [0, 2, 7] } { offset = [0, 1, 4] }     // Special handling of sus2 chords
	{ chord == [0, 5, 7] } { offset = [0, 3, 4] }     // Special handling of sus4 chords
	{ chord.size == 3 }    { offset = [0, 2, 4] }     // Index offsets for triads
	{ chord.size == 4 }    { offset = [0, 2, 4, 6] }  // Index offsets for seventh chords
	{ chord.size == 2 }    { offset = intOffset };

	rootIndex = ~noteNames[0].indexOf(root[0].asSymbol);
	noteNames = ~noteNames[0].wrapAt(rootIndex + offset);

	noteNames.do { |n, i| noteNames[i] = n.asString };

	noteNames.do { |n, i|
		noteNames[i] = ~resolveAccidents.(n, root, tranChord, i);
	};

	[tranChord, noteNames];
};
)