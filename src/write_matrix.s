.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

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
    
        add s0,x0,a1
	add s2,x0,a2  
	add s1,x0,a3  
	addi a1,x0,1
	call fopen  
	addi t0,x0, -1
	beq a0, t0, error27
    
        sw a0, 0(sp)
	addi a0,x0 8  
	call malloc

	add s4,x0,a0  
	sw s2, 0(s4)  
	sw s1, 4(s4)  
	lw a0, 0(sp)  
	add a1,x0 s4  
	addi a2,x0, 2
	add s3,x0, a2  
	addi a3,x0, 4
	call fwrite  
	bne a0, s3, error30

	lw a0, 0(sp) 
	add a1,x0, s0  
	mul a2, s2, s1  
	add s6,x0, a2  
	addi a3,x0, 4
	call fwrite
	bne a0, s6, error30

	lw a0, 0(sp)  
	call fclose
	bne a0,x0, error28

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

error27:
	addi a0,x0 27
	j exit


error28:
	addi a0,x0, 28
	j exit

error30:
	addi a0,x0, 30
	j exit

