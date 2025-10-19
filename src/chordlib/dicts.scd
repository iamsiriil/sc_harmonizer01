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
// Chord symbol aliases

~chordSymbols = Dictionary[

	\P5     -> Set[],

	// Triads
	\d      -> Set['d', 'dim', 'º'],
	\m      -> Set['m', 'min', '-', 'mi'],
	\M      -> Set['M', 'Maj', '^', 'Δ'],
	\A      -> Set['A', 'aug', '+'],

	// Seventh chords
	\d7     -> Set['d7', 'dim7', 'º7'],
	\d5m7   -> Set['d5m7', 'd5min7', 'dim5m7', 'ø7', 'm7♭5', '-7♭5', 'half-dim7', 'min7dim5'],
	\d5M7   -> Set['d5M7', 'dim5Maj7', 'º5M7', 'd5Maj7', 'º5^7', 'dim5M7', 'd5^7', 'dim5^7'],
	\m7     -> Set[],
	\m3M7   -> Set[],
	\m3A5m7 -> Set[],
	\m3A5M7 -> Set[],
	\d5D7   -> Set[],
	\d5M7   -> Set[],
	\D7     -> Set[],
	\M7     -> Set[],
	\A5m7   -> Set[],
	\A5M7   -> Set[],

	// Augmented sixth chords
	\It     -> Set[],
	\Gr     -> Set[],
	\Fr     -> Set[],

	// Neapolitan sixth
	\Na     -> Set[],

	// Suspended chords
	\sus2   -> Set[],
	\sus4   -> Set[]
];

// Chord blueprints

~chords = Dictionary[
	\P5     -> [0, 7],
	// Triads
	// Allowed extensions (9th, 11th, 13th)
	\m3d5   -> [0, 3, 6],
	\m3P5   -> [0, 3, 7],
	\M3P5   -> [0, 4, 7],
	\M3A5   -> [0, 4, 8],

	// Seventh chords
	// Allowed extensions (9th, 11th, 13th)
	\m3d5d7 -> [0, 3, 6, 9],
	\m3d5m7 -> [0, 3, 6, 10],
	\m3d5M7 -> [0, 3, 6, 11],
	\m3P5m7 -> [0, 3, 7, 10],
	\m3P5M7 -> [0, 3, 7, 11],
	\m3A5m7 -> [0, 3, 8, 10],
	\m3A5M7 -> [0, 3, 8, 11],
	\M3d5m7 -> [0, 4, 6, 10],
	\M3d5M7 -> [0, 4, 6, 11],
	\M3P5m7 -> [0, 4, 7, 10],
	\M3P5M7 -> [0, 4, 7, 11],
	\M3A5m7 -> [0, 4, 8, 10],
	\M3A5M7 -> [0, 4, 8, 11],

	// Augmented sixth chords
	// No extensions allowed
	\It     -> [0, 2, 6],      // Only first inversion allowed
	\Gr     -> [0, 2, 6, 10],  // Only first inversion allowed
	\Fr     -> [0, 4, 6, 10],  // Only second inversion allowed

	// Neapolitan sixth
	\Na     -> [0, 3, 7],      // Only first inversion allowed

	// Suspended chords
	\sus2   -> [0, 2, 7],
	\sus4
	-> [0, 5, 7]
];

// Utility arrays with note names and major scale
~noteNames = [
	['C', 'D', 'E', 'F', 'G', 'A', 'B'],
	[0, 2, 4, 5, 7, 9, 11]
];
)