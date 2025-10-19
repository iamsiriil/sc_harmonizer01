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

~asAnsiChar = { |string|

	case
	{ string == "##" } { "𝄪" }
	{ string == "#" }  { "♯" }
	{ string == "b" }  { "♭" }
	{ string == "bb" } { "𝄫" }
};

/****************************************************************************************/

~namesToAnsi = { |names|

	names.do { |n, i|

		switch (n.size)
		{ 3 }{
			case
			{ n.includes($#) } { names[i] = n[0] ++ ~asAnsiChar.("##") }
			{ n.includes($b) } { names[i] = n[0] ++ ~asAnsiChar.("bb") }
		}
		{ 2 } {
			case
			{ n.includes($#) } { names[i] = n[0] ++ ~asAnsiChar.("#") }
			{ n.includes($b) } { names[i] = n[0] ++ ~asAnsiChar.("b") }
		}
	};
};

/****************************************************************************************/

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
