.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

   # Prologue
	addi sp, sp, -40
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)
        sw s7, 32(sp)
        sw ra, 36(sp)

	# Epilogue

	add s3, a1,x0 
	add s2, a2,x0
	addi a1,x0,0
	call fopen

	addi t2,x0 -1
	beq a0, t2, error27
	sw a0, 0(sp)
	add a1, s3,x0
	addi s5,x0, 4
	add a2, s5,x0
	call fread
	bne a0, s5, error29

	add a1, s2,x0
	add a2, s5,x0
	lw a0, 0(sp)
	call fread
	bne a0, s5, error29
    
        lw t2, 0(s3)
	lw t3, 0(s2)  
	mul s4, t2, t3
	slli s4, s4, 2 
	addi a0, s4,0
	call malloc
	beq a0,x0, error26

	add s7, a0,x0
	lw a0, 0(sp)
	add a1, s7,x0
	add a2, s4,x0
	call fread
	bne a0, s4, error29

	lw a0, 0(sp)
	call fclose
	bne a0,x0 error28

	add a0, s7,x0
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
	lw s6, 28(sp)
        lw s7, 32(sp)
        lw ra, 36(sp)
	addi sp, sp, 40
	
    jr ra
    
error26:
	addi a0,x0, 26
	j exit

error27:
	addi a0,x0, 27
	j exit

error29:
	addi a0,x0, 29
	j exit

error28:
	addi a0,x0, 28
	j exit


    
