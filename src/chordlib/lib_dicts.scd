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
// Interval aliases
(
~intervals = Dictionary[
	\Un -> Set['Rt', 'Un',  'Pu', 'P8', 'd2', 'd9'],
	\m2 -> Set['Au', 'A8',  'm9'],
	\M2 -> Set['d3', 'd10', 'M9'],
	\m3 -> Set['A2', 'A9',  'm10'],
	\M3 -> Set['d4', 'd11', 'M10'],
	\P4 -> Set['A3', 'A10', 'P11'],
	\A4 -> Set['d5', 'd12', 'A11'],
	\P5 -> Set['d6', 'd13', 'P12'],
	\m6 -> Set['A5', 'm13', 'm13'],
	\M6 -> Set['d7', 'd14', 'M13'],
	\m7 -> Set['A6', 'A13', 'm14'],
	\M7 -> Set['d8', 'd15', 'M14']
];

/****************************************************************************************/
// Chord symbol aliases

~chordSymbols = Dictionary[
	// Triads
	\d3d5 -> Set['Ita', 'It', 'Italian', 'º3º5', '-3-5', 'b3b5', 'dim3dim5'],
	\d3P5 -> Set['Sus2', 'sus2', 's2', 'sus9', 's9'],
	\d3A5 -> Set[],

	\m3d5 -> Set['d', 'dim', 'Dim', 'º'],
	\m3P5 -> Set['m', 'min', '-', 'mi'],
	\m3A5 -> Set[],

	\M3d5 -> Set[],
	\M3P5 -> Set['Neapolitan', 'Nap', 'Na', 'Np', 'M', 'Maj'],
	\M3A5 -> Set['A', 'aug', '+'],

	\A3d5 -> Set[],
	\A3P5 -> Set['Sus4', 'sus4', 's4', 's13'],
	\A3A5 -> Set[],

	// Seventh chords
	\d3d5d7 -> Set[],
	\d3d5m7 -> Set['Ger', 'Gr', 'German', 'º35m7', 'º35min7', 'º35m7', 'º3nat5', '-35'],
	\d3d5M7 -> Set[],

	\d3P5d7 -> Set[],
	\d3P5m7 -> Set[],
	\d3P5M7 -> Set[],

	\d3A5d7 -> Set[],
	\d3A5m7 -> Set[],
	\d3A5M7 -> Set[],

	\m3d5d7 -> Set['d7', 'dim7', 'º7'],
	\m3d5m7 -> Set['d5m7', 'd5min7', 'dim5m7', 'ø7', 'm7♭5', '-7♭5', 'half-dim7', 'min7dim5'],
	\m3d5M7 -> Set['d5M7', 'dim5Maj7', 'º5M7', 'd5Maj7', 'º5^7', 'dim5M7', 'd5^7', 'dim5^7'],

	\m3P5d7 -> Set[],
	\m3P5m7 -> Set['min7', 'Min7'],
	\m3P5M7 -> Set[],

	\m3A5d7 -> Set[],
	\m3A5m7 -> Set[],
	\m3A5M7 -> Set[],

	\M3d5d7 -> Set[],
	\M3d5m7 -> Set['French', 'Fr'],
	\M3d5M7 -> Set[],

	\M3P5d7 -> Set['6', '13', 'Majº7', 'majº7'],
	\M3P5m7 -> Set['Dominant', 'Dom', 'D', '7', 'D7'],
	\M3P5M7 -> Set['Maj7', 'M7'],

	\M3A5d7 -> Set[],
	\M3A5m7 -> Set[],
	\M3A5M7 -> Set[],

	\A3d5d7 -> Set[],
	\A3d5m7 -> Set[],
	\A3d5M7 -> Set[],

	\A3P5d7 -> Set[],
	\A3P5m7 -> Set['sus27', 'sus2m7', 'sus2min7'],
	\A3P5M7 -> Set[],

	\A3A5d7 -> Set[],
	\A3A5m7 -> Set[],
	\A3A5M7 -> Set[],
];

/****************************************************************************************/
// Interval note offsets

~intervalOffsets = Dictionary[
	\Un -> [0, 0],
	\m2 -> [0, 1],
	\M2 -> [0, 2],
	\m3 -> [0, 3],
	\M3 -> [0, 4],
	\P4 -> [0, 5],
	\A4 -> [0, 6],
	\P5 -> [0, 7],
	\m6 -> [0, 8],
	\M6 -> [0, 9],
	\m7 -> [0, 10],
	\M7 -> [0, 11],
	\P8 -> [0, 12],
];

/****************************************************************************************/
// Triads and seventh chords note offsets

~chordOffsets = Dictionary[

	// Triads
	// Allowed extensions (9th, 11th, 13th)
	\d3d5 -> [0, 2, 6], // Italian sixth
	\d3P5 -> [0, 2, 7], // Sus2
	\d3A5 -> [0, 2, 8],

	\m3d5 -> [0, 3, 6], // Diminished triad
	\m3P5 -> [0, 3, 7], // Minor triad
	\m3A5 -> [0, 3, 8],

	\M3d5 -> [0, 4, 6],
	\M3P5 -> [0, 4, 7], // Major Third / Neapolitan sixth
	\M3A5 -> [0, 4, 8], // Augmented triad

	\A3d5 -> [0, 5, 6],
	\A3P5 -> [0, 5, 7], // Sus4
	\A3A5 -> [0, 5, 8],

	// Seventh chords
	// Allowed extensions (9th, 11th, 13th)
	\d3d5d7 -> [0, 2, 6, 9],  // German sixth
	\d3d5m7 -> [0, 2, 6, 10],
	\d3d5M7 -> [0, 2, 6, 11],

	\d3P5d7 -> [0, 2, 7, 9],
	\d3P5m7 -> [0, 2, 7, 10],
	\d3P5M7 -> [0, 2, 7, 11],

	\d3A5d7 -> [0, 2, 8, 9],
	\d3A5m7 -> [0, 2, 8, 10],
	\d3A5M7 -> [0, 2, 8, 11],

	\m3d5d7 -> [0, 3, 6, 9],  // Diminished seventh
	\m3d5m7 -> [0, 3, 6, 10], // Half-diminished seventh
	\m3d5M7 -> [0, 3, 6, 11],

	\m3P5d7 -> [0, 3, 7, 9],
	\m3P5m7 -> [0, 3, 7, 10], // Minor seventh
	\m3P5M7 -> [0, 3, 7, 11],

	\m3A5d7 -> [0, 3, 8, 9],
	\m3A5m7 -> [0, 3, 8, 10],
	\m3A5M7 -> [0, 3, 8, 11],

	\M3d5d7 -> [0, 4, 6, 9],
	\M3d5m7 -> [0, 4, 6, 10], // French Sixth
	\M3d5M7 -> [0, 4, 6, 11],

	\M3P5d7 -> [0, 4, 7, 9],
	\M3P5m7 -> [0, 4, 7, 10], // Dominant seventh
	\M3P5M7 -> [0, 4, 7, 11], // Major seventh

	\M3A5d7 -> [0, 4, 8, 9],
	\M3A5m7 -> [0, 4, 8, 10],
	\M3A5M7 -> [0, 4, 8, 11],

	\A3d5d7 -> [0, 5, 6, 9],
	\A3d5m7 -> [0, 5, 6, 10],
	\A3d5M7 -> [0, 5, 6, 11],

	\A3P5d7 -> [0, 5, 7, 9],
	\A3P5m7 -> [0, 5, 7, 10],
	\A3P5M7 -> [0, 5, 7, 11],

	\A3A5d7 -> [0, 5, 8, 9],
	\A3A5m7 -> [0, 5, 8, 10],
	\A3A5M7 -> [0, 5, 8, 11]
];

/****************************************************************************************/

~subtract = Dictionary[
	2 -> 0,
	3 -> 2,
	4 -> 4,
	5 -> 6,
	6 -> 7,
	7 -> 9
];

/****************************************************************************************/
// Utility arrays with note names and major scale

~noteNames = [
	['C', 'D', 'E', 'F', 'G', 'A', 'B'],
	[0, 2, 4, 5, 7, 9, 11]
];
)