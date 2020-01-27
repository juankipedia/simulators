JMP INIT

# org 003CH
JMP KB_IN; sets 7 point 5 Interrupt Service Routine


# org 0040H
INIT : ; inits interrupts and devices
	LXI SP, 0240H; sets stack pointer memory location 
	MVI A,04H; prepare the mask to enable 7 poitn 5 interrupt
	SIM; apply the settings RTS masks

;SET 8 8-bit character display -left entry and decoded scan keyboard n-Key Rollover
	LXI H, 2000H;  sets !CS - A14 to 0 to activate 8279 and A13 - C/D to 1 to send a command to the 8279
	MVI M, 03H; sets 000 [00] [011] that is the desire configuration

	
R_AND_S_T: ; read and save table
	CALL R_AND_S_T_R; calls read and save table routine


LOOP: ; main loop
	CALL PROGRAM; calls main program
	JMP LOOP

# org 0080H
PROGRAM: ; main program routine
	;output result of the program
  	RET

# org 00C0H
R_AND_S_T_R: ; read and save table routine (reads edges of graph)
	MVI B, 00H; sets register B to 0 pointing to first exchange rate
	MVI A, 06H; sets register A with upper bound of B (n * n) - n
	CMP B; if B == 6
	JZ 00CFH; if B == 6 then jump to R_AND_S_T_R RET
	
	CALL R_EXCHANGE_RATE;

	INR B; B += 1
	JMP 00C2H;  jumps to if A = 6
  	RET

# org 0100H
R_EXCHANGE_RATE: ; reads exchange rate pointed by register B

	; it calls 3 functions OUTPUT_DISPLAY(B), INPUT_RATE(B),  SAVE_RATE(B)
	RET

# org 0180H
E_KEYBOARD: ;enables keyboard by EI, and waits until key is pressed
	EI; enables keyboard interrupts
LOOP_EK: 	JMP LOOP_EK; waits until keyboard interrupts 
	RET

# org 0185H
D_KEYBOARD:
	DI; disables keyboard interrupts
	RET

# org 01C0H
KB_IN: ;keyboard interrupt function
	JMP 0184H; jumps to E_KEYBOARD RET instruction

# org 03C0H
OUTPUT_DISPLAY
	RET

# org 05C0H
INPUT
	RET

# org 07C0H
SAVE_RATE
	RET

# org 07E9H
ADJUST
	RET


