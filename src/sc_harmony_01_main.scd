/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

"./sc_harmony_01_loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
SynthDef(\tone, { |freq = 440, dur = 1, amp = 0.2|
	var sig = Pulse.ar(freq) * amp;
	sig = sig * EnvGen.ar(Env.linen(0.1, (dur * 0.7)), doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;
)

//  Test synth
Synth(\tone);

/*************************************************************************************/
// Get harmonized progression
(
//~prog = ['CM', 'F#M', 'DM', 'AbM', 'EM', 'BbM'];
~prog = ['CM', 'Em', 'GM', 'Bd', 'Dm', 'FM', 'Am', 'CM'];
~dur = [1, 1, 1, 1, 1, 1, 1, 2];

~result = ~harmonizeProg.(~prog, ~dur, direction: "line", sustain: true, logger: false);
//~result = ~result + 12;
)
~result.do { |n| n[1].postln };
/*************************************************************************************/
// Play progression
(
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq((~result[0][0] + 12), 1),
		\dur, Pseq(~result[0][1], 1),
		\amp, 0.1,
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq((~result[1][0] + 12), 1),
		\dur, Pseq(~result[1][1], 1),
		\amp, 0.1,
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq((~result[2][0] + 12), 1),
		\dur, Pseq(~result[2][1], 1),
		\amp, 0.1,
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq((~result[3][0] + 12), 1),
		\dur, Pseq(~result[3][1], 1),
		\amp, 0.1,
	),
]).play;
)








