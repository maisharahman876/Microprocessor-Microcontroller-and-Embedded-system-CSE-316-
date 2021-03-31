
 .model small
.stack 100h
.data
CR EQU 0DH
LF EQU 0AH
    
MSG1 Db cr, 'Enter 1st number: $'    
MSG2 Db CR, LF,'Enter operator: $'      
MSG3 Db CR, LF,'Enter 2nd number: $'
MSG4 Db CR, LF,'The expression is: $'  
MSG5 Db CR, LF,'Wrong Operator $' 
MSG6 Db CR, LF,'Overflow happened $' 
x dw ?
o db ?
y dw ?
s1 dw ?
s2 dw ?
z dw ?
s3 dw ?
.code
main proc
    mov  ax, @data      ;load data
    mov  ds, ax 
    
;print String
    LEA DX, MSG1
    MOV AH, 9
    INT 21H 
    
;taking input    
    call input
    mov x,ax
    mov s1,cx   
    
;print String    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H 
;taking operator
    mov ah,1
    int 21h
    mov o,al
    cmp al,'q'
    je exit 
    cmp al,'+'
    je next
    cmp al,'-'
    je next
    cmp al,'*'
    je next
    cmp al,'/'
    je next 
    
    LEA DX, MSG5 ; wrong operator
    MOV AH, 9
    INT 21H
    jmp exit
    
;print String
next:
    LEA DX, MSG3
    MOV AH, 9
    INT 21H 
    
;taking input    
    call input
    mov y,ax
    mov s2,cx   
    
;Operation  
    cmp o,'+'
    je plus
    cmp o,'-'
    je minus_  
    cmp o,'*'
    je multiply 
    cmp o,'/'
    je divide
    
plus:
    mov ax,x
    mov bx,y
    add ax,bx
    mov z,ax 
    cmp s1,0
    je jump10
    neg x
jump10: 
    cmp s2,0
    je jump11
    neg y 
jump11:
    mov ax,z
    and ax,8000h
    cmp ax,0
    je sign
    neg z  
   
    mov s3,1 
    jmp print
    
sign:
   mov s3,0 
   jmp print
minus_:
   mov ax,x
    mov bx,y
    sub ax,bx  
    mov z,ax 
    cmp s1,0
    je jump12
    neg x
jump12: 
    cmp s2,0
    je jump13
    neg y 
jump13:
    mov ax,z
    and ax,8000h
    cmp ax,0
    je sign
    neg z
    mov s3,1 
    jmp print
      

multiply:
    cmp s1,0
    je jump1
    neg x
jump1: 
    cmp s2,0
    je jump2
    neg y
jump2:
    mov ax,x
    mov bx,y
    mul bx  
    mov z,ax 
    mov ax,s1
    mov bx,s2
    xor ax,bx
    cmp ax,0
    je sign
     cmp z,0
    je sign
    mov s3,1
    jmp print
      
    
divide:
    cmp s1,0
    je jump3
    neg x
jump3: 
    cmp s2,0
    je jump4
    neg y
jump4: 
    
    mov ax,x 
    cwd
    mov bx,y
    idiv bx  
    mov z,ax 
    mov ax,s1
    mov bx,s2
    xor ax,bx
    cmp ax,0
    je sign
     cmp z,0
    je sign
    mov s3,1
    jmp print 
    
;output
print:
    mov ax,z
    and ax,8000h
    cmp ax,0
    jne overflow
    LEA DX, MSG4   ;expression
    MOV AH, 9
    INT 21H
    mov ah,2
    mov dx,'['
    int 21h
    cmp s1,1
    jne print2
    mov dx,'-'
    int 21h
print2:
    mov ax,x
    call output
    mov ah,2
    mov dx,']'
    int 21h
    mov dl,o
    int 21h
     
    mov dx,'['
    int 21h
    cmp s2,1
    jne print3
    mov dx,'-'
    int 21h
print3:
    mov ax,y
    call output
    mov ah,2
    mov dx,']'
    int 21h 
    mov dx,'='
    int 21h
    mov dx,'['
    int 21h  
    cmp s3,1
    jne print1
    mov ah,2 
    mov dx,'-'
    int 21h
    
print1:
    
    mov ax,z
    call output
    mov ah,2
    mov dx,']'
    int 21h
    jmp exit    
    
;exit
overflow:
    LEA DX, MSG6
    MOV AH, 9
    INT 21H    
 
exit:       
    Mov ah,4ch
    int 21h    
main endp



input proc 
   push bx
     ;push cx
   push dx
   xor bx,bx ; make bx,cx zero  
   xor cx,cx

     
   mov ah,1
   int 21h      ;input digit  
   cmp al,'-'
   je minus
   jmp repeat
minus:
    mov cx,1 
    int 21h
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
  ; pop cx
   pop bx
    
    ret       
input endp

output proc
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
    ret 
printt:
    mov dx,48
    mov ah,2
    int 21h
    jmp return     
output endp

end main 