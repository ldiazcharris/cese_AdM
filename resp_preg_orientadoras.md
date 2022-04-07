# Respuesta a preguntas orientadoras

### Clase: Arquitectura de Mircroprocesadores

#### Curso de especialización en Sisteas Embebidos

### Preguntas:

1. **Describa brevemente las diferencias entre las familias de procesadores Cortex M0, M3 y  M4.**

    La diferencia básica entre las familias de microprocesadores Cortex M0, M3 y M4 son los componentes o recursos disponibles en su arquitectura. Los Cortex M0 son la arquitectura Cortex más sencilla y los cortex M4 va aumentando la complejidad y la cantidad de recursos disponibles. A continuación se listan algunas de las características que los diferencian:

    **Cortex M0:**

    - **SysticTimer:** opcional, depende del fabricante.
    - **MPU:** no implementada (pero es opcional en el Cortex M0+)
    - **CPU Cahé:** no implementada.
    - **Arquitectura de memoria:** Von Neumann.
    - **Arquitectura ARM:** ARMv6-M.

    **Cortex M3:**

    - **SysticTimer:** implementado.
    - **MPU:** opcional, depende del fabricante.
    - **CPU Cahé:** no implementada.
    - **Arquitectura de memoria:** Harvard.
    - **Arquitectura ARM:** ARMv7-M.

    **Cortex M4:**

    - **SysticTimer:** implementado.
    - **MPU:** opcional, depende del fabricante.
    - **CPU Cahé:** posible,  depende del fabricante.
    - **Arquitectura de memoria:** Harvard.
    - **Arquitectura ARM:** ARMv7E-M.

2. **¿Por qué se dice que el set de instrucciones Thumb permite mayor densidad de código? Explique**

3. **¿Qué entiende por arquitectura load-store? ¿Qué tipo de instrucciones no posee este tipo de arquitectura?**

    La arquitectura load-store literalmente significa cargar-guardar, indica que en los procesadores Cortex-M los datos deben cargarse desde la memoria, procesarse y luego volver a escribirse (guardarse) en la memoria utilizando instrucciones separadas. Por ejemplo, para incrementar un valor de datos almacenado en SRAM, el procesador necesita usar *una instrucción* para "cargar" (leer) los datos desde la SRAM y "cargarlos" (guardar) en un registro dentro del procesador, *una segunda* instrucción para incrementar el valor del registro y luego *una tercera* instrucción para volver a escribir el valor en la memoria.

4. **¿Cómo es el mapa de memoria de la familia?**


5. **¿Qué ventajas presenta el uso de los “shadowed pointers” del PSP y el MSP?**
    
    El término "shadowed pointer" se refiere a que se usan dos stak pointers (SP), uno para funciones de OS Kernel y manejadores de interrupciones (Main SP, MSP) y otro para las tareas que se ejecuten en las aplicaciones (Processor SP, PSP).
    
    Cuando se trabaja en aplicaciones de bare metal, el PSP se puede ignorar y se trabaja simplemente con el MSP. Pero,cuando se implementan soluciones que utilizan un RTOS o un OS Kernel, el uso del "shadowed pointer" es muy práctico, ya que permite separar los SP del modo thread priviligiado (OS Kernel) y del modo handler (excepciones) por un lado y los del modo thread usuario por otro lado. De esta forma, si llegase a fallar el PSP, el MSP seguiría funcionando.

    Cuando el procesador arranca lo hace utilizando el SP apuntando al MSP y  para cambiar de MSP a PSP se hace con un bit en el registro de control. En el stack se guardan todas las variables declaradas en una función (locales) y con ellas se puede acceder a funciones de interrupciones el SP.

6. **Describa los diferentes modos de privilegio y operación del Cortex M, sus relaciones y como se conmuta de uno al otro. Describa un ejemplo en el que se pasa del modo privilegiado a no priviligiado y nuevamente a privilegiado.**

    Los procesadores Cortex-M tiene dos niveles de privilegio que son:
    - **Modo privilegiado:** este modo permite el acceso a todas las áreas de memoria del sistema, sin restricción alguna. En este modo se permite escribir cualquier registro. Es tipico operar en este modo siempre que se usan aplicaciones del tipo bare metal. Ejemplo de esto sería, poder escribir en el registro de control.
    - **Modo no privilegiado:** en este modo la aplición tiene acceso limitado a los registros del sistema, y se le denegará el acceso siempre que intente a acceder a registros especiales como por ejemplo el registro de control. En aplicaciones que usan un OS kernel o un RTOS, el OS siempre corre en modo privilegiado y las tareas en modo no privilegiado (aunque esto puede ser modificado a través del OS).

    El cambio de modos de privilegio se hace a través del registro CONTROL, el cual solo puede accederse desde el modo privilegiado.

    Además, dos modos de operación:
    - **Modo Handler:** este modo es el que se usa para manejar todas las excepciones. En este modo, la aplicación funciona en modo privilegiado siempre.
    - **Modo Thread:** este modo es el que se usa cuando se ejecuta el código de aplicación normal y puede estar en modo privilegiado o en modo no privilegiado.

    Una vez se ha accedido a la CPU en desde el modo thread no priviligiado, no es posible volver a tomar el modo thread priviligiado. La única forma de cambiar a modo privilegiado es a través del modo Handler, el cual siempre tiene privilegios de acceso.

    Un ejemplo es pasar del modo privilegiado thread al no privilegiado thread (por decisión de la aplicación), luego al ocurrir una interrupción (NMI u otra) al modo Handler, en este modo modificar el registro CONTROL para luego al privilegiado thread.

7. **¿Qué se entiende por modelo de registros ortogonal? Dé un ejemplo**

    El modelo de registros ortogonal implica que cualquier operación de la ALU podrá usar como operador cualquier registro del micro y su salida (resultado de la operación) podrá guardarse también en cualquier registro. Cuando se realiza una operación de movimiento de registros, este movimiento puede hacerse des de un registro "a" hasta un registro "b".

8. **¿Qué ventajas presenta el uso de intrucciones de ejecución condicional (IT)? Dé un ejemplo**


9. **Describa brevemente las excepciones más prioritarias (reset, NMI, Hardfault).**
    **Reset:** es la excepción con mayor prioridad en el vector de interruciones y corresponde a las propias de la arquitectura ARM. Es decri, esta excepción está definida por la propia arquitectura. Esta excepción hace que el microcontrolador se reinicie incondicionalmente. 

    **NMI:** *Non-Maskable Interrupt*, esta excepción se puede generar desde un periférico o desde una fuente externa. Los periféricos que pueden causar una NMI son el Watch Dog Timer o el Brown-out Detector.

    **Hard Fault:** Maneja todas las fallas como excepciones, si el manejador de fallas de la fuente de falla indicada no está habilitado. Es decir, es el manejador de fallas por defecto. El Hard Fault Handler siempre está habilitado. Al igual que *reset* está definido por ARM. El *Hard Fault Status Register* permite monitorear las fuentes de fallas. A continuación, se detallan los flags que es posible monitorear:

   *DEBUGEVT:* Indica que el evento de depuración ocasionó una falla.

    *FORCED:* Indica una falla de bus, una falla de administración de memoria o una falla de uso.

    *VECTBL:* Indica que hay una falla en una operación del "vector fetch" (búsqueda de direcciones en el stack).

    *EXTERNAL:* indica que el evento de depuración es causado por una señal externa (la señal EDBGRQ es una entrada en el procesador, que normalmente se usa en el diseño de varios procesadores para la depuración sincronizada).

    *VCATCH:* indica que el evento de depuración es causado por un "vector catch" (mecanismo del debugger), una función programable que permite que el procesador se detenga automáticamente cuando ingresa cierto tipo de excepción del sistema, incluido el reinicio.

    *DWTTRAP:* Indica que el evento de depuración es causado por un punto de observación.

    *BKPT:* Indica que el evento de depuración es causado por un punto de interrupción.

    *HALTED:* Indica que el procesador se detuvo debido a una solicitud del depurador (incluido un solo paso).

10. **Describa las funciones principales de la pila. ¿Cómo resuelve la arquitectura el llamado a funciones y su retorno?**

11. **Describa la secuencia de reset del microprocesador.**

12. **¿Qué entiende por “core peripherals”? ¿Qué diferencia existe entre estos y el resto de los periféricos?**

13. **¿Cómo se implementan las prioridades de las interrupciones? Dé un ejemplo**

14. **¿Qué es el CMSIS? ¿Qué función cumple? ¿Quién lo provee? ¿Qué ventajas aporta?**

    MSIS es el acrónimo de "*Cortex Microcontroller Software Interface Standart*", la cual es una HAL que no depende del fabricante (es proporcionada por ARM). Esta HAL brinda soporte para:

        - El controlador de interrupciones del sistema (NVIC).
        - Control del Systic Timer.
        - Drivers genéricos para los diferentes periféricos.
        - Proporciona una API para la implementación de sitemas operativos en tiempo real.
        - Funciones de acceso especial para introducción de código ensamblador.
        - Define los registros estandar de la arquitectura ARM.
        - Entre otras.

15. **Cuando ocurre una interrupción, asumiendo que está habilitada ¿Cómo opera el microprocesador para atender a la subrutina correspondiente? Explique con un ejemplo**

16. **¿Cómo cambia la operación de stacking al utilizar la unidad de punto flotante?**

17. **Explique las características avanzadas de atención a interrupciones: tail chaining y late arrival.**

18. **¿Qué es el systick? ¿Por qué puede afirmarse que su implementación favorece la portabilidad de los sistemas operativos embebidos?**

     SysTick timer: A simple timer included inside the processor. This enables an embedded OS to be used on the wide range of Cortex-M micro-controllers available. Details of the SysTick timer are covered in section 9.5 of this book

19. **¿Qué funciones cumple la unidad de protección de memoria (MPU)?**

    La MPU permite que se puedan proteger contra accesos "peligrosos" las áreas de memoria de un microcontrolador. De esta manera, es posible evitar que determinadas áreas críticas sean accedidas por un sistema operativo o por el programador en tiempo de ejecución y proteger la integridad del sistema.

20. **¿Cuántas regiones pueden configurarse como máximo? ¿Qué ocurre en caso de haber  solapamientos de las regiones? ¿Qué ocurre con las zonas de memoria no cubiertas por las regiones definidas?**

21. **¿Para qué se suele utilizar la excepción PendSV? ¿Cómo se relaciona su uso con el resto de las excepciones? Dé un ejemplo.**

22. **¿Para qué se suele utilizar la excepción SVC? Expliquelo dentro de un marco de un sistema operativo embebido.**

### ISA

1. **¿Qué son los sufijos y para qué se los utiliza? Dé un ejemplo.**

2. **¿Para qué se utiliza el sufijo ‘s’? Dé un ejemplo.**

3. **¿Qué utilidad tiene la implementación de instrucciones de aritmética saturada? Dé un ejemplo con operaciones con datos de 8 bits.**

4. **Describa brevemente la interfaz entre assembler y C ¿Cómo se reciben los argumentos de las funciones? ¿Cómo se devuelve el resultado? ¿Qué registros deben guardarse en la pila antes de ser modificados?**

5. **¿Qué es una instrucción SIMD? ¿En qué se aplican y que ventajas reporta su uso? Dé un ejemplo.**