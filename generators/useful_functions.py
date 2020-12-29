import random
import time
def csvToList(filePath):
    file = open(filePath)
    toReturn = []
    for line in file:
        line = line.replace("\n","")
        toReturn.append(line.split(","))
    return toReturn


def unpackListOfLists(listOfLists : list , i: int):
    toReturn = []
    for l in listOfLists:
        toReturn.append(l[i])

    return toReturn

def generateRandomNumbersSeqs(n,m):
    
    seqes = []
    while(len(seqes) < n):
        seq = generateRandomNumbersSeq(m)
        if not seq in seqes:
            seqes.append(seq)
    
    return seqes

def generateRandomNumbersSeq(n:int):
    numbers = ["0","1","2","3","4","5","6","7","8","9"]
    return ''.join(random.choices(numbers,k=n))

def getAtRandomNoneOrThat(that, probabilityOfThat = 0.5):
    if random.random() < probabilityOfThat :
        return that
    else: return None

def getRandomDate(fromYear,toYear):
    stime = time.mktime(time.strptime(str(fromYear),"%Y"))
    etime = time.mktime(time.strptime(str(toYear),"%Y"))
    randomDate = stime + (etime - stime) * random.random()
    return time.strftime('%Y%m%d',time.localtime(randomDate))

def getRandomDateTime(fromYear,toYear):
    stime = time.mktime(time.strptime(str(fromYear),"%Y"))
    etime = time.mktime(time.strptime(str(toYear),"%Y"))
    randomDate = stime + (etime - stime) * random.random()
    return time.strftime('%Y%m%d %H:%M:00',time.localtime(randomDate) )