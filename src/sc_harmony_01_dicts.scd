/**************************************************************************************
- HARMONY 01 / Dictionaries and reset functions
**************************************************************************************/
(

~data = Dictionary[
	\voice -> Dictionary[
		\range -> Dictionary[
			\bas -> [40, 60],
			\ten -> [48, 67],
			\alt -> [55, 74],
			\spn -> [60, 81]
		],
		\invalidIntervals -> Dictionary[
			\bas -> [6, 10, 11, 18],
			\ten -> [6, 10, 11],
			\alt -> [6, 10, 11],
			\spn -> [6, 10, 11]
		],
		\number -> 4,
		\names  -> ['bas', 'ten', 'alt', 'spn']
	],

	\chords -> Dictionary[
		\midi       -> nil,
		\progression      -> nil,
		\durations        -> nil
	],

	\state -> Dictionary[
		\currChord       -> nil,
		\nextChord       -> nil,
		\validNotes      -> nil,
		\nextValidChords -> nil,
		\nextCipher      -> nil
	]
];

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
	\invalidIntervals -> Dictionary[
		// All except tritone and sevenths. Spn, alt and ten, one octave. Bass, two
		\bas -> [6, 10, 11, 18],
		\ten -> [6, 10, 11],
		\alt -> [6, 10, 11],
		\spn -> [6, 10, 11]
	],
	// Number of voices
	\numVoices -> 4,
	// Reference names for each of the voices
	\voiceNames -> ['bas', 'ten', 'alt', 'spn']
];

// Dictionary containing sets of necessary chords and the chord progression to be played
~chordData = Dictionary[
	\chords        -> nil,        // Dictionary with arrays
	\chordProg     -> nil         // 2D Array
];

// Dictionary containing the state of chords as they're built and played'
~chordState = Dictionary[
	\currChord       -> nil,  // Array
	\nextChord       -> nil,  // Array
	\validNotes      -> nil,  // OrderedIdentitySet with arrays ??
	\nextValidChords -> nil,  // OrderedIdentitySet
	\lastValidChords -> nil,  // OrderedIdentitySet
	\nextCipher      -> nil   // Symbol
];

// Dictionary containing default rule settings
~rules = Dictionary[
	\enforceVoiceCrossProhibition -> true,
	\enforceMelodicIntervals      -> true,
	\enforceVocalRange            -> true,
	\enforceCommonTones           -> true,
	\enforceParallelOctaves       -> true,
	\enforceParallelFifths        -> true,
	\enforceNoteDuplicate         -> true,
	\enforceRootDuplicate         -> true,
	\enforceThirdDuplicate        -> false,
	\enforceFifthDuplicate        -> false,
	\enforceChordPosition         -> true,
	\enforceRootPosition          -> true,
	\enforceFirstInversion        -> false,
	\enforceSecondInversion       -> false,
	\toggleCount                  -> 0
];

/*~progState = Dictionary[
	\chord -> Dictionary[

	],
	\rules -> Dictionary[

	]
];*/

/*************************************************************************************/

// Resets ~chordData dictionary values to nil
~resetChordData = #{ |chordData|

	chordData[\chords]    = nil;
	chordData[\chordProg] = nil;
	nil;
};

// Resets ~chordState dictionary values to nil
~resetChordState = #{ |chordState|

	chordState[\currChord]       = nil;
	chordState[\nextChord]       = nil;
	chordState[\validNotes]      = nil;
	chordState[\nextValidChords] = nil;
	chordState[\lastValidChords] = nil;
	chordState[\nextCipher]      = nil;
	nil;
};

~resetDataDict = #{ |data|

	data[\chords][\midiChords]     = nil;
	data[\chords][\progression]      = nil;
	data[\chords][\durations]      = nil;

	data[\state][\currChord]       = nil;
	data[\state][\validNotes]      = nil;
	data[\state][\nextValidChords] = nil;
	data[\state][\nextCipher]      = nil;
	nil;
};

// Reset ~rules dictionary to default setting
~resetRules = #{ |rules|

	rules[\enforceVoiceCrossProhibition] = true;
	rules[\enforceMelodicIntervals]      = true;
	rules[\enforceVocalRange]            = true;
	rules[\enforceParallelOctaves]       = true;
	rules[\enforceParallelFifths]        = true;
	rules[\enforceNoteDuplicate]         = true;
	rules[\enforceRootDuplicate]         = true;
	rules[\enforceThirdDuplicate]        = false;
	rules[\enforceFifthDuplicate]        = false;
	rules[\enforceChordPosition]         = true;
	rules[\enforceRootPosition]          = true;
	rules[\enforceFirstInversion]        = false;
	rules[\enforceSecondInversion]       = false;
	rules[\enforceCommonTone]            = true;

	rules[\toggleCount] = 0;
	nil;
};
)