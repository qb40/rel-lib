.model medium, BASIC
.stack 20h
.data
        
        keybflags     DB  ?               ; original flags
        keymatrix     DB  128 dup(0)      ; holds the key map
        keybon        DB  0               ; tells us if the keyb is on
        dos_int_seg   DW  ?               ; old key handler seg
        dos_int_off   DW  ?               ; old key handler off

.code
.386

public RELKeyboardOn
public RELKeyboardOff
public RELKey

RELKeyboardOn proc                        ; Switch our keyboard on
  cmp keybon,1
  jne keybon_cont
  ret 
keybon_cont:
  mov  ax, 40h                         ;
  mov  es, ax                          ; Stores the current keyboard
  mov  di, 17h                         ; flags state
  mov  al, es:[di]                     ;
  and  al, 70h                         
  mov  keybflags, al                   
  push ds
  mov  ax,3509h                        ; Function 35h Get Int Vector
  int  21h
  pop  ds
  mov  dos_int_off, bx                 ; Store the old addres
  mov  dos_int_seg, es                 ;
  mov  ax, SEG new_key_int             ; Get the SEG & OFF of our
  mov  dx, OFFSET new_key_int          ; procedure
  push ds
  mov  ds, ax
  mov  ax, 2509h                       ; Function 25h Set Int Vector
  int  21h
  pop  ds
  mov  keybon,1
  ret
RELKeyboardOn endp

new_key_int proc                       ; This is the new interrupt ISR
  push ax                              ; The CPU will call this everytime
  push bx                              ; you press or release a key
  push si                              
  push ds                              
  
  in   al, 60h                         ; Read the pressed key from port 60h  
  xor  ah, ah                          ;
  mov  si, ax                          ; The rest of this stuff
  in   al, 61h                         ; just resets the keyboard
  or   al, 82h                         ; flip-flop and tells the
  out  61h, al                         ; keyboard that we received 
  and  al, 127                         ; the key
  out  61h, al                         ;
  mov  al, 20h                         ;
  out  20h, al                         ;

  mov  bl, 1                           ; Assume it's a Make code
  test si, 128                         ; is it >= 128 ?
  jz   store_key                       ;
  and  si, 127                         ;
  xor  bl, bl                          ;
store_key:                             ;
  mov  ax, @DATA                       ;
  mov  ds, ax                          ;
  mov  keymatrix[si], bl               ; Store the new state in our array
  pop  ds                              ;
  pop  si
  pop  bx
  pop  ax
  iret                                 ; IRET = interrupt return
new_key_int endp

RELKeyboardoff proc
  cmp  keybon,0
  jne  keyboff_cont
  ret  
keyboff_cont:
  push ds
  mov  dx, dos_int_off                 ; Get the old SEG:OFF
  mov  ax, dos_int_seg                 ;
  mov  ds, ax                          ;
  mov  ax, 2509h                       ; 25h = Set Int Vector
  int  21h
  pop  ds
  mov  ax, 40h                         ; Restore the Key flags
  mov  es, ax                          ;
  mov  di, 17h                         ;
  mov  al, keybflags                   ;
  mov  es:[di], al                     ;
  mov  ax, SEG keymatrix               ;
  mov  di, OFFSET keymatrix            ; Set our array to zeros
  mov  es, ax                          ;
  xor  ax, ax                          ;
  mov  cx, 128                         ;
  rep  stosb                           ;
  mov  keybon, al
  ret
RELKeyboardoff endp

; stack 
;
; code     4
; ret seg  2
; ret off  0
;  
RELkey proc                            ; All this does is return
  mov cx, bp                           ; the key state of a
  mov bp,sp                            ; given key scancode
  mov si,[bp+4]                        ;
  mov al, keymatrix[si]                ; A list of scancodes is available
  xor ah, ah                           ; in the QB help
  mov bp, cx
  ret 2
RELkey endp

END

