/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
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
			\bas -> [40, 62],
			\ten -> [48, 69],
			\alt -> [55, 76],
			\spn -> [60, 81]
		],
		\validIntervals -> Dictionary[
			\bas -> [0, 1, 2, 3, 4, 5, 7, 12],
			\ten -> [0, 1, 2, 3, 4, 5, 7],
			\alt -> [0, 1, 2, 3, 4, 5, 7],
			\spn -> [0, 1, 2, 3, 4, 5, 7]
		],
		\number -> 4,
		\names  -> ['bas', 'ten', 'alt', 'spn']
	],

	\state -> Dictionary[
		\currChord       -> nil,
		\nextChord       -> nil,
		\validNotes      -> nil,
		\validNextChords -> nil,
		\nextCipher      -> nil
	],

	\chords -> nil
];

// Dictionary Containing data to be used while backtracking across the progression
~progState = Dictionary[
	\ruleEnforcement -> nil,
	\validChords     -> nil, // Gets all valid chords from ~data[\validNextChords] (redundant?)
	\result          -> nil, // Stores result from backtrack
	\dump            -> nil, // Result to be used in score export (redundant?)
	\return          -> nil, // Stores version of progression to be returned (voice/chord)
	\progression     -> nil,
	\durations       -> nil,
	\direction       -> nil,
	\output          -> nil,
	\sustain         -> nil
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
	\enforceUnisonProhibition     -> false
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
	\enforceSecondInversion,
	\enforceUnisonProhibition
];

/****************************************************************************************/
/*
~resetDataDict resets the ~data dictionary to default values to prevent
contamination across recursive calls
*/

~resetDataDict = #{ |data|

	~runLogger.("~resetDataDict");

	data[\state][\currChord]       = nil;
	data[\state][\nextChord]       = nil;
	data[\state][\validNotes]      = nil;
	data[\state][\validNextChords] = nil;
	data[\state][\nextCipher]      = nil;
	data[\chords]                  = nil;
	nil;
};

/****************************************************************************************/
/*
~resetProgState resets the ~progState dictionary to prevent contamination
across recursive calls
*/

~resetProgState = #{ |progState|

	~runLogger.("~resetProgState");

	progState[\ruleEnforcement] = nil;
	progState[\validChords]     = nil;
	progState[\result]          = nil;
	progState[\dump]            = nil;
	progState[\return]          = nil;
	progState[\progression]     = nil;
	progState[\durations]       = nil;
	progState[\direction]       = nil;
	progState[\output]          = nil;
	progState[\sustain]         = nil;
	nil;
};

/****************************************************************************************/
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
	rules[\enforceCommonTones]           = true;
	//rules[\enforceUnisonProhibition]     = false; -> Overwrites input value
	nil;
};
)
