from math import floor
import sys
import re


INVALID_INDEX = 'invalid index'
OUT_OF_RANGE_INDEX = 'out of range index'
EMPTY = 'empty'


class MinHeap:
    class Node:
        pass

    def __init__(self):
        self.heapArr = []

    def bubble_up(self, index):
        if not isinstance(index, int):
            raise Exception(INVALID_INDEX)
        if not (0 <= index <= len(self.heapArr)):
            raise Exception(OUT_OF_RANGE_INDEX)

        while (0 < index and self.heapArr[index] <= self.heapArr[floor((index+1)/2)-1]):
            temp = self.heapArr[index]
            self.heapArr[index] = self.heapArr[floor((index+1)/2)-1]
            self.heapArr[floor((index+1)/2)-1] = temp
            index = floor((index+1)/2)-1

    def bubble_down(self, index):
        if not isinstance(index, int):
            raise Exception(INVALID_INDEX)
        if not (0 <= index <= len(self.heapArr)):
            raise Exception(OUT_OF_RANGE_INDEX)

        smallest = index
        left = 2*(index+1) - 1
        right = 2*(index+1)
        if (right < len(self.heapArr) and self.heapArr[right] <= self.heapArr[smallest]):
            smallest = right
        if (left < len(self.heapArr) and self.heapArr[left] <= self.heapArr[smallest]):
            smallest = left
        if (smallest != index):
            temp = self.heapArr[index]
            self.heapArr[index] = self.heapArr[smallest]
            self.heapArr[smallest] = temp
            self.bubble_down(smallest)

    def heap_push(self, value):
        self.heapArr.append(value)
        self.bubble_up(len(self.heapArr)-1)

    def heap_pop(self):
        if len(self.heapArr) == 0:
            raise Exception(EMPTY)

        head = self.heapArr[0]
        if 1 < len(self.heapArr):
            self.heapArr[0] = self.heapArr.pop()
            self.bubble_down(0)
        else:
            self.heapArr.pop()

        return head

    def find_min_child(self, index):
        if not isinstance(index, int):
            raise Exception(INVALID_INDEX)
        if not (0 <= index <= len(self.heapArr)):
            raise Exception(OUT_OF_RANGE_INDEX)

        left = 2*(index+1) - 1
        right = 2*(index+1)
        smallest = left
        if (self.heapArr[right] <= self.heapArr[smallest]):
            smallest = right
        return smallest

    def heapify(self, *args):
        for element in args:
            self.heap_push(element)


class HuffmanTree:
    class Node:
        def __init__(self, char, freq):
            self.char = char
            self.freq = freq
            self.left = None
            self.right = None

    def __init__(self):
        self.nodes = []
        self.chars = []
        self.frequens = []
        self.root = None

    def set_letters(self, *args):
        self.chars = [*args]

    def set_repetitions(self, *args):
        self.frequens = [*args]

    def build_huffman_tree(self):
        self.totalList = list(zip(self.chars, self.frequens))
        nodes = [self.Node(char, freq) for char, freq in self.totalList]
        nodes.sort(key=lambda node: node.freq)

        while len(nodes) > 1:
            left = nodes.pop(0)
            right = nodes.pop(0)
            merged = self.Node(None, left.freq + right.freq)
            merged.left = left
            merged.right = right
            i = 0
            while i < len(nodes) and nodes[i].freq < merged.freq:
                i += 1
            nodes.insert(i, merged)

        self.root = nodes[0]

    def generate_huffman_codes(self, root, current_code="", codes={}):
        if root is None:
            return

        if root.char is not None:
            codes[root.char] = current_code

        self.generate_huffman_codes(root.left, current_code + "0", codes)
        self.generate_huffman_codes(root.right, current_code + "1", codes)

        return codes

    def get_huffman_code_cost(self):
        self.huffmanCodes = self.generate_huffman_codes(self.root)
        cost = 0

        for char, freq in self.totalList:
            cost += len(self.huffmanCodes[char]) * freq

        return cost

    def text_encoding(self, text):
        frequencyDict = {}
        for char in text:
            if char in frequencyDict:
                frequencyDict[char] += 1
            else:
                frequencyDict[char] = 1

        self.chars = list(frequencyDict.keys())
        self.frequens = list(frequencyDict.values())
        self.build_huffman_tree()


class Bst:
    class Node:
        def __init__(self, key):
            self.key = key
            self.left = None
            self.right = None

    def __init__(self):
        self.root = None

    def insertRec(self, node, key):
        if key < node.key:
            if node.left is None:
                node.left = self.Node(key)
            else:
                self.insertRec(node.left, key)
        elif key > node.key:
            if node.right is None:
                node.right = self.Node(key)
            else:
                self.insertRec(node.right, key)

    def insert(self, key):
        if self.root is None:
            self.root = self.Node(key)
        else:
            self.insertRec(self.root, key)

    def inorderRec(self, node, keys):
        if node is not None:
            self.inorderRec(node.left, keys)
            keys.append(node.key)
            self.inorderRec(node.right, keys)

    def inorder(self):
        keys = []
        self.inorderRec(self.root, keys)
        return ' '.join(str(key) for key in keys)


class Runner:
    dsMap = {'min_heap': MinHeap, 'bst': Bst, 'huffman_tree': HuffmanTree}
    callRegex = re.compile(r'^(\w+)\.(\w+)\(([\w, \-"\']*)\)$')

    def __init__(self, inputSrc):
        self.input = inputSrc
        self.items = {}

    def run(self):
        for line in self.input:
            line = line.strip()
            action, _, param = line.partition(' ')
            actionMethod = getattr(self, action, None)
            if actionMethod is None:
                return
            actionMethod(param)

    def make(self, params):
        itemType, itemName = params.split()
        self.items[itemName] = self.dsMap[itemType]()

    def call(self, params):
        regexRes = self.callRegex.match(params)
        itemName, funcName, argsList = regexRes.groups()

        args = [x.strip() for x in argsList.split(',')
                ] if argsList != '' else []
        args = [x[1:-1] if x[0] in ('"', "'") else int(x) for x in args]

        method = getattr(self.items[itemName], funcName)
        try:
            result = method(*args)
        except Exception as ex:
            print(ex)
        else:
            if result is not None:
                print(result)


def main():
    runner = Runner(sys.stdin)
    runner.run()


if __name__ == "__main__":
    main()
