(
var fun = { |n|
	var i = 0, return;

	block { |return|

		while { i < n} {
			"i: %".format(i).postln;
			if (i == 5) { return.value(i) };
			i = i + 1;
		};
	};
};
fun.(10);
)

(
var fun = { |n|
	var i = 0, return;

	block { |return|

		if (n < 0) { return.value(i) };
		if (n == 3) { i = 3; return.value(i) };

		while { i < n } {
			"i: %".format(i).postln;
			i = i + 1;
		};
	};
	i;
};
fun.(-2);
)

(
var backtrack = { |numVoices, nextChord, validNextChord, validNotes, i|
	var return, bool, j;

	block { |return|

		if (i == numVoices) {
			validNextChord.add(nextChord.copy);
			bool = true; return.value(bool);
		};

		j = 0;
		while { j < validNotes[i].size } {

			nextChord.put(i, validNotes[i][j]);

			if (~noteIsValid.(nextChord, i)) {
				bool = backtrack.(numVoices, nextChord, validNextChord, validNotes, (i + 1));
				if (bool == true) {
					return.value(bool)
				} {
					nextChord.put(i, 0);
				};
			} {
				nextChord.put(i, 0);
			};
			j = j + 1;
		};
		bool = false; return.value(bool);
	};
	bool;
};
)


(
~notes = ["C", "D", "E", "F", "G", "A", "B"];

[4, 6, 8].collect { |n| ~notes.wrapAt(n) }
)












