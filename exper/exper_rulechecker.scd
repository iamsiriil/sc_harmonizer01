// Test fixtures
(
// Test parallel octaves
~currChordPO = [[41, 53, 60, 69], [41, 57, 65, 72], [41, 57, 60, 65], [43, 52, 64, 71], [43, 52, 59, 64], [40, 55, 60, 72]];
~nextChordPO = [[48, 60, 64, 67], [48, 55, 72, 76], [48, 55, 64, 72], [40, 55, 67, 72], [48, 55, 64, 67], [48, 57, 65, 77]];
~nextChordPOValid =[[48, 52, 60, 67], [48, 55, 64, 72], [48, 55, 60, 64], [48, 55, 64, 72], [48, 55, 60, 64], [41, 53, 60, 69]];

// Test parallel fifths
~currChordPF = [[48, 55, 64, 72], [41, 53, 60, 69], [41, 57, 65, 72], [43, 55, 62, 71], [43, 52, 64, 71], [53, 55, 64, 71]];
~nextChordPF = [[50, 57, 62, 65], [48, 55, 67, 76], [46, 62, 70, 77], [48, 57, 64, 69], [43, 55, 59, 74], [53, 57, 65, 72]];
~nextChordPFValid =[[50, 53, 62, 69], [48, 55, 60, 64], [46, 58, 65, 74], [48, 57, 60, 64], [43, 59, 62, 71], [41, 57, 60, 65]];

// Test note duplication
~chordData = Dictionary[
	\chords -> Dictionary[
		\CM -> OrderedIdentitySet[[0, "Rt"], [4, "M3"], [7, "P5"], [12, "Rt"], [16, "M3"], [19, "P5"], [24, "Rt"], [28, "M3"], [31, "P5"], [36, "Rt"], [40, "M3"], [43, "P5"], [48, "Rt"], [52, "M3"], [55, "P5"], [60, "Rt"], [64, "M3"], [67, "P5"], [72, "Rt"], [76, "M3"], [79, "P5"], [84, "Rt"], [88, "M3"], [91, "P5"], [96, "Rt"], [100, "M3"], [103, "P5"], [108, "Rt"], [112, "M3"], [115, "P5"], [120, "Rt"], [124, "M3"], [127, "P5"]]
	],
	\progretion -> ['CM'],
	\nextHarmony -> 'CM'
];

~nextChordRD = [[48, 60, 64, 67], [48, 55, 60, 64], [48, 64, 67, 72], [52, 60, 72, 79], [52, 60, 67, 72], [52, 55, 60, 72]]; // Duplicate root
~nextChord3D = [48, 63, 67, 75]; // Duplicate third
~nextChord5D = [48, 55, 63, 67]; // Duplicate fifth

// Test voice cross
~nextChordVC =[[48, 60, 55, 67], [48, 55, 64, 72], [48, 55, 60, 64], [48, 55, 64, 72], [48, 55, 60, 64], [41, 53, 60, 69]];
)

/*************************************************************************************************************************/
// Check range between voices
// I can test voice crossing by enforcing a lower bound: 0 no voice crossing; < 0 voice crossing
(
~checkVoiceRange = { |nextChord, note, i|
	var cross, voice, n;

	if (i > 0) {
		voice = ~voiceData[\voiceNames][i];
		n = (nextChord[i] - nextChord[i - 1]);

		cross = if (~enforceVoiceCrossProhibition == true) {
			(n >= 0);
		} {
			(n < 0) && (nextChord[i] >= ~voiceData[\voiceRange][voice][0]);
		};

		switch(i)
		{ 1 } { cross && (n <= 24) }
		{ 2 } { cross && (n <= 12) }
		{ 3 } { cross && (n <= 12) }
	} {
		true
	}
};
~enforceVoiceCrossProhibition = true;

~checkVoiceRange.(~nextChordVC[0], 2);
)

// Bench test function
{ 10000.do { ~checkVoiceRange.(~nextChordPOValid[0], 2) } }.bench;

/*************************************************************************************************************************/
// Check for parallel octaves
(
~checkParallelOctaves = { |currChord, nextChord, numVoices|
	var index, result;
	var octaves = [12, 24, 36, 48, 60];

	var i = 0, j;
	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			octaves.do { |oct|
				if ((currChord[j] - currChord[i]) == oct) { index = [i, j] };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	result = (
		(currChord[index[1]] - currChord[index[0]]) ==
		(nextChord[index[1]] - nextChord[index[0]])
	);
	result.not;
};
// Test two chords
~checkParallelOctaves.(~currChordPO[2], ~nextChordPO[2], 4);
)

// Bench test the function
{ 1000.do { ~checkParallelOctaves.(~currChordPO[2], ~nextChordPO[2], 4) } }.bench;

// Test entire chord arrays and compare output to ~octavesAt.
(
~currChordPO.do { |n, i|
	(~checkParallelOctaves.(n, ~nextChordPOValid[i], 4)).postln;
};
)

/*************************************************************************************************************************/
// Check for parallel fifths
(
~checkParallelFifths = { |currChord, nextChord, numVoices|
	var index = Array.new(4), result = false;
	var fifths = [7, 19, 31, 43, 55];

	var i = 0, j;
	while {i < (numVoices - 1)} {

		j = i + 1;
		while {j < numVoices} {

			fifths.do { |n|
				if ((currChord[j] - currChord[i]) == n) { index.add([i, j]) };
			};
			j = j + 1;
		};
		i = i + 1;
	};
	index.do { |i|
		result = result ||
		((currChord[i[1]] - currChord[i[0]]) ==
		(nextChord[i[1]] - nextChord[i[0]]));
	};
	result.not;
};
// Test two chords
~checkParallelFifths.(~currChordPF[1], ~nextChordPF[1], 4);
)

// Bench test function
{ 10000.do({ ~checkParallelFifths.(~currChordPF[1], ~nextChordPF[1], 4); }) }.bench;

// Test entire chord arrays.
(
~currChordPF.do { |n, i|
	(~checkParallelFifths.(n, ~nextChordPF[i], 4)).postln;
};
)

/*************************************************************************************************************************/
// Check root duplication
(
~checkNoteDuplicate = { |nextChord|
	var chord, chordDegree, numRoot;

	chord = ~chordData[\chords][~chordData[\nextHarmony]];
	chordDegree = chord.select({ |item|
		(item[0] == nextChord[0]) ||
		(item[0] == nextChord[1]) ||
		(item[0] == nextChord[2]) ||
		(item[0] == nextChord[3])
	});

	ocase
	{ ~enforceRootDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 2)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforceThirdDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 2) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 1)
	}
	{ ~enforceFifthDuplicate == true } {
		(chordDegree.count({ |item| item[1] == "Rt" }) == 1)       &&
		(chordDegree.count({ |item| item[1].contains("3") }) == 1) &&
		(chordDegree.count({ |item| item[1].contains("5") }) == 2)
	}
};

~enforceNoteDuplicate = true;

// Enforcement flags: 1 true to 2 false
~enforceRootDuplicate = false;
~enforceThirdDuplicate = true;
~enforceFifthDuplicate =  false;

// Test root duplicate
~checkRootDuplicat.(~nextChordRD[]);
)

// Bench test function
{ 1000.do{ ~checkRootDuplicat.(~nextChordRD[2]) } }.bench

/*************************************************************************************************************************/
// Get valid notes and enforce common tone in same voice
(
// In harmony_00
~getValidNotes = {
	arg nextChord, currentNote;
	var allowedIntervals = [0, 1, 2, 3, 4, 5, 7];
	nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };
};

~getValidNotes = { |nextChord|
	...
	if (~enforceCommonTone == true)

};
)

/*************************************************************************************************************************/
// Final check8 before chord gets added to validNextChord array
(
~chordIsValid = { |currChord, nextChord, numVoices|
	(
		(
			if (~enforceNoteDuplicate == true) {
				~checkNoteDuplicate.(nextChord)
			} { true }
		) &&
		(
			if (~enforceParallelOctaves == true) {
				~checkParallelOctaves.(currChord, nextChord, numVoices)
			} { true }
		) &&
		(
			if (~enforceParallelFifths == true) {
				~checkParallelFifths.(currChord, nextChord, numVoices)
			} { true }
		)
	)
};
)

/*************************************************************************************************************************/
// Toggle rules
(
~toggleCount = 0;

~toggleRules = { |count|
	switch (count)
	{ 0 } {}
	{ 1 } {}
	{ 2 } {}
	{ 3 }
};
)

/*************************************************************************************************************************/
// Reset rules
(
~resetRules = {

};
)

















