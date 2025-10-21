/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
/*
Reference dictionary for parsed chords (C79/E)

~parsed = Dictionary[
   \root       -> ['C', nil, 0],
   \bass       -> 'E',
   \type       -> 'M3m7',
   \extensions -> ['M9'],
   \distance   -> 0,
   \names      -> ['C', 'D', 'E', 'G', 'Bb']
   \degrees    -> ['Rt', 'M9', 'M3', 'P5', 'm7'],
   \notes      -> [0, 2, 4, 7, 10, ...],
]
*/
/****************************************************************************************/
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

/****************************************************************************************/

~root = ~parseRoot.("Bb");
~dict = ~getChordData.(~root, \A3A5d7, true);

~dict[\notes].postln;
~dict[\names].postln;
~dict[\degrees].postln;
~dict[\symbol].postln;
)
