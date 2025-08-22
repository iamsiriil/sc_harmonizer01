/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

"./loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
SynthDef(\tone, { |freq = 440, dur = 1, amp = 0.2, pan = 0|
	var sig = SinOsc.ar(freq) * amp;
	sig = sig * EnvGen.ar(Env.linen(0.1, (dur * 0.7)), doneAction: 2);
	sig = Pan2.ar((sig ! 2), pan);
	Out.ar(0, sig);
}).add;
)

//  Test synth
Synth(\tone);

/*************************************************************************************/
// Get harmonized progression
(
~prog = ['CM', 'F#M', 'DM', 'AbM', 'EM', 'BbM'];
~dur = [1, 1, 1, 1, 1, 4];

~result = ~harmonizeProg.(~prog, ~dur, direction: "down", sustain: true, score: true, logger: false);
)

/*************************************************************************************/
// Play progression
(
~octave = (_ + 12); // Change octave
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][0]), 1),
		\dur, Pseq(~result[1][0], 1),
		\amp, 0.1,
		\pan, -0.9
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][1]), 1),
		\dur, Pseq(~result[1][1], 1),
		\amp, 0.1,
		\pan, -0.3
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][2]), 1),
		\dur, Pseq(~result[1][2], 1),
		\amp, 0.1,
		\pan, 0.3
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][3]), 1),
		\dur, Pseq(~result[1][3], 1),
		\amp, 0.1,
		\pan, 0.9
	),
]).play;
)
