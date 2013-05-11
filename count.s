# Author - Nikolay Bogoychev
# S/N - s1031254
# Counts the number of letters in a String.
		.data
welcome_msg:	.asciiz	"Enter text, followed by $:\n"
out_msg:	.asciiz	"Count: "
		.globl main

		.text

main:
		li $s0, 0  # Use this variable to count the letters.		
			   # $s1 to $s5 are used to store ANSII codes of symbols 
			   # whose counting we'll skip 
		li $s1, 36 # Store the $ character to detect string end
		li $s2, 32 # Store ANSII space
		li $s3, 9  # Store ANSII tab
		li $s4, 10 # Store ANSII new line feed
		li $s5, 15 # Store ANSII carriage return

		li	$v0, 4 # Load system call for printing string:
		la	$a0, welcome_msg # Load welcome message in the output register.
		syscall


letter_coun:				
		li $v0,12 # Load the syscode for reading a char.
		syscall # Read a char from the command line.
		
		beq $v0, $s1, end   # Jump to end if we encouter $ which signals the end of the string:
		beq $v0, $s2, letter_coun # Jump to beginning of the loop in case of space, since we don't count it.
		beq $v0, $s3, letter_coun # Jump to beginning of the loop.in case of tab, since we don't count it.
		beq $v0, $s4, letter_coun # Jump to beginning of the loop in case of new line feed, since we don't count it.
		beq $v0, $s5, letter_coun # Jump to beginning of the loop in case of carriage return, since we don't count it.

		addi $s0, 1 # Incremet actual letter count.
		j letter_coun # Repeat

end:
			   # Print formated text
		li $v0, 11 # Load code for printing char
		add $a0, $zero, $s4 # Print new line.
		syscall

		li $v0, 4  # Load code for printing string
		la $a0, out_msg # Print the formated message
		syscall
			   # Print actual letter count, that we keep in $s0
		li $v0, 1  # Load code for priting int.
		add $a0, $zero, $s0
		syscall
		
		li $v0, 11
		add $a0, $zero, $s4 # Print new line so that we have fancy formatting.
		syscall

			    # Exit the program
		li   $v0, 10
		syscall
