from music21 import *

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

    return progSize, ciphers, chords, rules


size, ciphers, chords, rules = parseSCDump()

#for i in range(0, size):
    #print(ciphers[i])
   # print(chords[i])
   # for r in rules[i]:
   #     print(r)
def getScore(size, ciphers, chords, rules):
    score = stream.Score()

    treble = stream.Part()
    bass = stream.Part()

    bas = stream.Voice()
    ten = stream.Voice()
    alt = stream.Voice()
    spn = stream.Voice()

    voices = [bas, ten, alt, spn]

    for v, i in zip(voices, range(0, 4)):
        for c, j in zip(ciphers, range(0, size)):
            stm = 'down' if i % 2 == 0 else 'up'
            dur = duration.Duration(type='whole')
            nt = note.Note(chords[j][i])

            nt.duration = dur
            nt.stemDirection = stm
            v.append(nt)

            if i == 0:
                for k in rules[j]:
                    rule = expressions.TextExpression(k)
                    rule.style.fontSize = 5
                    v.append(rule)




    bass.append([bas, ten])
    treble.append([alt, spn])

    score.insert(0, treble)
    score.insert(0, bass)

    score.show()
    

getScore(size, ciphers, chords, rules)
