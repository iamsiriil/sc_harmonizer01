/*
DATA STRUCTURES

-> chordProg            Array
-> firstChord           Array
-> currentChord         Array
-> nextChord            Array

-> chordList            Dictionary / OrderedIdentitySet
-> validNotes           Set

************************************************************
CLASS VARIABLES

numVoices               4 (default SATB)

midiRange               [0..127]
voiceRanges             [[B], [T], [A], [S]]

************************************************************
FLAGS

hasCommonToneSpn        true/false
hasCommonToneAlt        true/false
hasCommonToneTen        true/false
hasCommonToneBas       .true/false

enforceCommonTones      true/false

enforceRootPosition     true/false
enforceFirstInvertion   true/false

enforceDuplicatRoot     true/false
enforceDuplicat3Degree  true/false

enforceParallelFifths   true/false
enforceParallelOctaves  true/False

enforceVoiceSpacing     true/false

************************************************************
RULE HIERARCHY


*/

// Dictionary
(
~d = TwoWayDictionary[
	2->"Rt",
	1->"P5",
	3->"m3"
];
)
~d[2]

~d.order.do { |a| a.postln; };

~twd = TwoWayDictionary[]

// Sets
~set = Set[];
~iSet = IdentitySet[];
~oISet = OrderedIdentitySet[];

~set = (0..127).as(OrderedIdentitySet);
~bass = ~set.select { |n| (n > 45) && (n < 67)}
~set = OrderedIdentitySet
