.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t0,a0,0
    add a0, x0, x0
    add t1,x0,x0
    addi t2, x0, 4
    mul a3, a3, t2
    mul a4, a4, t2
    addi a5, x0, 1
    addi a6, x0, 1
    addi a7, x0, 1
    

    # Prologue
    


loop_start:

          
          blt a2,a5, loop_exit
          blt a3,a6, loop_exit1
          blt a4,a7, loop_exit2
          beq t1, a2, loop_end
          mul t2, t1, a3
          mul t3, t1, a4
          add t5, t0, t2
          add t6, a1, t3
          lw t5, 0(t5)
          lw t6, 0(t6)
          mul t5, t5, t6
          add a0, a0, t5
          addi t1, t1, 1
          j loop_start
loop_end:
    # Epilogue
    jr ra
loop_exit:
         li a0,36
         j exit
loop_exit1:
         li a0,37
         j exit
loop_exit2:
         li a0,37
         j exit
