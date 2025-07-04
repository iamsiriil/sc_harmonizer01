/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
(
// Checks if chord notes belong to the given cipher

~test_GXCSubroutine00 = { |triads, data|
	var set, result = true;

	"\nTEST #00: Notes belong to Chord\n".postln;

	data[\state][\validNextChords].do { |c, i|
		set = c.asSet;
		result = result && set.isSubsetOf(triads[data[\state][\nextCipher]][\notes]);

		~test_resultMessage.(result, "~getFirstChords", nil, i);
	};
	nil;
};

// Checks if chords are complete

~test_GXCSubroutine01 = { |triads, data|
	var set, result = true;

	"\nTEST #01: Chord is complete\n".postln;

	data[\state][\validNextChords].do { |c, i|
		set = ~getChordNotesDegree.(c, data[\state][\nextCipher], data[\chords]).asSet;
		result = result && (set == triads[data[\state][\nextCipher]][\degree].asSet);

		~test_resultMessage.(result, "~getFirstChords", nil, i);
	};
	nil;
};

// Checks whether chord notes are within range

~test_GXCSubroutine02 = { |data|
	var voiceRange = data[\voice][\range];
	var result;

	"\nTEST #02: Notes are within range\n".postln;

	data[\state][\validNextChords].do { |c, i|
		result = true;

		data[\voice][\names].do { |v, j|
			result = result && ((c[j] >= voiceRange[v][0]) && (c[j] <= voiceRange[v][1]));
		};
		~test_resultMessage.(result, "~getFirstChords", nil, i);
	};
	nil;
};

// Check whether voice spacing is correct

~test_GXCSubroutine03 = { |data, rules|
	var cross, result, n;

	"\nTEST #03: Spacing is correct\n".postln;

	cross = if (rules[\enforceVoiceCrossProhibition]) {
			(_ >= 0);
		} {
			(_ >= -4);
		};

	data[\state][\validNextChords].do { |c, i|
		result = true;

		for(1, 3) { |j|
			n = (c[j] - c[j - 1]).abs;

			if (j == 1){
				result = result && (cross.(n) && (n <= 24));
			} {
				result = result && (cross.(n) && (n <= 12));
			};
		};
		~test_resultMessage.(result, "~getFirstChords", nil, i);
		nil;
	};
};

/*************************************************************************************/

~test_getFirstChords = { |triads, data, progState, rules, firstCipher|

	~logger = false;
	~loggerCount = 0;

	~test_getFirstChordsArray.(triads, data, progState, rules, firstCipher);

	~resetRules.(rules);

	~test_GXCSubroutine00.(triads, data);
	~test_GXCSubroutine01.(triads, data);
	~test_GXCSubroutine02.(data);
	~test_GXCSubroutine03.(data, rules);
};

/*************************************************************************************/

~test_getNextChords = { |triads, data, progState, rules, fixtures, firstCipher, nextCipher|

	~logger = false;
	~loggerCount = 0;

	~test_getNextChordsArray.(triads, data, progState, rules, fixtures, firstCipher, nextCipher);

	~resetRules.(rules);

	~test_GXCSubroutine00.(triads, data);
	~test_GXCSubroutine01.(triads, data);
	~test_GXCSubroutine02.(data);
	~test_GXCSubroutine03.(data, rules);
};
)
