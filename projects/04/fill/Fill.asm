// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

@last_key
M=0
@current_key
M=0
@key_state
M=0

@8192
D=A
@screen_words
M=D                 //how many registers (16-bit words) make up the total screen



(LOOP)
    
    @KBD
    D=M
    @current_key
    M=D             //set current_key to current keyboard state

    @CONVERT_TO_1
    D;JGT           //if greater than 0 then convert to a 1 (keys have different values but all we care about is if its not 0)
    (CONVERT_RETURN)

    @current_key
    D=M             //D = current_key
    @last_key
    D=M-D           //D = last_key - current_key (last_key and current_key can only be 1s or 0s here)
                    //possible results: -1(key pressed), 0(no change), 1(key released)
    @key_state
    M=D

    @REFRESH_SCREEN
    D;JNE           //fill screen as a key was pressed/released
    (REFRESH_RETURN)

    @current_key
    D=M
    @last_key
    M=D             //last_key = current_key
    @LOOP
    0;JMP           //infinite loop


(CONVERT_TO_0)
    @key_state
    M=0
    @CONVERT_0_RETURN
    0;JMP
    

(REFRESH_SCREEN)
    @SCREEN
    D=A
    @word
    M=D             //point to first word in the screen

    @key_state
    D=M
    @CONVERT_TO_0
    D;JGT           //D can be either 1 (key pressed) or -1 (key released) here. if its 1 then we need to set it to 0
    (CONVERT_0_RETURN)

    (FILL_LOOP)
        @word
        D=M
        @SCREEN
        D=D-A       //D = word - SCREEN address
        @screen_words
        D=D-M       //D = (how many words we've done) - (how many words there are)
        @REFRESH_RETURN
        D;JGE       //return if D >= 0 (we have looped through all words)

        @key_state
        D=M         //screen word will be set to D (key_state) which at this point will be 0 if a key was released or -1
                    //if a key was pressed

        @word
        A=M
        M=D        //get pointer address and then set that address to -1

        @word
        M=M+1       //increment word pointer

        @FILL_LOOP
        0;JMP

(CONVERT_TO_1)
    @current_key
    M=1
    @CONVERT_RETURN
    0;JMP
    
