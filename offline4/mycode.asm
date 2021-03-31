.model small
.data 
CR EQU 0DH
LF EQU 0AH
MSG Db CR,'Enter the number: $' 
MSG1 Db CR, LF,'The series is: $'
newline db cr,lf,'$'  
x dw ?
f1 dw ?
f2 dw ? 
c dw ? 
b db ?
.code
main proc 
    mov  ax, @data      ;load data
    mov  ds, ax 
    mov f1,0 
    mov f2,1 
    mov c,0 
    mov b,0 
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
    call fib
    
   
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

fib proc 
   
   cmp b,1
   je skip
   mov ax,f1
   call output
   inc c 
   
   cmp x,1
   je next 
   mov ah,2
   mov dl,','
   int 21h 
   mov ax,f2
   call output
   inc c 
   cmp x,2
   je next 
skip:
   cmp b,1
   je skip1
   mov ah,2
   mov dl,','
   int 21h 
skip1: 
   
   mov ax,f1
   add ax,f2 
   mov bx,ax
   mov b,1 
   
   call output
   inc c 
   mov cx,x
   cmp cx,c
   je return3
   mov cx,f2 
   mov f1,cx
   
   mov f2,bx
   
   mov ah,2
   mov dl,','
   int 21h 
   
   call fib
   ret
    
next:
    ret
     
next1:
    mov ax,f1
    call output
    mov ax,f2
    call output
    ret 
return3:
    ret 
    
fib endp

end main