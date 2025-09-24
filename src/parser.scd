/**************************************************************************************
- HARMONY 01 / Dictionaries and reset functions
**************************************************************************************/
(
~midiRoot = #{ |note|
	var midi = 0;

	~runLogger.("~midiRoot");

	~noteNames.do { |n, i|

		if ((note.size == 1) && (n.size == 1) && (n.contains(note))) {
			midi = i;
		};
		if ((note.size > 1) && (n.size > 1) && (n.contains(note))) {
			midi = i;
		};
	};
	midi;
};

/*************************************************************************************/

~rootDistance = #{ |prog, chords|
	var arr = Array.new(prog.size);

	~runLogger.("~rootDistance");

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

~progParser = #{ |prog, chords|
	var arr;

	~runLogger.("~progParser");

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

	if (prog.size > 1){
		~rootDistance.(prog, chords);
	}
};

/*************************************************************************************/

~setRules = { |progState, chordDict, test = false|
	var dict = Dictionary.new();

	~runLogger.("~setRules");

	progState[\progression].size.do { |i|
		var arr = Array.new(10);

		if (i == 0) {
			arr.add([\enforceMelodicIntervals, false]);
			arr.add([\enforceCommonTones, false]);
			arr.add([\enforceParallelOctaves, false]);
			arr.add([\enforceParallelFifths, false]);
		} {
			/*arr.add([\enforceNoteDuplicate, false]);
			arr.add([\enforceRootDuplicate, false]);*/
			arr.add([\enforceChordPosition, false]);
			arr.add([\enforceRootPosition, false])
		};

		if ((chordDict[i][\distance] == 6) && (test == false)) {
			arr.add([\enforceParallelOctaves, false]);
			arr.add([\enforceParallelFifths, false]);
			arr.add([\enforceMelodicIntervals, false]);
		};

		dict[i] = arr;
	};
	progState[\ruleEnforcement] = dict;
};
)
