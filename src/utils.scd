/*****************************************************************************************
* Harmonizer 01 - A Rule-Based Harmonizer for SuperCollider                              *
* Copyright (C) 2025 Siriil                                                              *
*                                                                                        *
* This program is free software: you can redistribute it and/or modify                   *
* it under the terms of the GNU General Public License as published by                   *
* the Free Software Foundation, either version 3 of the License, or                      *
* (at your option) any later version.                                                    *
*                                                                                        *
* This program is distributed in the hope that it will be useful,                        *
* but WITHOUT ANY WARRANTY; without even the implied warranty of                         *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                          *
* GNU General Public License for more details.                                           *
*                                                                                        *
* You should have received a copy of the GNU General Public License                      *
* along with this program.  If not, see <http://www.gnu.org/licenses/>.                  *
*****************************************************************************************/
(
// Get the corresponding degree of a note, given a cipher

~getNoteDegree = #{ |note, cipher, chords|
	var notes = chords[cipher][\notes].asArray;
	var degree = chords[cipher][\degree];

	~runLogger.("~getNoteDegree");

	degree[notes.indexOf(note)];
};

/****************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord

~getChordNotesDegree = #{ |currChord, cipher, chords|
	var degreeArray = Array.new(4);

	~runLogger.("~getChordNotesDegree");

	currChord.do { |n|
		degreeArray.add(~getNoteDegree.(n, cipher, chords));
	};
	degreeArray;
};

/****************************************************************************************/
// list of note names (e.g. C)

~getNoteName = #{ |note|

	~runLogger.("~getNoteName");

	note.collect { |n| ~midiRange[\name][n] };
};

/****************************************************************************************/
// list of note names, with respective octave number (e.g. C4)

~getNoteNameOct = #{ |note|

	~runLogger.("~getNoteNameOct");

	note.collect { |n| ~midiRange[\octave][n] };
};

/****************************************************************************************/

~getChordNoteNameOct = #{ |chord, midiRange|

	~runLogger.("~getChordNoteNameOct");

	chord.collect { |n| midiRange[\octave][n] };
};
)
