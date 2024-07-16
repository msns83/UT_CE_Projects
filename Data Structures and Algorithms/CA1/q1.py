str = [*input()]
indeces = [0]
max = 1

for i in range(0, len(str)-1):
    if str[i] == str[i+1]:
        indeces.append(i+1)
indeces.append(len(str))
indeces.append(len(str))

for i in range(0, len(indeces)-2):
    if max < indeces[i+2] - indeces[i]:
        max = indeces[i+2] - indeces[i]


print(max)
