from BitVector import BitVector
import random
from .tools import get_encryption_key
from .permutation import *

class DES:
    def __init__(self, itr_nums=16, rnd_sboxes=False):
        self.itr = itr_nums
        if rnd_sboxes:
            self.sboxes = {i:[ [random.randint(0,15) for _ in range(16)] for _ in range(4)] for i in range(8)}
        else:
            self.sboxes = s_boxes

    def __get_key(self, key):
        if (not key) or not (len(key) == 8):
            key = get_encryption_key()
    
        return BitVector(textstring=key).permute(key_parity_permutation)
    
    def __read_file(self, file_name):
        input_bits = BitVector(filename=file_name)
        raw_bits = BitVector(size=0)
        while (input_bits.more_to_read):
            read_block = input_bits.read_bits_from_file(64)
            if read_block._getsize() > 0:
                raw_bits = raw_bits + read_block
        return raw_bits
                
    def __write_file(self, data, file_name):
        OUTFILE = open(file_name, 'wb')
        data.write_to_file(OUTFILE)
        OUTFILE.close()

    def decrypt(self, bits_input=None, key=None, plain_file=None, cipher_file=None):
        round_keys = self.__generate_round_keys(self.__get_key(key), self.itr)
        round_keys.reverse()

        if not bits_input:
            bits_input = self.__read_file(cipher_file)
        output = self.__algorithm(bits_input, round_keys)
        if plain_file:
            self.__write_file(output, plain_file)
        return output

    def encrypt(self, bits_input=None, key=None, plain_file=None, cipher_file=None):
        round_keys = self.__generate_round_keys(self.__get_key(key), self.itr)

        if not bits_input:
            bits_input = self.__read_file(plain_file)
        output = self.__algorithm(bits_input, round_keys)
        if cipher_file:
            self.__write_file(output, cipher_file)
        return output

    def __generate_round_keys(self, encryption_key, keys_num=16):
        round_keys = []
        key = encryption_key.deep_copy()
        for round_count in range(keys_num):
            [LKey, RKey] = key.divide_into_two()    
            shift = shifts_for_round_key_gen[round_count]
            LKey << shift
            RKey << shift
            key = LKey + RKey
            round_key = key.permute(round_key_permutation)
            round_keys.append(round_key)
        return round_keys

    def __iterate(self, Lp:BitVector, Rp:BitVector, Ki):
        F_result = self.__F_function(Rp, Ki) # F function
        Ln = Rp
        Rn = Lp ^ F_result # XOR
        return Ln, Rn

    def __F_function(self, R:BitVector, key):
        new_R = R.permute(expansion_permutation) # Expansion Permutation
        out_xor = new_R ^ key # Round Key XOR
        out_sboxes = self.__substitute(out_xor) # S boxes
        output = out_sboxes.permute(P_box_permutation) # P boxes
        return output
    
    def __substitute(self, expanded_half_block):
        output = BitVector(size=32)
        segments = [expanded_half_block[x*6:x*6+6] for x in range(8)]
        for sindex in range(len(segments)):
            row = 2*segments[sindex][0] + segments[sindex][-1]
            column = int(segments[sindex][1:-1])
            output[sindex*4:sindex*4+4]=BitVector(intVal=self.sboxes[sindex][row][column], size=4)
        return output

    def __algorithm(self, input:BitVector, round_keys):
        if len(input)%64 != 0:
            input = input + BitVector(intVal=0, size=64-(len(input)%64))
        output_bits = BitVector(size=0)

        for i in range(0,len(input),64):
            bit_block = input[i:i+64].deep_copy()
            bit_block = bit_block.permute(initial_permutation) # initial permutation
            L, R = bit_block.divide_into_two() # break block

            for key in round_keys:
                L, R = self.__iterate(L, R, key) # itration
            
            bit_block = R + L # concat 
            bit_block = bit_block.permute(initial_permutation_inverse) # initial permutation inverse
            output_bits = output_bits + bit_block
        return output_bits
    
            
