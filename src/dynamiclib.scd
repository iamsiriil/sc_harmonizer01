/**************************************************************************************
- HARMONY 01 / Dynamic Library
**************************************************************************************/

/* Reference dictionary for parsed chords (C79/E)

~parsed = Dictionary[
   \root       -> 'C',
   \bass       -> 'E',
   \type       -> 'D7',
   \extensions -> ['M9'],
   \distance   -> 0,
   \names      -> ['C', 'D', 'E', 'G', 'Bb']
   \degrees    -> ['Rt', 'M9', 'M3', 'P5', 'm7'],
   \notes      -> [0, 2, 4, 7, 10, ...],
]
*/


(
~chordSymbols = Dictionary[
	// Triads
	\d      -> Set['d', 'dim', 'º'],
	\m      -> Set['m', 'min', '-', 'mi'],
	\M      -> Set['M', 'Maj', '^', 'Δ'],
	\A      -> Set['A', 'aug', '+'],

	// Seventh chords
	\d7     -> Set['d7', 'dim7', 'º7'],
	\d5m7   -> Set['d5m7', 'd5min7', 'dim5m7', 'ø7', 'm7♭5', '-7♭5', 'half-dim7', 'min7dim5'],
	\d5M7   -> Set['d5M7', 'dim5Maj7', 'º5M7', 'd5Maj7', 'º5^7', 'dim5M7', 'd5^7', 'dim5^7'],
	\m7     -> Set[],
	\m3M7   -> Set[],
	\m3A5m7 -> Set[],
	\m3A5M7 -> Set[],
	\d5D7   -> Set[],
	\d5M7   -> Set[],
	\D7     -> Set[],
	\M7     -> Set[],
	\A5m7   -> Set[],
	\A5M7   -> Set[],
	//\A5A7   -> Set[]

	// Augmented sixth chords
	\Na     -> Set[],
	\It     -> Set[],
	\Gr     -> Set[],
	\Fr     -> Set[],

	// Suspended chords
	\sus2   -> Set[],
	\sus4   -> Set[]
];

~chords = Dictionary[
	// Triads
	// Allowed extensions (9th, 11th, 13th)
	\d      -> [0, 3, 6],
	\m      -> [0, 3, 7],
	\M      -> [0, 4, 7],
	\A      -> [0, 4, 8],

	// Seventh chords
	// Allowed extensions (9th, 11th, 13th)
	\d7     -> [0, 3, 6, 9],
	\d5m7   -> [0, 3, 6, 10],
	\d5M7   -> [0, 3, 6, 11],
	\m7     -> [0, 3, 7, 10],
	\m3M7   -> [0, 3, 7, 11],
	\m3A5m7 -> [0, 3, 8, 10],
	\m3A5M7 -> [0, 3, 8, 11],
	\d5D7   -> [0, 4, 6, 10],
	\d5M7   -> [0, 4, 6, 11],
	\D7     -> [0, 4, 7, 10],
	\M7     -> [0, 4, 7, 11],
	\A5m7   -> [0, 4, 8, 10],
	\A5M7   -> [0, 4, 8, 11],
	//\A5A7 -> [0, 4, 8, 12]

	// Augmented sixth chords
	// No extensions allowed
	\It     -> [0, 2, 6],      // Only first inversion allowed
	\Gr     -> [0, 2, 6, 10],  // Only first inversion allowed
	\Fr     -> [0, 4, 6, 10],  // Only second inversion allowed
	// Not augmented
	\Na     -> [0, 3, 7],      // Only first inversion allowed

	// Suspended chords
	// Allowed extensions (7th, 9th, 11th, 13th)
	\sus2   -> [0, 2, 7],
	\sus4   -> [0, 5, 7]
];

~noteNames = [
	['C', 'D', 'E', 'F', 'G', 'A', 'B'],
	[0, 2, 4, 5, 7, 9, 11]
];
)

/*************************************************************************************/

(
~parseRoot = { |root|
	var arr = Array.new(3);
	var midi;

	"~parseChords: Function Call".postln;

	root = root.asString;

	if (root.size == 2) {
		arr.add(root[0]);
		arr.add(root[1]);
	} {
		arr.add(root);
		arr.add(nil);
	};

	"arr: %".format(arr).postln;
	case
	{ root == "Cb" } { midi = 11 }
	{ root == "B#" } { midi = 0 }
	{
		midi = ~noteNames[1][~noteNames[0].indexOf(arr[0].asSymbol)].postln;

		case
		{ arr[1] == $# } { midi = midi + 1 }
		{ arr[1] == $b } { midi = midi - 1 }
		{ midi };
	};

	arr.add(midi);
	arr;
};

/*************************************************************************************/

~getChordNoteNames = { |root, chord|
	var dis, tranChord, noteNames, rootIndex;

	"~getChordNoteNames: Function Call".postln;

	case
	{ chord == [0, 2, 7] } { dis = [0, 1, 4] }
	{ chord == [0, 5, 7] } { dis = [0, 3, 4] }
	{ chord.size == 3 }    { dis = [0, 2, 4] }
	{ chord.size == 4 }    { dis = [0, 2, 4, 6] };

	tranChord = (chord + root[2]);

	rootIndex = ~noteNames[0].indexOf(root[0].asSymbol);
	noteNames = ~noteNames[0].wrapAt(rootIndex + dis);

	noteNames.do { |n, i|
		noteNames[i] = n.asString;
	};

	noteNames.do { |n, i|
		var noteIndex = ~noteNames[0].indexOf(n.asSymbol);
		var ref, dif;

		// B# and Cb require special treatment
		case
		{ (root[0] == $B) && (root[1] == $#) && (n == "B")} {
			ref = -1;
		}
		{ (n == "C") && ((tranChord[i] == 11) || (tranChord[i] == 10)) } {
			ref = 12;
		}
		{ (n == "B") && ((tranChord[i] == 12) || (tranChord[i] == 13)) } {
			ref = 11;
		}
		{
			if (tranChord[i] >= 12) {
				ref = ~noteNames[1][noteIndex] + 12;
			} {
				ref = ~noteNames[1][noteIndex];
			};
		};

		dif = tranChord[i] - ref;

		case
		{ dif.isPositive } {
			dif.do {
				noteNames[i] = noteNames[i] ++ "#";
			}
		}
		{ dif.isNegative } {
			dif.abs.do {
				noteNames[i] = noteNames[i] ++ "b";
			}
		}
	};
	[tranChord, noteNames];
};

/*************************************************************************************/

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

/*************************************************************************************/

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

/*************************************************************************************/

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

/*************************************************************************************/


~getAnsiChar = { |names|
	var sharp  = "♯";
	var dsharp = "𝄪";
	var flat   = "♭";
	var dflat  = "𝄫";

	names.do { |n, i|

		switch (n.size)
		{ 3 }{

			case
			{ n.includes($#) } { names[i] = n[0] ++ dsharp }
			{ n.includes($b) } { names[i] = n[0] ++ dflat }
		}
		{ 2 } {

			case
			{ n.includes($#) } { names[i] = n[0] ++ sharp }
			{ n.includes($b) } { names[i] = n[0] ++ flat }
		}
	};
};


~getChord = { |root, chord, ansi = false|
	var dict = Dictionary.new(3);
	var temp, deg;

	"~getChord: Function Call".postln;

	temp = ~getChordNoteNames.(root, chord);
	deg  = ~getChordDegrees.(temp[0], temp[1]);

	temp[0].do { |n, i|

		if (n >= 12) {
			temp[0][i] = n - 12;
			temp[1]    = temp[1].rotate(1);
			deg        = deg.rotate(1);
		}
	};
	temp[0].sort;

	if (ansi) { ~getAnsiChar.(temp[1]) };

	dict[\notes]   = temp[0];
	dict[\names]   = temp[1];
	dict[\degrees] = deg;

	if (root[1].isNil) {
		dict[\cipher]  = root[0] ++ ~chords.findKeyForValue(chord);
	} {
		dict[\cipher]  = root[0] ++ root[1] ++ ~chords.findKeyForValue(chord);
	};

	dict;
};

/*************************************************************************************/

~root = ~parseRoot.("F#");
~dict = ~getChord.(~root, ~chords[\A5m7], true);

~dict[\notes].postln;
~dict[\names].postln;
~dict[\degrees].postln;
~dict[\cipher].postln;
)

~str = "C##";

~str.size == 3 && ~str.includes($#)