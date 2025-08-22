/**************************************************************************************
- HARMONY 01 / Dictionaries and reset functions
**************************************************************************************/
(
/*
~data dictionary stores information about each voice, as well as
chord metadata used for backtracking when building each new chord in the progression.

Keys shown as 'nil' are placeholders for documentation only. In SuperCollider,
dictionaries cannot be assigned nil values.
*/

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

// Dictionary Containing data to be used while backtracking across the progression
~progState = Dictionary[
	\progression     -> nil,
	\durations       -> nil,
	\ruleEnforcement -> nil,
	\validChords     -> nil,
	\direction       -> nil,
	\result          -> nil,
	\dump            -> nil
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
];

// Convinience array with the sequence of rule symbols
~ruleKeys = [
	\enforceVoiceCrossProhibition,
	\enforceMelodicIntervals,
	\enforceCommonTones,
	\enforceVocalRange,
	\enforceParallelOctaves,
	\enforceParallelFifths,
	\enforceNoteDuplicate,
	\enforceRootDuplicate,
	\enforceThirdDuplicate,
	\enforceFifthDuplicate,
	\enforceChordPosition,
	\enforceRootPosition,
	\enforceFirstInversion,
	\enforceSecondInversion
];

// Convenience array containing all dictionaries
~dictionaries = [~midiRange, ~triads, ~data, ~progState, ~rules, ~ruleKeys];

/*************************************************************************************/
/*
~resetDataDict resets the ~data dictionary to default values to prevent
contamination across recursive calls
*/

~resetDataDict = #{ |data|

	~runLogger.("~resetDataDict");

	data[\state][\currChord]       = nil;
	data[\state][\nextChord]       = nil;
	data[\state][\validNotes]      = nil;
	data[\state][\nextValidChords] = nil;
	data[\state][\nextCipher]      = nil;
	data[\chords]                  = nil;
	nil;
};

/*************************************************************************************/
/*
~resetProgState resets the ~progState dictionary to prevent contamination
across recursive calls
*/

~resetProgState = #{ |progState|

	~runLogger.("~resetProgState");

	progState[\progression]     = nil;
	progState[\durations]       = nil;
	progState[\ruleEnforcement] = nil;
	progState[\validChords]     = nil;
	progState[\direction]       = nil;
	progState[\result]          = nil;
	progState[\dump]            = nil;
	nil;
};

/*************************************************************************************/
// ~resetRules resets the ~rules dictionary to its default settings

~resetRules = #{ |rules|

	~runLogger.("~resetRules");

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
	rules[\enforceCommonTones]            = true;
	nil;
};
)
