/*****************************************************************************************
* Harmonizer 01 - A Rule-Based Harmonizer for SuperCollider                              *
* Copyright (C) 2025 Siriil                                                              *
*                                                                                        *
* This program is free software: you can redistribute it and/or modify                   *
* it under the terms of the GNU General Public License as published by                   *
* the Free Software Foundation, either version 3 of the License, or                      *
* (at your option) any later version.                                                    *
*                                                                                        *
* This program is distributed in the hope that it will be useful,                        *
* but WITHOUT ANY WARRANTY; without even the implied warranty of                         *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                          *
* GNU General Public License for more details.                                           *
*                                                                                        *
* You should have received a copy of the GNU General Public License                      *
* along with this program.  If not, see <http://www.gnu.org/licenses/>.                  *
*****************************************************************************************/
(
// Paths needed to export score

~srcDir = PathName(thisProcess.nowExecutingPath).pathOnly;
~rootDir = PathName(~srcDir).parentPath;
~pyDir = (~rootDir +/+ "score/python").standardizePath;

~dumpTxt = (~pyDir +/+ "dump.txt").standardizePath;
~getScorePy = (~pyDir +/+ "getscore.py").standardizePath;

/****************************************************************************************/
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

"ALL FILES HAVE BEEN LOADED".postln;
)
