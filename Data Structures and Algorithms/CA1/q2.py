key, expression = [*input()], [*input()]

for i in range(0, len(key)):
    if expression[i] == key[i]:
        continue
    for j in range(i+2, len(expression), 2):
        if expression[j] == key[i]:
            expression[i], expression[j] = expression[j], expression[i]
            break
    else:
        break

if key == expression:
    print("yes")
else:
    print("no")
