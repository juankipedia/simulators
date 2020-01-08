JMP INIT


# org 003CH
CALL KB_IN; sets 7 point 5 Interrupt Service Routine


# org 0040H
INIT : ; inits interrupts and devices
	MVI A,04H; prepare the mask to enable 7 poitn 5 interrupt
	SIM; apply the settings RTS masks
	;SET 8 8-bit character display -left entry and decoded scan keyboard 2-key lockout
	
R_AND_S_T: ; read and save table
	CALL R_AND_S_T_R; calls read and save table routine


LOOP: ; main loop
	CALL PROGRAM; calls main program
	JMP LOOP

# org 0080H
PROGRAM: ; main program routine
	;output result of the program
  	RET

# org 0100H
R_AND_S_T_R: ; read and save table routine (reads edges of graph)
	MVI B, 00H; sets register B to 0 pointing to first exchange rate
	MVI A, 09H; sets register A with upper bound of B n * n
	CMP B; if B == 9
	JZ 0046H; if B == 9 then jump to instruction on location 0046H
	
	CALL R_EXCHANGE_RATE;

	INR B; B += 1
	JMP 0102H; to instruction in location 0102H
  	RET

# org 0200H
R_EXCHANGE_RATE: ; reads exchange rate pointed by register B 
	RET

# org 0400H
 KB_IN: ;keyboard interrupt function
  	RET
