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




