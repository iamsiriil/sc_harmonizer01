# Harmonizer 01

Harmonizer 01 is a rule-based system that generates harmonized chord progressions according to classical harmony rules. It is implemented in SuperCollider and is the first iteration in a series exploring music-generation algorithms aimed at live performance tools.

Although still under development, the current version is fully usable: load the project source files and call `harmonizeProg` (see Usage below). It takes two mandatory arguments—a chord progression and a corresponding array of durations—and returns a harmonized progression that you can assign to a Routine, Task, or Pbind, to be played by any user-defined synth that accepts frequency and duration parameters.

The function also offers two optional flags: sustain (when true, holds common tones instead of repeating them) and direction (selects ascending, descending, or ranged chord motion).

Rather than evolving a single codebase across versions, this project advances through distinct iterations with narrow scope, keeping each one manageable. In Harmonizer 01, the emphasis is on the rule system and the backtracking algorithm. To reduce complexity, only triads are used, drawn from a static MIDI-note library, and a simple parser prepares the input progression for the backtracking stage.

The next iteration will introduce dynamically generated chord ranges (e.g., seventh chords, extended chords, augmented-sixth chords) and a more comprehensive parser.

## The Algorithm

The entry point is harmonizeProg, which requires:

* **progression**: an Array of Symbols (chord ciphers), and

* **durations**: an Array of Integers (one per chord).
Both arrays must have the same length.

The progression is parsed to extract and store per-chord data in a Dictionary: root, chord quality (major, minor, diminished, augmented), and the interval from the previous chord’s root. During parsing, a specific rule profile is assigned to each chord to guide generation. The parser then collects chord data from the static library (MIDI-note ranges and degree arrays).

Before backtracking, these note ranges are filtered by voice range, and—depending on the rules and the previous chord—by (a) removing notes that violate melodic-interval constraints and (b) optionally collapsing candidates to the common tone when applicable. This filtering is repeated for each chord as backtracking traverses the progression.

Generation uses two nested backtracking loops. The inner loop builds all valid chord realizations for a given previous chord from the filtered note sets; the outer loop steps through the entire progression, trying candidate realizations in sequence. If at any point no valid realization can be found—or all candidates are exhausted—the algorithm backtracks to the last stable position, selects the next candidate, and continues.

On success, the function returns an array with two elements:

* `~result[0]` = arrays of MIDI notes per voice [Bass, Tenor, Alto, Soprano]

* `~result[1]` = arrays of durations per voice [Bass, Tenor, Alto, Soprano]

On occasion, the program might fail to generate a progression, in which case an error message is prompted. This is rare, and will be addressed over time as the rule profiling process matures. In these instances, the user may want to experiment with the `direction` parameter.

## Usage

Clone the repository and load the entry file into a project file of your own:

```SuperCollider
"/local/path/to/sc_harmonizer01/src/loadall.scd".load;
```

Then call the main function:

```SuperCollider
harmonizeProg.(progression, durations, direction: "line", sustain: true, score: false, logger: false)
```

#### Arguments

+ **progression** (Array of Symbols) – chord progression to harmonize. Symbols must match the static library (see Valid chord symbols).

+ **durations** (Array of Integers) – one duration per chord. Must match the length of progression.

+ **direction** (String, default "line") – upper-voice motion: "up", "down", or "line" (ranged, centered on first chord’s top note).

+ **sustain** (Boolean, default true) – sustains common tones by extending the first note’s duration.

+ **score** (Boolean, default false) – exports score via Python 3 + music21 + Finale/Sibelius/MuseScore.

+ **logger** (Boolean, default false) – prints function call traces (debugging).

#### Example
```SuperCollider
~progression = ['CM', 'FM', 'GM', 'CM'];
~durations  = [2, 1, 1, 2];
~result = harmonizeProg.(~progression, ~durations);
```
#### Return format

```SuperCollider
[
    // MIDI notes per voice
    [ [..Bass..], [..Tenor..], [..Alto..], [..Soprano..] ],
    // durations per voice
    [ [..Bass..], [..Tenor..], [..Alto..], [..Soprano..] ]
]
```

You can then map each voice into a Pbind (see `main.scd` for a full example).

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

A more complete example is available in `main.scd`.

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

This project is released under the MIT License.

