JMP INIT

# org 003CH
JMP KB_IN; sets 7 point 5 Interrupt Service Routine


# org 0040H
INIT : ; inits interrupts and devices
	LXI SP, 5868H; sets stack pointer memory location 
	MVI A,04H; prepare the mask to enable 7 poitn 5 interrupt
	SIM; apply the settings RTS masks

;SET 8 8-bit character display -left entry and decoded scan keyboard n-Key Rollover
	LXI H, 2800H;  sets !CS - A14 to 0 to activate 8279 and A13 - C/D to 1 to send a command to the 8279
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
	JZ 00D7H; if B == 6 then jump to R_AND_S_T_R RET

	LXI H, 5822H; direction where register B will be saved before calling the function
	MOV M,B; save the register

	CALL R_EXCHANGE_RATE;

	LXI H, 5822H; load direction of register B in memory
	MOV B,M; restore register B

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

# org 01C3H
	; Prueba push/pop
	;MVI B,01H
	;MVI C,02H
	;MVI D,03H
	;MVI E,04H
INPUT:

	PUSH B;Se guarda preventivamente el dato que
	;contenga el registro B y C
	PUSH D;Se guarda preventivamente el dato que
	;contenga el registro D y E

	CALL S_INIT; iniciar simulacion

	CALL E_KEYBOARD; habilita el KEYBOARD

	; Se incia un bucle que solo termina cuando se activa la
	; interrupcion R75

	; Es el momento propicio para simular la entrada de
	; caracteres al FIFO del 8279
	; Agrega en los puertos F8H al FFH los caracteres deseados
	; en orden

	CALL D_KEYBOARD; Se deshabilita el keyboard
	
	CALL S_NUMBER_C ; Simula la entrada del word-status
	LDA 0800H;Se lee el word status FIFO del 8279

	CALL GET_NUMBER_C ;obtiene numero de caracteres en
	;FIFO
	CALL SAVE_NC_RAM;guarda el numero de caracteres en
	; RAM

	; Se comprueba si hay caracteresen FIFO
	; en caso no haber finaliza INPUT
	MOV A,B
	CPI 00H
	JZ END_LOOP

	CALL S_INIT_PORT_COUNTER; inicia el contador de puertos
	; usado para la simulacion de la entrada de un caracter

	;Bucle que hace la lectura de todos los
	;caracteres que esten en la FIFO, segun el nuemro de 
	;caracteres
	CALL INPUT_LOOP

END_LOOP:	
	POP D;Se recupera los datos almacenados
	;preventivamente de los regs D Y E
	POP B;Se recupera los datos almacenados
	;preventivamente de los regs B y C
	RET

INPUT_LOOP:
	CALL S_KEY_ENTRY; simula entrada de un caracter
	LDA 0800H;Se lee un caracter de la FIFO
	STAX D;Almacena el caracter en RAM
	;en la direccion contenida en los registros D,E
	INX D;Se incrementa la direccion D,E en uno
	; Para el proximo caracter que se use
	DCR B;Se decrementa el registro B en uno
	; indicando que se leyo un caracter y para
	;poder comparar si ya se leyeron todos los
	;caracteres que estaban en FIFO
	MOV A,B;Se mueve el numero de caracteres restantes
	;del reg B al reg A para poder hacer la comparacion
	CPI 00;Se compara si el numero de caracteres
	;restantes es cero
	JNZ INPUT_LOOP
	;Si el numero de caracteres restantes no es
	;cero, se mantiene el bucle y se salta a
	;INPUT_RATE_LOOP
	;en caso contrario se sale del bucle para
	;terminar con la lectura
INPUT_LOOP_R:RET

GET_NUMBER_C:
	;Gets number of characters in FIFO
	;given by data entry (word status) in reg A
	;and save this number in reg B
	MOV B,A
	RET

SAVE_NC_RAM:
	;Saves number of characters in FIFO on 5869H RAM
	;and load D and E regs with data 5869H
	MOV A,B
	STA 5869H; Guarda en la direccion RAM 5869H
		;el numero de caracteres en FIFO (reg A)
	LXI D, 586AH;Carga la direccion 586AH en los regs D y E
		;por ser la direccion donde se comensaran
		;a guardar los datos leidos del 8279
	RET

S_INIT: ; Iniciar simulacion
	; incia todos los puertos (F8H al FFH) usados para la
	; simulacion en FFH
	MVI A, FFH
	OUT F8H
	OUT F9H
	OUT FAH
	OUT FBH
	OUT FCH
	OUT FDH
	OUT FEH
	OUT FFH
	RET

S_INIT_PORT_COUNTER:; Se inicia el contador de puertos usados para
	; la simulacion
	MVI C, F7H; inicia el contador en F7H 
	RET

S_NUMBER_C:; Simula la entrada de word-status
	; contando el numero de puertos entre F8H y FFH
	; en los que se ha ingreado un dato diferente de FFH
	;PUSH B
	MVI C, 00H; el reg C es usado para contar

	IN F8H; hace una lectura del puerto XXH cuyo valor se
	; guarda en el reg A
	CPI FFH; compara el reg A con el valor FFH
	JZ S_NUMBER_C_R
	;Si la comparacion es positiva la bandera Z se pone en 1
	; indicando que no hay mas caracteres en FIFO
	; (simulacion)
	INR C; en caso contrario, se incrementa C y se analiza el
	; siguiente puerto

	IN F9H
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FAH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FBH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FCH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FDH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FEH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

	IN FFH
	CPI FFH
	JZ S_NUMBER_C_R
	INR C

S_NUMBER_C_R:
	MOV A,C; el numero de caracteres en reg C se pasan al
	; regA
	STA 0800H;SE almacena reg A en la direccion 0800H
	
	RET
S_KEY_ENTRY: ; Simular la entrada de un caracter
	INR C
	MOV A,C

	CPI F8H
	CZ IN_F8

	CPI F9H
	CZ IN_F9

	CPI FAH
	CZ IN_FA

	CPI FBH
	CZ IN_FB

	CPI FCH
	CZ IN_FC

	CPI FDH
	CZ IN_FD

	CPI FEH
	CZ IN_FE

	CPI FFH
	CZ IN_FF
	RET

IN_F8:
	IN F8H; Lee un dato por el puerto F8H
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_F9:
	IN F9H; Lee un dato por el puerto F9H
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FA:
	IN FAH; Lee un dato por el puerto FAH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FB:
	IN FBH; Lee un dato por el puerto FBH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FC:
	IN FCH; Lee un dato por el puerto FCH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FD:
	IN FDH; Lee un dato por el puerto FDH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FE:
	IN FEH; Lee un dato por el puerto FEH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET
IN_FF:
	IN FFH; Lee un dato por el puerto FFH
	;Se almacena en el reg A
	STA 0800H; Almacena el dato en reg A, en la direccion
	; 0800H
	RET

O_D:
	RET
SAVE_RATE:
	RET
ADJUST:
	RET
