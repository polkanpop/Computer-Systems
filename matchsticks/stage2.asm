// Name: Luu Hieu Khang
// ID: 104993706

// getting player name

mov r0, #namePrompt
mov r1, #namePlayer 
bl InputString
bl NewLine

// getting starting number of matchsticks
mov r0, #matchsticksPrompt
bl InputMatchsticks //this function stores the input number into R2
mov r3, r2
cmp r3, #5          // make sure the input is between 5 and 100
blt Error 
cmp r3, #100
bgt Error

//print game info
mov r0, #namePlayer
mov r1, r3
bl NewLine
bl PrintInfo



PlayerTurn:
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

//getting the player input for the number of matchsticks to remove

//prompt
bl NewLine
mov r0, #player
str r0, .WriteString
mov r0, #namePlayer
str r0, .WriteString
mov r0, #howManyToRemove
str r0, .WriteString

//player input
bl InputNumber
mov r4, r2    //store the number of matchsticks to remove in R3

cmp r4, #1    //make sure the input is between 1 and 3
blt Error
cmp r4, #3
bgt Error
cmp r4, r3
bgt Error


//update the remaining matchsticks
sub r3, r3, r4
cmp r3, #0
bgt PlayerTurn
bl GameOver





halt



//FUNCTIONS



InputString: 
push {r3, r4}
mov r3, r0
mov r4, r1
str r3, .WriteString
str r4, .ReadString
str r4, .WriteString

ret

InputMatchsticks:
push {r3}
mov r3, r0
str r3, .WriteString
pop {r3}

InputNumber:
push {r4}
ldr r4, .InputNum
str r4, .WriteUnsignedNum
mov r2, r4 // store the the number in r2
pop {r4}

ret 

NewLine:
push {r0}
mov r0, #0x0A
strb r0, .WriteChar
pop {r0}

ret

Error:
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
b InputNumber

PrintInfo:
push {r3, r4, r5, r6}
mov r3, r0 
mov r4, r1 
mov r5, #nameOutput
mov r6, #matchsticksOutput

str r5, .WriteString
str r3, .WriteString

push {lr}
bl NewLine
pop {lr}
str r6, .WriteString
str r4, .WriteUnsignedNum
pop {r3, r4, r5, r6}

ret

GameOver:
push {lr}
bl NewLine
pop {lr}
push {r3}
mov r3, #gameOver
str r3, .WriteString
pop {r3}

ret





//stage 1
namePrompt: .asciz "Please enter your name: "
namePlayer: .block 128
matchsticksPrompt: .asciz "How many matchsticks (5-100)? "
errorMessage: .asciz "Invalid input, please try again."
nameOutput: .asciz "Player 1 is "
matchsticksOutput: .asciz "Matchsticks: "

//stage 2

player: .asciz "Player "
thereAre: .asciz ", there are "
matchsticksRemaining: .asciz " match sticks remaining"
howManyToRemove: .asciz ", how many do you want to remove (1-3)"
gameOver: .asciz "Game Over"


