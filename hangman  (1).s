.data
.balign 4
    handle: .skip 4    
    buffer: .skip 80
    string: .asciz "\t%s\n"
    string2: .asciz "\t%c\n"
    random_word: .skip 4
    removed_char: .skip 4
    modified_word: .skip 4 
    welcome: .asciz "\t\t!!!Welcome to the Game HangMan!!!!\n\tRULES:-\n\t  -In this classic word-guessing game, you'll try to guess the secret word by suggesting letters one at a time.\n\t  -every incorrect guess brings you one step closer to being HANGED!!\n\n"
    display: .asciz "Your Current Score:\n\tCorrect Guess: %d\n\tIncorrect Guess: %d\n"
    input_string: .asciz "Your Guess : \n"
    end: .asciz "\n\tGAME OVER!\n\tOppps!!! it's looks like the stick figure is hanged!!!\n\t Don't worry Nobody was hurt in making of this game!!\n\t Try again and save the figure next time!!\n\t\t Thank you for Playing!!!"
    correct: .asciz "\tYour guess is correct!!! \n\t The word was %s\n"
    incorrect: .asciz "\tYour guess is incorrect :( \n\t The word was %s\n"
    hangman_stage1: .asciz "\n\n\n\n\n\t===========\n"
    hangman_stage2: .asciz "\n\n\n\n\n\t     |\n\t     |\n\t     |\n\t     |\n\t     |\n\t===========\n"
    hangman_stage3: .asciz "\n\n\t +----+\n\t |    |\n\t      |\n\t      |\n\t      |\n\t      |\n\t===========\n"
    hangman_stage4: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t      |\n\t      |\n\t      |\n\t===========\n"
    hangman_stage5: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t |    |\n\t      |\n\t      |\n\t===========\n"
    hangman_stage6: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t/|    |\n\t      |\n\t      |\n\t===========\n"
    hangman_stage7: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t/|\\   |\n\t      |\n\t      |\n\t===========\n"
    hangman_stage8: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t/|\\   |\n\t/     |\n\t      |\n\t===========\n"
    hangman_stage9: .asciz "\n\n\t +----+\n\t |    |\n\t 0    |\n\t/|\\   |\n\t/ \\   |\n\t      |\n\t===========\n"
    incorrect_guess_count: .word 0
    correct_guess_count: .word 0
.text
.global Main
.extern printf
.extern getRandomName

Main:
    push {ip, lr}
    ldr r0, =welcome
	bl printf
    bl hangman
    pop {ip, pc}
    
generate:
    push {ip, lr}
    
    @ Get the random word and store it in the random_word
    bl getRandomName
    ldr r1, =random_word
    str r0, [r1] 
    
    @ Get the middle character from the random word
    ldr r2, =random_word
    ldr r2, [r2]
    mov r3, #0

loop:
    ldrb r4, [r2], #1
    cmp r4, #0
    beq middle
    add r3, r3, #1
    b loop

middle:
    lsr r3, r3, #1 @ Divide the length by 2 to get the middle element
    ldr r2, =random_word
    ldr r2, [r2]
    ldrb r4, [r2, r3] @ Load the middle character into r4

ldr r5, =removed_char
strb r4, [r5]

@ Create a new null-terminated string with the modified word
ldr r6, =modified_word
mov r7, #0
strb r7, [r6]

ldr r7, =random_word
ldr r7, [r7]
mov r8, #0 @ Counter for modified word

loop2:
    ldrb r4, [r7], #1
    cmp r4, #0
    beq end_loop2
    cmp r8, r3 @ Check if we are at the middle
    bne storechar

    mov r4, #'_'

storechar:
    strb r4, [r6], #1
    add r8, r8, #1 @ Increment the counter
    b loop2
    
end_loop2:
	
    mov r4, #0
    strb r4, [r6] @ Add null terminator


@displaying the score
 ldr r1, =incorrect_guess_count
 ldr r2, [r1]
 ldr r1, =correct_guess_count
 ldr r1, [r1]
 ldr r0, =display
 bl printf


@ Print the modified random word
ldr r0, =string
ldr r1, =modified_word
bl printf
ldr r0, =input_string
bl printf

    
    pop {ip, pc}

hangman:
    push {ip, lr}
    @ printing the user input
	
    bl generate
    
    mov r4, #0 @ Initialize incorrect guess count

loop3:
	
    bl command_line
    ldr r1, =incorrect_guess_count
    ldr r2, [r1]
    cmp r2, #9
    bge end_game
    bl hangman
	pop {ip, pc}

end_game:
	push {ip, lr}
    @ Print the final hangman 
    ldr r0, =end
	bl printf
	mov r0, #0 
	mov r7, #1
    svc 0
    pop {ip, pc}

command_line:
    push {ip, lr}
    mov r0, #0
    ldr r1, =buffer
    mov r2, #1
    mov r7, #3
    svc #0

    ldr r3, =removed_char
    ldrb r4, [r1]  @ Character from the user
    ldrb r5, [r3]  @ Character from the random word
    cmp r4, r5
    beq correct_guess
    bne incorrect_guess
    
    pop {ip, pc}

correct_guess:
    push {ip, lr}
    ldr r1, =random_word
    ldr r1, [r1]
    ldr r0, =correct
    bl printf
    
    @increment the Correct Guess
    ldr r1, =correct_guess_count
    ldr r2, [r1]
    add r2, r2, #1
    str r2, [r1]
    
     @ reset  the buffer 
    mov r0, #0
    ldr r1, =buffer
    mov r2, #1
    mov r7, #3
    svc #0
    pop {ip, pc}
    
incorrect_guess:
    push {ip, lr}
    ldr r1, =random_word
    ldr r1, [r1]
    ldr r0, =incorrect
    bl printf
    
    @ Print the hangman drawing
    ldr r1, =incorrect_guess_count
    ldr r2, [r1]
    adr r3, hangman_stages
    ldr r0, [r3, r2, lsl #2]
    bl printf

    @ Increment the incorrect guess count
    ldr r1, =incorrect_guess_count
    ldr r2, [r1]
    add r2, r2, #1
    str r2, [r1]
    
    @ reset  the buffer 
    mov r0, #0
    ldr r1, =buffer
    mov r2, #1
    mov r7, #3
    svc #0
    
    pop {ip, pc}

hangman_stages:
    .word hangman_stage1
    .word hangman_stage2
    .word hangman_stage3
    .word hangman_stage4
    .word hangman_stage5
    .word hangman_stage6
    .word hangman_stage7
    .word hangman_stage8
    .word hangman_stage9
