addi s7, zero, 40           # Initialize s7 with the value 40
lw s1, zero(0)              # Set s1 to first element of array ; It is Result     
add s2, zero, zero          # Set s2 to 0 ; It is i
LOOP: beq s2, s7, END(28)   # If s2 equals 40 (s7), jump to END
lw s4, s2(0)               # Load array elment Arr[s2] from memory address into s4 
slt s5, s4, s1              # Set s5 to 1 if s4 < s1, else set s5 to 0
beq s5, zero, ADD(8)        # If s5 is 0 (i.e., s4 >= s1), jump to ADD (didn't catch!)
add s1, s4, zero            # Set s1 to the value of s4 (copy s4 to s1) (catched!)
ADD: addi s2, s2, 4         # Increment s2 by 4 (i++)
jal LOOP(-24)               # Jump to Loop (creates a recursive loop)
END: jal END(0)             # End of the program