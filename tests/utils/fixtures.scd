/**************************************************************************************
- HARMONY 01 / Test fixtures: Range
**************************************************************************************/
(
// Chord progressions for ~getChordDegreePairs and ~getChordDegreeArrays

~test_GCDFixture = [
	['CM'],
	['CM', 'FM', 'GM', 'CM'],
	['F#m', 'EM', 'DbA', 'Bm', 'Ed', 'F#m'],
	['Ebm', 'Gm', 'BA', 'BbM', 'Dm', 'Ebm'],
	['AbM', 'C#m', 'EbM', 'Bm', 'Gd', 'G#m']
];

/*************************************************************************************/
// ~getVocalChordRange
// Returns an array of single chord progressions, with all the triads

~test_GCVRFixtures = [
	['Cd'], ['Cm'], ['CM'], ['CA'],
	['C#d'],['C#m'],['DbM'],['DbA'],
	['Dd'], ['Dm'], ['DM'], ['DA'],
	['Ebd'],['Ebm'],['EbM'],['EbA'],
	['Ed'], ['Em'], ['EM'], ['EA'],
	['Fd'], ['Fm'], ['FM'], ['FA'],
	['F#d'],['F#m'],['F#M'],['F#A'],
	['Gd'], ['Gm'], ['GM'], ['GA'],
	['G#d'],['G#m'],['AbM'],['AbA'],
	['Ad'], ['Am'], ['AM'], ['AA'],
	['Bbd'],['Bbm'],['BbM'],['BbA'],
	['Bd'], ['Bm'], ['BM'], ['BA']
];

/*************************************************************************************/
// ~resolveMelodicInterval

~test_RMIFixtures = (
	\00: (
		\chord: [48, 55, 60, 64],
		\chordProg: ['CM', 'DM'],
		\exclude: [
			OrderedIdentitySet[42, 54, 57, 62],
			OrderedIdentitySet[66, 69],
			OrderedIdentitySet[66, 69, 74],
			OrderedIdentitySet[74, 78, 81]]
	),
	\01: (
		\chord: [50, 57, 62, 66],
		\chordProg: ['DM', 'Cm'],
		\exclude: [
			OrderedIdentitySet[60],
			OrderedIdentitySet[48, 51, 63, 67],
			OrderedIdentitySet[72, 75],
			OrderedIdentitySet[60, 72, 75, 79]]
	),
	\02: (
		\chord: [40, 59, 67, 76],
		\chordProg: ['Em', 'Ebm'],
		\exclude: [
			OrderedIdentitySet[46, 51, 54, 58],
			OrderedIdentitySet[51],
			OrderedIdentitySet[58, 75],
			OrderedIdentitySet[63, 66, 70]]
	),
	\03: (
		\chord: [58, 65, 74, 77],
		\chordProg: ['BbM', 'Cd'],
		\exclude: [
			OrderedIdentitySet[42, 48],
			OrderedIdentitySet[48, 51, 54],
			OrderedIdentitySet[60, 63, 66],
			OrderedIdentitySet[60, 63, 66]]
	),
	\04: (
		\chord: [60, 67, 72, 76],
		\chordProg: ['CM', 'DM'],
		\exclude: [
			OrderedIdentitySet[42, 45, 50, 54],
			OrderedIdentitySet[50, 54, 57],
			OrderedIdentitySet[57, 62, 66],
			OrderedIdentitySet[62, 66]]
	),
	\05: (
		\chord: [57, 62, 62, 65],
		\chordProg: ['Dm', 'C#m'],
		\exclude: [
			OrderedIdentitySet[40, 44, 49],
			OrderedIdentitySet[49, 52, 56, 68],
			OrderedIdentitySet[56, 68, 73, 76],
			OrderedIdentitySet[73, 76, 80]]
	),
	\06: (
		\chord: [60, 64, 67, 72],
		\chordProg: ['CM', 'F#M'],
		\exclude: [
			OrderedIdentitySet[42, 46, 49, 54],
			OrderedIdentitySet[49, 54, 58],
			OrderedIdentitySet[58, 61, 73],
			OrderedIdentitySet[61, 66, 78]]
	)
);

/*************************************************************************************/
// ~resolveCommonTone

~test_RCTFixtures = (
	\00: (
		\message: "CT: ten, alt",
		\chord: [48, 55, 64, 72],
		\chordProg: ['CM', 'Em'],
		\functions: [(_ > 1), (_ == 1), (_ == 1), (_ > 1)]
	),
	\01: (
		\message: "CT: ten, spn",
		\chord: [48, 55, 60, 64],
		\chordProg: ['CM', 'Em'],
		\functions: [(_ > 1), (_ == 1), (_ > 1), (_ == 1)]
	),
	\02: (
		\message: "CT: alt, spn",
		\chord: [48, 60, 67, 76],
		\chordProg: ['CM', 'Em'],
		\functions: [(_ > 1), (_ > 1), (_ == 1), (_ == 1)]
	),
	\03: (
		\message: "CT: ten",
		\chord: [48, 60, 64, 67],
		\chordProg: ['CM', 'FM'],
		\functions: [(_ > 1), (_ == 1), (_ > 1), (_ > 1)]
	),
	\04: (
		\message: "CT: alt",
		\chord: [48, 55, 60, 64],
		\chordProg: ['CM', 'FM'],
		\functions: [(_ > 1), (_ > 1), (_ == 1), (_ > 1)]
	),
	\05: (
		\message: "CT: spn",
		\chord: [48, 55, 64, 72],
		\chordProg: ['CM', 'FM'],
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

/**************************************************************************************
- HARMONY 01 / Test fixtures: Backtrack
**************************************************************************************/

~getProgression = { |triads|
	var prog = Array.new(triads.keys.size);

	triads.keys.do { |k|
		//var temp = [k, 1];
		prog.add(k);
	};
	prog;
};

~test_GNCFixtures = (
	\ciphers : [
		'Cd', 'Cm', 'CM', 'CA',
		'C#d','C#m','DbM','DbA',
		'Dd', 'Dm', 'DM', 'DA',
		'Ebd','Ebm','EbM','EbA',
		'Ed', 'Em', 'EM', 'EA',
		'Fd', 'Fm', 'FM', 'FA',
		'F#d','F#m','F#M','F#A',
		'Gd', 'Gm', 'GM', 'GA',
		'G#d','G#m','AbM','AbA',
		'Ad', 'Am', 'AM', 'AA',
		'Bbd','Bbm','BbM','BbA',
		'Bd', 'Bm', 'BM', 'BA'
	],
	\flags: [
		\enforceVoiceCrossProhibition,
		\enforceMelodicIntervals,
		\enforceVocalRange,
		\enforceCommonTones,
		\enforceParallelOctaves,
		\enforceParallelFifths,
		\enforceNoteDuplicate,
		\enforceChordPosition
	],
	\firstChords : (
		'Cd' :[[60, 63, 66, 72], [48, 60, 66, 75]],
		'Cm' :[[60, 63, 67, 72], [48, 60, 67, 75]],
		'CM' :[[60, 64, 67, 72], [48, 60, 67, 76]],
		'CA' :[[60, 64, 68, 72], [48, 60, 68, 76]],
		'C#d':[[49, 52, 55, 61], [49, 61, 67, 76]],
		'C#m':[[49, 52, 56, 61], [49, 61, 68, 76]],
		'C#M':[[49, 53, 56, 61], [49, 61, 68, 77]],
		'C#A':[[49, 53, 57, 61], [49, 61, 69, 77]],
		'Dd' :[[50, 53, 56, 62], [50, 62, 68, 77]],
		'Dm' :[[50, 53, 57, 62], [50, 62, 69, 77]],
		'DM' :[[50, 54, 57, 62], [50, 62, 69, 78]],
		'DA' :[[50, 54, 58, 62], [50, 62, 70, 78]],
		'Ebd':[[51, 54, 57, 63], [51, 63, 69, 78]],
		'Ebm':[[51, 54, 58, 63], [51, 63, 70, 78]],
		'EbM':[[51, 55, 58, 63], [51, 63, 70, 79]],
		'EbA':[[51, 55, 59, 63], [51, 63, 71, 79]],
		'Ed' :[[52, 55, 58, 64], [52, 64, 70, 79]],
		'Em' :[[52, 55, 59, 64], [52, 64, 71, 79]],
		'EM' :[[52, 56, 59, 64], [52, 64, 71, 80]],
		'EA' :[[52, 56, 60, 64], [52, 64, 72, 80]],
		'Fd' :[[53, 56, 59, 65], [53, 65, 71, 80]],
		'Fm' :[[53, 56, 60, 65], [53, 65, 72, 80]],
		'FM' :[[53, 57, 60, 65], [53, 65, 72, 81]],
		'FA' :[[53, 57, 61, 65], [53, 65, 73, 81]],
		'F#d':[[54, 57, 60, 66], [42, 57, 66, 72]],
		'F#m':[[54, 57, 61, 66], [42, 57, 66, 73]],
		'F#M':[[54, 58, 61, 66], [42, 58, 66, 73]],
		'F#A':[[54, 58, 62, 66], [42, 58, 66, 74]],
		'Gd' :[[55, 58, 61, 67], [43, 58, 67, 73]],
		'Gm' :[[55, 58, 62, 67], [43, 58, 67, 74]],
		'GM' :[[55, 59, 62, 67], [43, 59, 67, 74]],
		'GA' :[[55, 59, 63, 67], [43, 59, 67, 75]],
		'G#d':[[56, 59, 62, 68], [44, 59, 68, 74]],
		'G#m':[[56, 59, 63, 68], [44, 59, 68, 75]],
		'AbM':[[56, 60, 63, 68], [44, 60, 68, 75]],
		'AbA':[[56, 60, 64, 68], [44, 60, 68, 76]],
		'Ad' :[[57, 60, 63, 69], [45, 60, 69, 75]],
		'Am' :[[57, 60, 64, 69], [45, 60, 69, 76]],
		'AM' :[[57, 61, 64, 69], [45, 61, 69, 76]],
		'AA' :[[57, 61, 65, 69], [45, 61, 69, 77]],
		'Bbd':[[58, 61, 64, 70], [46, 61, 70, 76]],
		'Bbm':[[58, 61, 65, 70], [46, 61, 70, 77]],
		'BbM':[[58, 62, 65, 70], [46, 62, 70, 77]],
		'BbA':[[58, 62, 66, 70], [46, 62, 70, 78]],
		'Bd' :[[59, 62, 65, 71], [47, 62, 71, 77]],
		'Bm' :[[59, 62, 66, 71], [47, 62, 71, 78]],
		'BM' :[[59, 63, 66, 71], [47, 63, 71, 78]],
		'BA' :[[59, 63, 67, 71], [47, 63, 71, 79]]
	)
);

/**************************************************************************************
- HARMONY 01 / Test fixtures: Validators
**************************************************************************************/

~test_TAFixtures = Dictionary[
	\prog -> [
		[List['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", true, false, false], // Must be of type Array
		[[], [1, 1, 1, 1], "line", true, false, false],                           // Must not be empty
		[['CM', "FM", 'GM', 'CM'], [1, 1, 1, 1], "line", true, false, false],     // Must contain Symbols
		[['CX', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", true, false, false]      // Symbols must be valid
	],
	\dur -> [
		[['CM', 'FM', 'GM', 'CM'], List[1, 1, 1, 1], "line", true, false, false], // Must be of type Array
		[['CM', 'FM', 'GM', 'CM'], [], "line", true, false, false],               // Must not be empty
		[['CM', 'FM', 'GM', 'CM'], [1, "1", 1, 1], "line", true, false, false],   // Must contain numbers
		[['CM', 'FM', 'GM', 'CM'], [0, 1, 1, 1], "line", true, false, false]      // Numbers must be greater than 0
	],
	\dir -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], ["line"], true, false, false],   // Must be of type String
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "curve", true, false, false]     // String must be valid
	],
	\sus -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", "true", false, false]    // Must be of type Boolean
	],
	\scr -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", true, "false", false]    // Must be of type Boolean
	],
	\log -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", true, false, "false"]    // Must be of type Boolean
	],
	\progdur -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1], "line", true, false, false]         // Progression and durations must be of same size
	],
	\pass -> [
		[['CM', 'FM', 'GM', 'CM'], [1, 1, 1, 1], "line", true, false, false]      // Valid arguments
	]
];
)