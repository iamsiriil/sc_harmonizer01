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
~prog = ['CM', 'EM', 'AM', 'DM', 'Bd', 'CM'];
~dur = [1, 1, 1, 1, 1, 2];

~result = ~harmonizeProg.(~prog, ~dur);
)

(
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~result[0], 1),
		\dur, Pseq(~dur, 1),
		\amp, 0.1,
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~result[1], 1),
		\dur, Pseq(~dur, 1),
		\amp, 0.1,
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~result[2], 1),
		\dur, Pseq(~dur, 1),
		\amp, 0.1,
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~result[3], 1),
		\dur, Pseq(~dur, 1),
		\amp, 0.1,
	),
]).play;
)
