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
var chordProg = [['CM', 1], ['Em', 1]];
var validNotes = Dictionary.new(), chords = Dictionary.new();

~logger = true;
~loggerCount = 0;

~chordData[\chords] = ~getChordDegreeArrays.(~triads, chordProg).postln;

~chordState[\currChord] = [48, 55, 64, 72];
~chordState[\nextChord] = Array.fill(4, {0});
~chordState[\nextCipher] = 'Em';
~chordState[\validNextChords] = Array.new(20);

~getValidNotes.(~chordData[\chords], ~chordState, ~voiceData, ~rules);


~chordState[\validNotes].postln;

~getNextChords.(~voiceData, ~chordData[\chords], ~chordState, ~rules, 0);
)


