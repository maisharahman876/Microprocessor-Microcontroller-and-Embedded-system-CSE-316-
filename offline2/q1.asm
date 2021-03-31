.model small 

.stack 100h  

.data    
CR EQU 0DH
LF EQU 0AH
    
MSG1 Db cr, 'ENTER THE 1st NUMBER: $'    
MSG2 Db CR, LF,'ENTER THE 2nd NUMBER: $'
MSG3 Db CR, LF, 'ENTER THE 3rd NUMBER: $'  
MSG4 Db CR, LF, 'All the numbers are equal $'
MSG5 Db CR, LF, 'The second highest number is: $'
x db ?
y db ?
z db ?  
s db ?


main proc    
;initialize
    MOV AX, @DATA
    MOV DS, AX
    
;input x
    LEA DX, MSG1
    MOV AH, 9
    INT 21H    
    MOV AH, 1
    INT 21H
    MOV x, AL 
    sub x,48
    
;input y 
    LEA DX, MSG2
    MOV AH, 9
    INT 21H    
    MOV AH, 1
    INT 21H
    MOV y, AL 
    sub y,48
    
;input z
    LEA DX, MSG3
    MOV AH, 9
    INT 21H    
    MOV AH, 1
    INT 21H
    MOV z, AL 
    sub z,48
    
;condition checking 
    mov bh,x
    mov bl,y  
    mov cl,z
  ;checking if the 3 numbers are equal
    cmp bl,cl 
    jne if
    cmp bl,bh
    jne if3
    jmp end1 
    
if:
;checking if the 2 numbers are equal
    cmp cl,bh
    jne if2
    cmp cl,bl
    mov s,bl
    jg endall
    mov s,cl
    jmp endall 
if2:
;checking if the 2 numbers are equal
    cmp bl,bh
    jne elif
    cmp cl,bl
    mov s,bl
    jg endall
    mov s,cl
    jmp endall 
if3: 
;checking if the 2 numbers are equal
    cmp bh,bl
    mov s,bl
    jg endall
    mov s,bh
    jmp endall
        
elif: 
;finding 2nd largest number from 3 non equals
    cmp bh,bl
    jng elif1
    cmp bh,cl
    jng elif1
    cmp bl,cl
    mov s,bl
    jg endall 
    mov s,cl
    jmp endall
       
    
elif1: 
    cmp bl,cl
    jng elif2
    cmp bl,bh
    jng elif2
    cmp bh,cl
    mov s,bh
    jg endall 
    mov s,cl
    jmp endall
    
elif2:
    cmp cl,bl
    jng endall
    cmp cl,bh
    jng endall
    cmp bl,bh
    mov s,bl
    jg endall 
    mov s,bh
    jmp endall 
    
end1:
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    jmp exit

endall:
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
    MOV AH,2
    add s,48
    MOV DL,s
    INT 21H
    

;exit 
exit:
    MOV AH, 4CH
    INT 21H
    
    
main endp
end main