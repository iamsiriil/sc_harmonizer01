/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
~getChordSymbol = { |symbol|
	var normSymbol;


	~chordSymbols.keysValuesDo { |k, v|
		"k: % | v: %".format(k, v).postln;

		if (v.includes(symbol.asSymbol)) {
			normSymbol = k;
		};
	};
	normSymbol.asString;
}
)

~getChordSymbol.("Maj")