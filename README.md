# Harmonizer 01

Harmonizer 01 is a rule-based system that generates harmonized chord progressions according to classical harmony rules. It is implemented in SuperCollider and is the first iteration in a series exploring music-generation algorithms aimed at live performance tools.

Although still under development, the current version is fully usable: load the project source files and call `harmonizeProg` (see Usage below). It takes two mandatory arguments—a chord progression and a corresponding array of durations—and returns a harmonized progression that you can assign to a Routine, Task, or Pbind, to be played by any user-defined synth that accepts frequency and duration parameters.

The function also offers two optional flags: sustain (when true, holds common tones instead of repeating them) and direction (selects ascending, descending, or ranged chord motion).

Rather than evolving a single codebase across versions, this project advances through distinct iterations with narrow scope, keeping each one manageable. In Harmonizer 01, the emphasis is on the rule system and the backtracking algorithm. To reduce complexity, only triads are used, drawn from a static MIDI-note library, and a simple parser prepares the input progression for the backtracking stage.

The next iteration will introduce dynamically generated chord ranges (e.g., seventh chords, extended chords, augmented-sixth chords) and a more comprehensive parser.

## The Algorithm

The entry point is harmonizeProg, which requires:

* **prog**: an Array of Symbols (chord ciphers), and

* **dur**: not mandatory. The durations array is only necessary if the user inteds to output voices. If not provided, harmonizer will assign an array of ones, of the same size as `prog`, as durations.

The progression is parsed to extract and store per-chord data in a Dictionary: root, chord quality (major, minor, diminished, augmented), and the interval from the previous chord’s root. During parsing, a specific rule profile is assigned to each chord to guide generation. The parser then collects chord data from the static library (MIDI-note ranges and degree arrays).

Before backtracking, these note ranges are filtered by voice range, and—depending on the rules and the previous chord—by (a) removing notes that violate melodic-interval constraints and (b) optionally collapsing candidates to the common tone when applicable. This filtering is repeated for each chord as backtracking traverses the progression.

Generation uses two nested backtracking loops. The inner loop builds all valid chord realizations for a given previous chord from the filtered note sets; the outer loop steps through the entire progression, trying candidate realizations in sequence. If at any point no valid realization can be found—or all candidates are exhausted—the algorithm backtracks to the last stable position, selects the next candidate, and continues.

>[!NOTE]
> For more information checkout the [Wiki Pages](https://github.com/iamsiriil/sc_harmonizer01/wiki)

## Usage

> [!WARNING]
> This section is out of date and will be updated very soon. Meanwhile, check the `example.scd` file for reference.

Clone the repository and load the entry file into a project file of your own:

```SuperCollider
"/local/path/to/sc_harmonizer01/src/loadall.scd".load;
```

Then call the main function:

```SuperCollider
harmonizeProg.(prog, dur, dir: "line", out: 'voice', uni: false, sus: true, scr: false, log: false)
```

#### Arguments

+ **prog** (Array of Symbols) – chord progression to harmonize. Symbols must match the static library (see Valid chord symbols).

+ **dur** (Array of Numbers) – duration of each chord. Must match the length of progression. If no progression is passed and `out` is set to `'voice'`, Harmonizer will assign an array of ones, of the same size as `prog`. 

+ **dir** (String, default "line") – upper-voice motion: `"up"`, `"down"`, or `"line"` (ranged, centered on first chord’s top note).

+ **out** (Symbol, 'voice') – output format. `'voice'` ouputs one voice per subarray, `'chord'` outputs one chord per subarray.

+ **uni** (Boolean, default false) – when set to `true` prohibits unisons in chords.

+ **sus** (Boolean, default true) – sustains common tones by extending the first note’s duration.

+ **scr** (Boolean, default false) – exports score via Python 3 + music21 + Finale/Sibelius/MuseScore.

+ **log** (Boolean, default false) – prints function call traces (debugging).

#### Example
```SuperCollider
~progression = ['CM', 'FM', 'GM', 'CM'];
~durations  = [2, 1, 1, 2];
~result = harmonizeProg.(~progression, ~durations);
```
#### Return format

```SuperCollider

// out: 'voice'
[
    [ [..Bass..], [..Tenor..], [..Alto..], [..Soprano..] ],// MIDI notes per voice
    [ [..Bass..], [..Tenor..], [..Alto..], [..Soprano..] ] // durations per voice
]

// out: 'chord'
[ [..Chord1..], [..Chord2..], [..Chord3..], ... ]

```

You can then map each voice into a Pattern, Routine, or other playback construct (see `example.scd` for a full example).

#### Valid chord symbols

| Root	| Diminished	| Minor	| Major	| Augmented |
| ----- | ------------- | ----- | ----- | --------- | 
| **C**  	| Cd        	| Cm	| CM	| CA        |
| **C#/Db**	| C#d        	| C#m	| DbM	| DbA       |
| **D**  	| Dd        	| Dm	| DM	| DA        |
| **Eb**	| Ebd        	| Ebm	| EbM	| EbA       |
| **E**  	| Ed        	| Em	| EM	| EA        |
| **F**  	| Fd        	| Fm	| FM	| FA        |
| **F#**	| F#d        	| F#m	| F#M	| F#A       |
| **G**  	| Gd        	| Gm	| GM	| GA        |
| **G#/Ab**	| G#d        	| G#m	| AbM	| AbA       |
| **A**  	| Ad        	| Am	| AM	| AA        |
| **Bb**	| Bbd        	| Bbm	| BbM	| BbA       |
| **B**  	| Bd        	| Bm	| BM	| BA        |

A more complete example is available in `example.scd`.

#### Score export

The score export functionality requires Python 3 and the music21 library.

To install `music21`, run:

```bash
    # Linux / macOS
    pip3 install music21

    # Windows
    py -3 -m pip install music21
```

Once installed, you need to configure music21 by running the following in your terminal or Python REPL:

```Python
    import music21
    music21.configure.run()
```

The configuration process is important, as it tells music21 which notation software to use for opening exported scores (Finale, Sibelius, MuseScore, etc.).

👉 For more details and installation instructions, see the [official music21 documentation](https://www.music21.org/music21docs/usersGuide/usersGuide_01_installing.html)

**Note**: If you prefer to use a Python virtual environment, it is advisable to place it in `sc_harmony01/score/python/` as `venv/`. The program will automatically detect and use it when available.


## Next Steps

Even though the current version of the program is functional, some aspects need fine-tuning before progressing to the next iteration of the project:

* **Algorithmic efficiency** – Backtracking is computationally demanding, and SuperCollider isn’t ideal for heavy logic. Depending on progression length and rule complexity, a call to harmonizeProg can take from a few milliseconds to, in rare cases, a few seconds, leading to inconsistent performance. The backtracking process should be optimized and rule setup refined to prevent unnecessary recursion.

* **Quality of progression** – The rule assignment during parsing needs refinement to ensure higher musical quality and stylistic consistency.

* **Logger** – Currently limited to console output. Add the ability to log to a file to make debugging and long-run tracing more practical (especially for larger test suites).

* **Testing** – More systematic unit testing is required to ensure robustness across progressions, rule sets, and edge cases. Some subsystems—such as progression rules, the parser, and sustain functions—still require unit tests.

* **Score export** – This functionality was primarily developed as an additional testing tool to assess the quality of the generated progression in score form. As such, it does not currently reflect user-assigned durations or the suspension of common tones. Over time, it should be made more robust and expanded into a true composition aid, capable of reflecting user-assigned durations and suspensions.

* **Further documentation** – Additional documentation (e.g., a repository wiki) to explain subsystems and design choices in greater detail.

## Contributing & Support

This project is shared freely with the community, and feedback, testing, or ideas for improvement are all welcome.

If you find Harmonizer 01 useful and would like to support further development, you can also consider a small donation:

👉 [Buy me a coffee](http://paypal.me/iamsiriil)

## License

As of 2025-10-19, harmony01 is licensed under the GNU General Public License v3 (GPLv3).

All code committed prior to this date was licensed under the MIT License.

Author: Siriil

