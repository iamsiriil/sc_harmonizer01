/**************************************************************************************
- HARMONY 01 / Test suit
**************************************************************************************/
(
"./utils/loadall.scd".loadRelative;

~test = Dictionary[

	\range -> Dictionary[
		\GCDA    -> { ~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data) },
		\GCVR    -> { ~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data) },
		\RMI     -> { |verbose = false| ~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data, verbose) },
		\RCT     -> { |verbose = false| ~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, verbose) },
		\runAll  -> {
			~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data);
			~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data);
			~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data, false);
			~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, false);
		}
	],

	\chordRules -> Dictionary[
		\CCP    -> { ~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules) },
		\CVR    -> { ~test_checkVoiceRange.(~test_CVRFixtures, ~rules) },
		\CPO    -> { ~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~data[\voice]) },
		\CPF    -> { ~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~data[\voice]) },
		\CND    -> { ~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules) },
		\runAll -> {
			~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
			~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
			~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~data[\voice]);
			~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~data[\voice]);
			~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules);
		}
	],

	\backtrack -> Dictionary[
		\GFC -> { |firstChord = 'CM'|~test_getFirstChords.(~triads, ~data, ~progState, ~rules, firstChord) },
		\GNC -> { |firstChord = 'Em', nextChord = 'CM'| ~test_getNextChords.(~triads, ~data, ~progState, ~rules, ~test_GNCFixtures, firstChord, nextChord) }
	],

	\validators -> Dictionary[
		\TA -> { ~test_testArguments.(~test_TAFixtures) }
	],

	\runAll -> {
		~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data);
		~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data);
		~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data, false);
		~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, false);

		~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
		~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
		~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~data[\voice]);
		~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~data[\voice]);
		~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules);

		~test_getFirstChords.(~triads, ~data, ~progState, ~rules, 'CM');
		~test_getNextChords.(~triads, ~data, ~progState, ~rules, ~test_GNCFixtures, 'Em', 'CM');

		~test_testArguments.(~test_TAFixtures);
	};
];
)
