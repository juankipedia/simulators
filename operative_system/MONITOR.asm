.ORG 0000H
JMP INIT_MAIN

.ORG 003CH
JMP KB_IN; sets 7 point 5 Interrupt Service Routine


.ORG 0040H
INIT_MAIN: ; inits interrupts and devices
	LXI SP, 1868H; sets stack pointer memory location 
	MVI A,04H; prepare the mask to enable 7 poitn 5 interrupt
	SIM; apply the settings RTS masks

;SET 8 8-bit character display -left entry and decoded scan keyboard n-Key Rollover
	LXI H, 6800H;  sets !CS - A14 to 0 to activate 8279 and A13 - C/D to 1 to send a command to the 8279
	MVI M, 03H; sets 000 [00] [011] that is the desire configuration

	
R_AND_S_T: ; read and save table
	CALL R_AND_S_T_R; calls read and save table routine


LOOP_MAIN: ; main loop
	CALL PROGRAM; calls main program
	JMP LOOP_MAIN

PROGRAM: ; main program routine
	;output result of the program
  	RET

R_AND_S_T_R: ; read and save table routine (reads edges of graph)
	MVI B, 00H; sets register B to 0 pointing to first exchange rate
A_INIT:	MVI A, 06H; sets register A with upper bound of B (n * n) - n
	CMP B; if B == 6
	JZ RET_R_AND_S_T_R; if B == 6 then jump to R_AND_S_T_R RET

	LXI H, 1822H; direction where register B will be saved before calling the function
	MOV M,B; save the register

	CALL R_EXCHANGE_RATE;

	LXI H, 1822H; load direction of register B in memory
	MOV B,M; restore register B

	INR B; B += 1
	JMP A_INIT;  jumps to if A = 6
RET_R_AND_S_T_R: 	RET

R_EXCHANGE_RATE: ; reads exchange rate pointed by register B
    CALL INPUT
    CALL ADJUST
    CALL SAVE_RATE
	; it calls 3 functions OUTPUT_DISPLAY(B), INPUT_RATE(B),  SAVE_RATE(B)
	RET

E_KEYBOARD: ;enables keyboard by EI, and waits until key is pressed
	EI; enables keyboard interrupts
LOOP_EK: 	JMP LOOP_EK; waits until keyboard interrupts 
E_KEYBOARD_RET:	RET

D_KEYBOARD:
	DI; disables keyboard interrupts
	RET

KB_IN: ;keyboard interrupt function
	POP H;
	JMP E_KEYBOARD_RET; jumps to E_KEYBOARD RET instruction

;---------- Empieza INPUT ----------
.ORG 01C3H
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

MULTIPLY:

    CALL PREPARE_MULT
    CALL MAIN_MULT
    CALL INITIAL_POINT
    CALL INIT_
        RET

PREPARE_MULT:
    LDA 1895H
    STA 189BH
    LDA 1894H
    STA 189CH
    LDA 1892H
    STA 189DH
    LDA 1891H
    STA 189EH

    LDA 189AH
    STA 189FH
    LDA 1899H
    STA 18A0H
    LDA 1897H
    STA 18A1H
    LDA 1896H
    STA 18A2H
    RET

MAIN_MULT: ;Indica que digitos se deben multiplicar.
        LDA 18A3H ; Primera parte de la Posicion del digito a multiplicar que esta dada x la direccion 18
        MOV B,A  ;B es 18
        LDA 18A4H ; Segunda parte de la posicion del digito a multiplicar (puede ser 00H,01H,02H,03H)
        MOV C,A ; C ahora tiene la segunda parte que me indica la posicion donde esta guardado el digito.
        LDAX B ; Carga la informacion de la posicion dada por el registro par BC primer digito a multiplicar
        STA 18D2H ; Guarda la informacion en la posicion 2505 dicha posicion es la del multiplicando
        LDA 18A5H ; Carga la informacion de la posicion 80H en este caso
        MOV D,A ; Mueve la primera parte de la posicion a D
        LDA 18A6H ; Carga la segunda parte de la posicion en el acumulador
        MOV E,A ; Mueve a E la segunda parte de la posicion del multiplicador
        LDAX D ; Carga en el acumulador el digito correspondiente al multiplicador
        STA 18D3H ; Guarda en la posicion dada el multiplicador
        INR C ; Incremento el registro C para obtener en el ciclo siguiente el numero a multiplicar
        MOV A,C ; Muevo la posicion incrementada del multiplicando
        STA 18A4H ; Guardo la nueva posicion del muktiplicando
        ;HLT ; Salta a la rutina de multiplicar
        JMP START 
START:
	    LHLD 18D2H ; Se carga a H y L con cada digito
	    MOV B,H ; Se mueve el digito de H a B 
	    MVI A,00H ; Se coloca el acumulador en cero
	    CMP B ; Se compara si B es cero 
	    JZ ASSIGN ; Si B es cero se realiza de una vez la asignacion
	    MOV C,L ; Se mueve el digito de L a C
	    CMP C ; Se compara si C es cero
	    JZ ASSIGN ; Si C es cero se asigna de una vez el valor
	    MOV A,L ; Se mueve el digito de L al acumulador
LOOP:
	    DCR B ; Se decrementa B en uno
	    JZ ASSIGN ; si B ya es cero se asigna el valor
	    ADD L ; Se Suma L + L
	    DAA ; Se hace un ajuste decimal 
	    JMP LOOP ; Se llama de nuevo a la etiqueta loop 
ASSIGN: ; Hasta aqui calula el valor de la multiplicacion que esta guardado en un registro, se guarda con este 
;formato por ejemplo el numero 81.
	    STA 18D4H ; Guarda el valor calculado en la posicion    
        MVI L,01H
        LDA 18D4H
        STA 18CDH
	    JMP START_S
MAIN:
	    DCR L ; Decrementa el registro L para hacer el segundo salto a la etiqueta START_S
	    JZ START_S ; comienza a realizar el calculo de los digitos
        JMP OPER_M
        RET
	    ;HLT ; Se detiene una vez calculados los dos digitos
START_S:
	    LDA 18CDH ; Carga el numero que esta gardado en esa direccion al acumulador 
	    MVI B, 04H ; Se coloca en 4 par contar cantidad de bits desplazados
	    MVI C, 00H; En este registro se guardara el resultado
	    MVI H,00H; Se usa como auxiliar para ir guardadndo el resultado actual de A
	    LXI D,18D1H ; Posiciones donde estan guardados los valores de cada bit recorrido
	;JMP GETNUM 
GETNUM: ; Mueve los bits hacia la izquierda verificando si alguno es 1
	    RLC ; Mueve a la izquierda un bit
	    JC SUM_NEW ; Si hay un bit que no es cero salto a SUM
	    DCX D ; Decremento el valor de la tabla de bits
	    DCR B ; Decremento el valor de los bits recorridos
	    JNZ GETNUM ; Si B aun no es cero salto a GETNUM
	    MOV H,A ; Guardo el ultimo valor en H
	    JMP ASSIGN_VALUE ; Salto para asignar el valor ya calculado

SUM_NEW:	; Suma el valor correspondiente al digito en caso de que sea 1
	    MOV H,A ;cargoo el valor actual de A en H
	    LDAX D ; Cargo el valor del bit en A
	    ADD C ; Sumo el valor del bit con el resultado hasta ahora
	    MOV C,A ; Cargoo el valor de la suma en C 
	    MOV A,H ; Cargo el valor obtenido al desplazar el bit
	    DCX D ; Decremento el valor de la tabla de bits
	    DCR B ; Decremento  el valor de los bits recorrido
	    JNZ GETNUM ; Si aun no he recorrido todos los bit regreso a getnum
	    JMP ASSIGN_VALUE ; SI ya recorrio todos los bits asigno valor 
ASSIGN_VALUE:
        LDA 18A9H ; Carga el contenido de 18A9H en A esta es la primera parte de la direccion
        MOV D,A ; Primera parte de la posicion donde sera guardado el digito obtenido.
        LDA 18AAH ; Carga el contenido de 18AAH en A esta es la segunda parte de la direccion
        MOV E,A ; Segunda parte de la posicion donde sera guardado el digito obtenido.
        MOV A,C ; Carga en A el resultado que se encuenta en C
	    STAX D ; Guarda el resultado en la posicion de memoria dada por DE 400XH
	    MOV A,H ; Carga en A el valor actual obtenido de desplazar los digitos, 
		;es decir el valor necesario para separar el siguiente digito
	    STA 18CDH ; Guarda en la posicion dada el nuevo numero obtenido de desplazar los digitos
        LDA 18AAH ; Carga la segunda parte de la posicion donde se guardara el digito para incrementarla
        INR A ; Incrementa la posicion en 1
        MOV E,A
        STA 18AAH ; Incrementa la posicion donde se guardara para que en el siguiente ciclo se guarde en la posicion sgte.
        ;STAX D
	    JMP MAIN;Salto a la etiqueta main para separar siguiente digito
OPER_M: ; Realiza un retorno para multiplicar los digitos que correspondan.
        LDA 18A8H ; Contador de multiplicador
        DCR A ; Decrementa el valor en 1
        CPI 00H ; Compara si ya llego a cero
        STA 18A8H ; Guarda el nuevo valor 
        JNZ MAIN_MULT ; Si no es cero salta a MAIN_MULT
		MVI A,04H 
		STA 18A8H ; Coloca nuevamente en 4 el valor del Contador
		MVI A,9BH
		STA 18A4H ; Coloca en la posicion cero la referencia del multiplicando
		LDA 18A6H ; Toma el valor de referencia de la posicion donde estara el multiplicador
		ADI 01H 
		STA 18A6H ; Aumenta en 1 la referencia de la posicion del multiplicador
		LDA 18A7H ; Carga el valor del contador del multiplicando 
		DCR A
		CPI 00H
		STA 18A7H ; Decrementa el valor del multiplicando.
		JNZ MAIN_MULT
        RET

INITIAL_POINT:
    MVI A,03H
    STA 18A2H ;Referencia al numero que sigue luego de separar

START_POINT:
    MVI A,00H
    MVI B,00H
    MVI C,00H
    MVI D,00H
    MVI E,00H
    MVI H,00H
    MVI L,00H

LHLD 18D5H ;Carga la referencia donde estan los digitos en memoria
INR L    ;Incrementa en uno la posicion LSB para leer el primer digito 
MOV A,M  ;Mueve al acumulador el contenido de la primera posicion 
LHLD 18D7H ;Carga la referencia que contiene la posicion donde voy a comenzar a guardar
MOV M,A  ;Guarda en memoria el primer elemeto del digito

INIT:
    LHLD 18D5H;Carga la referencia donde estan los digitos en memoria
    MOV B,M   ;Carga el el registro B 
    MVI A,03H ;Carga en el registro la cantidad de desplazamientos que se haran para obtener el digito correcto
    ADD L     ;Se le suma 3 al registro L para obtener la posicin del digito correcta
    MOV L,A   ;Se mueve la posicion hasta la posicion requerida en este caso son 3 posiciones mas adelante.
    MOV A,M   ;Carga el contenido de la posicion desplazada en A
    ADD B     ;Suma lo que estaba en la posicion de memoria anterior con la posicion desplazada.INIT
    DAA       ;Convierte el hexadecimal a decimal
    ADD C     ;Aqui estara el acarreo en el primer recorrido es cero
    DAA       ;Convierte el hexadecimal a decimal
    MVI H,07H ;Carga en el registro H la primera parte de la posicion donde esta el auxiliar para conversion de bits
    MVI L,F3H ;Carga en el registro L la segunda parte de la posicion donde esta el auxiliar para conversion de bits
    MVI C,00H ;Se coloca el acarreo en cero para calcular el sgte sin problemas

    CALL SEPARATE;Luego de que realiza la suma separa los digitos donde uno de ellos sera el acarreo y el otro el digito que es parte del numero
    LHLD 18D7H   ;Carga en HL la referencia a la posicion donde se esta guardando el numero.
    INR L        ;Se incrementa en uno la posicion
    MOV A,L      ;Mueve la referencia incrementada
    STA 18D7H    ;Guarda la nueva posicion de referencia
    MOV M,D      ;Guarda el contenido calculado en la nueva referencia
    MVI D,00H    ;Coloca el D en cero para calcular el digito otra vez en la siguiente iteracion 
    LHLD 18D5H   ;Carga la referencia de la posicion donde esta el numero en tabla
    INR L        ;Incremento la posicion de la tabla
    INR L        ;Incremento la posicion de la tabla
    MOV A,L      ;Carga la posicion incrementada en L
    STA 18D5H    ;Guarda la nueva referencia que apunta a la direccion de la tabla
    LDA 18FEH    ;Carga el contador -- Esta posicion debe cambiar-- Fuera de rango
    DCR A        ;Decrementa en uno el contador
    STA 18FEH    ;Guarda el nuevo valor del contador
    JP INIT      ;Si aun no es cero Salta a INIT de nuevo

    ; Aqui calcula el ultimo digito
    LHLD 18D5H   ;Carga la referencia donde estan los digitos en memoria
    MOV A,M      ;Carga en A lo que esta en las posiciones referenciadas por la memoria
    ADD C        ;Se le suma el acarreo
    LHLD 18D7H   ;Carga la posicion donde se ha guardado
    INR L        ;Se incrementa en uno la posicion donde se esta guardando
    MOV M,A      ;Mueve el resultado de sumar el digito guardado en el acumulador con C y lo guarda en la posicion de memoria

    ;Aqui se arreglan las posiciones para realizar otra iteracion
    LHLD 18D5H  ;Carga la referencia donde estan los digitos en memoria
    INR L       ;Incrementa la posicion
    INR L       ;Incrementa la posicion
    MOV A,L     ;Mueve al acumulador la parte incrementada de la posicion
    STA 18D5H   ;Guarda la nueva referencia a la posicion
    LHLD 18D7H  ;Referencia a la posicion donde se van guardando los digitos
    INR L       ;Incremento la posicion
    INR L       ;Incremento la posicion
    MOV A,L     ;Mueve al acumulador la parte incrementada de la posicion
    STA 18D7H   ;Guarda la nueva referencia a la posicion
    MVI A,02H   ;Acumulador se coloca con 2
    STA 18FEH   ;Se reinicia el contador a 2
    LDA 18FFH   ;Se carga el contenido del contador externo
    DCR A       ;Se decrementa el contador externo
    STA 18FFH   ;Se guarda el contador decrementado
    JP START_POINT;Si el contador es mayor-igual a cero salta a START_POINT
    MVI A,03H     ;Si el contador es menor a cero se coloca 3 en el acumulador
    STA 18FFH     ;Se inicializa de nuevo el contador externo
    RET         ;Retorna Proceso termino.

SEPARATE:
    RLC
    JC IS_NOT_ZERO
    JMP IS_ZERO

IS_NOT_ZERO:
    MOV E,A
    MOV A,M
    ADD D
    DAA
    MOV D,A
    DCR L
    LDA 18A2H
    DCR A
    STA 18A2H
    MOV A,E
    JM SECOND_DIGIT
    JMP SEPARATE

IS_ZERO:
    MOV E,A
    DCR L
    LDA 18A2H
    DCR A
    STA 18A2H
    MOV A,E
    JM SECOND_DIGIT
    JMP SEPARATE

SECOND_DIGIT:
    MVI H,18H
    MVI L,F9H
    MOV B,M
    DCR B
    JM DONE
    MOV M,B
    MOV C,D
    MVI D,00H
    MVI H,07H
    MVI L,F3H
    MVI A,03H
    STA 18A2H
    MOV A,E
    JMP SEPARATE
DONE:
    MVI A,01H
    STA 18F9H
    MVI A,03H
    STA 18A2H
    RET

INIT_:	
	XRA A ;LIMPIAR ACUMULADOR
	LXI H,18ABH ;POSICION INICIAL DE DONDE SE GUARDA EL RESULTADO (9070H-9077H)
	LXI D,189BH ;POSICION AUXILIAR PARA GUARDAR LOS CARRY GENERADOS POR LAS OPERACIONES PARA CADA NUMERO
A0: ;A0 = 18D9H
	LDA 18D9H ;CARGAR PRIMER NUMERO AL ACUMULADOR
	MOV M,A ;GUARDAR EN MEMORIA
	INR L ;AUMENTAR POSICION DEL REGISTRO PAR HL
A1:  ;A1 = 18DAH + 18DEH   SE GENERA UN CARRY: C1
	LDA 18DAH ;CARGAR VALOR AL ACUMULADOR, ESTE NUMERO ES NECESARIO PARA CALCULAR EL DIGITO A1
	MOV M,A ;MOVER A MEMORIA
	LDA 18DEH ;CARGAR VALOR AL ACUMULADOR
	ADD M ;SUMAR ACUMULADOR CON EL CONTENIDO DE LA MEMORIA
	DAA     ;AJUSTE DECIMAL		
	MOV M,A      ;MOVER EL ACUMULADOR A MEMORIA
	MVI B,02H ; VALOR PARA COMPARAR EN SP2, SI B == 02 -> JMP A2, SI B == 03 -> JMP A3
	JMP SP2  ;SEPARAR LOS BITS DEL RESULTADO
	                 ; 9000H -> 30H
	                 ; 9001H -> 00H
	                 ; 9002H -> 03H <= CARRY
SP2:	;SEPARAR EN BITS
	MOV A,M ; MOVER CONTENIDO DEL REGISTRO M AL ACUMULADOR
	ANI 0FH ; EJECUTAR OPERACION AND CON EL ACUMULADOR PARA SEPARAR EL BYTE, DE AQUI SE OBTIENE LA PARTE DERECHA DEL NUMERO
            ; POR EJEMPLO, SI SE TIENE 52H EN EL ACUMULADOR, EJECUTANDO ESTA OPERACION SE OBTIENE 02H
	MOV C,M ; RESPALDAR VALOR ACTUAL DEL REGISTRO M EN EL REGISTRO C
	MOV M,A ; MOVER CONTENIDO DEL ACUMULADOR A MEMORIA 
	;STAX D  ;
	XCHG ; INTERCAMBIAR HL POR DE, CON ESTO SE GUARDARA EN LA DIRECCION ASIGNADA AL RESULTADO
	STAX D ; GUARDAR ACUMULADOR EN EL ESPACIO DE DIRECCIONES ASIGNADAS AL RESULTADO
	XCHG ; INTERCAMBIAR HL POR DE, VOLVER A ESTABLECER LOS REGISTROS PARES COMO ESTABAN
	MOV A,C ; MOVER CONTENIDO DEL REGISTRO C, QUE ES EL CONTENIDO QUE TENIA LA MEMORIA UN PAR DE INSTRUCCIONES ANTES, AL ACUMULADOR
	ANI F0H ; EJECUTAR OPERACION AND CON EL ACUMULADOR PARA SEPARAR EL BYTE, DE AQUI SE OBTIENE LA PARTE IZQUIERDA DEL NUMERO
            ; POR EJEMPLO, SI SE TIENE 52H EN EL ACUMULADOR, EJECUTANDO ESTA OPERACION SE OBTIENE 50H
	RRC ;ROTAR ACUMULADOR A LA DERECHA
	RRC ;ROTAR ACUMULADOR A LA DERECHA
	RRC ;ROTAR ACUMULADOR A LA DERECHA
	RRC ;ROTAR ACUMULADOR A LA DERECHA, CON ESTA ULTIMA ROTACION SE OBTIENE EL CARRY
	INR E ; INCREMENTAR LA DIRECCION A LA QUE APUNTA EL REGISTRO DE PARA GUARDAR EN MEMORIA
	STAX D ;GUARDAR CARRY EN LA MEMORIA, EN LA DIRECCION A LA QUE APUNTA EL REGISTRO PAR DE, QUE ES LA ASGINADA PARA EL RESULTADO
	INR L ; INCREMENTAR LA DIRECCION A LA QUE APUNTA EL REGISTRO HL
	LDA 07F4H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B ;SI B == 02H ENTONCES SALTA A A2
	JZ A2
	LDA 07F5H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B ;SI B == 03H ENTONCES SALTA A A3 
	JZ A3	
	LDA 07F6H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B  ;SI B == 04H ENTONCES SALTA A A4
	JZ A4	
	LDA 07F7H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B  ;SI B == 05H ENTONCES SALTA A A5
	JZ A5
	LDA 07F8H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B  ;SI B == 06H ENTONCES SALTA A A6
	JZ A6
	LDA 07F9H ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B  ;SI B == 07H ENTONCES SALTA A A7
	JZ A7
	LDA 07FAH ; CARGAR EL VALOR AUXILIAR PARA COMPARAR CON B
	CMP B  ;SI B == 08H ENTONCES SALTA A A
	JZ APROX ; SALTAR A SUBRUTINA QUE APROXIMA EL RESULTADO POR TRUNCAMIENTO				
A2:	; A2 = 18DBH + 18DFH + 18E3H + CARRY_A1
    LDA 18DBH ;CARGAR NUMERO AL ACUMULADOR
	MOV M,A ; MOVER EL ACUMULADOR A MEMORIA
	LDA 18DFH ; CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A ; MOVER RESULTADO AL REGISTRO M 
	LDA 18E3H ; CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M  
	ADD M ; SUMAR CARRY
	DAA ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
	MVI B, 03H ; CONDICION PARA SALTAR A A3, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
A3:	; A3 = 18DCH + 18E0H + 18E4H + 18E8H + CARRY_A2
    LDA 18DCH ;CARGAR NUMERO AL ACUMULADOR
	MOV M,A ; MOVER EL ACUMULADOR A MEMORIA
	LDA 18E0H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	LDA 18E4H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	LDA 18E8H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M  
	ADD M ; SUMAR CARRY
	DAA ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
	MVI B, 04H   ; CONDICION PARA SALTAR A A4, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
A4:	; A4 = 18DDH + 18E1H + 18E5H + 18E9H + CARRY_A3
    LDA 18DDH ;CARGAR NUMERO AL ACUMULADOR
	MOV M,A ; MOVER EL ACUMULADOR A MEMORIA
	LDA 18E1H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA  ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	LDA 18E5H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA  ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	LDA 18E9H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA  ; AJUSTE DECIMAL
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M  
	ADD M ; SUMAR CARRY
	DAA  ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
	MVI B, 05H ; CONDICION PARA SALTAR A A5, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
A5:	; A5 = 18E2H + 18E6H + 18EAH + CARRY_A4
    LDA 18E2H ;CARGAR NUMERO AL ACUMULADOR
	MOV M,A ; MOVER EL ACUMULADOR A MEMORIA
	LDA 18E6H ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	LDA 18EAH ;CARGAR NUMERO AL ACUMULADOR
	ADD M ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M  
	ADD M ; SUMAR CARRY
	DAA ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
    MVI B, 06H ; CONDICION PARA SALTAR A A6, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
A6: ; A6 = 18E7H + 18EBH + CARRY_A5
    LDA 18E7H ;CARGAR NUMERO AL ACUMULADOR
	MOV M,A ; MOVER EL ACUMULADOR A MEMORIA
	LDA 18EBH ;CARGAR NUMERO AL ACUMULADOR
	ADD M  ; SUMAR LO QUE ESTA EN MEMORIA CON EL ACUMULADOR
	DAA ; AJUSTE DECIMAL
	MOV M,A  ; MOVER RESULTADO AL REGISTRO M 
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M  
	ADD M ; SUMAR CARRY
	DAA ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
	MVI B, 07H ; CONDICION PARA SALTAR A A7, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
A7: ; A7 = 18ECH + CARRY_A6
    LDA 18ECH ; CARGAR NUMERO AL ACUMULADOR
	XCHG ; INTERCAMBIAR HL POR DE, EL REGISTRO DE APUNTA A LA DIRECCION DONDE SE ENCUENTRA EL CARRY DE LA OPERACION ANTERIOR, ESTE VALOR SE CARGAR AL REGISTRO M   
	ADD M ; SUMAR CARRY 
	DAA ; AJUSTE DECIMAL
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MOV M,A ; MOVER EL RESULTADO AL REGISTRO M 
	MVI B, 08H ; CONDICION PARA SALTAR A APROX, EXPLICADA ANTERIORMENTE EN SP2
	JMP SP2
APROX:
	MVI A,00H ; PARA COMPARAR CON B
	MVI B,04H ; CONDICION DE PARADA PARA LA PARTE ENTERA, SI SE LEEN CUATRO NUMEROS, SALTAR A TRUNC
	LXI H,18B3H ; DIRECCION PARA LEER RESULTADO ANTERIOR Y ACOMODARLO. VA HACIA ARRIBA
	LXI D,1874H ;DIRECCION DONDE VA EL RESULTADO
	MVI C, 00H ; CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
	JMP ZER
ZER: ;SUBRUTINA PARA AJUSTAR EL RESULTADO, SI HAY CEROS ANTES DE ALGUN NUMERO ESTOS NO SE GUARDAN EN LA DIRECCION ASIGNADA AL RESULTADO
    CMP B ; CONDICION DE PARADA PARA LA PARTE ENTERA
    JZ TRUNC 
    DCR L ;DECREMENTAR EL REGISTRO PAR HL PARA LEER EL PRIMER NUMERO
    DCR B ; DECREMENTAR B, YA SE LEYO UN NUMERO
    CMP M ; SI LO QUE ESTA EN M ES CERO, NO SE GUARDA EN EL RESULTADO Y SE SALTA A ZER
    JZ ZER
    MOV A,M ; SI LO QUE ESTA EN M NO ES CERO, ENTONCES SE GUARDA SU CONTENIDO EN EL ACUMULADOR Y SE ESCRIBE EN MEMORIA
	XCHG  ; INTERCAMBIAR REGISTROS HL POR DE, PARA GUARDAR EN MEMORIA
	MOV M,A ; ESCRIBIR EN MEMORIA
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
    MVI A,00H ; SE CARGA EN A 00 PARA LA CONDICION DE PARADA PARA LA PARTE ENTERA 
    INR E ;INCREMENTA EL REGISTRO E
    INR C ;INCREMENTA CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
    JMP INTE
INTE:   
	CMP B ;CONDICION DE PARADA PARA LA PARTE ENTERA
	JZ TRUNC
	DCR L ;DECREMENTA EL REGISTRO L PARA LEER EL PROXIMO NUMERO
	DCR B ; DECREMENTO PARA LA CONDICION
	MOV A,M ;MOVER LO QUE ESTA EN EL REGISTRO M AL ACUMULADOR
	XCHG ;
	MOV M,A ; GUARDAR EN MEMORIA
	XCHG ; REESTABLECER REGISTROS PARES HL Y DE
	MVI A,00H ; SE CARGA EN A 00 PARA LA CONDICION DE PARADA PARA LA PARTE ENTERA 
    INR C ; INCREMENTAR CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
	INR E  ;INCREMENTA EL REGISTRO E
	JMP INTE	; VUELVE A LEER HASTA TERMINAR CON LA PARTE ENTERA, ES DECIR QUE B = 4
TRUNC:
	MVI A,40H ; MUEVE 40H AL ACUMULADOR, VALOR QUE REPRESNTA EL PUNTO
	STAX D ; GUARDA EN MEMORIA EL VALOR DEL ACUMULADOR
	INR E ; INCREMENTA EL REGISTRO E PARA GUARDAR EN LA SIGUIENTE DIRECCION
	LDA 18AEH ; CARGA EL PRIMERO NUMERO DE LA PARTE DECIMAL		 
	STAX D ; GUARDA EN MEMORIA EL CONTENIDO DEL ACUMULADOR
	INR E  ; INCREMENTA EL REGISTRO E PARA GUARDAR EN LA SIGUIENTE DIRECCION
	LDA 18ADH ; CARGA EL SEGUNDO NUMERO DE LA PARTE DECIMAL	
	STAX D ; GUARDA EN MEMORIA EL CONTENIDO DEL ACUMULADOR
	INR C  ; INCREMENTAR CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
    INR C  ; INCREMENTAR CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
	INR C    ; INCREMENTAR CANTIDAD DE CARACTERES QUE CONFORMAN EL RESULTADO
	MOV A,C ; MOVER AL ACUMULADOR EL VALOR DE C
	STA 1873H ; GUARDAR EN MEMORIA EL VALOR DEL ACUMULADOR
	RET

;------- Parte del MainMult -------
;Guarda la posicion donde se tendra la direccion donde estara el digito que se multiplicara
.DATA 18A3H
DB 18,9BH,18H,9FH

.DATA 18A7H ;Contadores del multiplicando y multiplicador respectivamente
DB 04H,04H

;Direccion donde sera guardado el resulta de la multiplicacion separado en digitos
.DATA 18A9H
DB 18H,ABH

;Tabla auxiliar para la conversion de binario a decimal
.DATA 18CDH
DB 00H,01H,02H,04H,08H


;------- Parte del DigitsMult --------
.DATA 18D5H   ;Posicion que referencia a una posicion de la tabla 
DB ABH,18H

.DATA 18D7H ;Referencia a la posicion donde se van guardando
DB D9H,18H

.DATA 07F0H ;Auxiliar para separacion esto va en ROM
DB 01H,02H,04H,08H

.DATA 18F9H ;Contador para separar
DB 01H

.DATA 18FEH 
DB 02H,03H ;Contador interno, Contador externo


.DATA 07F4H
DB 02H, 03H, 04H, 05H, 06H, 07H, 08H

;-----Parte del ADJUST
.DATA 07FBH ;Carga posiciones de memoria con digitos contiguos del 1 al 5 para verificar cuantos digitos han sido ingresados
DB 01H,02H,03H,04H,05H

;-----Parte el SAVE_RATE
.DATA 181FH ;Referencia a la posicion donde se guardaran los digitos
DB 18H,00H