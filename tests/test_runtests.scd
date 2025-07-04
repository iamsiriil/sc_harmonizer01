/**************************************************************************************
- HARMONY 01 / Test suit
**************************************************************************************/
(
"./utils/loadall.scd".loadRelative;

~test_checkChordPosition.(~test_CCPFixtures, ~triads, ~rules);
~test_checkVoiceRange.(~test_CVRFixtures, ~rules);
~test_checkParallelOctaves.(~test_CPOFixtures, ~rules, ~data[\voice]);
~test_checkParallelFifths.(~test_CPFFixtures, ~rules, ~data[\voice]);
~test_checkNoteDuplicate.(~test_CNDFixtures, ~triads, ~rules);

~test_getChordDegreeArray.(~test_GCDFixture, ~triads, ~data);
~test_getChordVocalRange.(~test_GCVRFixtures, ~triads, ~data);
~test_resolveMelodicIntervals.(~test_RMIFixtures, ~triads, ~data);
~test_resolveCommonTones.(~test_RCTFixtures, ~triads, ~data, false);

~test_getFirstChords.(~triads, ~data, ~progState, ~rules, 'CA');
~test_getNextChords.(~triads, ~data, ~progState, ~rules, ~test_GNCFixtures, 'Em', 'CM');
)