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
// Recursive function to merge common tones and add respective durations.

~mergeNotes = { |prog, dur, nprog, ndur, new, i|
	var result;

	//~runLogger.("~mergeNotes");

	block { |return|

		if (i == (prog.size)) {
			result = [nprog, ndur];
			return.value(result);
		};

		if (i == 0) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		};

		if ((i > 0) && (new != prog[i])) {
			new = prog[i];
			nprog.add(prog[i]);
			ndur.add(dur[i]);
			result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
			return.value(result);
		} {
			ndur[ndur.size - 1] = ndur[ndur.size - 1] + dur[i];
		};

		result = ~mergeNotes.(prog, dur, nprog, ndur, new, i + 1);
		return.value(result);

	};
	result;
};

/****************************************************************************************/
// Wrapper function to ~mergeTones

~sustainCommonTones = { |progState|
	var temp = Array.new(4);
	var return = Array.fill(2, {Array.new(4)});

	~runLogger.("~sustainCommonTones");

	progState[\result].do { |v|
		var nprog = Array.new(v.size);
		var ndur = Array.new(v.size);

		temp.add(~mergeNotes.(v, progState[\durations], nprog, ndur, 0, 0));
	};
	temp.do { |i|
		return[0].add(i[0]);
		return[1].add(i[1]);
	};
	return;
};
)
