.model small

.stack 100h

.data
CR EQU 0DH
LF EQU 0AH
    
MSG1 Db cr, 'Enter your password: $'    
MSG2 Db CR, LF,'Invalid Password $'      
MSG3 Db CR, LF,'Valid Password $' 
x db ?
y db ?
z db ?
.code
main proc 
;initialize
    MOV AX, @DATA
    MOV DS, AX 
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AH, 1
loop_:
    INT 21H 
chk_upper:
    cmp al,7Ah
    jg chk_char 
    cmp al,61h
    jl chk_lower
    mov x,1 
    jmp loop_

chk_lower:
    cmp al,5Ah
    jg chk_char 
    cmp al,41h
    jl chk_nmbr
    mov y,1 
    jmp loop_ 
chk_nmbr:
    cmp al,39h
    jg chk_char 
    cmp al,30h
    jl chk_char
    mov z,1 
    jmp loop_
    
    
chk_char:
    cmp al,7eh
    jg end_loop 
    cmp al,21h
    jl  end_loop 
    jmp loop_
invalid:
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    jmp exit
valid:
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    jmp exit
end_loop:
    cmp x,1
    jne invalid
    cmp y,1
    jne invalid
    cmp z,1
    jne invalid
    jmp valid
            
;exit 
exit:
    MOV AH, 4CH
    INT 21H  
main endp
end main