/**************************************************************************************
- HARMONY 01 / Test fixtures: Range
**************************************************************************************/
(
// Chord progressions for ~getChordDegreePairs and ~getChordDegreeArrays

~test_GCDFixture = [
	[['CM', 2]],
	[['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]],
	[['F#m', 1], ['EM', 1], ['C#A', 1], ['Bm', 2], ['Ed', 1], ['F#m']],
	[['Ebm', 1], ['Gm', 1], ['BA', 1], ['BbM', 2], ['Dm', 1], ['Ebm']],
	[['AbM', 1], ['C#m', 1], ['EbM', 1], ['Bm', 2], ['Gd', 1], ['G#m']]
];

/*************************************************************************************/
// ~getVocalChordRange
// Returns an array of single chord progressions, with all the triads

~test_GVCRFixtures = { |triads|
	var prog = Array.new(triads.keys.size);

	triads.keys.do { |k|
		var temp = [[k, 1]];
		prog.add(temp);
	};
	prog;
};

/*************************************************************************************/
// ~resolveMelodicInterval

~test_RMIFixtures = (
	\00: (
		\chord: [48, 55, 60, 64],
		\chordProg: [['CM', 1], ['DM', 1]],
		\exclude: [
			OrderedIdentitySet[42, 54],
			OrderedIdentitySet[66],
			OrderedIdentitySet[66],
			OrderedIdentitySet[74]]
	),
	\01: (
		\chord: [50, 57, 62, 66],
		\chordProg: [['DM', 1], ['Cm', 1]],
		\exclude: [
			OrderedIdentitySet[60],
			OrderedIdentitySet[51, 63, 67],
			OrderedIdentitySet[72],
			OrderedIdentitySet[60, 72]]
	),
	\02: (
		\chord: [40, 59, 67, 76],
		\chordProg: [['Em', 1], ['Ebm', 1]],
		\exclude: [
			OrderedIdentitySet[46, 51, 58],
			OrderedIdentitySet[],
			OrderedIdentitySet[],
			OrderedIdentitySet[66, 70]]
	),
	\03: (
		\chord: [58, 65, 74, 77],
		\chordProg: [['BbM', 1], ['Cd', 1]],
		\exclude: [
			OrderedIdentitySet[48],
			OrderedIdentitySet[54],
			OrderedIdentitySet[63],
			OrderedIdentitySet[66]]
	),
	\04: (
		\chord: [60, 67, 72, 76],
		\chordProg: [['CM', 1], ['DM', 1]],
		\exclude: [
			OrderedIdentitySet[42, 50, 54],
			OrderedIdentitySet[57],
			OrderedIdentitySet[62, 66],
			OrderedIdentitySet[66]]
	),
	\05: (
		\chord: [57, 62, 62, 65],
		\chordProg: [['Dm', 1], ['C#m', 1]],
		\exclude: [
			OrderedIdentitySet[],
			OrderedIdentitySet[52, 56],
			OrderedIdentitySet[56, 68, 73],
			OrderedIdentitySet[76]]
	),
	\06: (
		\chord: [60, 64, 67, 72],
		\chordProg: [['CM', 1], ['F#M', 1]],
		\exclude: [
			OrderedIdentitySet[42, 49,54],
			OrderedIdentitySet[54, 58],
			OrderedIdentitySet[61, 73],
			OrderedIdentitySet[61, 66, 78]]
	)
);

/*************************************************************************************/
// ~resolveCommonTone

~test_RCTFixtures = (
	\00: (
		\message: "CT: ten, alt",
		\chord: [48, 55, 64, 72],
		\chordProg: [['CM', 1], ['Em', 1]],
		\functions: [(_ > 1), (_ == 1), (_ == 1), (_ > 1)]
	),
	\01: (
		\message: "CT: ten, spn",
		\chord: [48, 55, 60, 64],
		\chordProg: [['CM', 1], ['Em', 1]],
		\functions: [(_ > 1), (_ == 1), (_ > 1), (_ == 1)]
	),
	\02: (
		\message: "CT: alt, spn",
		\chord: [48, 60, 67, 76],
		\chordProg: [['CM', 1], ['Em', 1]],
		\functions: [(_ > 1), (_ > 1), (_ == 1), (_ == 1)]
	),
	\03: (
		\message: "CT: ten",
		\chord: [48, 60, 64, 67],
		\chordProg: [['CM', 1], ['FM', 1]],
		\functions: [(_ > 1), (_ == 1), (_ > 1), (_ > 1)]
	),
	\04: (
		\message: "CT: alt",
		\chord: [48, 55, 60, 64],
		\chordProg: [['CM', 1], ['FM', 1]],
		\functions: [(_ > 1), (_ > 1), (_ == 1), (_ > 1)]
	),
	\05: (
		\message: "CT: spn",
		\chord: [48, 55, 64, 72],
		\chordProg: [['CM', 1], ['FM', 1]],
		\functions: [(_ > 1), (_ > 1), (_ > 1), (_ == 1)]
	)
);

/**************************************************************************************
- HARMONY 01 / Test fixtures: Rules
**************************************************************************************/
// ~checkChordPosition

~test_CCPFixtures = (
	\chords: [
		[[48, 60, 64, 67], [60, 64, 67, 72]], // Root position
		[[40, 55, 64, 72], [52, 55, 60, 64]], // First inversion
		[[43, 55, 64, 72], [55, 60, 67, 76]]  // Second inversion
	],
	\flags: [
		[[true, false, false], true],
		[[false, true, false], true],
		[[false, false, true], true],
		[[false, false, false], false]
	],
	\expect: [
		[true, false, false, true],
		[false, true, false, true],
		[false, false, true, true]
	];
);

/*************************************************************************************/
// ~checkVoiceRange

~test_CVRFixtures = (
	\00: [[[55, 52, 60, 72], [48, 67, 64, 72], [48, 60, 67, 64]], [true, false]],
	\01: [[[55, 52, 60, 72], [48, 67, 64, 72], [48, 60, 67, 64]], [false, true]],
	\02: [[[48, 55, 60, 64], [48, 55, 64, 72], [48, 60, 67, 76]], [true, true]],
	\03: [[[48, 55, 60, 64], [48, 55, 64, 72], [48, 60, 67, 76]], [false, true]],
	\04: [[[55, 48, 60, 64], [48, 67, 60, 76], [48, 64, 72, 67]], [true, false]],
	\05: [[[55, 48, 60, 64], [48, 67, 60, 76], [48, 64, 72, 67]], [false, false]],
	\06: [[[40, 67, 72, 76], [48, 55, 72, 76], [48, 55, 60, 76]], [true, false]],
	\07: [[[40, 67, 72, 76], [48, 55, 72, 76], [48, 55, 60, 76]], [false, false]]
);

/*************************************************************************************/
// ~checkParallelOctaves

~test_CPOFixtures = (
	\fChord:    [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]],
	\sChordPO: [[[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]], false], // Has parallel octaves
	\sChordVL: [[[48, 52, 60, 67], [48, 55, 64, 72], [48, 55, 60, 64], [48, 55, 64, 72], [48, 55, 60, 64], [41, 53, 60, 69]], true]   // Progression is valid
);

/*************************************************************************************/
// Test parallel fifths

~test_CPFFixtures = (
	\fChord:    [[48, 55, 64, 72], [41, 53, 60, 69], [41, 57, 65, 72], [43, 55, 62, 71], [43, 52, 64, 71], [53, 55, 64, 71]],
	\sChordPF: [[[50, 57, 62, 65], [48, 55, 67, 76], [46, 62, 70, 77], [48, 57, 64, 69], [43, 55, 59, 74], [53, 57, 65, 72]], false], // Has parallel fifths
	\sChordVL: [[[50, 53, 62, 69], [48, 55, 60, 64], [46, 58, 65, 74], [48, 57, 60, 64], [43, 59, 62, 71], [41, 57, 60, 65]], true]   // Progression is valid
);

/*************************************************************************************/
// Test Note Duplicates

~test_CNDFixtures = (
	\00: (
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
	\01: (
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
	\02: (
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
)