/**************************************************************************************
- TESTING DATA STRUCTURES / Set
**************************************************************************************/

// Get midi range
(
~midiRange = OrderedIdentitySet.newFrom((0..127));
)
(
~midiRange = (0..127).as(OrderedIdentitySet);
)

// Get bass Range from midi range
(
~bass = ~midiRange.select({ |n| (n >= ~voices[\voiceRange][0][0]) && (n <= ~voices[\voiceRange][0][1]) });
~bass;
)

// Get chord notes for vocal range
(
~bassChord = (~triads[\Cd][\notes] & ~bass); // union of two sets
)

// Map notes and degrees (Cdim range)

~cdimDegree = ~triads[\Cd][\degree].asArray.wrapExtend(~triads[\Cd][\notes].size)
~cdimDegree[0];

(
~cdim = OrderedIdentitySet.new();
~i = 0;
~triads[\Cd][\notes].do { |n|
	var array = Array.newFrom([n, ~cdimDegree[~i]]);
	~cdim.add(array);
	~i = ~i + 1;
};
~cdim.detect({ |item| item[0] == 0 });
)













