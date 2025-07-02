/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

"./sc_harmony_01_loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
SynthDef(\tone, { |freq = 440, dur = 1, amp = 0.2, pan = 0|
	var sig = Pulse.ar(freq) * amp;
	sig = sig * EnvGen.ar(Env.linen(0.1, (dur * 0.7)), doneAction: 2);
	Out.ar(0, Pan2.ar((sig ! 2), pan));
}).add;
)

//  Test synth
Synth(\tone);

/*************************************************************************************/
// Get harmonized progression
(
~prog = ['Cm', 'FM', 'BbM', 'Bbm', 'EbM', 'AbM', 'G#m', 'C#M', 'F#M', 'F#m', 'BM', 'EM'];
~dur = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4];

~result = ~harmonizeProg.(~prog, ~dur, direction: "line", sustain: false, logger: false, dump: false);
)
~result;
/*************************************************************************************/
// Play progression
(
~octave = (_ + 12);
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
~resetProgState.(~progState)
(

~prog.do { |k, i|
	var names = ~triads[k][\names].wrapExtend(~triads[k][\notes].size).postln;
	names.collect { |n| ~result[i]}
};
)

(
~progState[\progression].do { |c, i|
	"Chord: %".format(c).postln;
	~ruleKeys.do { |k|

		if (~progState[\ruleEnforcement][i][k] == nil) {
			[k, ~rules[k]].postln;
		} {
			[k, ~progState[\ruleEnforcement][i][k]].postln;
		}
	};
};
)

