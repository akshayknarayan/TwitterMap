import string

class Sentiment:
    def __init__(self):
        self.wordmap = {}
        with open('sentiments.csv') as f:
            lines = f.readlines()
            for line in lines:
                spl = line.split(',')
                self.wordmap[spl[0]] = float(spl[1])

    def matchText(self, text):
        stripped = ''.join(letter for letter in text if (letter in string.letters) or (letter == ' '))
        total = 0
        words = stripped.split()
        for x in words:
            if x in self.wordmap:
                total += self.wordmap[x]
        return float(total)/len(words)
