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
/*
~data dictionary stores information about each voice, as well as
chord metadata used for backtracking when building each new chord in the progression.

Keys shown as 'nil' are placeholders for documentation only. In SuperCollider,
dictionaries cannot be assigned nil values.
*/

~data = Dictionary[
	\voice -> Dictionary[

		// Voice dictionary will need changes to account for additional voices
		// Max 7, as chords cannot have more than seven different notes (?)
		// spn1, spn2, alt1, alt2, ten, bar, bass (?)

		\range -> Dictionary[
			\bas -> [40, 62],

			// \bar -> [...], Since there's a greater distance between bass and tenor,
			// makes sense the baritone voice stays in between, with its own register.

			\ten -> [48, 69], // remains
			\alt -> [55, 76], // alt 1 and 2
			\spn -> [60, 81]  // Spn 1 and 2
		],
		\validIntervals -> Dictionary[

			// Only two are needed: bass and other voices

			\bas -> [0, 1, 2, 3, 4, 5, 7, 12],
			\ten -> [0, 1, 2, 3, 4, 5, 7],
			\alt -> [0, 1, 2, 3, 4, 5, 7],
			\spn -> [0, 1, 2, 3, 4, 5, 7]
		],

		// To be included dynamically since voice number may vary between 4 and 7 (?)
		\number -> 4,

		// Simply refer to voices as v0, v1, ..., v7 (?)
		\names  -> ['bas', 'ten', 'alt', 'spn']
	],

	\state -> Dictionary[
		\currChord       -> nil,
		\nextChord       -> nil,
		\validNotes      -> nil,
		\validNextChords -> nil, // Gathers all valid chords from ~getChords
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

	// Argumens (Maybe nested dictionary for all arguments?)
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
	// New rules for additional chord positions (third inversion and so on)
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
	// New rules for additional chord positions (third inversion and so on)
];

// Convenience array containing all dictionaries
~dictionaries = [~midiRange, ~triads, ~data, ~progState, ~rules, ~ruleKeys];

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
	// New rules for additional chord positions (third inversion and so on)
	nil;
};
)
