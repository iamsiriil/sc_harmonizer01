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

    treble = stream.Part()
    bass = stream.Part()

    treble.append(clef.TrebleClef())
    bass.append(clef.BassClef())

    treble.append(meter.TimeSignature('4/4'))
    bass.append(meter.TimeSignature('4/4'))

    for cipher, chord in zip(ciphers, chords):
        tmeasure = stream.Measure()
        bmeasure = stream.Measure()
        tmeasure.layoutWidth = 1600
        bmeasure.layoutWidth = 1600

        symbol = harmony.ChordSymbol(cipher)
        tmeasure.insert(0, symbol)

        bas = stream.Voice()
        ten = stream.Voice()
        alt = stream.Voice()
        spn = stream.Voice()

        dur = duration.Duration(type='whole')
        snote = note.Note(chord[3], duration=dur)
        anote = note.Note(chord[2], duration=dur)
        tnote = note.Note(chord[1], duration=dur)
        bnote = note.Note(chord[0], duration=dur)

        spn.append(snote)
        alt.append(anote)
        ten.append(tnote)
        bas.append(bnote)

        tmeasure.insert(0, spn)
        tmeasure.insert(0, alt)
        bmeasure.insert(0, ten)
        bmeasure.insert(0, bas)

        treble.append(tmeasure)
        bass.append(bmeasure)

    score.insert(0, treble)
    score.insert(0, bass)

    lastTrebleMeasure = treble.getElementsByClass('Measure')[-1]
    lastBassMeasure = bass.getElementsByClass('Measure')[-1]

    finalBar = bar.Barline('light-heavy')
    lastTrebleMeasure.rightBarline = finalBar
    lastBassMeasure.rightBarline = finalBar

    score.show()
    

getScore(*parseSCDump())
