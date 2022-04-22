.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32
.global productoEscalar16
.global productoEscalar12
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max
.global asm_downsampleM
.global asm_invertir


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud
@
@ Valor de retorno:
@   r0: un vector con tambaño = longitud y todos sus valores en cero
@
.thumb_func
    asm_zeros:
        mov 	r2, 0  @mover el valor cero al registro r2
    .asm_zeros_for:
        str 	r2, [r0], 4 @mover r2 a la dirección de memoria del registro r0 *r0 = r2, e incrementarel puntero en 4 = 1 dirección cada 4 bits
        subs 	r1, 1  @restar 1 a longitud y cuando llegue a cero actualizar bits N y Z
        bne  	.asm_zeros_for
        bx 		lr       @ vuelve adonde fue llamada (especificamente, )



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
@
@ Parametros recibidos:
@   r0: * vector de entrada con elementos de 32 bits (4 bytes)
@   r1: * vector de salida con elementos de 32 bits (4 bytes)
@	r2: longitud del vector
@	r3: escalar a multiplicar

@ Parametros internos:
@	r5: registro que servirá como almacenamiento intermedio para cargar las operaciones de multiplicación elemento del vector de entrada
@	r6: registro que servirá como almacenamiento intermedio para cargar la dirección del vector entrada
@
@
@ Valor de retorno:
@   r1: un vector ampliado por el escalar
@
.thumb_func
    asm_productoEscalar32:
        push	{r5, r6}  @cargar en el stack los registros r5 y r6 (crear un contexto)
    .asm_productoEscalar32_for:
        ldr		r6, [r0], 4 @cargar en r6 la dirección guardada en r0 (vector entrada) +4 bytes
        mul 	r5, r6, r3  @multiplicar r6 x r3 y guardar el resultado en r5
        str		r5, [r1], 4 @guardar el valor de r5 en r1 (vector de salida) en la posición +4 bytes

        subs 	r2, 1  @restar 1 a longitud y cuando llegue a cero actualizar bits N y Z
        bne  	.asm_productoEscalar32_for

        pop 	{r5, r6} @devolver los registros cargados en el stack a su valor inicial (cambio de contexto)
        bx 		lr       @ vuelve adonde fue llamada (especificamente, )

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: * vector de entrada con elementos de 16 bits (2 bytes)
@   r1: * vector de salida con elementos de 16 bits (2 bytes)
@	r2: longitud del vector
@	r3: escalar a multiplicar

@ Parametros internos:
@	r5: registro que servirá como almacenamiento intermedio para cargar las operaciones de multiplicación elemento del vector de entrada
@	r6: registro que servirá como almacenamiento intermedio para cargar la dirección del vector entrada
@
@ Valor de retorno:
@   r1: un vector ampliado por el escalar
@
.thumb_func
    asm_productoEscalar16:
        push	{r5, r6}  @cargar en el stack los registros r5 y r6 (crear un contexto)
    .asm_productoEscalar16_for:
        ldrh	r6, [r0], 2 @cargar en r6 la dirección guardada en r0 (vector entrada) +2 bytes
        mul 	r5, r6, r3  @multiplicar r6 x r3 y guardar el resultado en r5
        str		r5, [r1], 2 @guardar el valor de r5 en r1 (vector de salida) en la posición +2 bytes

        subs 	r2, 1  @restar 1 a longitud (r2) y cuando llegue a cero actualizar bits N y Z
        bne  	.asm_productoEscalar16_for

        pop 	{r5, r6} @devolver los registros cargados en el stack a su valor inicial (cambio de contexto)
        bx 		lr       @ vuelve adonde fue llamada (especificamente, )


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: * vector de entrada con elementos de 16 bits (2 bytes)
@   r1: * vector de salida con elementos de 16 bits (2 bytes)
@	r2: longitud del vector
@	r3: escalar a multiplicar

@ Parametros internos:
@	r5: registro que servirá como almacenamiento intermedio para cargar las operaciones de multiplicación elemento del vector de entrada
@	r6: registro que servirá como almacenamiento intermedio para cargar la dirección del vector entrada
@
@ Valor de retorno:
@   r1: un vector ampliado por el escalar, de tamño 12 bits y con saturación
@
.thumb_func
    asm_productoEscalar12:
        push	{r4, r6}  @cargar en el stack los registros r5 y r6 (crear un contexto)
        mov		r4, 4095
    .asm_productoEscalar12_for:
        ldrh	r6, [r0], 2 @cargar en r6 la dirección guardada en r0 (vector entrada) +2 bytes
        mul 	r5, r6, r3  @multiplicar r6 x r3 y guardar el resultado en r5
        subs	r5, r4		@resta 4095 a lo guardado en r5
        bmi		.guardar_valor @si el resultado anterior es negativo (r5 < 4095) entonces guarda r5 en el vector
		mov		r5, r4		@si el resultado anterior es positivo (r5 > 4095) entonces satura 12 bits y guarda en r5
    .guardar_valor:
        str		r5, [r1], 2 @guardar el valor de r5 en r1 (vector de salida) en la posición +2 bytes

        subs 	r2, 1  @restar 1 a longitud (r2) y cuando llegue a cero actualizar bits N y Z
        bne  	.asm_productoEscalar12_for

        pop 	{r5, r6} @devolver los registros cargados en el stack a su valor inicial (cambio de contexto)
        bx 		lr       @ vuelve adonde fue llamada (especificamente, )


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: *vectorIn
@   r1: *vectorOut
@   r2: longitud del vector
@

@ Parametros internos:
@	r3: acumula la suma de los valores dela ventana
@	r5: guarda temporalmente el valor del vector de entrada
@	r6: contador del for principal
@	r7: guarda el tamaño de la ventana
@	r8: guarda temporalemente los promedios calculados
@ 	r9: contador del for de la ventana
@	r10: registros temporales
@	r11: registros temporales
@
@
@ Valor de retorno:
@   r1: un vector ampliado por el escalar, de tamño 12 bits y con saturación
@

.thumb_func
    asm_filtroVentana10:
        push 	{r4-r11} 		@ cargar en el stack los registros r5 y r6 (crear un contexto)
        mov 	r5, r0			@ se carga vectorIn en r5
        mov 	r7, 10			@ r7 define el tamaño de la ventana
        mov 	r6, 0			@ r6 guarda las iteraciones del for principal (i)

    .asm_filtroVentana10_for:
        mov 	r3, 0			@ se limpia r3 en cada iteracion para vaciar la ventana
        mov 	r9, r6          @ r9 guarda las iteraciones del for de la ventana actualiza su valor en cada iteracion del for principal
        mov 	r5, r0			@ se carga el vectorIn en cada iteración

    .asm_filtroVentana10_ventanaFor:
       udiv 	r10, r9, r2		@ divide el numero de iteracion entre tamaño del vector y guarda en r10
       mul 		r11, r10, r2	@ multiplica lo anterior por el tamaño del vector
       sub 		r10, r9, r11	@ se hace el roll-over cuando se supera el tamaño del vector

       add 		r5, r0, r10, LSL 1     @ se incrementa en 1 la posición del vector
       add 		r9, 1                   @ se incrementa el contador del for de ventana

       ldrh 	r4, [r5]       	@ se carga el valor del VectorIn
       add 		r3, r4          @ se suma el valor anterior con el actual

       subs 	r7, 1			@ se decrementa el valor de la ventana en cada iteracion
       bne 		.asm_filtroVentana10_ventanaFor

       mov 		r7, 10			@ se carga nuevamente la ventana con 10 para el siguiente grupo de ciclos

       udiv 	r8, r3, r7      @ se saca el promedio de los valores acumulados
       strh 	r8, [r1], 2     @ se guarda en elpromedio en el vector de salida
       add 		r6,1            @ se incrementa el contador del for principal
       cmp 		r2, r6          @ se valida si llegó a al último elemento del vectorIn
       bne 		.asm_filtroVentana10_for

       pop 		{r4-r11}		@devolver los registros cargados en el stack a su valor inicial (cambio de contexto)
       bx 		lr				@ vuelve adonde fue llamada

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void pack32to16(int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector de entrada con elementos de 32 bits (4 bytes)
@   r1: * vector de salida con elementos de 16 bits (2 bytes)
@	r2: longitud del vector
@
@
@ Parametros internos:
@	r4: memoria temporal del empaquetamiento
@
@ Valor de retorno:
@   r1: vector con elementos de 16 bits, empaquetando 32 bits
@
.thumb_func
    asm_pack32to16:
        push 	{r4}
        mov 	r3, 0			@ se inicializa r3 en 0 para limpiar espurias
    .asm_pack32to16_for:
        ldr		r3, [r0], 4     @ se carga en r3 la posicion de r0 (vector entrada)
        mov		r4, r3, lsr 16 @ se guarda en r4 los 16 MSB
        strh 	r4, [r1], 2    	@ se guardan los 16 LSB de r4 en r1 (vector salida)
        subs 	r2, 1         	@ se resta 1 a r2 (longitud vector) y se actualizan los flags de estatus
        bne 	.asm_pack32to16_for @ salta si z != 0
        pop 	{r4}
        bx 		lr				@ vuelve adonde fue llamada





@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@  int32_t max(int32_t *vectorIn, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector de entrada con elementos de 32 bits (4 bytes)
@   r1: longitud del vector (numero de iteraciones)
@
@
@ Parametros internos:
@   r2: pivote de comparación
@   r3: posicion del maximo
@	r4: maximo temporal
@   r5: indice del vector y contador del for
@
@ Valor de retorno:
@   r0: la posición del elemento de mayor valor en el vector de entrada

.thumb_func
    asm_max:
        push 	{r4, r5}
        mov		r2, 0			@ se inicia el pivote en 0
        mov 	r3, 0           @ Posición inicial 0
        ldr 	r4, [r0]        @ se carga la posición 0 del vector de entrada en r4 como max temporal
        mov 	r5, 0           @ se inicia la posición en 0
    .asm_max_for:
        ldr 	r2, [r0], 4     @ se cargan las posiciones del vector entrada en r2 en cada iteracion
        cmp 	r2, r4          @ compara los valores y se actualizan los flags de STATUS
        bgt 	.greater_than	@ salta si r2 es mayor que r4
        b		.continue		@ salta a continue si r2 no es mayor
    .greater_than:
        mov 	r4, r2          @ se actualiza el maximo temporal con r2
        mov 	r3, r5          @ se carga el numero de la iteracion como el inidice del valor max actual
    .continue:
        add 	r5, 1           @ se incrementa la cuenta del for
        subs 	r1, 1          	@ se descuenta el numero de iteraciones
        bne 	.asm_max_for 	@ salta si no se han acabado las iteraciones
        mov 	r0, r3          @ cuando se recorre todo el vector carga en r0 el valor de la pos. del max
        pop 	{r4, r5}
        bx 		lr				@ vuelve adonde fue llamada

