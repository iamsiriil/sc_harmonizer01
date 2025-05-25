s.boot;

/**************************************************************************************
- GENERATE CHORD SETS
**************************************************************************************/

~a = OrderedIdentitySet.new();

(
~getTriad = { |set, root = 0|
	var triad = [root, (root + 3), (root + 7)];

	triad.do({ |note|

		while { note <= 127 } {
			set.add(note);
			note = note + 12;
		};
	});
	set.sort;
};
)

~octaves = ~getTriad.(~a);

~octaves == ~triads[\Cm][\notes]