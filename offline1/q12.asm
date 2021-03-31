.model small 
.stack 100h

.data   
x dw 0h
y dw 0h
z dw 0h
CR EQU 0DH
LF EQU 0AH
MSG1 DB 'ENTER the value of x : $' 
MSG2 DB CR,LF, 'ENTER the value of y : $' 
MSG3 DB CR, LF, 'The output is : $'
.code  

main proc  
    mov ax,@data
    mov ds,ax
    
    
    
    ;1st input 
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    mov ah,1
    int 21h 
    sub al,48
    mov ah,0  
    mov x,ax
    ;sub x,48
    
    ;2nd input
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    mov ah,1
    int 21h
    sub al,48
    mov ah,0
    mov y,ax
    ;sub y,48
    
    ;working1 (x-2y)
     mov ax,x
     sub ax,y
     sub ax,y
     mov z,ax
     add z,48 
     ;output1
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dx,z
     int 21h 
     
     
     ;working 25-(x+y)
     mov ax,x
     add ax,y 
     neg ax
     mov bx,25
     add bx,ax
     add bh,48
     add bl,48
     ;output2
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dl,bl
     ;mov dl,bl
     int 21h 
     mov ah,2
     mov dl,bh
     ;mov dl,bl
     int 21h
    
    ;exit
    mov ah,4ch
    int 21h  
    
    
main endp   
end main