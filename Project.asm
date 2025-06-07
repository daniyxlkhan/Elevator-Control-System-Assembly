.data
    current_floor:    .word 0        # Current floor (0-4)
    direction:        .word 1        # 1 = up, -1 = down, 0 = idle
    emergency_stop:   .word 0        # Emergency stop flag
    alarm_active:     .word 0        # Alarm system flag


prompt: 			.asciiz "\n1.Floor selection | 2.Emergency stop | 3.Emergency reset | 4.Activate alarm | 5.Exit elevator\nEnter your choice: "
current_floor_msg: 		.asciiz "Your current floor is: "
prompt_exit: 			.asciiz "\nYour are exiting the elevator now, Bye!"
prompt_error_bound: 		.asciiz "\nPlease enter a valid option!\n\n"
prompt_stop_activated: 		.asciiz "\nEmergency Stop activated! Reset it when you wish to continue.\n"
prompt_stop_cancelled: 		.asciiz "\nEmergency Stop cancelled! Resuming elevator operation...\n"
alarm_msg:			.asciiz "ALARM ACTIVATED!!!\n"
door_msg:			.asciiz "-Doors opening...\n"


.text
.globl main

initializer:
	li $t9, 0		# Emergency Stop, 0- Continue, 1 - Stop
	sw $t9, emergency_stop
	li $s0, 1	# Current floor
	li $s1, 1 #a set variable to check emergency stop condition

main:
	# ---- Read floor number from user ----
    	li $v0, 4             # syscall code for print_string
    	la $a0, prompt	      # load address of prompt1 into $a0
    	syscall               # print prompt1 message
    	
    	li $v0, 5             # syscall code for read_int
    	syscall               # read an integer from user input
    	move $t0, $v0         # store input in $t0 (User Input value)
    	
    	beq $t0, 5, Exit			# if 8, exit program
    	beq $t0, 3, cancelEmergencyStop		# if 7, cancel emergency stop
    	beq $t0, 2, activateStop		# if 0, stop elevator
    	beq $t0, 1, handleFloorRequest
    	
    	j main

handleFloorRequest:
	#lw $t9, emergency_stop
	beq $t9, 1, activateStop
    	# Show current floor
    	li $v0, 4
    	la $a0, current_floor_msg
    	syscall 
    	
    	li $v0, 1
    	move $a0, $t0
    	syscall
	
	j main
    	
activateStop:
	#li $t9, 1
	#sw $t9, emergency_stop    # Set emergency_stop to 1
	move $t9, $s1
	li $v0, 4   
    	la $a0, prompt_stop_activated
    	syscall   
    	
    	j main
    	
cancelEmergencyStop:
	li $t9, 0
	li $v0, 4
	la $a0, prompt_stop_cancelled
	syscall
	
	j main
	
Error_Bound:
	li $v0, 4
    	la $a0, prompt_error_bound   
    	syscall             
    	
	j main
	
Exit:
	li $v0, 4             	 # syscall code for print_string
    	la $a0, prompt_exit      # load address of prompt1 into $a0
    	syscall              	 # print prompt1 message
    	
	li $v0, 10               # syscall code to exit the program
    	syscall
	
