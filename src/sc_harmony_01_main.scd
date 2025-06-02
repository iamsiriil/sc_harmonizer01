s.boot;
s.quit;

// Load project files
(
"./sc_harmony_01_lib.scd".loadRelative;
"./sc_harmony_01_utils.scd".loadRelative;
"./sc_harmony_01_rules.scd".loadRelative;
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
	sig = sig * EnvGen.kr(Env.perc(0.01, (dur * 0.9)), doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;
)

Synth(\tone);

(
var firstChord = [48, 55, 64, 72];
var progression = Array.new(50);
~loggerCount = 0;

~chordState[\nextValidChords] = Array.new(50);

~chordData[\chordProg] = [['CM', 2], ['Cm', 1], ['Fm', 1], ['CM', 2]];

~chordData[\chords] = ~getChordDegreeArrays.(~triads, ~chordData[\chordProg]);


//~prog = ~harmonizeProg.(firstChord, progression);
//~progVoices = ~prog.flop;
)
~prog
(
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[0], 1),
		\dur, Pseq([2, 1, 1, 2], 1),
		\amp, 0.3,
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[1], 1),
		\dur, Pseq([2, 1, 1, 2], 1),
		\amp, 0.3,
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[2], 1),
		\dur, Pseq([2, 1, 1, 2], 1),
		\amp, 0.3,
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~progVoices[3], 1),
		\dur, Pseq([2, 1, 1, 2], 1),
		\amp, 0.3,
	),
]).play;
)
~a = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]];
~b = (1..10).iter;
~a = ~a.iter;
~a.next;
