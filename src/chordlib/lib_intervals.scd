/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
~getIntervalDegree = { |note1, note2|
	var size = ~noteNames[0].size;
	var ct, i;

	"~getIntervalDegree: Function Call".postln;

	note1 = note1[0].postln;
	note2 = note2[0].postln;

	i  = ~noteNames[0].indexOf(note1.asSymbol);
	ct = 1;

	while { (~noteNames[0][i] != note2.asSymbol) && (ct <= 6) } {

		if (~noteNames[0][i] != note2.asSymbol) {
			ct = ct + 1;
		};
		i = (i + 1) % size;
	};

	ct;
};

/****************************************************************************************/

~getIntervalType = { |degree, midiNote1, midiNote2|
	var dif = (midiNote2 - midiNote1);
	var type, sub;

	"~getIntervalType: Function Call".postln;

	"degree: %".format(degree).postln;
	sub = ~subtract[degree].postln;

	dif = (dif - sub);

	case
	{ (degree == 2) || (degree == 3) || (degree == 6) || (degree == 7) } {

		switch (dif)
		{ 0 } { type = "d" }
		{ 1 } { type = "m" }
		{ 2 } { type = "M" }
		{ 3 } { type = "A" }
	}
	{ (degree == 4) || (degree == 5) } {

		switch (dif)
		{ 0 } { type = "d" }
		{ 1 } { type = "P" }
		{ 2 } { type = "A" }
	};
	type;
};

/****************************************************************************************/

~getChordDegrees = { |notes, names|
	var degrees = Array.new(notes.size);
	var int, type;

	"~getChordDegrees: Function Call".postln;

	notes.do { |n, i|
		if (i == 0) {
			degrees.add("Rt");
		} {
			int  = ~getIntervalDegree.(names[0], names[i]);
			type = ~getIntervalType.(int, notes[0], notes[i]);

			degrees.add(type ++ int);
		}
	};

	degrees;
};
)