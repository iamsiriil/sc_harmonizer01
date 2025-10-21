/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(

~asAnsiChar = { |string|

	"~asAnsiChar: Function Call".postln;


	case
	{ string == "##" } { "𝄪" }
	{ string == "#" }  { "♯" }
	{ string == "b" }  { "♭" }
	{ string == "bb" } { "𝄫" }
};

/****************************************************************************************/

~namesToAnsi = { |names|

	"~namesToAnsi: Function Call".postln;

	names.do { |n, i|

		switch (n.size)
		{ 3 }{
			case
			{ n.includes($#) } { names[i] = n[0] ++ ~asAnsiChar.("##") }
			{ n.includes($b) } { names[i] = n[0] ++ ~asAnsiChar.("bb") }
		}
		{ 2 } {
			case
			{ n.includes($#) } { names[i] = n[0] ++ ~asAnsiChar.("#") }
			{ n.includes($b) } { names[i] = n[0] ++ ~asAnsiChar.("b") }
		}
	};
};

/****************************************************************************************/

~extendMidiRange = { |range|
	var arr = Array.new(range.size * 11);

	"~extendMidiRange: Function Call".postln;


	range.do { |n|

		while { n <= 127 } {

			arr.add(n);
			n = n + 12;
		};
	};
	arr.sort;
};

/****************************************************************************************/

~wrapAndExtend = { |dict, notes, names, degrees|

	"~wrapFirstOctave: Function Call".postln;

	notes.do { |n, i|

		if (n >= 12) {
			notes[i]  = n - 12;
			names     = names.rotate(1);
			degrees   = degrees.rotate(1);
		}
	};
	notes.sort;

	dict[\notes]   = ~extendMidiRange.(notes);
	dict[\names]   = names;
	dict[\degrees] = degrees;

	nil;
};
)
