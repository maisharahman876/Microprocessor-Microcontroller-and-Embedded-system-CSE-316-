.model small
.data 
CR EQU 0DH
LF EQU 0AH
MSG Db CR,'Enter the number: $' 
MSG1 Db CR, LF,'The series is: $'
newline db cr,lf,'$'
x dw 0
c dw 1
.code
main proc 
    mov  ax, @data      ;load data
    mov  ds, ax
    mov ah,9
    lea dx,msg
    int 21h
    lea dx,newline
    int 21h 
    call input
    
    mov x,ax
    mov ah,9
    lea dx,msg1
    int 21h
    lea dx,newline
    int 21h
    mov ax,x 
    mov bx,ax
    inc bx
    mov ax,c
    PUSH ax
    xor dx,dx
    call fib 
    mov ax,dx
    call output
    
loop_:
    inc c
    mov bx,x
    inc bx
    cmp c,bx
    je exit 
    mov ah,2
    mov dx,','
    int 21h
    mov ax,c
    PUSH ax
    xor dx,dx
    call fib 
    mov ax,dx
    call output
    jmp loop_
    
    
exit:   
;dos exit 
    mov ah,4ch
    int 21h
    
 
main endp 

input proc 
   push bx
   push cx
   push dx
   xor bx,bx ; make bx,cx zero  
   xor cx,cx

     
   mov ah,1
   int 21h      ;input digit  
repeat: 
   cmp al,'0'    ;checking if input is between 0 to 9
   jnge repeat2
   cmp al, '9'
   jnle repeat2 
   
   and ax,000fh   ; make ax equal to last 4 bits of al   
   push ax
   mov ax,10 
   mul bx    ;prev*10 is in ax
   pop bx    ;pop the input value
   add bx,ax ;bx=prev*10+input 
repeat2:    
   mov ah,1
   int 21h 
 
   cmp al,0dh
   jne repeat
   mov ax,bx 
   cmp cx,1
   jne jump
   neg ax
jump:  
   pop dx
   pop cx
   pop bx
    
    ret       
input endp  

output proc
    push bx
    push cx
    push dx
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
    pop dx
    pop cx
    pop bx
    ret 
printt:
    mov dx,48
    mov ah,2
    int 21h
    jmp return     
output endp

fib proc near 
  
   push bp
   mov bp,sp
   cmp c,1
   je base
   cmp c,2
   je base1
   cmp word ptr[bp+4],0
   jne next2 
   mov ax,0 
  jmp return1
next2:
   cmp [bp+4],1
   jne next1 
   mov ax,0
   jmp return1
   jmp next1
base1:
    mov dx,1
    jmp return1 
base:
    mov dx,0
    jmp return1
next1:
   cmp [bp+4],2
   jne next 
   mov ax,1
   jmp return1 
next: 
    mov cx,[bp+4]
    dec cx
    push cx
    call fib
    
    mov bx,ax
    mov cx,[bp+4] 
    sub cx,2
    push cx
    call fib
    
   
    mov cx,[bp+4]
    cmp cx,100b
    jg return1
     
    add bx,ax
    add dx,bx
    ;mov ax,bx
    ;mov bx,dx
        
return1:
   
    pop bp 
    ret 2     
    
fib endp

end main