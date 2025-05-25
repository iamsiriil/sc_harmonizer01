(
"../sc_harmony_01_rules.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
"../sc_harmony_01_lib.scd".loadRelative;
)

/**************************************************************************************
- HARMONY 01 / Test rules
**************************************************************************************/
// Test fixtures
(
// Test parallel octaves
~test_parallelOctaves = Dictionary[
	\frtChord    -> [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]],
	\scdChordPLO -> [[[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]], false], // Has parallel octaves
	\scdChordVAL -> [[[48, 52, 60, 67], [48, 55, 64, 72], [48, 55, 60, 64], [48, 55, 64, 72], [48, 55, 60, 64], [41, 53, 60, 69]], true]   // Progression is valid
];

// Test parallel fifths
~test_parallelFifths = Dictionary[
	\frtChord    -> [[48, 55, 64, 72], [41, 53, 60, 69], [41, 57, 65, 72], [43, 55, 62, 71], [43, 52, 64, 71], [53, 55, 64, 71]],
	\scdChordPLF -> [[[50, 57, 62, 65], [48, 55, 67, 76], [46, 62, 70, 77], [48, 57, 64, 69], [43, 55, 59, 74], [53, 57, 65, 72]], false], // Has parallel fifths
	\scdChordVAL -> [[[50, 53, 62, 69], [48, 55, 60, 64], [46, 58, 65, 74], [48, 57, 60, 64], [43, 59, 62, 71], [41, 57, 60, 65]], true]   // Progression is valid
];

~voiceData[\voiceRange];
// Test voice spacing
~test_voiceRange = Dictionary[
	\test00 -> [[[55, 52, 60, 72], [48, 67, 64, 72], [48, 60, 67, 64]], [true, false]],
	\test01 -> [[[55, 52, 60, 72], [48, 67, 64, 72], [48, 60, 67, 64]], [false, true]],
	\test02 -> [[[48, 55, 60, 64], [48, 55, 64, 72], [48, 60, 67, 76]], [true, true]],
	\test03 -> [[[48, 55, 60, 64], [48, 55, 64, 72], [48, 60, 67, 76]], [false, true]],
	\test04 -> [[[55, 48, 60, 64], [48, 67, 60, 76], [48, 64, 72, 67]], [true, false]],
	\test05 -> [[[55, 48, 60, 64], [48, 67, 60, 76], [48, 64, 72, 67]], [false, false]],
	\test06 -> [[[40, 67, 72, 76], [48, 55, 72, 76], [48, 55, 60, 76]], [true, false]],
	\test07 -> [[[40, 67, 72, 76], [48, 55, 72, 76], [48, 55, 60, 76]], [false, false]]
];

~test_CNDData = (
	\chordSetRD: (
		\message: "Chord Set #1: Root duplicate",
		\chords: [[48, 60, 64, 67], [48, 55, 60, 64], [48, 64, 67, 72], [52, 60, 72, 79], [52, 60, 67, 72], [52, 55, 60, 72]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],  // Expect: true
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],  // Expect: false
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],  // Expect: false
			[[true, true, true], false, "Test #4: Flags: RD true; TD true; FD true; ND false"]     // Expect: true
		],
		\expect: [true, false, false, true]    // Expected return for flags: [RD, TD, FD, ND]
	),
	\chordSetTD: (
		\message: "Chord Set #2: Third duplicate",
		\chords: [[40, 52, 60, 67], [40, 55, 64, 72], [40, 55, 60, 64], [48, 52, 64, 67], [48, 52, 55, 64], [48, 55, 64, 76]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],     // Expect: false
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],     // Expect: true
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],     // Expect: false
			[[false, false, false], false, "Test #4: Flags: RD false; TD false; FD false; ND false"]  // Expect: true
		],
		\expect: [false, true, false, true]    // Expected return for flags: [RD, TD, FD, ND]
	),
	\chordSetFD: (
		\message: "Chord Set #3: Fifth duplicate",
		\chords: [[43, 55, 60, 64], [43, 60, 67, 76], [43, 60, 64, 67], [48, 55, 67, 76], [48, 55, 64, 67], [48, 52, 55, 67]],
		\flags: [
			[[true, false, false], true, "Test #1: Flags: RD true; TD false; FD false; ND true"],    // Expect: false
			[[false, true, false], true, "Test #2: Flags: RD false; TD true; FD false; ND true"],    // Expect: false
			[[false, false, true], true, "Test #3: Flags: RD false; TD false; FD true; ND true"],    // Expect: true
			[[false, true, false], false, "Test #4: Flags: RD false; TD true; FD false; ND false"]   // Expect: true
		],
		\expect: [false, false, true, true]    // Expected return for flags: [RD, TD, FD, ND]
	)
);

~test_CCPData = Dictionary[
	\chords -> [
		[[48, 60, 64, 67], [60, 64, 67, 72]], // Root position
		[[40, 55, 64, 72], [52, 55, 60, 64]], // First inversion
		[[43, 55, 64, 72], [55, 60, 67, 76]]  // Second inversion
	],
	\flags -> [
		[[true, false, false], true],
		[[false, true, false], true],
		[[false, false, true], true],
		[[false, false, false], false]
	],
	\expect -> [
		[true, false, false, true],
		[false, true, false, true],
		[false, false, true, true]
	];
];
)

(
//~test_CCPSubroutine = {

~test_checkChordPosition = {
	var chords = ~test_CCPData[\chords];
	var expect = ~test_CCPData[\expect];
	var result = true;

	~chordState[\nextCipher] = 'CM';
	~chordData[\chordProg] = [['CM', 2]];
	~getChordDegreeArrays.();

	~test_CCPData[\flags].do { |f, i|
		var flagRP, flagFI, flagSI, flagCP;

		#flagRP, flagFI, flagSI = f[0];
		flagCP = f[1];

		~enforceChordPosition   = flagCP;
		~enforceRootPosition    = flagRP;
		~enforceFirstInversion  = flagFI;
		~enforceSecondInversion = flagSI;

		chords.do { |a|
			a. do { |c|
				result = result && ~checkChordPosition.(c).postln;
			};
			(result == expect[i]);
		};

		flagRP = flagFI = flagSI = nil;
		result = true;
		~resetRules.();
		nil;
 	}
};
~test_checkChordPosition.();
)

/*************************************************************************************/
// Test ~checkVoiceSpacing
(
~test_checkVoiceRange = {
	var flagTrue, flagFalse;
	var expTrue, expFalse;
	var result = true;

	(
		flagTrue = ~test_voiceRange[\test00][1][0];
		expFalse = ~test_voiceRange[\test00][1][1];

		~enforceVoiceCrossProhibition = flagTrue;

		~test_voiceRange[\test00][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expFalse) {
			"TEST #0 | expected: % got: % | PASSED".format(expFalse, result).postln;
		} {
			"TEST #0 | expected: % got: % | FAILED".format(expFalse, result).postln;
		};
	);
	flagTrue = nil; expFalse = nil; result = true;
	~resetRules.();

	(
		flagFalse = ~test_voiceRange[\test01][1][0];
		expTrue = ~test_voiceRange[\test01][1][1];

		~enforceVoiceCrossProhibition = flagFalse;

		~test_voiceRange[\test01][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expTrue) {
			"TEST #1 | expected: % got: % | PASSED".format(expTrue, result).postln;
		} {
			"TEST #1 | expected: % got: % | FAILED".format(expTrue, result).postln;
		};
	);
	flagFalse = nil; expTrue = nil; result = true;
	~resetRules.();

	(
		flagTrue = ~test_voiceRange[\test02][1][0];
		expTrue = ~test_voiceRange[\test02][1][1];

		~enforceVoiceCrossProhibition = flagTrue;

		~test_voiceRange[\test02][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expTrue) {
			"TEST #2 | expected: % got: % | PASSED".format(expTrue, result).postln;
		} {
			"TEST #2 | expected: % got: % | FAILED".format(expTrue, result).postln;
		};
	);
	flagTrue = nil; expTrue = nil; result = true;
	~resetRules.();

	(
		flagFalse = ~test_voiceRange[\test03][1][0];
		expTrue = ~test_voiceRange[\test03][1][1];

		~enforceVoiceCrossProhibition = flagFalse;

		~test_voiceRange[\test03][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expTrue) {
			"TEST #3 | expected: % got: % | PASSED".format(expTrue, result).postln;
		} {
			"TEST #3 | expected: % got: % | FAILED".format(expTrue, result).postln;
		};
	);
	flagFalse = nil; expTrue = nil; result = true;
	~resetRules.();

	(
		flagTrue = ~test_voiceRange[\test04][1][0];
		expFalse = ~test_voiceRange[\test04][1][1];

		~enforceVoiceCrossProhibition = flagTrue;

		~test_voiceRange[\test04][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expFalse) {
			"TEST #4 | expected: % got: % | PASSED".format(expFalse, result).postln;
		} {
			"TEST #4 | expected: % got: % | FAILED".format(expFalse, result).postln;
		};
	);
	flagTrue = nil; expFalse = nil; result = true;
	~resetRules.();

	(
		flagFalse = ~test_voiceRange[\test05][1][0];
		expFalse = ~test_voiceRange[\test05][1][1];

		~enforceVoiceCrossProhibition = flagFalse;

		~test_voiceRange[\test05][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expFalse) {
			"TEST #5 | expected: % got: % | PASSED".format(expFalse, result).postln;
		} {
			"TEST #5 | expected: % got: % | FAILED".format(expFalse, result).postln;
		};
	);
	flagFalse = nil; expFalse = nil; result = true;
	~resetRules.();

	(
		flagTrue = ~test_voiceRange[\test06][1][0];
		expFalse = ~test_voiceRange[\test06][1][1];

		~enforceVoiceCrossProhibition = flagTrue;

		~test_voiceRange[\test06][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expFalse) {
			"TEST #6 | expected: % got: % | PASSED".format(expFalse, result).postln;
		} {
			"TEST #6 | expected: % got: % | FAILED".format(expFalse, result).postln;
		};
	);
	flagFalse = nil; expFalse = nil; result = true;
	~resetRules.();

	(
		flagFalse = ~test_voiceRange[\test07][1][0];
		expFalse = ~test_voiceRange[\test07][1][1];

		~enforceVoiceCrossProhibition = flagFalse;

		~test_voiceRange[\test07][0].do { |c, i|
			result = result && ~checkVoiceSpacing.(c, (i + 1));
		};
		if (result == expFalse) {
			"TEST #7 | expected: % got: % | PASSED".format(expFalse, result).postln;
		} {
			"TEST #7 | expected: % got: % | FAILED".format(expFalse, result).postln;
		};
	);
	flagFalse = nil; expFalse = nil; result = true;
	~resetRules.();
	nil;
};
~test_checkVoiceRange.();
)

/*************************************************************************************/
// Test ~checkParallelOctaves
(
~test_checkParallelOctaves = {
	var expect, result = true;

	( // Test 00
		expect = ~test_parallelOctaves[\scdChordPLO][1];

		~test_parallelOctaves[\frtChord].do { |c, i|

			~chordState[\currChord] = c;
			result = result && ~checkParallelOctaves.(~test_parallelOctaves[\scdChordPLO][0][i]);
		};
		if (result == expect) {
			"TEST #0 | expected: % got: % | PASSED".format(expect, result).postln;
		} {
			"TEST #0 | expected: % got: % | FAILED".format(expect, result).postln;
		};
	);
	expect = nil; result = true;

	( // Test 01
		expect = ~test_parallelOctaves[\scdChordVAL][1];

		~test_parallelOctaves[\frtChord].do { |c, i|

			~chordState[\currChord] = c;
			result = result && ~checkParallelOctaves.(~test_parallelOctaves[\scdChordVAL][0][i]);
		};
		if (result == expect) {
			"TEST #1 | expected: % got: % | PASSED".format(expect, result).postln;
		} {
			"TEST #1 | expected: % got: % | FAILED".format(expect, result).postln;
		};
	);
	expect = nil; result = true;
	nil;
};
~test_checkParallelOctaves.();
)

/*************************************************************************************/
// Test ~checkParallelFifths
(
~test_checkParallelFifths = {
	var expect, result = true;

	// Test 00: Two chord progression containing parallel fifths
	(
		expect = ~test_parallelFifths[\scdChordPLF][1];

		~test_parallelFifths[\frtChord].do { |c, i|

			~chordState[\currChord] = c;
			result = result && ~checkParallelFifths.(~test_parallelFifths[\scdChordPLF][0][i]);
		};
		if (result == expect) {
			"TEST #0 | expected: % got: % | PASSED".format(expect, result).postln;
		} {
			"TEST #0 | expected: % got: % | FAILED".format(expect, result).postln;
		};

		~chordState[\currChord] = nil;
		expect = nil; result = true;
	);

	// Test 01: Two chord progression containing no parallel fifths
	(
		expect = ~test_parallelFifths[\scdChordVAL][1];

		~test_parallelFifths[\frtChord].do { |c, i|

			~chordState[\currChord] = c;
			result = result && ~checkParallelFifths.(~test_parallelFifths[\scdChordVAL][0][i]);
		};
		if (result == expect) {
			"TEST #1 | expected: % got: % | PASSED".format(expect, result).postln;
		} {
			"TEST #1 | expected: % got: % | FAILED".format(expect, result).postln;
		};

		~chordState[\currChord] = nil;
		expect = nil; result = true;
		nil;
	);
};
~test_checkParallelFifths.();
)

/*************************************************************************************/
// Test Note Duplicates
(
~test_CNDSubroutine = { |dict|
	var result = true;
	var chords = dict[\chords];
	var expect = dict[\expect];

	dict[\flags]. do { |f, i|
		var flagRD, flagTD, flagFD, flagND;

		#flagRD, flagTD, flagFD = f[0];
		flagND = f[1];

		~enforceNoteDuplicate  = flagND;
		~enforceRootDuplicate  = flagRD;
		~enforceThirdDuplicate = flagTD;
		~enforceFifthDuplicate = flagFD;

		chords.do { |c|
			result = result && ~checkNoteDuplicate.(c);
		};
		if (result == expect[i]) {
			"TEST #% | expected: % got: % | PASSED".format(i, expect[i], result).postln;
		} {
			"TEST #% | expected: % got: % | FAILED".format(i, expect[i], result).postln;
		};
		flagRD = flagTD = flagFD = flagND = nil;
		result = true;
		~resetRules.();
 	};
	nil;
};

~test_checkNoteDuplicate = {
	var result;

	"\nTEST : ~checkNoteDuplicate".format().postln;

	~chordState[\nextCipher] = 'CM';
	~chordData[\chordProg] = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 2]];
	~getChordDegreeArrays.();

	~test_CNDData.do { |dict|

		"\n%\n".format(dict[\message]).postln;
		~test_CNDSubroutine.(dict);
	};
	nil;
};

~test_checkNoteDuplicate.();
)

~test_CNDData[\chordSetRD][\chords][0]
~test_CNDData[\chordSetRD][\flags]



(
~e = IdentityDictionary[
	\a -> 1,
	\b -> 2,
	\c -> 3
];
~e.do { |i| i.postln };
)














