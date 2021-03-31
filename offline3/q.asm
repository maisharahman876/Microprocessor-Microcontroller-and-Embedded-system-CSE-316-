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
    
plus:
    ;two positive
    cmp s1,0
    jne neg1
    cmp s2,0
    jne neg2
    mov ax,x  ;(+x)+(+y)
    add ax,y
    mov z,ax
    mov s3,0
    jmp print
    
neg1:        ;1st neg
   cmp s2,0
   jne neg3
   mov ax,x
   cmp ax,y
   jg sign
   mov s3,0
   mov bx,y
   sub bx,ax ;(-x)+(y) && y>x
   mov z,bx
   jmp print
    
    
neg2:        ;2nd neg
   mov ax,x
   cmp ax,y
   jng sign1
   sub ax,y  ;x+(-y) && x>y
   mov s3,0
   mov z,ax 
   jmp print
   
    
neg3:        ;two neg 
    mov s3,1
    mov ax,x
    add ax,y  ;(-x)+(-y)
    mov z,ax
    jmp print 

sign:
   mov s3,1    ;(-x)+y && x>y
   sub ax,y
   mov z,ax
   jmp print  
sign1:
   mov s3,1    ;x+(-y) && x<y
   mov bx,y
   sub bx,ax
   mov z,bx
   jmp print 
   
minus_:
   cmp s1,0
   jne neg21   
   cmp s2,1
   jne neg22
   mov ax,x  ;(+x)-(-y)
   add ax,y
   mov z,ax
   mov s3,0
   jmp print
neg21:        ;1st neg
   cmp s2,0
   je neg23
   mov ax,x
   cmp ax,y
   jg sign2
   mov s3,0  ;(-x)-(-y) &&y>x
   mov bx,y
   sub bx,ax
   mov z,bx
   jmp print
    
    
neg22:        ;2nd neg
   mov ax,x
   cmp ax,y
   jng sign21
   sub ax,y  
   mov z,ax
   mov s3,0    ;x-(y) &&x>y
   jmp print
   
    
neg23:        ;(-x)-(y)
    mov s3,1
    mov ax,x
    add ax,y
    mov z,ax
    jmp print 

sign2:
   mov s3,1     ;(-x)-(y)&& x>y
   sub ax,y
   mov z,ax
   jmp print  
sign21:
   mov s3,1     ;x-(y) &&x<y
   mov bx,y
   sub bx,ax
   mov z,bx
   jmp print  

multiply:
        
    
;output
print:
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    cmp s3,1
    jne print1
    mov ah,2 
    mov dx,'-'
    int 21h
    
print1:
    mov ax,z
    call output    
    
;exit    
 
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
   pop dx
  ; pop cx
   pop bx
    
    ret       
input endp

output proc
    xor cx,cx  ;count=0 and dx=0
    xor dx,dx 
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
    cmp cx,0   ;check if count>0 
    je return
          
    pop dx   ;pop the top of stack       
    add dx,48 ;print the digit 
    mov ah,2 
    int 21h  
    
    dec cx       ;count--
    jmp repeat1 
return:
    ret 
    
output endp

end main 