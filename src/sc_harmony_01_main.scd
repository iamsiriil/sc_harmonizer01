/**************************************************************************************
- HARMONY 01 / Main
**************************************************************************************/
s.boot;

"./sc_harmony_01_loadall.scd".loadRelative;

/*************************************************************************************/
// Create a synth
(
SynthDef(\tone, { |freq = 440, dur = 1, amp = 0.2|
	var sig = SinOsc.ar(freq) * amp;
	sig = sig * EnvGen.ar(Env.linen(0.1, (dur * 0.7)), doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;
)

//  Test synth
Synth(\tone);

/*************************************************************************************/
// Get harmonized progression
(
~prog = ['CM', 'F#M', 'DM', 'AbM', 'EM', 'BbM'];
~dur = [1, 1, 1, 1, 1, 2];

~result = ~harmonizeProg.(~prog, ~dur, false);
~result = ~result + 12;
)

/*************************************************************************************/
// Play progression
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


~result = ~result + 12;
(
~dumpProg = { |data, progState, name|
	var path = PathName.new("../data/scdump/dump%.txt".format(name).resolveRelative);
	var file = File(path.fullPath, "a");

	file.write("%\n".format(data[\voice][\number]));

	progState[\result].flop.do { |v|
		file.write("%\n".format(v));
		file.write("%\n".format(progState[\durations]));
	};

	progState[\progression].size.do { |i|
		file.write("%\n".format(i));
		progState[\ruleEnforcement][i].do { |r|
			file.write("%\n".format(r));
		};
	};

	file.close;
};
~dumpProg.(~data, ~progState, "01");
)
~data[\voice][\number]
~progState[\ruleEnforcement]












