.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A UPPER CASE LETTER: $'
    MSG2 DB CR, LF, 'The previous lowercase letter is : $'   
    MSG3 DB CR, LF, 'The ones complement is : $'
    x DB ? 
    y db ?

.CODE
main proc
    ;initialize
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input     
    MOV AH, 1
    INT 21H
    MOV x, AL
     
    
;output the previous lowercase letter
    mov y,al
    ADD y, 20h
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    MOV AH,2
    sub y,1
    MOV DL,y
    INT 21H
    
;output one's complement
    mov bl,x
    neg bl
    add bl,0ffh
    mov y,bl
    LEA DX, MSG3
    MOV AH, 9
    INT 21H 
    MOV AH,2
    MOV DL,y
    INT 21H
    
     
    

;exit
    MOV AH, 4CH
    INT 21H
          
       

main endp 
end main 