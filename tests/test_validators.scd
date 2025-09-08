/**************************************************************************************
- HARMONY 01 / Test validators

PROGRESSION:
- Must be of type Array
- Must not be empty
- Values must of type Symbol
- Symbols must be valid

DURATIONS:
- Must be of type Array
- Must not be empty
- Values must be of type Number (Integer/Float)
- Values should be greater than 0

DIRECTION:
- Must be of type String
- Must be valid, only "up", "down" or "line" are allowed

SUSTAIN:
- Must be of type Boolean

SCORE:
- Must be of type Boolean

LOGGER:
- Must be of type Boolean
**************************************************************************************/

"../src/loadall.scd".loadRelative;

(
var prog = ['CM', 'FS', 'GM', 'CM'];
var durs = [1, 1, 3, 2];
var dir  = "up";

~result = ~harmonizeProg.(
	progression: prog,
	durations: durs,
	direction: dir,
	sustain: true,
	score: false,
	logger: false
);
)
