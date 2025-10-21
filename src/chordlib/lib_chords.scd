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
	var chord = ~chordOffsets[symbol];
	var temp, deg, accident;

	"~getChordRange: Function Call".postln;

	temp = ~getChordNoteNames.(root, chord);
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
