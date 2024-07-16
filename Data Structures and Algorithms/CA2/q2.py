from collections import deque

que = deque([])

def operator(command):
  if command[0] == "back":
    if(len(que) == 0):
      print("No job")
    else:
        print(que.popleft())
  elif command[0] == "front":
    if(len(que) == 0):
      print("No job")
    else:
        print(que.pop())
  elif command[0] == "reverse":
    que.reverse()
  elif command[0] == "push_back":
    que.appendleft(command[1])
  elif command[0] == "push_front":
    que.append(command[1])

def main():
  q = int(input())
  for i in range(0,q):
    command = input().split()
    operator(command)
    

main()