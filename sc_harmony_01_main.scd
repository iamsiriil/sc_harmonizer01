s.boot;
s.quit;

// Load project files
(
"./sc_harmony_01_utils.scd".loadRelative;
"./sc_harmony_01_tests.scd".loadRelative;
"./sc_harmony_01_lib.scd".loadRelative;
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
~clock = TempoClock.new(120/60);

~t = { |chordProg, firstChord = nil|
	var nextChord, chordList

	~chordData[\chordProg] = chordProg;
	~getChordDegreeArrays.();

	if (firstChord != nil) {
		nextChord = fistChord
	} {
		nextChord = ~getFirstChord.(); // ...
	};

	Task({
		var buildChord;
		var tempo = 2.5;

		chordProg.do({ |c, i|
			var dur = tempo / ~clock.tempo;

			~chordState[\nextChipher] = c[0];

			if (i == 0) {
				nextChord;
			} {
				~getValidNotes.();
				buildChord = Array.fill(4, {0});
				~getNextChords.(buildChord, 0);

				nextChord = ~chordState[\nextValidChords].choose;
			};

			// Play SATB
			Synth();
			Synth();
			Synth();
			Synth();
			tempo.wait;

			~chordState[\currChord] = nextChord;
			~chordState[\lastValidChords] = ~chordState[\nextValidChords];
		});

	});
};
)






























