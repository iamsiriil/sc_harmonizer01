/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(

~getChordSymbol = { |dict, root, accident, symbol|

	"~getChordSymbol: Function Call".postln;

	if (root[1].isNil) {
		dict[\symbol] = root[0] ++ symbol;
	} {
		dict[\symbol] = root[0] ++ accident ++ symbol;
	};

	nil;
};

/****************************************************************************************/

~getChordData = { |root, symbol, ansi = false|
	var dict  = Dictionary.new(4);
	//var chord = ~chordOffsets[symbol].postln;
	var temp, deg, accident, chord, offset;

	if (symbol.asString.size == 2) {
		chord  = ~intervalOffsets[symbol][0];
		offset = ~intervalOffsets[symbol][1];
	} {
		chord = ~chordOffsets[symbol];
	};

	temp = ~getChordNoteNames.(root, chord, offset);
	deg  = ~getChordDegrees.(temp[0], temp[1]);


	if (ansi) {
		~namesToAnsi.(temp[1]);
		accident = ~asAnsiChar.(root[1]);
	} {
		accident = root[1];
	};

	~wrapAndExtend.(dict, temp[0], temp[1], deg);
	~getChordSymbol.(dict, root, accident, symbol);

	dict;
};
)
\p5.asString.size