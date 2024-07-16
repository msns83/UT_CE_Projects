import sys
import re


class Queue:
    def __init__(self):
        self.keeper = []
        self.queSize = 0
        self.head = 0

    def enqueue(self, value):
        self.keeper.append(value)
        self.queSize += 1

    def dequeue(self):
        if (0 < self.queSize):
            val = self.keeper[self.head]
            self.head += 1
            self.queSize -= 1
            return val

    def size(self):
        return self.queSize

    def empty(self):
        if (self.queSize == 0):
            return True
        return False

    def one_line_str(self):
        ans = ""
        for i in range(self.head, len(self.keeper)):
            ans += f"{self.keeper[i]} "
        return ans


class Stack:
    def __init__(self, capacity=10):
        self.keeper = []
        self.stackCount = 0
        self.stackSize = capacity

    def push(self, value):
        if (self.stackCount < self.stackSize):
            self.keeper.append(value)
            self.stackCount += 1

    def pop(self):
        if (0 < self.stackCount):
            self.stackCount -= 1
            return self.keeper.pop()

    def put(self, value):
        self.keeper.pop()
        self.keeper.append(value)

    def peek(self):
        return self.keeper[self.stackCount - 1]

    def expand(self):
        self.stackSize *= 2

    def capacity(self):
        return self.stackSize

    def size(self):
        return self.stackCount

    def empty(self):
        if (self.stackCount == 0):
            return True
        return False

    def one_line_str(self):
        ans = ""
        for i in range(0, self.stackCount):
            ans += f"{self.keeper[i]} "
        return ans


class Node:
    def __init__(self, value, nextNode, preNode):
        self.key = value
        self.next = nextNode
        self.pre = preNode


class LinkedList:
    def __init__(self):
        self.listSize = 0
        self.head = None

    def insert_front(self, value):
        newNode = Node(value, self.head, None)
        if (self.head != None):
            self.head.pre = newNode
        self.head = newNode
        self.listSize += 1

    def insert_back(self, value):
        node = self.head
        if (node == None):
            newNode = Node(value, None, None)
            self.head = newNode
        else:
            while (node.next != None):
                node = node.next
            newNode = Node(value, None, node)
            node.next = newNode
            self.listSize += 1

    def reverse(self):
        node = self.head
        preAddress = self.head
        while (node != None):
            preAddress = node
            address = node.next
            node.next = node.pre
            node.pre = address
            node = address
        self.head = preAddress

    def one_line_str(self):
        ans = ""
        node = self.head
        while (node != None):
            ans += f"{node.key} "
            node = node.next
        return ans


class Runner:
    ds_map = {'stack': Stack, 'queue': Queue, 'linked_list': LinkedList}
    call_regex = re.compile(r'^(\w+)\.(\w+)\(([\w, ]*)\)$')

    def __init__(self, input_src):
        self.input = input_src
        self.items = {}

    def run(self):
        for line in self.input:
            line = line.strip()
            action, _, param = line.partition(' ')
            action_method = getattr(self, action, None)
            if action_method is None:
                return
            action_method(param)

    def make(self, params):
        item_type, item_name = params.split()
        self.items[item_name] = self.ds_map[item_type]()

    def call(self, params):
        regex_res = self.call_regex.match(params)
        item_name, func_name, args_list = regex_res.groups()
        args = args_list.split(',') if args_list != '' else []

        method = getattr(self.items[item_name], func_name)
        result = method(*args)
        if result is not None:
            print(result)


def main():
    runner = Runner(sys.stdin)
    runner.run()


if __name__ == "__main__":
    main()
