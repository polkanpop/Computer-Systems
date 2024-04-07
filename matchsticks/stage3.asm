// Name: Luu Hieu Khang
// ID: 104993706

// getting player name
mov r0, #namePrompt
mov r1, #namePlayer 
bl InputString
bl NewLine
//getting starting number of matchsticks
mov r0, #matchsticksPrompt
str r0, .WriteString
bl InputNumber              //store the input number to R2
str r2, initialMatchsticks  //store the input number from r2 to initalize number of matchsticks 
mov r3, r2
cmp r3, #5                  // make sure the input is between 5 and 100
blt Error 
cmp r3, #100
bgt Error

MatchStart:
ldr r3, initialMatchsticks  //load the initial number of matchsticks to r3 so that it stores the remaining number of matchsticks
bl NewLine
b InitialMatchsticksPrompt

InitialMatchsticksPrompt:   //print the initial nummber of matchsticks at the start of the game
bl NewLine
mov r0, #player
str r0, .WriteString
mov r0, #namePlayer
str r0, .WriteString
mov r0, #thereAre
str r0, .WriteString
ldr r5, initialMatchsticks
str r5, .WriteUnsignedNum                       
mov r0, #matchsticksRemaining
str r0, .WriteString
b HowManyToRemovePrompt


PlayerTurn:
b RemainingMatchsticksPrompt
RemainingMatchsticksPrompt: // print the remaining matchsticks
bl NewLine
mov r0, #player
str r0, .WriteString
mov r0, #namePlayer
str r0, .WriteString
mov r0, #thereAre
str r0, .WriteString
str r3, .WriteUnsignedNum
mov r0, #matchsticksRemaining
str r0, .WriteString


HowManyToRemovePrompt:
bl NewLine
mov r0, #player
str r0, .WriteString
mov r0, #namePlayer
str r0, .WriteString
mov r0, #howManyToRemove
str r0, .WriteString

//player inputs here
bl InputNumber          //stores the number that the player inputs into r2
mov r4, r2              //copy r2 into r4, r4 stores the number of matchsticks to remove
cmp r4, #1              //make sure the input number is between 1 and 3
blt Error
cmp r4, #3
bgt Error
cmp r4, r3
bgt Error



//update the remaining matchsticks
sub r3, r3, r4          //r3 store the number of remaining matchsticks, r4 stores the number of matchsticks to remove

cmp r4, #1              
beq PlayerInputNumberOne
bgt PlayerInputNumberLargerThanOne




PlayerInputNumberOne:
bl NewLine
cmp r3, #0              //if the player inputs number 1 and the remaining number of matchsticks is 0
beq PlayerLose          //then the player lose
bgt ComputerTurn        // if the remaining number of matchsticks is greater than 0, branch to the computer's turn
ret

PlayerInputNumberLargerThanOne:
bl NewLine              
cmp r3, #0              // if the player inputss a number that is larger than 1 and the remainging number of matchsticks is 0
beq Draw                // then it is a draw
bgt ComputerTurn        // if the remaining number of matchsticks is greater than 0, branch to computer's turn
ret



ComputerTurn:

ldr r0, .Random
and r0, r0, #3
cmp r0, #0
beq ComputerTurn
cmp r0, r3
bgt ComputerTurn
sub r3, r3, r0

bl NewLine

//print the computer's turn
mov r1, #computerPrompt         
str r1, .WriteString
str r0, .WriteUnsignedNum
bl NewLine

cmp r0, #1
beq ComputerInputNumberOne
bgt ComputerInputNumberLargerThanOne

ComputerInputNumberOne:
cmp r3, #0
beq PlayerWin
bgt PlayerTurn

ComputerInputNumberLargerThanOne:
cmp r3, #0
beq Draw
bgt PlayerTurn



b PlayerTurn


halt



//FUNCTIONS



InputString: 
push {r3, r4}           //this function takes in two arguments and print it out
mov r3, r0
mov r4, r1
str r3, .WriteString
str r4, .ReadString
str r4, .WriteString

ret

InputNumber:                              //this function takes in one input argument and stores it in r2
push {r4}
ldr r4, .InputNum
str r4, .WriteUnsignedNum
mov r2, r4 // store the the number in r2
pop {r4}

ret 

NewLine:                            //this function creates a new line
push {r0}
mov r0, #0x0A
strb r0, .WriteChar
pop {r0}

ret

Error:                              //this function returns an error message if the input number is Invalid
push {r3}                           
push {lr}
bl NewLine
pop {lr}
mov r3, #errorMessage
str r3, .WriteString
pop {r3}
push {lr}
bl NewLine
pop {lr}
b InputNumber                       //and then branch back to InputNumber function so that the user can input again


GameOver:
push {lr}
bl NewLine
pop {lr}
push {r3}
mov r3, #gameOver                   //prints Game Over
str r3, .WriteString        
pop {r3}
push {lr}
bl NewLine
pop {lr}
push {r3}
mov r3, #playAgain
str r3, .WriteString                //prompt the user to play again
pop {r3}
push {r4}
mov r4, #continue                   //copy the address for the "continue" label to r4
str r4, .ReadString                 //read the user input, the input will turn into a binary word  
mov r0, r4                          //copy the address containing the input to r0
pop {r4}
ldrb r0, [r0]                       //loads only the first 8 bits of data in memmory from the memmory location of r0
                                    // everything from the 9th bit onwards is set to 0
cmp r0, #121                        // compare that number to 121 which is ASCII number for "y"    
beq MatchStart
cmp r0, #110                        //compare that number to 110 which is ASCII number for "n"
beq QuitGame
ret

QuitGame:
halt




Draw:
push {r3}
mov r3, #drawPrompt
str r3, .WriteString
pop {r3}
b GameOver
ret

PlayerWin:
push {r3}
mov r3, #player
str r3, .WriteString
mov r3, #namePlayer
str r3, .WriteString
mov r3, #winPrompt
str r3, .WriteString
pop {r3}
push {lr}
bl NewLine
pop {lr}
b GameOver
ret

PlayerLose:
push {r3}
mov r3, #player
str r3, .WriteString
mov r3, #namePlayer
str r3, .WriteString
mov r3, #losePrompt
str r3, .WriteString
pop {r3}
b GameOver
ret

//stage 1
namePrompt: .asciz "Please enter your name: "
namePlayer: .block 128
matchsticksPrompt: .asciz "How many matchsticks (5-100)? "
initialMatchsticks: .word 0
errorMessage: .asciz "Invalid input, please try again."
nameOutput: .asciz "Player 1 is "
matchsticksOutput: .asciz "Matchsticks: "

//stage 2

player: .asciz "Player "
thereAre: .asciz ", there are "
matchsticksRemaining: .asciz " match sticks remaining"
howManyToRemove: .asciz ", how many do you want to remove (1-3)"
gameOver: .asciz "Game Over"

//stage 3
computerPrompt: .asciz "Computer Player's turn: "
winPrompt: .asciz ", YOU WIN!"
losePrompt: .asciz ", YOU LOSE!"
drawPrompt: .asciz "It's a draw!"
continue: .block 128
playAgain: .asciz "Play again (y/n)?"