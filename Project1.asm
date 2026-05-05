#Shahd Sbaih .....1220060
#Veronica Wakileh..... 1220245
.data
    Hello_msg: .asciiz   "Welcome to Veronica and Shahd's Project\n" 
    Choose_msg: .asciiz  "\nPlease  choose one of these options :\n"
    FirstDisplay_msg: .asciiz  "\n1- Press 'R/r' to read from a file\n2-Press 'Q/q' to quit\n"
    Enter_msg: .asciiz  "\nPlease enter the correct name of the file:  \n"
    Error_msg: .asciiz  "\n [ Error opening file .... ] "
    SecondDisplay_msg: .asciiz  "\n1- Press 'F/f' for First Fit\n2-Press 'B/b' for Best Fit\n3-Press 'Q/q' to quit\n"
    First_msg: .asciiz  "\n [ First Fit ALgorithm is chosen ] \n "
    Best_msg: .asciiz  "\n  [ Best Fit ALgorithm is chosen ]  \n"
    ThirdDisplay_msg:  .asciiz   "\n1- Press 'P/p' to print the result into output file\n2- Press 'Q/q' to quit\n2- Press 'Z/z' to go back\n"
    Save_msg: .asciiz  "\n  [ Results are saved in the output file :) ] \n"
    Quit_msg : .asciiz  "\n  [ Thank you for using our program Bye bye ] <3\n"
    invalid_msg: .asciiz "   [ Invalid choice ! Please Re-Enter a vaild choice ]  "
    ReadCorrectly_msg: .asciiz "\n  [The file is opened and read correctly ^__^ ] \n"
    Done_msg: .asciiz "[ Algorithem has been applied successfuly ^__^ ] \n "
	wrongInput_msg: .asciiz "\n[ invalid input in the file ] \n"
    
    #output file 
    out_filename : .asciiz "output.txt"
	algo_used: .asciiz "- The algorithm used is : "
 	bins_used: .asciiz "- The number of bins used is : " 
	FF:		.asciiz "First Fit\n"
	BF:		.asciiz "Best Fit \n"
	new_line: .asciiz "\n"
	bin_word:  .asciiz "Bin: "
	items_word:   .asciiz "Items: "
	bins_line:  		.asciiz "\n____________________________________________"
	space: .asciiz " "
	zero_dot: .ascii "0."



	.align 2
	intBuffer: 		.space 12 
	binsIndex:			.space 64
	binsNum:			.space 64
	
	hundred: 	.float 100.0
    #for the read part 
    fileName : .space 100 #reserve 100 bytes for the file's name /path
    #at first we're reading strings but we want float so we store'em in a buffer 
    Buffer : .space 1024 #reserve for initial file content 
    
    #arrays
    .align 2
    items_Array: .space 1024 # to store the items from the input file
    bins_Array: .space 1024 #to create bins
    
    Final_Array: .space 40000 # 2D array to store each bin and it's items 


    
###########################################################
.text
.globl main

main:
    la $a0,Hello_msg             #load wlc_msg address to $a0 
    li $v0, 4                 #4 --> Print String
    syscall
FirstMenu:

	la $a0, Choose_msg
	li $v0, 4
	syscall
	
	la $a0, FirstDisplay_msg
   	li $v0, 4
    	syscall
    	
   	li $v0 , 12 # Read char 12
	syscall 
    	#converting to lowercase
    	move $t0 ,$v0 #move from v0 to t0
    	ori $t0 ,$t0,0x20 # if it is already lowercase nothing is done , if upper bitwise or with 0x20 (32)
    	beq $t0 ,'q',Quit #compare what the user entered and the q , if equal go to Quit lable
    	beq $t0,'r',input_file #compare what the user entered and the r , if equal go to input file lable
    	j invalid1 #if any other option it's invalid

input_file:
	la $a0, Enter_msg
	li $v0, 4
	syscall
	
	# read the filename from the user
    	la $a0, fileName
    	li $a1, 100  # maximum length of the filename ######
    	li $v0, 8  # read string   
    	syscall
    	la   $t0, fileName

Replace:    
    lb   $t1, 0($t0)  # Load byte (char)
    beq  $t1, 0x0A, NullTer
    addi $t0, $t0, 1  # Move to next char
    j    Replace 

NullTer: 
    sb $zero, 0($t0)  # Replace \n with null terminator(\0)
    
    # Open file
    la $a0, fileName    # $a0 = file name
    li $a1, 0           # $a1 = read-only mode
    li $v0, 13          # syscall: open file
    syscall

    bltz $v0, Error     # if file descriptor < 0, jump to error

    move $s3, $v0       # store the file descriptor in $s3

    move $a0, $s3       # file descriptor
    la $a1, Buffer
    li $a2, 1024
    li $v0, 14          # syscall: read from file
    syscall

    # Close file after reading
    li $v0, 16          # syscall: close file
    move $a0, $s3       # pass the correct file descriptor
    syscall

    	
    	la $a0, ReadCorrectly_msg #print if the file is opened and read correctly
	li $v0, 4
	syscall
    	
    	la $t0, Buffer #to initaily store the stuff read from the file in
    	la $t6, items_Array  # the array that holds the float values 
	li $t2,48 #moving the number 48 into a reg (the ASCII of 0 = 48)
	li $t7,10 #moving the number 10 into a reg for division later
	
	
	
	
loop1:
	li $t5, 0                # counter for digits

#	lb $t1, 0($t0)           # load first digit
#	li $t9,48
#	bne $t1,$t9,wrongInput

	addi $t0, $t0, 2         # skip 0.
	lb $t1, 0($t0)           # load first digit
	beq $t1, 0, label2       # if null end of buffer
	addi $t5, $t5, 1
	sub $t3, $t1, $t2        # $t3 = first digit - 48
	j loop2

loop2:
	addi $t0, $t0, 1         # next char
	lb $t1, 0($t0)
	beq $t1, 0x0A, label     # if \n go convert
	beq $t1, 0, label        # if \0 go convert 
	addi $t5, $t5, 1         # count digit
	sub $t4, $t1, $t2        # convert digit 
	mul $t3, $t3, 10
	add $t3, $t3, $t4
	j loop2

label:
	addi $t0, $t0, 1         # skip \n or \0
	mtc1 $t3, $f2
	cvt.s.w $f2, $f2
	j convertToFloat

convertToFloat:
	beq $t5, $zero, FillTheArray
	mtc1 $t7, $f4
	cvt.s.w $f4, $f4
	div.s $f2, $f2, $f4
	sub $t5, $t5, 1
	j convertToFloat

FillTheArray:
	swc1 $f2, 0($t6)         # store float in array
	addi $t6, $t6, 4
	addi $s0, $s0, 1
	j loop1

label2:
	j SecondMenu
	
Error:
	#error opening the file , display the message and reload the menu
	la $a0, Error_msg
	li $v0, 4
	syscall
	j input_file 
invalid1:
	#invalid user input , display the message and reload the First menu
	la $a0, invalid_msg
	li $v0, 4
	syscall	
	j FirstMenu
invalid2:
	#invalid user input , display the message and reload the Second menu
	la $a0, invalid_msg
	li $v0, 4
	syscall	
	j SecondMenu
invalid3:
	#invalid user input , display the message and reload the Third menu
	la $a0, invalid_msg
	li $v0, 4
	syscall	
	j ThirdMenu
	
SecondMenu:
	la $a0, Choose_msg
	li $v0, 4
	syscall
	
	la $a0, SecondDisplay_msg
	li $v0, 4
	syscall
	
   	li $v0 , 12 # Read char 12
	syscall 
    	#converting to lowercase
    	move $t0 ,$v0 #move from v0 to t0
    	ori $t0 ,$t0,0x20 # if it is already lowercase nothing is done , if upper bitwise or with 0x20 (32)
    	beq $t0 ,'q',Quit #compare what the user entered and the q , if equal go to Quit lable
    	beq $t0,'f',FirstFit #compare what the user entered and the f , if equal go to First Fit algorithem lable
    	beq $t0,'b',BestFit #compare what the user entered and the r , if equal go to Best Fit algorithem lable
    	j invalid2 #if any other option it's invalid

	j Quit
wrongInput:
	la $a0, wrongInput_msg
	li $v0, 4
	syscall
	j Quit
	
#############################################
FirstFit:
#	jal reset_bins 
	la $a0, First_msg 
	li $v0, 4
	syscall
	
	la $s4,FF
	
	# Initialize pointers and counters
	la $t1, items_Array     # $t1 points to the start of the items array
	li $t2, 1               # $t2 = 1 (will be converted to float for new bin size)
	
	li $s5 , 1
	
	# Convert integer 1 to float 
	mtc1 $t2, $f2 
	cvt.s.w $f2, $f2    # f2 ----->1
	     
	li $t3,0
	mtc1 $t3, $f8
	cvt.s.w $f8, $f8  # f8 ----->0
	
	# Initialize the first bin with size 1
	la $t0, bins_Array 
	swc1 $f2, 0($t0)
	
	la $s0, bins_Array # adress for first bin

loopA:
	la $t0, bins_Array 
	lwc1 $f0,0($t1) #store the items array in a reg 
	c.eq.s $f0 , $f8
	bc1t ThirdMenu
	
	lwc1 $f0, 0($t1) # Load current item 
	
	lwc1 $f4, 0($t0)# Load current bin size into 

	# if item fits in current bin go to updateSize
	c.le.s $f0, $f4 
	bc1t updateSize
	# else try next bin
	j loopB

updateSize: 

	# Subtract item size from bin space
	sub.s $f4, $f4, $f0      
	swc1 $f4, 0($t0)         # Store updated bin space
	
	sub $t4,$t0,$s0 #row index is in t4 (bins index)

	j EQ 
	# Move to next item
	addi $t1, $t1, 4         
	j loopA

back:
	# Used after adding item to bin to return to next item
	addi $t1, $t1, 4         
	j loopA	
loopB:
    addi $t0, $t0, 4         
    lwc1 $f4, 0($t0)

    # Check if this bin is truly new (t0 - s0 >= s5 * 4)
    sub $t6, $t0, $s0       # t6 = current offset from first bin
    mul $t7, $s5, 4         # t7 = number of bins used * 4 (bytes)

    bge $t6, $t7, checkIfNewBin
    
    # if not beyond used bins, continue normal checks
    c.le.s $f0 , $f4
    bc1t updateSize
    j loopB

checkIfNewBin:
    # Now confirm if bin is 0 (new)
    c.eq.s $f4 , $f8        
    bc1t createBin
    j loopB
    
createBin:
	# Create a new bin of size 1
	addi $s5,$s5,1
	mov.s $f4, $f2           # $f4 = 1
	j updateSize             # Now that we created a bin put the item in it
##########################################3
EQ:
	la $t9, Final_Array
	mul $t4, $t4,100	
	add $t4,$t4, $t9
loopC:
	lwc1 $f6,0($t4)
	c.eq.s $f6 , $f8
	bc1t addItem
	addi $t4,$t4,4
	j loopC
addItem:
	swc1 $f0, 0($t4)
	j back
#########################	
BestFit:
	jal reset_bins 
	la $a0, Best_msg
	li $v0, 4
	syscall	
	
	la $s4,BF

	li $s5,1
	
	# Initialize pointers and counters
	la $t1, items_Array     # $t1 points to the start of the items array
	li $t2, 1               # $t2 = 1 (will be converted to float for new bin size)

	
	# Convert integer 1 to float 
	mtc1 $t2, $f2 
	cvt.s.w $f2, $f2    # f2 ----->1
	     
	li $t3,0
	mtc1 $t3, $f8
	cvt.s.w $f8, $f8  # f8 ----->0
	
	# Initialize the first bin with size 1
	la $t0, bins_Array 
	swc1 $f2, 0($t0)
	la $s0, bins_Array # adress for first bin

	li $t5, 0	 #index
	la $t6, bins_Array 

	mov.s $f6, $f2    #(min) f6 ----->1


loopa:
# Loop for each items 
# exits this loop when a \0 is found in the items array
	la $t0, bins_Array #reset bins array
	lwc1 $f0,0($t1) #load current item
	c.eq.s $f0 , $f8 #If item =0 we are done go to third menu
	bc1t ThirdMenu
	
	lwc1 $f0, 0($t1) # load current item 
	
	lwc1 $f4, 0($t0)# load current bin size into 


	c.le.s $f0, $f4  #if item <= bin space (if item fits)
	bc1t comp_min #check if it is the best fit

	j loopb #else move to next bin
	
	# if item fits in current bin go to updateSize
	c.le.s $f0, $f4 
	bc1t updateS

updateS: 
# Enters here after scanning all bins and finding best fit (or no fit)		
 
	# Subtract item size from bin space
	move $t4,$t5	
	add $t5,$t5,$s0   # $t5 = address of the best bin
	swc1 $f6, 0($t5) # store updated bin space
	
	mov.s $f6, $f2  #reset min   f6 ----->1    
	li $t5, 0 #reset index $t5 -----> 0
	j eq #go place item in Final array (2d array)
	
	addi $t1, $t1, 4  # Move to next item

	j loopa

comp_min:
#enters only if item fits in current bin (item < bins)
#checks if current bin is a better fit than the previous min
	sub.s $f7,$f4,$f0  # calculate what is the remaining space if we place the item in this bin 
	c.le.s $f7,$f6 # if less than the current min
	bc1t change_min # go change the current min
	j loopb #if not less go to next bin 
	
	
change_min:
#entered when a better fit bin is found
#updates the best fit index and space
	mov.s $f6,$f7	#change min value
	sub $t5, $t0,$s0 #save index of bin 
	j loopb	#then move to next bin
####################	
eq:
	la $t9, Final_Array
	mul $t4, $t4,100	
	add $t4,$t4, $t9
loopc:
	lwc1 $f9,0($t4)
	c.eq.s $f9 , $f8
	bc1t AddItem
	addi $t4,$t4,4
	j loopc
AddItem:
	swc1 $f0, 0($t4)
	j Back

Back:
	# Used after adding item to bin to return to next item
	addi $t1, $t1, 4         
	j loopa
#####################
loopb:
# move bin
#also entered if the item did not fit the first bin
#tries to find the best bin that fits

	#try next bin in bins array
	addi $t0, $t0, 4    
	lwc1 $f4, 0($t0)#load next bin     
	
	   # Check if we are beyond the current number of bins
	sub $t7, $t0, $s0     # offset = t0 - base of bins
 	mul $t6, $s5, 4       # t6 = num_bins_used * 4 (bytes)
    	bge $t7, $t6, checkIfNewBin_b

	
	# If item fits in this bin, go to see if it is the best fit
	c.le.s $f0 , $f4
	bc1t comp_min
	
	# if doest fit go create a new bin
	j createBin_b
checkIfNewBin_b:
# Now confirm if bin is 0 (i.e. uninitialized = truly new)
    c.eq.s $f4 , $f8        
    bc1t createBin_b
    j loopb
createBin_b:
# we are checking if we can use an empty bin to place the item
# or we may have to create a new bin if no suitable bin was found 
	
	c.eq.s $f6, $f2 #if min has not changed ( 1 )
	bc1f	updateS #if f6 is not 1  go back to updateS and place item in best bin


#if f6 =1 
	# Check if current bin f4 is empty 
	c.eq.s $f4 , $f8
	bc1f loopb #if f4 id not  0 move to next bin in loop b
	
# if the bin ia empty we can now create a new bin 
	mov.s $f4, $f2           # $f4 = 1
	addi $s5,$s5,1
	sub.s $f4,$f4,$f0 #f4 = 1 - item size
	swc1 $f4, 0($t0) #store updated bin space
	sub $t4, $t0,$s0
	j eq



#########################		

ThirdMenu:

	la $a0, Done_msg
	li $v0, 4
	syscall	
	
	la $a0, Choose_msg
	li $v0, 4
	syscall
	
	la $a0, ThirdDisplay_msg
	li $v0, 4
	syscall
		
   	li $v0 , 12 # Read char 12
	syscall 
    	#converting to lowercase
    	move $t0 ,$v0 #move from v0 to t0
    	ori $t0 ,$t0,0x20 # if it is already lowercase nothing is done , if upper bitwise or with 0x20 (32)
    	beq $t0 ,'q',Quit #compare what the user entered and the q , if equal go to Quit lable
    	beq $t0,'p',Print #compare what the user entered and the f , if equal go to Print lable
    	beq $t0, 'z',SecondMenu #if user wants to go back to second menu
    	j invalid3 #if any other option it's invalid
####################3
Print:
    # Trick to clear file: open then immediately close it (truncates the file)
    la $a0, out_filename      # load file name
    li $a1, 1                 # open for writing (this will truncate the file)
    li $v0, 13                # syscall 13 = open file
    syscall
    move $t9, $v0             # save file descriptor temporarily

    li $v0, 16                # syscall 16 = close file
    move $a0, $t9             # pass the FD to close
    syscall

    # Now re-open the same file for writing for real use
    la $a0, out_filename
    li $a1, 1                 # again write mode
    li $v0, 13
    syscall
    move $s3, $v0             # save FD in $s3 for future writes

    # Write the name of the algorithm used
    move $a0, $s3
    la $a1, algo_used
    li $a2, 26                # length of the string
    li $v0, 15                # syscall 15 = write to file
    syscall

    # Write chosen algorithm again from another address (maybe it's dynamic text)
    move $a0, $s3
    la $a1, 0($s4)
    li $a2, 10
    li $v0, 15
    syscall

    # Write info about how many bins used
    move $a0, $s3
    la $a1, bins_used
    li $a2, 31
    li $v0, 15
    syscall

    # Convert number of bins to string using custom function
    move $a0, $s5
    jal int_to_string

    # Write the number of bins to the file
    move $a0, $s3
    la $a1, 0($v0)
    li $a2, 2
    li $v0, 15
    syscall

    # Write "Bins:" line
    move $a0, $s3
    la $a1, bins_line
    li $a2, 45
    li $v0, 15
    syscall

    # Write new line to separate sections
    move $a0, $s3
    la $a1, new_line
    li $a2, 2
    li $v0, 15
    syscall

########################################################
bin_index:
    # Prepare to print bins and their items
    la $t1, Final_Array      # pointer to the 2D array storing items per bin
    li $t2, 0                # used for offsetting rows (bins)
    li $t3, 0                # bin number
    move $t5, $s5            # copy number of bins to process

    # Write "Bin" word
    move $a0, $s3
    la $a1, bin_word
    li $a2, 5
    li $v0, 15
    syscall

    # Print the bin number as string
    move $a0, $t3
    jal int_to_string

    move $a0, $s3
    la $a1, 0($v0)
    li $a2, 2
    li $v0, 15
    syscall

    # Write "Items" word
    move $a0, $s3
    la $a1, items_word
    li $a2, 7
    li $v0, 15
    syscall

check_next_bin:
    # Load item size at current bin/item position
    lwc1 $f9, 0($t1)

    # Check if it’s an empty slot (<= 0.0)
    c.le.s $f9 , $f8
    bc1t next_bin           # if item not valid, move to next bin

    # Write "0." to handle printing like 0.25 instead of .25
    move $a0, $s3
    la $a1, zero_dot
    li $a2, 2
    li $v0, 15
    syscall

    # Convert float to int (x100) and print it
    j float_to_string

print_size:
    # Print item size string
    move $a0, $s3
    la $a1, 0($v0)
    li $a2, 2
    li $v0, 15
    syscall

    # Add a space between item sizes
    move $a0, $s3
    la $a1, space
    li $a2, 2
    li $v0, 15
    syscall

    # Move to next item (float = 4 bytes)
    addi $t1 , $t1 , 4
    j check_next_bin

next_bin:
    addi $t3, $t3, 1         # bin number++
    la $t1, Final_Array      # reset pointer to beginning of 2D array
    addi $t2, $t2, 400       # jump to next bin (100 items x 4 bytes)
    add $t1, $t1, $t2        # point to the next bin's items
    subi $t5, $t5, 1         # one less bin to go

    # If done printing all bins, go end file
    beq $t5, $zero, end_file

    # Print newline and new bin label
    move $a0, $s3
    la $a1, new_line
    li $a2, 2
    li $v0, 15
    syscall

    move $a0, $s3
    la $a1, bin_word
    li $a2, 5
    li $v0, 15
    syscall

    move $a0, $t3
    jal int_to_string

    move $a0, $s3
    la $a1, 0($v0)
    li $a2, 2
    li $v0, 15
    syscall

    move $a0, $s3
    la $a1, items_word
    li $a2, 7
    li $v0, 15
    syscall

    j check_next_bin

########################################################
end_file:
    # Print save message
    la $a0, Save_msg
    li $v0, 4
    syscall

    # Close the output file
    li $v0, 16
    move $a0, $s3
    syscall

    j FirstMenu


#################################################################
# Converts integer in $a0 to string in $v0
int_to_string:
    li     $t0, 10                
    la     $v0, intBuffer       
    addiu  $v1, $v0, 11            # point to end of buffer
    sb     $zero, 0($v1)           # null terminator

    move   $t8, $a0                # value to convert

itoa_loop:
    divu   $t8, $t0                # divide by 10
    mflo   $t8
    mfhi   $t7                     # get remainder
    addiu  $t7, $t7, 48            # convert to ASCII
    addiu  $v1, $v1, -1            # move back
    sb     $t7, 0($v1)
    bnez   $t8, itoa_loop

    move $v0, $v1                  # return pointer to string
    jr   $ra

# Converts float to string by multiplying by 100 then calling int_to_string
float_to_string:
    lwc1 $f12, hundred      	 # load constant 100.0
    mul.s $f9, $f9, $f12         # multiply to shift decimal
    cvt.w.s $f9, $f9             # convert to int
    mfc1 $a0, $f9                # move to $a0
    jal int_to_string
    j print_size


############################################################################################################3
reset_bins:
    # Clear Final_Array (1D list of bin sizes)
    la $t0, Final_Array
    li $t1, 0
clear_bins_sizes:
    li $t2, 0
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    li $t3, 100
    blt $t1, $t3, clear_bins_sizes

    # Clear bins_Array (2D array of items in bins)
    la $t0, bins_Array
    li $t1, 0
clear_bins_2d:
    li $t2, 0
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    addi $t1, $t1, 1
    li $t3, 10000          # assuming 100 bins x 100 slots each
    blt $t1, $t3, clear_bins_2d

    # Reset bin count to 1 (because first bin exists)
    li $s4, 1
    jr $ra

Quit:
    la $a0, Quit_msg
    li $v0, 4
    syscall

    li $v0 , 10 # Exit program
    syscall