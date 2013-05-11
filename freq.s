# Author - Nikolay Bogoychev
# S/N - s1031254
# Counts how many times each letter occurs in a String.
		.data
welcome_msg:	.asciiz	"Enter text, followed by $:\n"
		.globl main
number_occ:	.space 104 # This is the String where we keep how many times each letter occurs. The space left
			   # is 104 since the English alphabet is 26 symbols and each integer requires 4 bytes 
			   # of space so 26*4=104

		.text
main:
		li $s0, 90 # Load the code for ANSII Z. We will need that when telling the program to use different
			   # cycles for lowercase and uppercase letters since they have different ANSII codes.
			   # $s1 to $s5 are used to store ANSII codes of symbols 
			   # whose counting we'll skip and $s6 is used to store
			   # a symbol which we'd use when formatting the print output
		li $s1, 36 # Store the $ character to detect string end
		li $s2, 32 # Store ANSII space
		li $s3, 9  # Store ANSII tab
		li $s4, 10 # Store ANSII new line feed
		li $s5, 15 # Store ANSII carriage return
		li $s6, 58 # Store ANSII Colon used for formating string

		li $v0, 4 # Load code for priting string.
		la $a0, welcome_msg # Print the welcome message
		syscall

input:		
		li $v0,12 # Load the syscode for reading a char.
		syscall # Read a char from the command line.
		
		beq $v0, $s1, print_prep # Jump to printing preparation if we encouter the end of the string:
		beq $v0, $s2, input # Jump to input in case of space
		beq $v0, $s3, input # Jump to input in case of tab
		beq $v0, $s4, input # Jump to input in case of new line feed
		beq $v0, $s5, input # Jump to input in case of carriage return
		bgt $v0, $s0, lowercase # If we encouter a lowercase letter give it to lowercase to process
		# Explaining the logic: We'd first get the alphabet letters to get the following codes:
		# 0 for A, 1 for B, etc... (Done by the next line or the lowercase section in case the letter is lowercase
		# Then used those codes, shifted by 2 positions (meaning multiplied by 4) to address particular elements
		# in the array that stores the frequencies. For example the element for the letter A is going to be 
		# number_occ[0], for letter B it is number_occ[4] (because letter A takes bytes from 0 to 3 and so the integer
		# for letter B is located starting position 4, letter C goes to 8, etc.
		addi $v0, -65 # Get the input symbols so that A=0, B=1, etc...)
array_op:
		sll $v0, $v0, 2 # Multiplies $v0 to 4 so that we get the necessary position for the array element.
		la $t0, number_occ # Load the array in $t0
		add $t0, $t0, $v0 # Get the counter to point to the right position for the curret letter..
		lw $t1, 0($t0) # Load the current number count for the letter needed in $t1
		addi $t1, 1 # Increment the counter for the particular letter
		sw $t1, number_occ($v0) # Store back to the array
		j input # loop back to process the next input symbol.

lowercase:
		addi $v0, -97 # Get the input symbols so that a=0, b=1, etc...)
		j array_op # Jump to the part of the code that actually works with the array.
print_prep:
		li $s0, 64 # We'll use $s0 to print the letters A, B... in the loop. The ANSII character for A is 65 so	 
			   # we Load the previous number so that we can do incremet in the actual loop. We reuse this register,
			   # since we don't need anymore the old value stored in it.
		li $s1, 0 # Initial value in S1 we're going to use to go through the array and get how many times each letter
			  # occured by using this variable.We reuse this register, since we don't need anymore 
			  # the old value stored in it.
		li $s3, 25 # This variable contains the number of English letters -1 (because we start counting from 0)
			   # we use this to stop the loop and go to the end of the program. We reuse this register, since 
			   # we don't need anymore the old value stored in it.

		li $v0, 11 # Load code for priting char.
		move $a0, $s4 # Print new line to get good formating.
		syscall 
print_loop:	
		addi $s0, 1 # Increment the letter priting variable by one, so that we print the next letter
		move $a0, $s0 # Move to the priting address:
		syscall

		move $a0, $s6 # Move the colon symbol to the priting address
		syscall

		move $a0, $s2 # Move space to the priting address
		syscall

		sll $t0, $s1, 2 # Multiply the array variable by four so that we get to the desired element of the array
		lw $a0, number_occ($t0) # Load the integer value from the desired position in the array to the priting addres.
		li $v0, 1 # Load print integer code and print.
		syscall

		li $v0, 11 # Load code for priting char.
		move $a0, $s4 # Print new line to get good formating.
		syscall

		beq $s3, $s1 end # Check if we've reached the end element of the array.
		addi $s1, 1
		j print_loop # Repeat to print the next letter.

end:
		li $v0, 10
		syscall # Load the exit code and exit the program.