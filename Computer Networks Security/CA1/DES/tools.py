import sys
from BitVector import BitVector
import random

def get_encryption_key():
    key = ""
    while True:
        if sys.version_info[0] == 3:
            key = input("\nEnter a string of 8 characters for the key: ")
        else:
            key = raw_input("\nEnter a string of 8 characters for the key: ")
        if len(key) != 8:
            print("\nKey generation needs 8 characters exactly.  Try again.\n")
            continue
        else:
            break
    return key

def test_avalanche(cipher, test_word="testtest", verbose=False):
    plain_text = BitVector(textstring=test_word)
    normal = cipher.encrypt(bits_input=plain_text, key='yourkeys')
    random_index = random.randint(0, len(plain_text)-1)
    plain_text[random_index] =  not plain_text[random_index]
    edited = cipher.encrypt(bits_input=plain_text, key='yourkeys')
    result = edited ^ normal
    avalanche = result.count_bits()
    if verbose:
        print("Avalanche Effect (changed bits in a 64 bits ciphertext for 1 bit change in a 64 bit plain text):", avalanche)
    return avalanche


