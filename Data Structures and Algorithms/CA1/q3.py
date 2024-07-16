count = 0


def tryNumbers(numbers, index):
    if len(numbers) == 0:
        global count
        count += 1

    for i in range(0, len(numbers)):
        if numbers[i] % index == 0 or index % numbers[i] == 0:
            temp = numbers[i]
            numbers.remove(temp)
            tryNumbers(numbers, index+1)
            numbers.insert(i, temp)
    else:
        pass


n = int(input())
tryNumbers([*range(1, n+1)], 1)
print(count)
