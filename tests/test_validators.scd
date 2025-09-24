/**************************************************************************************
- HARMONY 01 / Test validators
**************************************************************************************/
(
~test_TASubroutine = { |fixtures, args, i|
	var error = nil, result = true;

	fixtures[args].do { |f|
		{
			~testArguments.(f[0], f[1], f[2], f[3], f[4], f[5]);
		}.try { |err|
			error = err;
			nil;
		};

		if (args != \pass){
			if (error.notNil) {
				result = result && true;
			} {
				result = result && false;
			};
		} {
			if (error.isNil) {
				result = result && true;
			} {
				result = result && false;
			}
		};

	};
	~test_resultMessage.(result, "~testArguments", nil, i);
	nil;
};

~test_testArguments = #{ |fixtures|
	var args = [\prog, \dur, \dir, \sus, \scr, \log, \progdur, \pass];

	args.do { |a, i|

		~test_TASubroutine.(fixtures, a, i)
	};
	nil;
};
)
