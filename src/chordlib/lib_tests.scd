/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
"../loadall.scd".loadRelative;
)

(
// DICTIONARIES **************************************************************************
// Test value uniqueness in dicts

~testValuesUniqueness = { |dict|
	var set = Set.newFrom(dict);
	var result, diff;

	dict.postln;
	if (set.size == dict.size) {
		result = true;
	} {
		result = false;
	};

	diff = (set.size - dict.size).abs;

	[result, diff].postln;
};
/****************************************************************************************/
// Test for duplicate symbols across all sets stored in the ~chordSymbols dictionary

~testChordSymbolsUniqueness = { |dict|
	var testArray = [], testSet;

	dict.do { |v|
		testArray = testArray ++ v.asArray;
	};

	testSet = testArray.asSet;

	if (testSet.size < testArray.size) {
		false;
	} {
		true;
	};
};

/****************************************************************************************/
// Test dictionary keys uniqueness

~testKeysUniqueness = {};


/****************************************************************************************/
// Need special treatment for Un
~root = ~parseRoot.("C");
~dict = ~getChordData.(~root, \m7, true);

 ~dict[\notes].postln;
 ~dict[\names].postln;
 ~dict[\degrees].postln;
 ~dict[\symbol].postln;

//~testChordSymbolsUniqueness.(~chordSymbols);
//~unique = ~testValuesUniqueness.(~chordSymbols);
)
