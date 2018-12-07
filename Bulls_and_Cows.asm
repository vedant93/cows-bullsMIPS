#--This is the word version of the Bulls and Cows Games completed for CS 3340.501 Computer Architecture F-18 (Semester long project).
#--Project Group: 1) Luis 2) Nikhil Pareek 3) Vedant 4) Veeredranath
#--Brief overview of the game:
#--i) For each game, the program randomly selects a WORD from a dictionalry list of 400 eligible words and propmts the user for a guess. 
#--ii)The user must enter a word, which has 4 non-repeated letters and is a meaningful English word, e.g. WORD, CALF, VERB, DUCK, etc...
#--iii) After subsequent checks of input validation, the user receives a number of Count of Bulls and Cows.
#--iv) If the matching digits are in their right positions, they are "bulls", and if in different positions, they are "cows".
#--v) The game would continue until the user scores all the "4 Bulls" correct for guessing correct word exactly.
#--vi) The user gets 10 chances to guess the correct word, that is "4 Bulls". And after that, the game gets over and Menu pops up. 

#--v) Examples: If the secret word is HEAT, a guess of COIN would result in "0 Bulls, 0 Cows" (all of the guessed letters are wrong).
#--vi) A guess of EATS would result in "0 Bulls, 3 Cows" (since E, A, T are all present, but not in the guessed positions).
#--And a guess of TEAL would result in "2 Bulls, 1 Cow" (since E and A are in the right positions, while T is in the wrong position).


#-----------------------------.data starts-----------------------------------------
.data

	Welcome: .asciiz "\nBulls & Cows \nPlease select from one of the following menu options:\n"
	Menu1: .asciiz "(press 1) Start new game\n"
	Menu2: .asciiz "(press 2) How to play\n"
	Menu3: .asciiz "(press 3) Exit Game\n"
	MenuPrompt: .asciiz "Please enter your choice: "
	MenuPrompt2: .asciiz "\n\nYou will have ten tries to get the correct answer, good luck"
	UserInput: .space 64
	UserChoice: .asciiz "Please enter a 4-letter word (enter 0 to give up): "
	words_array: .asciiz "acid", "aged", "also","army","back","band","bank","base" ,"bath" ,"bear" ,"beat" ,"belt" ,"best" ,"bird" ,#(14)
	"blow" ,"blue","body" ,"bond" ,"bone" ,"born","both" ,"bowl","bulk","burn","bush","busy","calm","came","camp","card","care",#(17)
	"case","cash","cast","chat","chip","city","club","coal","coat","code","cold","come","cope","copy","cost","crew","crop","dark", #(18)
	"date","dawn","days","deal","dean","dear","debt","deny","desk","dial","diet","disc","disk","does","done","dose","down","draw" #(18)
	,"drew","drop","drug","dual","duke","dust","duty","each","earn","east","easy","evil","exit","face","fact","fail","fair","farm" #(18)
	,"fast","fate","fear","felt","file","film","find","fine","fire","firm","fish","five","flat","flow","ford","form","fort","four" #(18)
	,"from","fuel","fund","gain","game","gate","gave","gear","gift","girl","give","glad","goal","goes","gold" ,"gone","gray", "grew" #(18)
	,"grey","grow","gulf","hair","half","hand","hang","hard","harm","hate","have","head","hear","heat","held","help","hero","hire" #18)
	,"hold","hole","holy","home","hope","host","hour","huge","hung","hunt","hurt","idea","inch","into","iron","item","jack","jane" #(18)
	,"jean","john","join","jump","jury","just","kent","kept","kind","king","knew","know","lack","lady","laid","lake","land","lane" #18
	,"jean","john","join","jump","jury","just","kent","kept","kind","king","knew","know","lack","lady","laid","lake","land","lane" #18
	,"last","late","lead","left","life","lift","like","line","link","list","live","load","loan","lock","long","lord","lose", "lost" #18
	,"love","luck","made","mail","main","make","male","many","meal","mean","meat","menu","mike","mile","milk","mind","mine","mode" #18
	,"more","most","move","much","must","name","navy","near","neck","news","next","nice","nick","nose","note","okay","once","only" #18
	,"open","oral","over","pace","pack","page","paid","pain","pair","palm","park","part","past","path","peak","pick","pink", "plan" #18
	,"play","plot","plus","port","post","pure","push","race","rail","rain","rank","rate","read","real","rely","rent","rest","rice" #18
	,"rich","ride","ring","rise","risk","road","rock","role","rose","rule","rush","ruth","safe","said","sake","sale","salt","same" #18
	,"sand","save","seat","self","send","sent","sept","ship","shop","shot","show","shut","sick","side","sign","site","size","skin" #18
	,"slip","slow","snow","soft","soil","sold","sole","some","song","sort","soul","spot","star","stay","step","stop","such","suit" #18
	,"sure","take","tale","talk","tank","tape","task","team","tech","tend","term","than","them","then","they","thin","this","thus" #18
	,"time","tiny","told","tone","tony","tour","town","trip","tune","turn","twin","type","unit","upon","used","user","vary","vast" #18
	,"very","vice","view","vote","wage","wait","wake","walk","want","ward","warm","wash","wave","ways" #14
	give_up_prompt: .asciiz "Here's the correct word: "
	user_word: .space  4
	newline: .asciiz "\n"
	userError1: .asciiz "\nnot a valid input (Try Again): "
	promptAttempts: .asciiz"Attempt number "
	promptBulls: .asciiz"Bulls: "
	promptCows: .asciiz"Cows: "
	promptAttemptsLeft: .asciiz"\nRemaining Tries: "
	promtTries: .asciiz "Number of tries: "
	understand: .asciiz"\n|Press 1 to return to the menu|\n|Press 2 to quit| "
	link: .asciiz "\nHow to play (url link)\nhttps://en.wikipedia.org/wiki/Bulls_and_Cows\n\n|Press any key to return to menu|\n"
	seconds: .asciiz " seconds"
	time_elapsed: .asciiz "Time Elapsed: "

	correct_input: .asciiz "You got it correct!\n"
	max_guess_prompt: .asciiz "\nYou have used all 10 chances to guess the word"
	max_guess_prompt_2: .asciiz "Here is the correct word: "
	DupeError: .asciiz "\nYou may not repeat any character in your guess.\n"
	InputRangeError: .asciiz "\nIt appears an invalid character was used.\n"
	LenError: .asciiz "\n More than 4 character word\n"


	
#-----------------------------------------------.text starts----------------------------



.text
main:


	li $v0, 4
	la $t0, Welcome			#---------Displays WElcome message to the user-----------------
	add $a0, $t0, $zero
	syscall
	la $t0, Menu1
	add $a0, $t0, $zero
	syscall
	la $t0, Menu2
	add $a0, $t0, $zero
	syscall
	la $t0, Menu3
	add $a0, $t0, $zero
	syscall
	la $t0, MenuPrompt		#----------Displaying the Menu option to the users-----------------	
	add $a0, $t0, $zero
	syscall
	
	
	jal Music			#----------Jumps to Music function and plays the tune till the time user selects a menu option-----------------	
	li $v0, 8			#----------Loading the input as a string to avoid problems------------
	la $a0, UserInput
	li $a1, 64
	syscall			
	lb $t1, ($a0)	
	
					
	addi $t0, $zero, 49		#-----------Stroing 1 in $t0 for checking purposes------------
	beq $t1, $t0, Game  		#-----------The game starts here by calling the Game function----------
	addi $t0, $zero, 50		#-----------This is for testing purposes if 2 was pressed-------------------
	beq $t1, $t0, HowToPlay		#-----------Displaying instructions--------------------------------
	addi $t0, $zero, 51		#-----------This is for displaying the credits------------
	bne $t1, $t0, MenuError		#-----------In case the user selects invalid menu option, print error message and go back to the menu---
	li $v0, 10			#-----------Program exit call--------------
	syscall

	
			
endGame:

	li $v0, 4
	la $t0, understand		#-----------At the end of the game, user is shown the Menu optin again for the purpose of exit and replay the game-----------
	add $a0, $t0, $zero
	syscall
	
	
	jal Music			#----------Jumps to Music function and plays the tune till the time user selects a menu option-----------------	
        li $v0, 8			#----------Loading the input as a string to avoid problems----------
	la $a0, UserInput
	li $a1, 64
	syscall			
	
	
	lb $t1, ($a0)	
	addi $t0, $zero, 49		#-----------This is for displaying the credits------------
	beq $t1, $t0, main		#-----------In case the user selects invalid menu option, print error message and go back to the menu---
	addi $t0, $zero, 50
	beq $t1, $t0, GameOver		#---------If the user has exhausted all the 10 chances--------------
	addi $t0, $zero, 1		#---------This is for displaying the credits-----------------
	bne $t1, $t0, MenuError		#---------In case the user selects invalid menu option, print error message and go back to the menu----------
	li $v0, 10
	syscall


HowToPlay:

	li $v0, 4
	la $t0, link
	add $a0, $t0, $zero
	syscall

	
	jal Music			#----------Jumps to Music function and plays the tune till the time user selects a menu option-----------------	
	li $v0, 8			#---------Loading the input as a string to avoid problems---------------
	la $a0, UserInput
	li $a1, 64
	syscall			
	
	
	lb $t1, ($a0)	
	addi $t0, $zero, 50		#---------This is for displaying the credits-----------------
	bne $t1, $t0, MenuError		#----------------In case the user selects invalid menu option, print error message and go back to the menu---


MenuError:	
	li $v0, 4			#-----------Using system clock to log time( milliseconds )-----
	la $t0, userError1
	add $a0, $t0, $zero
	syscall
	j main
	

Game:

	li $v0, 30			#-------Fetching system time--------------
	syscall
	addi $sp, $sp, -4
	sw $a0, 0($sp)


li $a1,1930 			#loading max number
	

					#-----Generates a number that is multiple of 5--------
loop_multiple_of_five:
	li $t1, 5
	li $v0, 42 
	syscall 
	add $t0, $a0, $zero 
	div $t0, $t1
	mfhi $t0 
	beqz $t0, Exit_22
	j loop_multiple_of_five


Exit_22:
	
	#li $v0, 1		#---------Printing the number for our references and testing purposes------
	add $s4, $a0, $zero
	#syscall
	
	
	
	
	addi $sp, $sp, -4
	sw $s4, 0($sp)
	li $v0, 4
	la $t0, MenuPrompt2
	add $a0, $t0, $zero
	syscall
	la $a0, words_array($s4)
	move $s3, $a0 		#----------Now s3 contains the address of the word-----------


#these three registers are used to load the correct charecter from register location s3
	li $t3, 1			#---The given three registers are used to load the correct charecter from register location s3
	li $t4, 2
	li $t5, 3
	li $t6, 0 			#------------Counter to check the number of inputs------------

input:				#-------------Getting the input from the user and input validation for the same----------

	beq $s1, 4, Correct_Input
	li $v0, 4
	la $a0, newline
	syscall

	li $s1, 0 			#---------Number of bulls-------------
	li $s2, 0			 #---------Number of cows-------
	beq $t6, 10, After_max_guesses	#-----Checking if the user has exhausted the number of guess counts, that is 10.


	li $v0, 4
	la $a0, UserChoice
	syscall
	jal Music			#----------Jumps to Music function and plays the tune till the time user selects a menu option-----------------	
	li $v0, 8
	la $a0, user_word		#--------------Storing the user input string in user_word----------------
	li $a1, 20
	syscall
	la $t8, user_word
	lb $t9, 0($t8)
	beq $t9, 48, Giveup







#-----------------INput Validation starts here---------------------------

#Registeres being used------ $t8, $t9, $s4, $s5,$s6, $s7-------------------


# i) Condition 1: There should be no repetition in the user_word.
# ii) Condition2: The user_word should only be constiting of english letter/characters, they may be Upper Case and Lower Case letters/characters.
# iii)Condition3: The user_word must be of exact 4 letter long, not less than 4 or more than 4.


	la $t8, user_word	# Loading the user_word address into $t8 register----
	
	lb $t9, 0($t8)		# Loading the first letter in $t9 register---
	lb $s4, 1($t8)		# Loading the second letter in $s4 register---
	lb $s5, 2($t8)		# Loading the third letter in $s5 register---
	lb $s6, 3($t8)		# Loading the fourth letter in $s6 register---
	lb $s0, 4($t8)

	
	
# The user input letters must be from [0-9A-F] and no duplicates. 
# The ASCII values for 0 ==> 48, 9 ==> 57, A ==> 65, F ==> 70, a ==> 97, f ==> 102.
	
	
	
	bge $s0, 62, labelz	#-------------Shows error of the input is more than 4 characters long----
		
	
	addi $s7, $zero, 65	#-----Checking for if the SEcond letter is valid-----
	blt $t9, $s7, UserInputError
	addi $s7, $zero, 90	#---Lower case checks---------
	ble $t9, $s7, SecondCheck
	addi $s7, $zero, 97	#---Upper case checks---------
	blt $t9, $s7, UserInputError
	addi $s7, $zero, 122
	ble $t9, $s7, FirstFix
	j UserInputError	#-----IN case of  invalid input from user, call UserInputError----


FirstFix:
	sub $t9, $t9, 32

SecondCheck:
	
	addi $s7, $zero, 65	#-----Checking for if the SEcond letter is valid-----
	blt $s4, $s7, UserInputError
	addi $s7, $zero, 90
	ble $s4, $s7, ThirdCheck
	addi $s7, $zero, 97
	blt $s4, $s7, UserInputError
	addi $s7, $zero, 122
	ble $s4, $s7, SecondFix
	j UserInputError

SecondFix:

	sub $s4, $s4, 32

ThirdCheck:

	
	addi $s7, $zero, 65	#-----Checking for if the SEcond letter is valid-----
	blt $s5, $s7, UserInputError	
	addi $s7, $zero, 90	#---Lower case checks---------
	ble $s5, $s7, FourthCheck
	addi $s7, $zero, 97	#---Upper case checks---------
	blt $s5, $s7, UserInputError
	addi $s7, $zero, 122
	ble $s5, $s7, ThirdFix
	j UserInputError	#-----IN case of  invalid input from user, call UserInputError----

ThirdFix:

	sub $s5, $s5, 32

FourthCheck:

	addi $s7, $zero, 65	#-----Checking for if the SEcond letter is valid-----
	blt $s6, $s7, UserInputError
	addi $s7, $zero, 90	#---Lower case checks---------
	ble $s6, $s7, AfterCheck
	addi $s7, $zero, 97	#---Upper case checks---------
	blt $s6, $s7, UserInputError
	addi $s7, $zero, 122
	ble $s6, $s7, FourthFix
	j UserInputError	#-----IN case of  invalid input from user, call UserInputError----

FourthFix:

	sub $s6, $s6, 32

AfterCheck:
	
	
# Here are the validations for the six checks to account for all combinations of the four numerals and duplicate entries check--------

	beq $t9, $s4, Duplicate
	beq $t9, $s5, Duplicate
	beq $t9, $s6, Duplicate
	beq $s4, $s5, Duplicate
	beq $s4, $s6, Duplicate
	beq $s5, $s6, Duplicate

#---------------------INput Validation ends here----------------------		

	li $v0, 4
	la $a0, newline
	syscall



	addi $t6,$t6,1		#----------------------Incrementing counter for the number of inputs----------
	li $t7, 4 		#----------------------Hard-code value 4 to t7-----------------------


#-----------------------First for loop--------------------

	li $t0, 0 		#-----------------------First for loop--------------------
				
	li $t2, -1 		#-----------------------$t2 register is used to get the correct charecter from the register location s3
	loop_1:
	addi $t2, $t2, 1 	#----------------------Adding 1 to t2 everytime it goes through the entire loop once/Incrementation----
	beq $t0, $t7, Exit 	#---------------------Checks if $t0 = 4. If yes, it means it checked all the charecters and should exit loop----
	
# This part is being used to load the correct character from the word location ,that is,at $s3. 
# And also, we have 4 beq's as whenever loop_1 starts then the program is moving to the next charecter in the $s3 word. 
# For the oabve  mentioned reasons, we are using using $zero, $t3, $t4, $t5 registers in order to jump to the correct location for the required charecter

	beqz $t2, first	 	#If t1 = 0, this is the first time loop_1 is being executed. And Branch to first 
	beq $t3, $t2, second 	#If t1 = 1, this is the second time loop_1 is being executed. AndBranch to second 
	beq $t4, $t2, third 	#If t1 = 2, this is the third time loop_1 is being executed. And Branch to third  
	beq $t5, $t2, fourth 	#If t1 = 3, this is the fourth time loop_1 is being executed. And Branch to fourth 
first:
	lbu $a0, 0($s3) 	#Load the first byte at this location ==> loads the first character in the word.
	li $t1, 0
	j loop_2
second:
	lbu $a0, 1($s3)		#Load the second byte at this location ==> loads the second character in the word.
	li $t1, 0
	j loop_2
third:
	lbu $a0, 2($s3)		#Load the third byte at this location ==> loads the third character in the word.
	li $t1, 0
	j loop_2
fourth:
	lbu $a0, 3($s3)		#Load the fourth byte at this location ==> loads the fourth charecter in the word.
	li $t1, 0
	j loop_2

loop_2:
	beq $t1, $t7, End_of_loop_1	#------------Exit condition of j--------------
	lbu $a1, user_word($t1)

	beq $a0, $a1, nested_if
	addi $t1, $t1, 1		#-----------Increments j by 1---------------
	j loop_2	
nested_if:
	 bne $t0, $t1, else
	 addi $s1, $s1, 1 
	 addi $t1, $t1, 1		#-----------Again, increments j by 1---------
	 j loop_2
else:
	 addi $s2, $s2, 1
	 addi $t1, $t1, 1		#----------Increments j by 1------------
	 j loop_2
	 		  
End_of_loop_1:				#----------End of the loop-------------
	addi $t0, $t0, 1		
	j loop_1
	
Exit:
	li $v0, 4			#----------------Prints out Bulls count-------------------
	la $t0, promptAttempts
	add $a0, $t0, $zero
	syscall
	
	li $v0, 1 
	add $a0, $t6, $zero
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall


	li $v0, 4
	la $t0, promptBulls		#----------------Prints out Cows count-------------------
	add $a0, $t0, $zero
	syscall
	
	li $v0, 1
	add $a0, $s1, $zero
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	la $t0, promptCows			#-------------Prints out cows
	add $a0, $t0, $zero
	syscall
	
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 4
	la $t0, promptAttemptsLeft
	sub $a0, $t0, $zero
	syscall
	li $v0, 1 
	sub $t0, $t6, 10
	abs $t0, $t0
	add $a0, $t0, $zero
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j input
	
 Correct_Input:
	li $v0, 4			#-------In case the user gets all the four Bulls correct------------------------
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, correct_input
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4			#Output timer------------
	la $a0, time_elapsed
	syscall
	
	lw $t8, 4($sp)
 	li $v0, 30
 	syscall
 	sub $t8, $a0, $t8
 	div $t8, $t8, 1000
 	li $v0, 1
 	add $a0, $t8, $zero
 	syscall
	li $v0, 4
 	la $a0, seconds
 	syscall
 	
 	
	li $t6, 0 		#-------------Counter to check the number of inputs 
	li $s1, 0 		#---------------Number of bulls
	li $s2, 0 		#-------------Number of cows
	j endGame
	
	
After_max_guesses:
	li $v0, 4
	la $a0, max_guess_prompt
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, max_guess_prompt_2
	syscall
	
	lw $s4, 0($sp)
	
	
	li $v0, 4
	la $a0, words_array($s4)
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	
	li $v0, 4
	la $a0, time_elapsed		#-------------Output timer------------------------------------------------------
	syscall
	
	lw $t8, 4($sp)
 	li $v0, 30
 	syscall
 	
 	
 	sub $t8, $a0, $t8
 	div $t8, $t8, 1000

 	li $v0, 1
 	add $a0, $t8, $zero
 	syscall
 	
 	li $v0, 4
 	la $a0, seconds
 	syscall
 	li $v0, 4
	la $a0, newline
	syscall
	
	j endGame
 	
 	
 UserInputError:			#--------------User INput Validation propmt---------------------
	li $v0, 4
	la $t0, InputRangeError
	add $a0, $t0, $zero
	syscall
	j input
	
Duplicate:			#--------Checks for Duplicate wordds------------------------
	li $v0, 4
	la $t0, DupeError
	add $a0, $t0, $zero
	syscall
	j input
	
Giveup:		#-----------Give_up prompt----------
	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $t0, give_up_prompt
	add $a0, $t0, $zero
	syscall
	
	li $v0, 4
	la $a0, words_array($s4)
	syscall

	li $v0, 4
	la $a0, newline
	syscall
	
	j endGame

Music: 		#------------Music on prompt--------------
	li $a0, 60 		
	li $a1, 500  
	li $a2, 110
	li $a3, 127
	la $v0, 33
	syscall
	jr $ra 
 
 
labelz:
 	li $v0, 4
 	la $a0, LenError
 	syscall
 	j input
 
 
GameOver:
	
	
	

