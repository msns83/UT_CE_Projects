addi s7, zero, 40          # Initialize s7 with the value 40
add s1, zero, zero          # Set s1 to 0
add s2, zero, zero          # Set s2 to 0
add s3, zero, zero          # Set s3 to 0

Loop: 
    add s6, s2, s3          # Add values of s2 and s3, store result in s6
    lw s4, s6(0)            # Load word from memory address s6 + 0 into s4
    beq s2, s7, END         # If s2 equals 40 (s7), jump to END

    slt s5, s4, s1          # Set s5 to 1 if s4 < s1, else set s5 to 0
    beq s5, zero, ADD       # If s5 is 0 (i.e., s4 >= s1), jump to ADD

    add s1, s4, zero        # Set s1 to the value of s4 (i.e., copy s4 to s1)

ADD:
    addi s2, s2, 4          # Increment s2 by 4
    jal Loop                # Jump and link to Loop (creates a recursive loop)

END:                        # End of the program