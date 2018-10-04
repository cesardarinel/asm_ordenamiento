; Autor: Cesar Darinel Ortiz
; Tarea: 3 laboratorio
; Fecha Entrega: 04/10/2018

.model small
.stack 256
.data
; ========================Variables declaradas aquí===============
letrero DB 'INSERTE UNA CADENA NO MAS DE 50 CARACTERES-->: $'
; texto a solicita la cadena
pedirvariable DB 'INSERTE LA VARIABLE A BUSCAR : $'
; texto insertar variable a buscar
text2 DB 'Y SE REPITE : $'              ; Cadena a desplegar
arregloConDatos db 51 dup (0)           ; buffer de lectura de cadena
pantalla db 80 dup (00)                 ; buffer del tamaño de la pantalla
variableBuscada db 1 dup (0)            ; la variable que estamos buscando
count db 1 dup (2)                      ; un contador
segundodigito db 1 dup (2)              ; segundo dígito para imprimir
.code
; ========================================================
inicio:
           mov ax,@data                 
           mov ds,ax                        
           mov es,ax                    ; set segment register
           and sp,not 3                 ; align stack to avoid AC fault
; ==================Código==================================

           mov ah,09                    ; Para mostrar en pantalla una cadena
           mov dx, offset letrero       ; posición de la cadena a montar
           int 21h                      ; llamó al sistema

           mov bx,00                    ; inicializar en cero
ciclodelectura:
           mov ah,01                    ; para lectura de teclado.
           int 21h                      ; llamada al SO
           
           cmp al,13                    ; verificar si se pulsa el Enter.
           je imprimoLetreroCaptura     ; saltamos a solicitar el caracter si presiona enter
           mov arregloConDatos[bx],al   ; copiar el carácter tomado en el buffer.
           cmp bx,50                    ; verificó si debo de salir.
           je imprimoLetreroCaptura     ; si escribimos más de 50 caracteres dejo de leer
           inc bx                       ; apuntó a la sgte. posición del buffer.
           jmp ciclodelectura           ; continuó leyendo

imprimoLetreroCaptura:
           mov ah,09                    ; Para mostrar en pantalla una cadena
           mov dx, offset pedirvariable ; posición de la cadena a montar
           int 21h                      ; llamada al sistema

           mov ah,01                    ; para lectura de teclado.
           int 21h                      ; llamada al SO
           mov variableBuscada,al       ; muevo lo que está en al al campariablebuscada

           mov bx,00                    ; inicializando cero
           mov count,00                 ; inicializando cero(posibles errores)
           mov al,variableBuscada       ; muevo a al para comparar
ciclodeconteo:
           cmp arregloConDatos[bx],al   ; comparar el monto con la variable a buscar
           jne nocuento                 ; si no son iguales no cuento
           inc count                    ; si son iguales incremento la variable
   nocuento:
           cmp bx,50                    ; verificó si debo de salir.
           je letreroFinal              ; salimos del ciclo y vamos al final
           inc bx                       ; apuntó a la sgte. posición del buffer.
           jmp ciclodeconteo            ; retornamos al ciclo


ordenaminetoBurbuja:
        cmp bx,50                        ; verificó si debo de salir.
        je inicioPantalla                ; cuando termino de ordenar presento los datos
        mov si,00                        ; inicializando cero
        inc bx                           ; apuntó a la sgte. posición del buffer.
ordenaminetoBurbujainterno:
        cmp si,50                        ;verificó si debo de salir. termine de ciclar
        jge ordenaminetoBurbuja          ;salto al ciclo anterior para ordenar.
        mov al,arregloConDatos[si]       ;paso los datos al registro, para poder usarlo 
        inc si                           ;incremento en uno el indicador 
        cmp arregloConDatos[si], al      ;coparo el guardado con el indicador mas uno [2][1]
        jle incrementaciclointerno       ;si el indicador es menor no hago calculos.
        mov ah, arregloConDatos[si]      ;paso el valor a un registro para no perderlo
        mov arregloConDatos[si],al       ;sustituyo el valor superior con el inferior 
        dec si                           ;regreso a decrementar el indicador para usarlo
        mov arregloConDatos[si],ah       ;sustituyo valor inferior con el superior
        inc si                           ;retorno el indicador a su valor inicial 
incrementaciclointerno:                  
        jmp ordenaminetoBurbujainterno   ;continuo al siguiente paso del ciclo

letreroFinal:
           mov al,count                 ; paso el monto a al para separarlos
           aam                          ;divide el resultado de una multiplicacion     
           ; separó el monto de al en dos y quedan en  (ah/al)
           mov count,ah                 ; muevo el monto de ah a la variable a presentar
           mov segundodigito,al         ; mover el monto de al a la variable a presentar

           mov ah,02                    ; para mostrar carácter
           mov dl,10                    ; imprimió el carácter de salto de línea
           int 21h                      ; llamada sistema

           mov ah,09                    ; Para mostrar en pantalla una cadena
           mov dx, offset text2         ; posición de la cadena a montar
           int 21h                      ; Llamada al sistema

           add count,48                 ; sumar 48 para que pase a la tabla ascii
           mov ah,02                    ; para mostrar carácter
           mov dl,count                 ; imprimió el carácter del primer dígito
           int 21h                      ; Llamada al sistema

           add segundodigito,48         ; sumar 48 para que pase a la tabla ascii
           mov ah,02                    ; para mostrar carácter
           mov dl,segundodigito         ; imprimió el carácter del segundo dígito
           int 21h                      ; Llamada a sistema

           mov ah,02                    ; para mostrar carácter
           mov dl,10                    ; imprimió el carácter de salto de línea
           int 21h                      ; llamada sistema
           
           mov bx,00                    ; inicializando cero
           mov di,00                    ; inicializando cero
           jmp ordenaminetoBurbuja
; ********************************************************************
inicioPantalla:
           cmp di,80
           je limpiopantalla
           mov pantalla[di],32
           inc di
           jmp inicioPantalla

pantallaBono:   
           cmp di,00
           je reinicia
           jmp next1
reinicia: 
           mov di,80
   next1:

           cmp bx,50
           je reinicia2
           jmp next2
reinicia2: 
           mov bx,00
   next2:
           mov ah,0Bh                    ; para lectura de teclado.
           int 21h                       ; llamada al SO
           cmp al,0ffh                   ; verificar si se pulsa el Enter.
           je Salir                      ; saltamos a solicitar el caracter si presiona enter
           mov si,00 
copiodataPantalla:
           mov al,arregloConDatos[bx]
           mov pantalla[di],al
           dec di
           inc bx 
           
           mov ah,09                    ; Para mostrar en pantalla una cadena
           mov dx, offset pantalla      ; posición de la cadena a montar
           int 21h                      ; llamada al sistema

limpiopantalla:
           mov dh, 23
           mov dl, 80
           mov bh, 0
           mov ah, 2                    ; 
           int 10h                      ; llamada al sistema 
           jmp pantallaBono    
Salir:            
; ========================================================
.exit
end inicio


















