.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    
    # Prologue
    addi sp, sp, -56
    sw a7, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    sw ra, 52(sp)
    
    addi t1,x0, 5
    bne a0, t1, incorrectargs
    
    addi sp, sp, -4
    sw a2, 0(sp)
    add s0, a1,x0
    
     
    # Read pretrained m0
    addi a0, x0,4
    call malloc
    add s2, a0,x0
    beq s2, zero, errorMalloc
    
    addi a0,x0, 4
    call malloc
    add s1, a0,x0
    beq s1, zero, errorMalloc
    
    lw a0, 4(s0)
    add a1, s2,x0
    add a2, s1,x0
    call read_matrix
    add s4, a0,x0

    
    # Read pretrained m1
    addi a0,x0, 4
    call malloc
    add s3, a0,x0
    beq s3, zero, errorMalloc
    
    addi a0,x0, 4
    call malloc
    add s6, a0,x0
    beq s6, zero, errorMalloc
    
    lw a0, 8(s0)
    add a1, s3,x0
    add a2, s6,x0
    call read_matrix
    add s5, a0,x0

    
    # Read input matrix
    addi a0,x0, 4
    call malloc
    add s8, a0,x0
    beq s8, zero, errorMalloc
    
    addi a0,x0, 4
    call malloc
    add s7, a0,x0
    beq s7, zero, errorMalloc
    
    lw a0, 12(s0)
    add a1, s8,x0
    add a2, s7,x0
    call read_matrix
    add s9, a0,x0

    
    # Compute h = matmul(m0, input)
    mul t1, s2, s7
    slli t2, t1, 2
    add a0, t2,x0
    call malloc
    add s11, a0,x0
    beq s11, zero, errorMalloc
    
    add a0, s4,x0
    lw a1, 0(s2)
    lw a2, 0(s1)
    add a3, s9,x0
    lw a4, 0(s8)
    lw a5, 0(s7)
    add a6, s11,x0
    call matmul

    
    # Compute h = relu(h)
    add a0, s11,x0
    lw t1, 0(s2)
    lw t2, 0(s7)
    mul a1, t1, t2
    call relu

    
    # Compute o = matmul(m1, h)
    lw t1, 0(s3)
    lw t2, 0(s7)
    mul t3, t1, t2
    slli t4, t3, 2
    add a0, t4,x0
    call malloc
    add s10, a0,x0
    beq s10, x0, errorMalloc
    
    add a0, s5,x0
    lw a1, 0(s3)
    lw a2, 0(s6)
    add a3, s11,x0
    lw a4, 0(s2)
    lw a5, 0(s7)
    add a6, s10,x0
    call matmul

    
    # Write output matrix o
    lw a0, 16(s0)
    add a1, s10,x0
    lw a2, 0(s3)
    lw a3, 0(s7)
    call write_matrix

    
    # Compute and return argmax(o)
    add a0, s10,x0
    lw t1, 0(s3)
    lw t2, 0(s7)
    mul a1, t1, t2
    call argmax
    add s11, a0,x0

    
    # If enabled, print argmax(o) and newline
    lw t1, 0(sp)
    addi sp, sp, 4
    addi t2,x0, 1
    beq t1, t2, finish
    add a0, s11,x0
    call print_int
    addi a0,x0, '\n'
    call print_char
finish:
    add a0, s1,x0
    call free
    add a0, s2,x0
    call free
    add a0, s3,x0
    call free
    add a0, s4,x0
    call free
    add a0, s5,x0
    call free
    add a0, s6,x0
    call free
    add a0, s7,x0
    call free
    add a0, s8,x0
    call free
    add a0, s9,x0
    call free
    
    add a0, s10,x0
    call free
    
    add a0, s11,x0
    
    # Epilogue
    lw a7, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    lw ra, 52(sp)
    addi sp, sp, 56
    
    jr ra

errorMalloc:
    addi a0,x0 26
    j exit

incorrectargs:
    addi a0,x0, 31
    j exit
