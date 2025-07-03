from music21 import *
import os

def parseSCDump():
    with open("/home/siriil/Music/projects/harmony01/data/scdump/python/dump.txt", "r") as file:
        chords = []
        progSize = int(file.readline()) 

        for _ in range(0, progSize):
            chords.append(str(file.readline()).strip(" \n").split(" "))

        ciphers = []
        rules = []
        for _ in range(0, progSize):
            rule = []
            ciphers.append(str(file.readline()).strip(" \n"))
            for _ in range(0, 14):
                rule.append(str(file.readline()).strip(" \n"))

            rules.append(rule)

    for i in range(0, progSize):
        if "b" in ciphers[i]:
            ciphers[i] = ciphers[i].replace("b", "-")

    return progSize, ciphers, chords, rules



def getScore(size, ciphers, chords, rules):
    score = stream.Score()


    #tclef = clef.TrebleClef()
    #bclef = clef.BassClef()

    #treble.append(tclef)
    #bass.append(bclef)

    for cipher, chord in zip(ciphers, chords):
        measure = stream.Measure()

        treble = stream.Part()
        bass = stream.Part()
        
        bas = stream.Voice()
        ten = stream.Voice()
        alt = stream.Voice()
        spn = stream.Voice()

        voices = [bas, ten, alt, spn]

        symbol = harmony.ChordSymbol(cipher)

        measure.insert(0, symbol)

        for v, i in zip(voices, range(0, 4)):
            dur = duration.Duration(type = 'whole')
            nt = note.Note(chord[i])
            nt.duration = dur;
            v.append(nt)
        
        treble.append([spn, alt])
        bass.append([ten, bas])

        measure.insert(0, treble)
        measure.insert(0, bass)

        score.insert(0, measure)
   # for v, i in zip(voices, range(0, 4)):
   #     for c, j in zip(ciphers, range(0, size)):

   #         if i == 3:
   #             cipher = harmony.ChordSymbol(ciphers[j])
   #             v.append(cipher)

   #         stm = 'down' if i % 2 == 0 else 'up'
   #         dur = duration.Duration(type='whole')
   #         nt = note.Note(chords[j][i])

   #         nt.duration = dur
   #         nt.stemDirection = stm
   #         v.append(nt)

   #        # if i == 0:
   #        #     for k in rules[j]:
   #        #         rule = expressions.TextExpression(k)
   #        #         rule.style.fontSize = 5
   #        #         v.append(rule)

   # tclef = clef.TrebleClef()
   # bclef = clef.BassClef()

   # treble.append(tclef)
   # bass.append(bclef)

   # treble.append([alt, spn])
   # bass.append([bas, ten])
   # 

   # for part in [treble, bass]:
   #     for m in part.getElementsByClass("Measure"):
   #         m.rightBarline = bar.Barline("regular")
   #         m.layoutWidth = 800
   #         m.insert(0, layout.SystemLayout(isNew=True))

   # score.insert(0, treble)
   # score.insert(0, bass)

    score.show()
    

size, ciphers, chords, rules = parseSCDump()
getScore(size, ciphers, chords, rules)
