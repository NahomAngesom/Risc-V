.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    

    
    addi t5, x0, 0
    # Error checks
    mul t3, a1, a2
    mul t4, a4, a5
    ble t3, t5, error_checks
    ble t4, t5, error_checks
    bne a2, a4, error_checks
    

    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    addi s0,a0,0
    addi s1, a3,0
    addi s2, a1,0
    addi s3, a2,0
    addi s4, a5,0
    addi s5, a6,0
    addi s6, a6,0

    add s7,x0,x0
    # Prologue

outer_loop_start:
    beq s7, s2, outer_loop_end
    add s8,x0,x0

    j inner_loop_start

inner_loop_start:
    beq s8, s4, inner_loop_end
    addi a0, s0,0
    addi a1, s1,0
    addi a2, s3,0
    addi a3, x0, 1
    addi a4, s4,0
    jal ra, dot 
    sw a0, 0(s5)
    addi s5, s5, 4
    addi s1, s1, 4
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi t4,zero, 4
    mul t4, t4, s3
    add s0, s0, t4
    addi t4,zero, -4
    mul t4, t4, s4
    add s1, s1, t4
    addi s7, s7, 1

    j outer_loop_start

outer_loop_end:

    # Epilogue
    addi a6, s6,0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    jr ra

error_checks:
    addi a0, x0, 38
    j exit
