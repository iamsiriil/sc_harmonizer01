/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

// Load all project files
"./src/loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
SynthDef(\tone, { |freq = 440, amp = 0.2, pan = 0, gate = 1,
	atk = 0.1, dec = 0.2, sus = 0.7, rel = 0.1|
	var env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	var sig = SinOsc.ar(freq) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

//  Test synth
Synth(\tone);

/*************************************************************************************/
// Get harmonized progression
(
~prog = ['Cm', 'EbM', 'AbM', 'GM', 'DbM', 'Cm', 'GM', 'Cm']; //['Dm', 'C#d', 'Cm', 'EbM', 'AM', 'Dm'];
~dur =  [2, 2, 2, 2, 2, 2, 2, 4];

~result = ~harmonizeProg.(
	~prog, ~dur,
	dir: "up",
	sus: true,
	scr: false,
	log: false
);
)

/*************************************************************************************/
// Play progression
(
~octave = (_ + 12); // Change octave
Ppar([
	// Bass
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][0]), 2),
		\dur, Pseq(~result[1][0], 2),
		\amp, 0.1,
		\pan, -0.9,
		\legato, 0.99
	),

	// Tenor
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][1]), 2),
		\dur, Pseq(~result[1][1], 2),
		\amp, 0.1,
		\pan, -0.3,
		\legato, 0.99
	),

	// Alto
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][2]), 2),
		\dur, Pseq(~result[1][2], 2),
		\amp, 0.1,
		\pan, 0.3,
		\legato, 0.99
	),

	// Soprano
	Pbind(
		\instrument, \tone,
		\midinote, Pseq(~octave.(~result[0][3]), 2),
		\dur, Pseq(~result[1][3], 2),
		\amp, 0.1,
		\pan, 0.9,
		\legato, 0.99
	),
]).play;
)
