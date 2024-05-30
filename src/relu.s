.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:

    # Prologue
    add t0, x0, x0
    addi t6, x0, 1
loop_start:
           beq t0,a1, loop_end
           blt a1,t6, loop_exit
           addi t2,x0,4
           mul t1,t0,t2
           add t2,t1,a0
           lw t4, 0(t2)
           bge t4,x0, loop_continue
           add t4, x0, x0
           sw t4,0(t2)
           
loop_continue:
             addi t0,t0,1
             j loop_start
loop_end:
       jr ra
loop_exit:
         li a0,36
         j exit