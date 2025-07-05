/**************************************************************************************
- HARMONY 01 / Sustain notes
**************************************************************************************/
(
// Recursive function to merge common tones and add respective durations.

~mergeNotes = { |prog, dur, nprog, ndur, new, i|
	var result;

	//~runLogger.("~mergeNotes");

	block { |return|

		if (i == (prog.size)) {
			result = [nprog, ndur];
			return.value(result);
		};

		if (i == 0) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		};

		if ((i > 0) && (new != prog[i])) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		} {
			ndur[ndur.size - 1] = ndur[ndur.size - 1] + dur[i];
		};

		result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
		return.value(result);

	};
	result;
};

/*************************************************************************************/
// Wrapper function to ~mergeTones

~sustainCommonTones = { |progState|
	var temp = Array.new(4);
	var return = Array.fill(2, {Array.new(4)});

	~runLogger.("~sustainCommonTones");

	progState[\result].do { |v|
		var nprog = Array.new(v.size);
		var ndur = Array.new(v.size);

		temp.add(~mergeNotes.(v, progState[\durations], nprog, ndur, 0, 0));
	};
	temp.do { |i|
		return[0].add(i[0]);
		return[1].add(i[1]);
	};
	return;
};
)
