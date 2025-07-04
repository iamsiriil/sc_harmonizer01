/**************************************************************************************
- HARMONY 01 / Test suit
**************************************************************************************/
(
"./utils/loadall.scd".loadRelative;


~test = Dictionary[

	\range -> Dictionary[
		\GCDA -> { ~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data) },
		\GCVR -> { ~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data) },
		\RMI -> { ~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data) },
		\RCT -> { |verbose = false| ~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, verbose) }
	],

	\chordRules -> Dictionary[
		\CCP -> { ~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules) },
		\CVR -> { ~test_checkVoiceRange.(~test_CVRFixtures, ~rules) },
		\CPO -> { ~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~data[\voice]) },
		\CPF -> { ~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~data[\voice]) },
		\CND -> { ~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules) }
	],

	\backtrack -> Dictionary[
		\GFC -> { |firstChord = 'CM'|~test_getFirstChords.(~triads, ~data, ~progState, ~rules, firstChord) },
		\GNC -> { |firstChord = 'Em', nextChord = 'CM'| ~test_getNextChords.(~triads, ~data, ~progState, ~rules, ~test_GNCFixtures, firstChord, nextChord) }
	]
];
)
