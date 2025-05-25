(
~chordProg = [['Cd', 2], ['CM', 1], ['Cm', 1], ['Cd', 2]];
~chords = ~chordProg.collect({ |item| item[0] }).asSet;
)
~chords.do { |item| ~triads[item].postln }

(
//~chords.do({ |item| ~triads[item].postln })
~chordsNeeded = Dictionary.new();
~chords.do({ |item|
	~chordsNeeded.put(~triads[item])
});
)
(
~chordData = Dictionary[
	\chords ->
]
)

~triads[\]