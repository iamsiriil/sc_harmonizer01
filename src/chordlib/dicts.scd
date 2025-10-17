/**************************************************************************************
- HARMONY 01 / Dynamic Library - Dictionaries
**************************************************************************************/
(
// Chord symbol aliases

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

	// Augmented sixth chords
	\It     -> Set[],
	\Gr     -> Set[],
	\Fr     -> Set[],

	// Neapolitan sixth
	\Na     -> Set[],

	// Suspended chords
	\sus2   -> Set[],
	\sus4   -> Set[]
];

// Chord blueprints

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
	\M3d5m7 -> [0, 4, 6, 10],
	\M3d5M7 -> [0, 4, 6, 11],
	\D7     -> [0, 4, 7, 10],
	\M7     -> [0, 4, 7, 11],
	\A5m7   -> [0, 4, 8, 10],
	\A5M7   -> [0, 4, 8, 11],

	// Augmented sixth chords
	// No extensions allowed
	\It     -> [0, 2, 6],      // Only first inversion allowed
	\Gr     -> [0, 2, 6, 10],  // Only first inversion allowed
	\Fr     -> [0, 4, 6, 10],  // Only second inversion allowed

	// Neapolitan sixth
	\Na     -> [0, 3, 7],      // Only first inversion allowed

	// Suspended chords
	\sus2   -> [0, 2, 7],
	\sus4   -> [0, 5, 7]
];

// Utility arrays with note names and major scale
~noteNames = [
	['C', 'D', 'E', 'F', 'G', 'A', 'B'],
	[0, 2, 4, 5, 7, 9, 11]
];
)