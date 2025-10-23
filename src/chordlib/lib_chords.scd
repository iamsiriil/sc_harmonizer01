/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
~getChordData = { |root, symbol, ansi = false, normalize = false|
	var dict  = Dictionary.new(4);
	var temp, deg, accident, chord, offset;

	//~resolveSymbol.(symbol).postln;

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
	~getInputSymbol.(dict, root, accident, symbol, normalize);

	dict;
};
)
