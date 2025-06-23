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

	\state -> Dictionary[
		\currChord       -> nil,
		\nextChord       -> nil,
		\validNotes      -> nil,
		\nextValidChords -> nil,
		\nextCipher      -> nil
	],

	\chords -> nil
];

~progState = Dictionary[
	\progression     -> nil,
	\durations       -> nil,
	\ruleEnforcement -> nil,
	\validChords     -> nil,
	\result          -> nil
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

/*************************************************************************************/

~resetDataDict = #{ |data|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~resetDataDict: Function Call".format(~loggerCount).postln; };

	data[\chords][\midiChords]     = nil;
	data[\chords][\progression]      = nil;
	data[\chords][\durations]      = nil;

	data[\state][\currChord]       = nil;
	data[\state][\validNotes]      = nil;
	data[\state][\nextValidChords] = nil;
	data[\state][\nextCipher]      = nil;
	nil;
};

/*************************************************************************************/

// Reset ~rules dictionary to default setting
~resetRules = #{ |rules|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~resetRules: Function Call".format(~loggerCount).postln; };

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
