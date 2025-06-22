/**************************************************************************************
- HARMONY 01 / Dictionaries and reset functions
**************************************************************************************/
(
~midiRoot = { |str|
	var midi = 0;

	~noteNames.do { |n, i|

		if ((str.size == 1) && (n.size == 1) && (n.contains(str))) {
			midi = i;
		};
		if ((str.size > 1) && (n.size > 1) && (n.contains(str))) {
			midi = i;
		};
	};
	midi;
};

/*************************************************************************************/

~rootDistance = { |prog, chords|
	var arr = Array.new(prog.size);

	arr.add(0);

	for (0, (prog.size - 2)) { |i|
		var f = 0, s = 0;

		f = ~midiRoot.(chords[i][\root].asString);
		s = ~midiRoot.(chords[i + 1][\root].asString);

		if (s > f) {
			arr.add(s - f);
		} {
			s = s + 12;
			arr.add(s - f);
		}
	};

	arr.do { |n, i|
		chords[i][\distance] = n;
	};
	chords;
};

/*************************************************************************************/

~progParser = { |prog, chords|
	var arr;

	prog.do { |c, i|
		var dict = Dictionary.new;

		dict[\cipher] = c;
		dict[\type] = c.asString.last;

		if (c.asString.size == 3) {
			dict[\root] = c.asString[0..1];
		} {
			dict[\root] = c.asString[0];
		};
		chords[i] = dict;
	};

	~rootDistance.(prog, chords);
};

/*************************************************************************************/

~ruleToggler = { |progState, chordDict|
	var dict = Dictionary.new();

	progState[\progression].size.do { |i|
		var arr = Array.new(10);

		if (chordDict[i][\distance] == 6) {
			arr.add([\enforceMelodicIntervals, false]);
		};
		dict[i] = arr;
	};
	dict.postln;
	progState[\ruleEnforcement] = dict;
}
)

(
~chords = Dictionary.new();
~prog = ['CM', 'F#d', 'GM', 'CM'];
~progState[\progression] = ~prog;

~progParser.(~prog, ~chords);
~ruleToggler.(~progState, ~chords);
)
~chords[1][\distance]
~progState[\ruleEnforcement][1]

~arr = Array.new(3);

~arr.add([\enforceMelodicIntervals, false])