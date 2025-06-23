s.boot;
s.quit;

// Load project files
(
"./sc_harmony_01_lib.scd".loadRelative;
"./sc_harmony_01_dicts.scd".loadRelative;
"./sc_harmony_01_utils.scd".loadRelative;
"./sc_harmony_01_range.scd".loadRelative;
"./sc_harmony_01_rules.scd".loadRelative;
"./sc_harmony_01_parser.scd".loadRelative;
"./sc_harmony_01_backtrack.scd".loadRelative;
)
/**************************************************************************************
- HARMONY 01 / Main

GOALS:
- Prohibit parallel fifths and octaves between voices
- Enforce root doubling (two roots, one 3rd, one 5th)
- Prioritize root position or 1st inversion, avoid 2nd inversion except in cadential or passing contexts
- Limit voice-leading intervals per voice
    - bass: unisons, 2nds, 3rds, 4ths, 5ths, octaves;
    - tenor/alto: unisons, 2nds, 3rds, 4ths;
    - soprano: unisons, 2nds, 3rds, 4ths, 6ths)
- Fallback system if no valid chord found:
    - equalize root and 1st inversion,
    - allow 2nd inversion,
    - allow non-standard doubling (e.g., two 3rds or two 5ths),
    - relax interval limits, reuse current chord
- Generate first chord dynamically
- Use PBind instead of Task for event-driven playback
- Accept chords and durations as input [['c', 2], ['f', 1], ['g', 1], ['c', 4]], with durations in beats
- getNextChord returns only the first valid chord to reduce computational overhead
**************************************************************************************/
// -> SynthDef
(
SynthDef(\tone, { |freq = 440, dur = 1, amp = 0.2|
	var sig = SinOsc.ar(freq) * amp;
	sig = sig * EnvGen.ar(Env.linen(0.1, (dur * 0.7)), doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\tone);

(
~logger = true;
~loggerCount = 0;

~noteNames = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"];

~progState[\progression] = ['CM', 'EM', 'AM', 'DM', 'Bd', 'CM'];
~progState[\durations] = [1, 1, 1, 1, 1, 2];
~harmonizeProg.(~triads, ~data, ~progState, ~rules);
)



~progState[\result];
~progVoices = (~progState[\result].flop) + 12;
~getChordNoteNameOct.(~progState[\result][1], ~midiRange);




(
var chords = Dictionary.new();

~progState[\progression] = ['CM', 'EM', 'AM', 'DM', 'Bd', 'CM'];

~progParser.(~progState[\progression], chords);
~setRules.(~progState, chords);

~progState[\ruleEnforcement][0];
)

(
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[0], 1),
		\dur, Pseq(~progState[\durations], 1),
		\amp, 0.1,
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[1], 1),
		\dur, Pseq(~progState[\durations], 1),
		\amp, 0.1,
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[2], 1),
		\dur, Pseq(~progState[\durations], 1),
		\amp, 0.1,
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[3], 1),
		\dur, Pseq(~progState[\durations], 1),
		\amp, 0.1,
	),
]).play;
)
