from music21 import *

def parseSCDump():
    file = open("./scdump/dump01.txt", "r")
    voices = [[], [], [], []]
    numVoices = int(file.readline()) 

    for n in range(0, numVoices):
        notes = str(file.readline().strip("\n")) 
        durations = str(file.readline().strip("\n")) 
        voices[n].append(list(map(int, notes.strip("[]").split(", "))))
        voices[n].append(list(map(int, durations.strip("[]").split(", "))))

    file.close

    return voices

rules = []
#parts = parseSCDump()
#
#score = stream.Score()
#
#treble = stream.Part()
#bass = stream.Part()
#
#spn = stream.Voice()
#alt = stream.Voice()
#ten = stream.Voice()
#bas = stream.Voice()
#
#for n in parts[0][0]:
#    nt = note.Note()
#    dur = duration.Duration(type='half')
#    nt.pitch.midi = n
#    nt.duration = dur
#    nt.stemDirection = 'down'
#    bas.append(nt)
#
#for n in parts[1][0]:
#    dur = duration.Duration(type='half')
#    nt = note.Note()
#    nt.pitch.midi = n
#    nt.duration = dur
#    nt.stemDirection = 'up'
#    ten.append(nt)
#
#for n in parts[2][0]:
#    dur = duration.Duration(type='half')
#    nt = note.Note()
#    nt.pitch.midi = n
#    nt.duration = dur
#    nt.stemDirection = 'down'
#    alt.append(nt)
#
#for n in parts[3][0]:
#    dur = duration.Duration(type='half')
#    nt = note.Note()
#    nt.pitch.midi = n
#    nt.duration = dur
#    nt.stemDirection = 'up'
#    spn.append(nt)
#
#bass.append(bas)
#bass.append(ten)
#treble.append([alt, spn])
#
#score.insert(0, treble)
#score.insert(0, bass)
#
#score.show()
