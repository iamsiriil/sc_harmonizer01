/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
/*
Before gathering chord data symbol has to:
-> parse input symbol and extracl base chord
-> check is base chord is valid and present in the alias dictionary
-> collect input symbol and normalized symbol
-> detect if symbol is special symbol (need specific handling)

Special Symbols:
-> Sixth chords (Gr, Fr, It and Na)
-> Suspended chords (have second and fourth degrees, instead of third. require different name offset)
-> Added sixth chords (have the same notes as some of the seventh chords but require different name offset)
*/

~handleInputSymbol = { |dict, root, accident, inputSymbol, normalize|

	"~getChordSymbol: Function Call".postln;

	/*if (normalize == true) {
		//
	}*/

	// ~isSpecialSymbol.(symbol); <--

	if (root[1].isNil) {
		// Include normSymbol -> normalized symbol
		// Include symbol     -> user provided symbol
		dict[\symbol] = root[0] ++ inputSymbol;
	} {
		dict[\symbol] = root[0] ++ accident ++ inputSymbol;
	};

	nil;
};

/****************************************************************************************/

~getNormalizedSymbol = { |symbol|
	var normSymbol;


	~chordSymbols.keysValuesDo { |k, v|
		//"k: % | v: %".format(k, v).postln;

		if (v.includes(symbol.asSymbol)) {
			normSymbol = k;
		};
	};
	normSymbol.asString;
};

/****************************************************************************************/

~getAliases = { |normSymbol|
	~chordSymbols[normSymbol.asSymbol].asArray.sort;
};

/****************************************************************************************/

~resolveSymbol = { |symbol|
	// look for symbol in keys
	// if not iterate all sets and get key
};
)

// (
// ~getAliases.("m3d5d7")
// ~getNormalizedSymbol.("º7")
//
// ['c', 'a', '0z', 'p'].sort
// )