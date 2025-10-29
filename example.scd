/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

// Load all project files
"./src/loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
// For voice outout
SynthDef(\organ1, { |freq = 440, amp = 0.2, pan = 0, gate = 1,
	atk = 0.1, dec = 0.2, sus = 0.7, rel = 0.1|
	var env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	var sig = SinOsc.ar(freq) * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

// For chord output
SynthDef(\organ2, { |freq = #[110, 220, 440, 880], amp = 0.2, pan = 0, gate = 1,
	atk = 0.1, dec = 0.2, sus = 0.7, rel = 0.1|
	var env = Env.adsr(atk, dec, sus, rel).kr(2, gate);
	var sig = Splay.ar(SinOsc.ar(freq));
	sig = sig * amp * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

/*************************************************************************************/
// Get harmonized progression
(
~prog = ['Dm', 'C#d', 'Cm', 'EbM', 'AM', 'Dm'];
~dur =  nil;

~result = ~harmonizeProg.(
	~prog,         // Progression
	~dur,          // Duration (no longer mandatory)
	dir: "line",   // Direction
	out: 'voice',  // Output format (arrays per voice or per chord)
	uni: true,     // Enforce unison prohibition
	sus: true,     // sustain common tones
	scr: false,    // Export score
	log: false     // Logger
);
)

/*************************************************************************************/
// Play progression (out: 'voice')
(
~octave = (_ + 12); // Change octave

Ppar([
	// Bass
	Pbind(
		\instrument, \organ1,
		\midinote, Pseq(~octave.(~result[0][0]), 2),
		\dur, Pseq(~result[1][0], 2),
		\amp, 0.1,
		\pan, -0.9,
		\legato, 0.99
	),

	// Tenor
	Pbind(
		\instrument, \organ1,
		\midinote, Pseq(~octave.(~result[0][1]), 2),
		\dur, Pseq(~result[1][1], 2),
		\amp, 0.1,
		\pan, -0.3,
		\legato, 0.99
	),

	// Alto
	Pbind(
		\instrument, \organ1,
		\midinote, Pseq(~octave.(~result[0][2]), 2),
		\dur, Pseq(~result[1][2], 2),
		\amp, 0.1,
		\pan, 0.3,
		\legato, 0.99
	),

	// Soprano
	Pbind(
		\instrument, \organ1,
		\midinote, Pseq(~octave.(~result[0][3]), 2),
		\dur, Pseq(~result[1][3], 2),
		\amp, 0.1,
		\pan, 0.9,
		\legato, 0.99
	),
]).play;
)

/*************************************************************************************/
// Play progression (out: 'chord')
(
~octave = (_ + 12); // Change octave

~r = Routine({
	var synth = Synth(\organ2, [\gate, 0]);

	~result.do { |c, i|

		c = ~octave.(c).postln;

		synth.set(\gate, 0);
		synth.set(\freq, c.midicps, \gate, 1);

		if (i == (~result.size - 1)) {

			4.wait;
			synth.set(\gate, 0);

		} {
			1.wait;
		};
	};
});

~r.play();
)
