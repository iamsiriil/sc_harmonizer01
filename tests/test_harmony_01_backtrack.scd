/**************************************************************************************
- HARMONY 01 / Backtrack
**************************************************************************************/
(
"../src/sc_harmony_01_lib.scd".loadRelative;
"../src/sc_harmony_01_utils.scd".loadRelative;
"../src/sc_harmony_01_rules.scd".loadRelative;
"../src/sc_harmony_01_backtrack.scd".loadRelative;
"../src/sc_harmony_01_range.scd".loadRelative;
"../src/sc_harmony_01_dicts.scd".loadRelative;
)
/*************************************************************************************/
(
//var buildChord = Array.fill(4, {0}).postln;
//var validNextChords = Array.new(20);
var chordProg = [['CM', 1], ['C#m', 1]];
var validNotes = Dictionary.new(), chords = Dictionary.new();

~logger = true;
~loggerCount = 0;

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg).postln;

~currChord = [[60, 64, 67, 72], [48, 55, 64, 72]];

~chordState[\currChord] = ~currChord[1];
~chordState[\nextChord] = Array.fill(4, {0});
~chordState[\nextCipher] = 'C#m';
~chordState[\validNextChords] = Array.new(20);

~rules[\enforceParallelOctaves] = false;
~rules[\enforceParallelFifths] = false;
~rules[\enforceCommonTones] = false;

~rules[\toggleCount] = 0;
~resetRules.(~rules);

~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData, ~rules);

~getNextChords.(~voiceData, ~chordData[\chords], ~chordState, ~rules, 0);

~chordState[\validNextChords].do { |c| (~getChordNoteNameOct.(c, ~midiRange)).postln };
)


