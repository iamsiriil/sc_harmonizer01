/*****************************************************************************************
* Harmonizer 01 - A rule-based harmonizer for SuperCollider								 *
* Copyright (C) 2025 Siriil																 *
* Licensed under GPLv3. See LICENSE file for details.									 *
*****************************************************************************************/
(
~runLogger = { |name, message = "Function Call"|
	var step, function;

	if (~logger) {

		~loggerCount = ~loggerCount + 1;

		step = "#%".format(~loggerCount).padRight(6);
		function = "%".format(name).padRight(25);

		"% | % | %".format(step, function, message).postln
	}
};
)