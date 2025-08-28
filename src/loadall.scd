/**************************************************************************************
- HARMONY 01 / Load all files
**************************************************************************************/
(
// Paths needed to export score

~srcDir = PathName(thisProcess.nowExecutingPath).pathOnly;
~rootDir = PathName(~srcDir).parentPath;
~pyDir = (~rootDir +/+ "score/python").standardizePath;

~dumpTxt = (~pyDir +/+ "dump.txt").standardizePath;
~getScorePy = (~pyDir +/+ "getscore.py").standardizePath;

/*************************************************************************************/
// Project files

"./lib.scd".loadRelative;
"./dump.scd".loadRelative;
"./dicts.scd".loadRelative;
"./utils.scd".loadRelative;
"./range.scd".loadRelative;
"./logger.scd".loadRelative;
"./parser.scd".loadRelative;
"./sustain.scd".loadRelative;
"./chordrules.scd".loadRelative;
"./progrules.scd".loadRelative;
"./backtrack.scd".loadRelative;
"./validators.scd".loadRelative;
"./harmonizer.scd".loadRelative;
"../tests/test_runtests.scd".loadRelative;
)
