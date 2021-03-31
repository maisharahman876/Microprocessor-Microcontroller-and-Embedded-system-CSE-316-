.model small 
.stack 100h

.data   
x db 0h
y db 0h
z db 0h
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
    mov x,al
    sub x,48
    
;2nd input
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    mov ah,1
    int 21h
    mov y,al
    sub y,48
    
;working1 (x-2y)
     mov ah,x
     sub ah,y
     sub ah,y
     mov z,ah
     add z,48 
     ;output1
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dl,z
     int 21h 
     
     
;working 25-(x+y)
     mov bl,x
     add bl,y 
     neg bl
     mov bh,25
     add bh,bl
     mov z,bh
     add z,48
     ;output2
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dl,z
     int 21h    
     
;working 2x-3y
     mov bl,x
     add bl,x 
     mov bh,y
     add bh,y
     add bh,y
     neg bh
     add bh,bl
     mov z,bh
     add z,48
     ;output3
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dl,z
     int 21h
             
             
;working y-x+1
     mov bl,y
     add bl,1 
    
     mov bh,x
     
     neg bh
     add bh,bl
     mov z,bh
     add z,48
     ;output4
     LEA DX, MSG3
     MOV AH, 9
     INT 21H
     mov ah,2
     mov dl,z
     int 21h
     
    ;exit
    mov ah,4ch
    int 21h  
    
    
main endp   
end main