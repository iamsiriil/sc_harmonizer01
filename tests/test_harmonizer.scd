/**************************************************************************************
- HARMONY 01 / Test ~harmonizeProg
**************************************************************************************/
// Fixtures
(
~getTwoChordProg = {

};

~progA = ['CA', 'DbA', 'DA', 'EbA', 'EA', 'FA', 'F#A', 'GA', 'AbA', 'AA', 'BbA', 'BA'];
~progM = ['CM', 'DbM', 'DM', 'EbM', 'EM', 'FM', 'F#M', 'GM', 'AbM', 'AM', 'BbM', 'BM'];
~progm = ['Cm', 'C#m', 'Dm', 'Ebm', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'Bbm', 'Bm'];
~progd = ['Cd', 'C#d', 'Dd', 'Ebd', 'Ed', 'Fd', 'F#d', 'Gd', 'G#d', 'Ad', 'Bbd', 'Bd'];
~dur = 1 ! 12;

~result = ~harmonizeProg.(~progA, ~dur, scr: true);
)
(
~triads.keys.select({ |k| k.asString.last == $d})
)
1 ! 12