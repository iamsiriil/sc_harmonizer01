/**************************************************************************************
- HARMONY 01 / Logger
**************************************************************************************/
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