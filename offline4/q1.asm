
.model small
.stack 100h
.data
CR EQU 0DH
LF EQU 0AH
    
MSG1 Db cr, 'Enter 1st matrix: $'          
MSG2 Db CR, LF,'Enter 2nd matrix: $'
MSG3 Db CR, LF,'The final matrix is: $'
newline db cr,lf,'$'   
a   db 4 dup (0)
b   db 4 dup (0)
         
    
.code
main proc
    mov  ax, @data      ;load data
    mov  ds, ax 
    
;print String
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    LEA DX,newline
    int 21h
   
    lea si,a
    lea di,b 
    xor cx,cx
;taking input
input1:
   
     cmp cx,4
     je input
     cmp cx,2
     jne new
     mov ah,9
     LEA DX,newline
     int 21h 
     
new:
     mov ah,1
     int 21h
     and al,0fh 
     mov [si],al
     mov ah,2
     mov dx,9
     int 21h 
     inc si
     inc cx     
     jmp input1 
input: 
     LEA DX, MSG2
     MOV AH, 9
     INT 21H
     LEA DX,newline
     int 21h 
     xor cx,cx
     
input2:
     cmp cx,4 
     je operate
     cmp cx,2
     jne new1
     mov ah,9
     LEA DX,newline
     int 21h 
     
new1:
     mov ah,1
     int 21h
     and al,0fh 
     mov [di],al
     mov ah,2
     mov dx,9
     int 21h
     inc di
     inc cx     
     jmp input2 
     
  
operate:
    ;operation 
    mov ah,9
    
    LEA DX,MSG3
    int 21h    
    LEA DX,newline
    int 21h        
        
    xor cx,cx 
    lea si,a
    lea di,b
loop_:  
    cmp cx,4 
    je exit 
    cmp cx,2
    jne new3
    mov ah,9
    LEA DX,newline
    int 21h 
     
new3:
    mov al,[si]
    add al,[di]
    mov ah,0
    call output
    inc cx 
    inc si
    inc di
    mov ah,2
    mov dx,9
    int 21h
    jmp loop_
    
    
exit: 
    LEA DX, MSG1      
    Mov ah,4ch
    int 21h 
    
main endp
output proc
    push cx
    xor cx,cx  ;count=0 and dx=0
    xor dx,dx
    cmp ax,0
    je printt 
begin1: 
 
    cmp ax,0  ; if ax is zero
    je repeat1       
          
    mov bx,10 ; extract the last digit and push it to stack
    div bx                   
    push dx               
    inc cx  ;count++             
    
    xor dx,dx   ; dx=0  
    jmp begin1
     
repeat1: 
    cmp cx,0 
               ;check if count>0 
    je return
          
    pop dx   ;pop the top of stack       
    add dx,48 ;print the digit 
    mov ah,2 
    int 21h  
    
    dec cx       ;count--
    jmp repeat1 
return:
    pop cx
    ret 
printt:
    mov dx,48
    mov ah,2
    int 21h
    jmp return     
output endp
end main
 
    