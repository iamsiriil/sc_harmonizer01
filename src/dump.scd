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

~pythonExe = {
	var venvLinux = ~pyDir +/+ "venv/bin/python3";
	var venvMac   = ~pyDir +/+ "venv/bin/python3";
	var venvWin   = ~pyDir +/+ "venv/Scripts/python.exe";

	~pythonExe.("~harmonizeProg");

	case
	{ (thisProcess.platform.name == \windows) && File.exists(venvWin) } { venvWin }
	{ thisProcess.platform.name == \windows }                           { "py -3" }
	{ File.exists(venvLinux) }                                          { venvLinux }
	{ File.exists(venvMac) }                                            { venvMac }
	{ "python3" }

}.value;

/****************************************************************************************/

~dumpChords = { |midiRange, triads, progState, file|
	var names, notes;

	~runLogger.("~dumpChords");

	file.write("%\n".format(progState[\progression].size));

	progState[\progression].do { |p, i|

		names = triads[p][\names].wrapExtend(triads[p][\notes].size);
		notes = triads[p][\notes];

		progState[\dump][i].do { |n, j|
			var note = names[notes.indexOf(n)];
			var octave;

			case
			// When using .asInteger, SuperCollider converts char to the ASCII number and String to the respective digit.
			{ note == "B#" } { octave = midiRange[\octave][n].last.asString.asInteger - 1 }
			{ note == "Cb" } { octave = midiRange[\octave][n].last.asString.asInteger + 1 }
			{ octave = midiRange[\octave][n].last };

			if (note.contains($b)) { note = note.replace($b, $-) } { note }; // Prevents issues with music21, by replacing "b" with "-"

			file.write("%% ".format(note, octave));
		};
		file.write("\n");
	};
};

/****************************************************************************************/

~dumpRules = { |progState, rules, ruleKeys, file|
	var temp = Dictionary.new();

	~runLogger.("~dumpRules");

	~resetRules.(rules);

	progState[\progression].do { |c, i|

		case
		{ c.asString.last == $A } {
			c = c.asString[0..c.asString.size - 2] ++ "+";
			file.write("%\n".format(c));
		}
		{ c.asString.last == $d } {
			c = c.asString[0..c.asString.size - 2] ++ "o";
			file.write("%\n".format(c));
		}
		{ file.write("%\n".format(c)) };

		ruleKeys.do { |k|
			temp[k] = rules[k];
		};

		progState[\ruleEnforcement][i].do { |r|
			temp[r[0]] = r[1];
		};

		ruleKeys.do { |k|
			file.write("%: %\n".format(k, temp[k]));
		};
	};
};

/****************************************************************************************/

~dumpData = { |midiRange, triads, progState, rules, ruleKeys|
	var file = File.new(~dumpTxt, "w");

	~runLogger.("~dumpData");

	~dumpChords.(midiRange, triads, progState, file);
	~dumpRules.(progState, rules, ruleKeys, file);

	file.close;

	"% %".format(~pythonExe.asString, ~getScorePy.asString).unixCmd;
};
)
