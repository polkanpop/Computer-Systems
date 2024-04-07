// Name: Luu Hieu Khang
// ID: 104993706
// getting player name

mov r0, #namePrompt
mov r1, #namePlayer
bl InputString
bl NewLine

mov r0, #matchsticksPrompt
bl InputMatchsticks //this function stores the input number into R2
cmp r2, #5
blt Error 
cmp r2, #100
bgt Error

mov r0, #namePlayer
mov r1, r2
bl NewLine
bl PrintInfo



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

ret








namePrompt: .asciz "Please enter your name: "
namePlayer: .block 128
matchsticksPrompt: .asciz "How many matchsticks (5-100)? "
errorMessage: .asciz "Invalid input, please try again."
nameOutput: .asciz "Player 1 is "
matchsticksOutput: .asciz "Matchsticks: "
