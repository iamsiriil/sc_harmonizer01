(
// Returns an array of single chord progressions, with all the triads
~test_GVCRFixtures = { |triads|
	var prog = Array.new(triads.keys.size);

	triads.keys.do { |k|
		var temp = [[k, 1]];
		prog.add(temp);
	};
	prog;
};

~test_RMIFixtures = [
	[
		[['CM', 1], ['DM', 1]],
		[48, 55, 60, 64],
		[
			OrderedIdentitySet[42, 54],
			OrderedIdentitySet[66],
			OrderedIdentitySet[66],
			OrderedIdentitySet[74]
		]
	],
	[
		[['DM', 1], ['Cm', 1]],
		[50, 57, 62, 66],
		[
			OrderedIdentitySet[60],
			OrderedIdentitySet[51, 63, 67],
			OrderedIdentitySet[72],
			OrderedIdentitySet[60, 72]
		]
	],
	[
		[['Em', 1], ['Ebm', 1]],
		[40, 59, 67, 76],
		[
			OrderedIdentitySet[46, 51, 58],
			OrderedIdentitySet[],
			OrderedIdentitySet[],
			OrderedIdentitySet[66, 70]
		]
	],
	[
		[['BbM', 1], ['Cd', 1]],
		[58, 65, 74, 77],
		[
			OrderedIdentitySet[48],
			OrderedIdentitySet[54],
			OrderedIdentitySet[63],
			OrderedIdentitySet[66]
		]
	],
	[
		[['CM', 1], ['DM', 1]],
		[60, 67, 72, 76],
		[
			OrderedIdentitySet[42, 50, 54],
			OrderedIdentitySet[57],
			OrderedIdentitySet[62, 66],
			OrderedIdentitySet[66]
		]
	],
	[
		[['Dm', 1], ['C#m', 1]],
		[57, 62, 62, 65],
		[
			OrderedIdentitySet[],
			OrderedIdentitySet[52, 56],
			OrderedIdentitySet[56, 68, 73],
			OrderedIdentitySet[76]
		]
	],
	[
		[['CM', 1], ['F#M', 1]],
		[60, 64, 67, 72],
		[
			OrderedIdentitySet[42, 49,54],
			OrderedIdentitySet[54, 58],
			OrderedIdentitySet[61, 73],
			OrderedIdentitySet[61, 66, 78]
		]
	]
];
)