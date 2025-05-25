(
"../sc_harmony_01_lib.scd".loadRelative;
"../sc_harmony_01_utils.scd".loadRelative;
"../sc_harmony_01_rules.scd".loadRelative;
"../sc_harmony_01_backtrack.scd".loadRelative;
)

/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
// Test fixtures



/*************************************************************************************/
// Run test
(
var buildChord = Array.fill(4, {0}).postln;
~progression = Array.new(~chordData[\chordProg]);

~logger = true;
~loggerCount = 0;

// Update chordData and chordSate dicts with input data
~chordData[\chordProg] = [['CM', 1], ['CA', 1], ['Fm', 1]];
~chordState[\currChord] = [40, 56, 64, 72];
~chordState[\nextCipher] = 'Fm';

~progression.add(~chordState[\currChord]);

~chordState[\nextValidChords] = Array.new(50);

// Gather midi note numbers and note degree information for all chords in progression
~getChordDegreeArrays.();

// With that data, generate valid candidates for each voice for the next chord
~getValidNotes.();

if (~chordState[\nextCipher].asString.contains("A", 1)) {
	~enforceParallelFifths = false;
};

// Run ~getNextChords to backtrack next valid chords
while { ~getNextChords.(buildChord, 0) == false } { ~toggleRules.(~toggleCount) };

~toggleCount.postln;
//~getNextChords02.(buildChord, 0).postln;
~chordState[\nextValidChords].postln;
~progression.postln;
~resetChordDicts.(); ~resetRules.();
)

/*************************************************************************************/
(
~harmonizeProg = { |firstChord, progression|
	var chordProg = ~chordData[\chordProg].copy;
	var remainingProg = chordProg.drop(1);

	progression.add(firstChord.copy);
	~chordState[\currChord] = firstChord;

	remainingProg.do { |c, i|
		var buildChord = Array.fill(4, {0});
		var maxAttempts = 5;
		var attempts = 0;
		var found = false;

		// CRITICAL RESETS
		~resetRules.();
		~chordState[\nextValidChords] = Array.new(50);
		~toggleCount = 0;

		~chordState[\nextCipher] = c[0];
		~getValidNotes.();

		while {
			attempts = attempts + 1;
			found = ~getNextChords.(buildChord, 0);
			(found == false) && (attempts < maxAttempts) && (~toggleCount < 8)
		} {
			~toggleRules.(~toggleCount);
		};

		if(found.not) {
			Error("No valid chord found for % after % attempts (toggleCount: %)".format(
				c[0], attempts, ~toggleCount
			)).throw;
		};

		~chordState[\currChord] = ~chordState[\nextValidChords].choose;
		progression.add(~chordState[\currChord].copy);
	};

	progression;
};
)

/*************************************************************************************/

(
var buildChord = Array.fill(4, {0}).postln;
var firstChord = [48, 55, 64, 72];
var progression = Array.new(50);



~logger = true;
~loggerCount = 0;

~chordState[\nextValidChords] = Array.new(50);

//progression.add(firstChord);

//~chordData[\chordProg] = [['CM', 2], ['Fm', 1], ['EbM', 1], ['AbM', 1], ['C#M', 1], ['CM', 2]];
~chordData[\chordProg] = [['CM', 2], ['BA', 1], ['BbA', 1], ['Am', 2]];

~getChordDegreeArrays.();

~prog = ~harmonizeProg.(firstChord, progression);


)

~prog.flop;

~chordData[\chords]['AbM']['notes']

for (1, 3) { |i| i.postln}




