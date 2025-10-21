/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
// DICTIONARIES **************************************************************************
// Test value uniqueness in dicts

~testUniqueness = { |dict|
	var set = Set.newFrom(dict);
	var result, diff;

	if (set.size == dict.size) {
		result = true;
	} {
		result = false;
	};
	diff = (set.size - dict.size).abs;

	"result: % | diff: %".format(result, diff).postln;
	[result, diff].postln;
};

// Test symbol uniqueness across sets
~testSymbolUniqueness = {};

// Test dictionary keys uniqueness
~testKeysUniqueness = {};

//~unique = ~testUniqueness.(~chordSymbols);

/****************************************************************************************/

~root = ~parseRoot.("B");
~dict = ~getChordData.(~root, \M3, true);

~dict[\notes].postln;
~dict[\names].postln;
~dict[\degrees].postln;
~dict[\symbol].postln;
)
~intervalOffsets[\P5]