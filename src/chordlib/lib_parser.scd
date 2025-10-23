/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
// Error handling to prevent roots with double sharps/flats
// before ~parseRoot is called
~parseRoot = { |root|
	var arr = Array.new(3);
	var midi;

	"~parseChords: Function Call".postln;

	root = root.asString;

	if (root.size == 2) {
		arr.add(root[0].asString); // .asString ensures a string instead of char
		arr.add(root[1].asString);
	} {
		arr.add(root);
		arr.add(nil);
	};

	case
	{ root == "Cb" } { midi = 11 }
	{ root == "B#" } { midi = 0 }
	{
		midi = ~noteNames[1][~noteNames[0].indexOf(arr[0].asSymbol)];

		case
		{ arr[1] == "#" } { midi = midi + 1 }
		{ arr[1] == "b" } { midi = midi - 1 }
		{ midi };
	};

	arr.add(midi);
	arr;
};

/****************************************************************************************/
// Chord symbol "C#min7(9/13)/E"
~parseInputSymbol = { |symbol|

	if (symbol.isKind(Symbol)) {
		symbol = symbol.asString;
	};
	// Chord symbol is broken down into:
	// -> root
	// -> base chord
	// -> extensions
	// -> bass note
}
)