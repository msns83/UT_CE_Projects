from DES.main import DES
from DES.tools import test_avalanche

def encryption_decryption():
    en_plain_text_file = "./text_files/input.txt"
    en_cipher_text_file = "./text_files/ciphertext.txt"

    de_cipher_text_file = "./text_files/ciphertext.txt"
    de_plain_text_file = "./text_files/output.txt"

    cipher = DES()
    cipher.encrypt(plain_file=en_plain_text_file, cipher_file=en_cipher_text_file)
    cipher.decrypt(plain_file=de_plain_text_file, cipher_file=de_cipher_text_file)

def avalanche_effect():
    times = 50
    des_ava = 0
    rnd_ava = 0
    for _ in range(times):
        des_ava += test_avalanche(DES(rnd_sboxes=False))
        rnd_ava += test_avalanche(DES(rnd_sboxes=True))
    des_ava = des_ava/times
    rnd_ava = rnd_ava/times     

    print("--- DES S Boxes Avalanche Effect ---")
    print(f"Average ({times} times) (changed bits in a 64 bits ciphertext for 1 bit change in a 64 bit plain text):")
    print(des_ava)
    print("--- Random S Boxes Avalanche Effect ---")
    print(f"Average ({times} times) (changed bits in a 64 bits ciphertext for 1 bit change in a 64 bit plain text):")
    print(rnd_ava)

def main():
    encryption_decryption()
    avalanche_effect()
    
main()