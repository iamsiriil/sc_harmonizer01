/**************************************************************************************
- HARMONY 01 / Progression rules
**************************************************************************************/
( // Needs work
~checkChord = { |progState, i|
	var progression = progState[\progression];
	var progResult = progState[\result];
	var result = true;

	~runLogger.("~checkChord");

	if (i == 0) {
		result = result && (progResult[i][0] != progResult[i][1]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "up")) { // change to symbol 'up'
		result = result && (progResult[i][3] >= progResult[i - 1][3]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "down")) { // change to symbol 'down'
		result = result && (progResult[i][3] <= progResult[i - 1][3]);
	};

	if ((progression.size >= 2) && (i >= 1) && (progState[\direction] == "line")) { // change to symbol 'line'
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
// Needs work
~checkDirection = { |progState|
	var result = true;

	~runLogger.("~checkDirection");

	case
	{ progState[\direction] == "up" } { // change to symbol 'up'
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] >= progState[\result][i - 1][3]);
			}
		};
	}
	{ progState[\direction] == "down" } { // change to symbol 'down'
		progState[\result].do { |n, i|
			if (i > 0) {
				result = result && (progState[\result][i][3] <= progState[\result][i - 1][3]);
			}
		};
	};
	result;
};

/*************************************************************************************/
// Needs work
~progIsValid = { |progState|

	~runLogger.("~progIsValid");

	~checkDirection.(progState);
};
)