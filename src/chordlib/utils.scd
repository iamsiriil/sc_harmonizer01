/**************************************************************************************
- HARMONY 01 / Dynamic Library - Utility functions
**************************************************************************************/
(
~getAnsiChar = { |names|
	var sharp  = "♯";
	var dsharp = "𝄪";
	var flat   = "♭";
	var dflat  = "𝄫";

	names.do { |n, i|

		switch (n.size)
		{ 3 }{

			case
			{ n.includes($#) } { names[i] = n[0] ++ dsharp }
			{ n.includes($b) } { names[i] = n[0] ++ dflat }
		}
		{ 2 } {

			case
			{ n.includes($#) } { names[i] = n[0] ++ sharp }
			{ n.includes($b) } { names[i] = n[0] ++ flat }
		}
	};
};

/*************************************************************************************/

~extendMidiRange = { |range|
	var arr = Array.new(range.size * 11);

	range.do { |n|

		while { n <= 127 } {

			arr.add(n);
			n = n + 12;
		};
	};
	arr.sort;
};
)
