// SET

// Get midi range
(
~midiRange = Set.newFrom((1..127));
)

// Get bass Range from midi range
(
~bass = ~midiRange.select({ |n| (n >= ~voices[\voiceRange][0][0]) && (n <= ~voices[\voiceRange][0][1]) });
~bass;
)

// Get chord notes for vocal range
(
~bassChord = (~triads[\Cd][\notes] & ~bass); // union of two sets
)

// 3. Get chord within voice range with degree


/******************************************************************************************/
// ARRAY

// Get midi range
(
~midiRangeArray = (0..127);
)

// Get bass Range from midi range
(
~bassArray = ~midiRangeArray.select({ |n| (n >= ~voices[\voiceRange][0][0]) && (n <= ~voices[\voiceRange][0][1]) })
)

// Get chord notes for vocal range
(
~bassChordArray = (~triads[\Cd][\notes].select({ |n| (n >= ~voices[\voiceRange][0][0]) && (n <= ~voices[\voiceRange][0][1]) })).asArray
)

// Map degree to chord range
(
~degreeChordArray = ~triads[\Cd][\degree].wrapExtend(~triads[\Cd][\notes].size);

// Map as dictionary
~cdimChordDict = Dictionary[
	\notes -> ~triads[\Cd][\notes].asArray,
	\degree ->~degreeChordArray
];
"Dictionary | Note: % has degree: %".format(~cdimChord[\notes][23], ~cdimChord[\degree][23]).postln;

// Map as 2D Array
~cdimChordArray = Array.newFrom([~triads[\Cd][\notes].asArray, ~degreeChordArray]);
"Array | Note: % has degree: %".format(~cdimChordArray[0][23], ~cdimChordArray[1][23]).postln;

// Check if note is root degree using dictionary
~isRootDic = { |chord, index|
	if (chord[\degree][index] == "Rt") { true } { false }
};

~isRootDic.(~cdimChordDict, 21);
)































