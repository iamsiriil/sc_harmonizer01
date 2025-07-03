/**************************************************************************************
- HARMONY 01 / Progression rules
**************************************************************************************/
(
~checkChord = { |progState, i|
	var progression = progState[\progression];
	var progResult = progState[\result];
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #% : ~checkChord: Function Call".format(~loggerCount).postln; };

	if (i == 0) {
		result = result && (progResult[i][0] != progResult[i][1]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "up")) {
		result = result && (progResult[i][3] >= progResult[i - 1][3]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "down")) {
		result = result && (progResult[i][3] <= progResult[i - 1][3]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "line")) {
		var min = progResult[0][3] - 4;
		var max = progResult[0][3] + 4;
		result = result && ((progResult[i][3] >= min) && (progResult[i][3] <= max));
	};

	if ((progression.size >= 3) && (i > 1)) {
		var a = (progResult[i - 2][0] - progResult[i - 1][0]);
		var b = (progResult[i - 1][0] - progResult[i][0]);
		result = result && (((a + b).abs != 10) && ((a + b).abs != 11));
	};

	if ((progression.size >= 2) && (i >= 2)) {
		for (0, 3) { |j|
			result = result && ((progResult[i][j] - progResult[i - 1][j]).abs <= 7);
		};
	};
	result;
};

/*************************************************************************************/

~checkDirection = { |progState|
	var result = true;

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~checkDirection: Function Call".format(~loggerCount).postln; };

	case
	{ progState[\direction] == "up" } {
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] >= progState[\result][i - 1][3]);
			}
		};
	}
	{ progState[\direction] == "down" } {
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] <= progState[\result][i - 1][3]);
			}
		};
	};
	result;
};

/*************************************************************************************/

~progIsValid = { |progState|

	if (~logger == true) { ~loggerCount = (~loggerCount + 1); "\nSTEP #%: ~progIsValid: Function Call".format(~loggerCount).postln; };

	~checkDirection.(progState);
};
)