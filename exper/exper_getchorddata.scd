os.boot;

/**************************************************************************************
- HARMONY 01 / Experiment / Get chord data
**************************************************************************************/
// Data Structures
(
~voiceData = Dictionary[
	\voiceRange -> Dictionary[
		\bas -> [40, 60],
		\ten -> [48, 67],
		\alt -> [55, 74],
		\spn -> [60, 81]
	],
	\validIntervals -> Dictionary[
		\bas -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12, 13, 14,15, 16, 17, 19, 20, 21, 24],
		\ten -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\alt -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12],
		\spn -> [0, 1, 2, 3, 4, 5, 7, 8, 9, 12]
	],
	\numVoices -> 4,
	\voiceNames -> ['bas', 'ten', 'alt', 'spn']
];

~chordData = Dictionary[
	\chords -> nil,
	\chordProg -> nil,
	\nextCipher -> nil
];

~chordState = Dictionary[
	\currChord -> Array.new(),
	\nextChord -> Array.fill(4, {0}),
	\validNotes ->  nil,
	\nextValidChords -> OrderedIdentitySet.fill(50, {[]}),
	\nextCipher -> nil;
];
)


/*************************************************************************************/
// Get chords from chord progression as note - degree pairs
(
~chordProg = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]];

~getChordDegreePairs = { |chordProg|
	var chords, dict;

	chords = chordProg.collect { |c| c[0] };    // Separate ciphers from durations
	chords.asSet;                               // Remove duplicates

	dict = Dictionary.new();

	chords.do { |c|
		var notes;

		notes = (~triads[c][\notes]) +++ ~triads[c][\degree].bubble(1);
		dict[c] = notes;
	};
	dict;
};

~chordData[\chords] = ~getChordDegreePairs.(~chordProg);
//~chordData[\progression] = ~getChordDegreePairs;
~chordData[\chords];
)

/*************************************************************************************/
// Get chord notes and degrees as separate arrays
(
~chordProg = [['CM', 2], ['FM', 1], ['GM', 1], ['CM', 4]];

~getChordDegreeArrays = { |chordProg|
	var ciphers, dictChords, dict;

	ciphers = chordProg.collect { |c| c[0]};
	ciphers.asSet;

	dict = Dictionary.new();
	dictChords = Dictionary.new();

	ciphers.do { |c|
		dict[\notes] = ~triads[c][\notes];
		dict[\degree] = ~triads[c][\degree].wrapExtend(~triads[c][\notes].size);

		dictChords[c] = dict;
	};
	~chordData[\chords] = dictChords;
};
~getChordDegreeArrays.(~chordProg);
~chordData[\chords][\FM][\notes];
)

/*************************************************************************************/
// Get the corresponding degree of a note, given a cipher
(
~getNoteDegree = { |note, cipher|
	//var cipher = ~chordState[\nextCipher];
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];

	degree[notes.indexOf(note)];
};

~getNoteDegree.(31, 'FM');
)

/*************************************************************************************/
// Get an array with the corresponding degrees of the notes of a chord
(
~getChordNotesDegree = { |chord, cipher|
	//var cipher = ~chordState[\nextCipher];
	var notes = ~chordData[\chords][cipher][\notes];
	var degree = ~chordData[\chords][cipher][\degree];
	var degreeArray = Array.new(~voiceData[\numVoices]);

	chord.do { |n|
		degreeArray.add(degree[notes.indexOf(n)]);
	};
	degreeArray;
};
~chord = [48, 60, 64, 67];
~getChordNotesDegree.(~chord, 'CM');
)

/*************************************************************************************/

(
~getChordVocalRange = { |cipher|
	//var cipher = ~chordState[\nextCipher];
	var voices = ~voiceData[\voiceNames];
	var chordNotes = ~chordData[\chords][cipher][\notes].as(OrderedIdentitySet);
	var voiceRange, dict;

	dict = Dictionary.new();

	voices.do { |v|
		voiceRange = ~voiceData[\voiceRange][v];
		dict[v] = chordNotes & (voiceRange[0]..voiceRange[1]);
	};
	~chordState[\validNotes] = dict;
};
~getChordVocalRange.('CM');
~chordState[\validNotes];
)

/*************************************************************************************/
(
~resolveMelodicIntervals = {

};
)
/*************************************************************************************/

(
~resolveCommonTones = { |currChord|
	//var currChord = ~chordState[\currChord];
	var validNotes = ~chordState[\validNotes];
	var voiceNames = ~voiceData[\voiceNames];

	if (~enforceRootPosition == true) {
		voiceNames = voiceNames.drop(1);
		currChord = currChord.drop(1);
	};

	voiceNames.do { |v, i|
		var set = [currChord[i]];
		if (set.isSubsetOf(~chordState[\validNotes][v])) {
			~chordState[\validNotes][v] = (~chordState[\validNotes][v] & set);
		};
	};
};

~enforceRootPosition = true;
~currChordFM = [41, 53, 60, 69];

~resolveCommonTones.(~currChordFM);
~chordState[\validNotes][\bas];
)





/*************************************************************************************/
// Get valid notes
(
~getValidNotes = {

	~getChordVocalRange.();

	if (~enforceMelodicIntervals == true) {
		~resolveMelodicIntervals.();
	};
	if (~enforceCommonTone == true) {
		~resolveCommonTones.();
	};
};
)

/*************************************************************************************/


"ABC"@0 == $A

"M3"@1 == $3

~tInt = Set["Rt", "m3", "M3", "d5", "P5", "A5"];
~c = ["Rt", "M3", "P5", "Rt"];
~c.asSet.size == 3
(~tInt & ~c.asSet)

Set["Rt", "m3", "M3", "d5", "P5", "A5"] & Set["Rt", "M3", "P5", "Rt"]














/*************************************************************************************/
// Tests
(
~testArray = Array.fill(4, {[]});

~vRange.do { |r, i|
		~testArray[i] = r.select { |n|
		~voiceData[\validIntervals][~voiceData[\voiceNames][i]].includes((n[0] - ~currChord[0][i]).abs);
		}
	};
)
~testArray[3];

(
~testArray2 = Array.fill(4, {[]});

~currChord[0].do { |r, i|
	~testArray2[i] = ~testArray[i].collect { |n|
		n[0] == r;
	};
};
)
~testArray2

(
~b = ~voiceData[\voiceRange][\bas];
~bSet = OrderedIdentitySet.newFrom((~b[0]..~b[1]));

~cM = ~triads[\CM][\notes].as(OrderedIdentitySet);
~nt = ~currChord[0][0];
~nSet = OrderedIdentitySet.new();
~nSet.add(~nt);
~cM & ~bSet & ~nSet;
)


Set.newFrom((1..12))
Set[4, 6, 45, 61, -2] & (1..12).asSet

~range = (~voiceData[\voiceRange][\spn][0]..~voiceData[\voiceRange][\spn][1]).as(OrderedIdentitySet);

~range & Set[67, 65, 23, 45]










(
var i = 2;
~vRange[i].postln;
~test[i].postln;
)
nextChord.select { |n| allowedIntervals.includes((n - currentNote).abs) };



(
~getValidNotes = {
	var chordB, chordT, chordA, chordS;
	var nextHarm = ~chordData[\nextHarm];

	chordB = ~chordData[\chords][nextHarm].collect { |n| (n >= ~voiceData[\voiceRange][\bas][0]) && (n >= ~voiceData[\voiceRange][\bas][1]) };
};
~getValidNotes.();
)









