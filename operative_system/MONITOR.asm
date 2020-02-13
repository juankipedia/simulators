JMP INIT

# org 003CH
JMP KB_IN; sets 7 point 5 Interrupt Service Routine


# org 0040H
INIT : ; inits interrupts and devices
	LXI SP, 1868H; sets stack pointer memory location 
	MVI A,04H; prepare the mask to enable 7 poitn 5 interrupt
	SIM; apply the settings RTS masks

;SET 8 8-bit character display -left entry and decoded scan keyboard n-Key Rollover
	LXI H, 6800H;  sets !CS - A14 to 0 to activate 8279 and A13 - C/D to 1 to send a command to the 8279
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

	LXI H, 1822H; direction where register B will be saved before calling the function
	MOV M,B; save the register

	CALL R_EXCHANGE_RATE;

	LXI H, 1822H; load direction of register B in memory
	MOV B,M; restore register B

	INR B; B += 1
	JMP 00C2H;  jumps to if A = 6
  	RET

# org 0100H
R_EXCHANGE_RATE: ; reads exchange rate pointed by register B
    CALL INPUT
    CALL ADJUST
    CALL SAVE_RATE
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

;---------- Empieza INPUT ----------
# org 01C3H
INPUT:

	CALL S_INIT; Se inicia la simulacion

	CALL E_KEYBOARD; Se habilita el KEYBOARD

	; Se incia un bucle que solo termina cuando se activa la
	; interrupcion R75

	; Es el momento propicio para simular la entrada de
	; caracteres al FIFO del 8279
	; Agrega en los puertos F8H al FFH los caracteres deseados
	; en orden left-right

	CALL D_KEYBOARD; Se deshabilita el keyboard
	
	CALL S_NUMBER_C ; Simula la entrada del word-status
	LDA 4800H;Se lee el word status FIFO del 8279

	CALL GET_NUMBER_C ;obtiene numero de caracteres en
	;FIFO
	CALL SAVE_NC_RAM;guarda el numero de caracteres en
	; RAM

	; Se comprueba si hay caracteres en FIFO
	; en caso no haber finaliza INPUT
	MOV A,B
	
	CPI 00H

	; Si no hay caracteres en FIFO (reg A = reg B = 0)
	; Se salta al final de esta rutina (INPUT)
	JZ END_LOOP

	CALL S_INIT_PORT_POINTER
	; inicia el puntero de puertos
	; usado para la simulacion de la entrada de un caracter

	;Bucle que hace la lectura de todos los
	;caracteres que esten en la FIFO, segun el nuemero de 
	;caracteres
	CALL INPUT_LOOP

END_LOOP:	
	RET

INPUT_LOOP:
	CALL S_KEY_ENTRY; simula entrada de un caracter
	LDA 4800H;Se lee un caracter de la FIFO
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
	;Saves number of characters in FIFO on 1869H RAM
	;and load D and E regs with data 1869H

	; Cuando  se llama a esta rutina en el reg B se debe
	; enecontrar
	; el numero de caracteres que hay en FIFO 

	MOV A,B; El valor del reg B se pasa al reg A
	STA 1869H; Guarda en la direccion RAM 1869H
		;el numero de caracteres en FIFO (reg A)
	LXI D, 186AH;Carga la direccion 186AH en los regs D y E
		;por ser la direccion donde se comensaran
		;a guardar los caracteres leidos del 8279
	RET

S_INIT: ; Inicia la simulacion
	; Se inician todos los puertos (del F8H al FFH) usados
	; para la simulacion, con el FFh

	; Nota: Los puertos del F8H al FFh simulan la FIFO
	; del 8279
	; El valor FFh se usa como indicativo de vacio

	MVI A, FFH ; Cargar en el registro A el valor FFH
	OUT F8H ; Envia al puerto F8H el valor FFH
	OUT F9H ; Envia al puerto F9H el valor FFH
	OUT FAH ; Envia al puerto FAH el valor FFH
	OUT FBH ; Envia al puerto FBH el valor FFH
	OUT FCH ; Envia al puerto FCH el valor FFH
	OUT FDH ; Envia al puerto FDH el valor FFH
	OUT FEH ; Envia al puerto FEH el valor FFH
	OUT FFH ; Envia al puerto FFH el valor FFH
	RET

S_INIT_PORT_POINTER:; Se inicia el puntero que indica el
	; el puerto que se leera cada vez que se simula
	; la entrada de un caracter con la rutina S_KEY_ENTRY

	
	; Se usara el reg C para llevar el estado del puntero
	MVI C, F7H; Inicia el puntero en F7H 
	; Se inicia en F7H para que en la primera iteracion
	; la rutina S_KEY_ENTRY establezca el puntero en
	; F8H que es el puerto real de inicio
	RET

S_NUMBER_C:; Simula la entrada de word-status
	; contando el numero de puertos entre F8H y FFH
	; en los que se ha ingresado un dato diferente de FFH

	MVI C, 00H; el reg C es usado para contar y se inicia
	; en 00H

	IN F8H; hace una lectura del puerto XXH cuyo valor se
	; guarda en el reg A

	CPI FFH; compara el reg A con el valor FFH

	; Si A igual FFH, la bandera Z se pone en 1
	; Lo que indica que no hay mas caracteres en FIFO
	; Se deja de contar y se salta al final de la rutina
	; donde se almacena la informacion del contador
	JZ S_NUMBER_C_R

	; en caso contrario, se incrementa C
	INR C 

	;Se analiza el siguiente puerto
	
	; Nota: la descripcion de lo que se hizo con el
	; puerto F8H es analoga a lo que se hace con los
	; puertos  F9H, FAH, FBH, FCH, FDH, FEH y FFH
	; a continuacion

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

	; En este punto el reg C contiene la informacion
	; de cuantos caracteres hay en FIFO

	MOV A,C; el numero de caracteres en reg C se pasan al
	; regA
	STA 4800H;SE almacena reg A en la direccion 4800H
	; Creando la simulacion, pues seguidamente se llamara
	; a las rutinas que leen el status-word del FIFO del 8279
	
	RET

S_KEY_ENTRY: ; Simula la entrada de un caracter
	
	; El registro C es usado como puntero que indica
	; cual es el puerto que se debe leer
	; Donde el puerto simula la entrada de un caracter	

	INR C ; Se incrementa el registro C
	; Para posicionarse en el puerto que toca ya que se
	; esta simulando la lectura del FIFO del 8279, y en
	; consecuencia es una lectura secuencial

	MOV A,C; El valor del reg C se lleva al reg A
	; para poder hacer una comparacion directa

	CPI F8H; Si a igual F8H indica que el puntero C
	; esta apuntado al purto F8H y en consecuencia se
	; lee dicho puerto saltando a la rutina que realiza
	; esa accion que es IN_F8
	CZ IN_F8
	; Esta rutina (S_KEY_ENTRY) solo lee un puerto a la
	; vez, en consecuencia una vez se lee un puerto,
	; las subsiguientes comparaciones fallaran

	; En caso de que la comparacion falle, se sigue
	; comparando con los siguientes puertos

	; Nota: la descripcion de lo que se hizo con el
	; puerto F8H es analoga a lo que se hace con los
	; puertos  F9H, FAH, FBH, FCH, FDH, FEH y FFH
	; a continuacion

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
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H

	;Nota: La razon por la que se almacena en la direccion
	; de memoria 4800H, es porque esto es una simulacion
	; de la entrada de un caracter, y el monitor seguidamente
	; a esta rutina leera el caracter en la direcion 4800H
	RET
IN_F9:
	IN F9H; Lee un dato por el puerto F9H
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FA:
	IN FAH; Lee un dato por el puerto FAH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FB:
	IN FBH; Lee un dato por el puerto FBH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FC:
	IN FCH; Lee un dato por el puerto FCH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FD:
	IN FDH; Lee un dato por el puerto FDH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FE:
	IN FEH; Lee un dato por el puerto FEH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
IN_FF:
	IN FFH; Lee un dato por el puerto FFH
	;Se almacena en el reg A
	STA 4800H; Almacena el dato en reg A, en la direccion
	; 4800H
	RET
;--------- Termina INPUT------------


;---------- Empieza SAVE_RATE ----------
SAVE_RATE: ;save rate
    LXI B,188CH ;Carga la primera posicion desde donde se comienzan a leer los digitos a guardar
    MVI A,05H ; Carga en A 05H que es el numero de digitos que se guardaran(con digitos se incluye el ".")
    STA 181EH ; Guarda en la posicion 181EH el contador de digitos que me indica si ya los copie todos en la tabla o no. 
    LDA 181FH ; Carga en A el contenido de parte de la posicion donde comenzara a guardarse la tabla
    MOV D,A   ; Mueve la parte de la posicion a D
LOOP_SAVE_RATE:
    LDA 1820H ; Carga la segunda parte de la posicion donde sera guardada la tabla 
    MOV E,A   ; Mueve a E el contenido de A en este punto ya tengo la posicion donde iniciara la tabla( posteriormente se incrementara)
    LDAX B    ; Carga en el acumulador el contenido de la posicion que me la indica BC
    STAX D    ; Guarda el contenido de A en la posicion indicada por DE aqui se guarda lo que estaba en la posicion de memoria BC
    INR E     ; Se incrementa una posicion de la tabla
    MOV A,E   ; Se mueve el valor de E al acumulador para actualizar el valor de la tabla
    STA 1820H ; Actualiza el valor de la tabla
    INR C     ; Incrementa una posicion de el registro BC para obtener el siguiente digito
    LDA 181EH ; Se carga el contenido de la posicion 181EH en el acumulador( este es el contador)
    DCR A     ; Decremento en 1 el contador de los digitos
    STA 181EH ; Guardo el nuevo valor del contador
    CPI 00H   ; Comparo si el contador es igual a cero
    JNZ LOOP_SAVE_RATE ; Si el contador es diferente a cero salto a la etiqueta LOOP_SAVE_RATE para seguir guardando digitos
    RET
;--------- Termina SAVE_RATE------------

;--------- Empieza ADJUST ----------
ADJUST:
    LDA 1869H ; Carga el numero de elementos que hay en el display
    MOV B,A ; Mueve el numero de elementos en el display a B
    LDA 07FBH ; Carga el numero 1
    CMP B ; Compara si lo que esta en B es igual a 1
    JZ ONE_D
    LDA 07FCH ; Carga el numero 2
    CMP B ; Compara si lo que esta en B es igual a 2
    JZ TWO_D
    LDA 07FDH ; Carga el numero 3
    CMP B ; Compara si lo que esta en B es igual a 3
    JZ TWO_D
    LDA 07FEH ; Carga el numero 4
    CMP B ; Compara si lo que esta en B es igual a 4
    JZ FOUR_D
    LDA 07FFH ; Carga el numero 5 
    CMP B ; Compara si lo que esta en b es igual a 5
    JZ FIVE_D
ONE_D: ; Realiza el ajuste de los digitos decimales cuando un solo digito es ingresado EJM 1 se guarda como 01.00
    MVI A,00H
    STA 1890H
    STA 188FH
    MVI A,40H
    STA 188EH
    LDA 186AH
    STA 188DH
    MVI A,00H
    STA 188CH
    RET
TWO_D: ; Realiza el ajuste de los digitos decimales cuando dos y tres digitos son ingresados EJM 12 se guarda como 12.00
    MVI A,00H
    STA 1890H
    STA 188FH
    MVI A,40H
    STA 188EH
    LDA 186BH
    STA 188DH  
    LDA 186AH
    STA 188CH
    RET
FOUR_D: ; Realiza el ajuste de los digitos decimales cuando son ingresados 3 digitos EJM 23.1 se guarda como 23.10
    MVI A,00H
    STA 1890H
    LDA 186DH
    STA 188FH
    MVI A,40H
    STA 188EH
    LDA 186BH
    STA 188DH
    LDA 186AH
    STA 188CH
    RET
FIVE_D: ; En este caso no se realiza ajuste solo se guarda el numero completo para tenerlo en una direccion de memoria especifica
    LDA 186EH
    STA 1890H
    LDA 186DH
    STA 188FH
    MVI A,40H
    STA 188EH
    LDA 186BH
    STA 188DH
    LDA 186AH
    STA 188CH
    RET
;---------- Termina ADJUST----------


O_D:
	RET

;-----Parte del ADJUST
#ORG 07FBH ;Carga posiciones de memoria con digitos contiguos del 1 al 5 para verificar cuantos digitos han sido ingresados
#DB 01H,02H,03H,04H,05H

;-----Parte el SAVE_RATE
#ORG 181FH ;Referencia a la posicion donde se guardaran los digitos
#DB 18H,00H
