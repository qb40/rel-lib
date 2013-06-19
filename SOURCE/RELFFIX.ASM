.MODEL MEDIUM, BASIC
.386
.STACK 200H
.CODE

;============================================================================
;RELFIXISR
;INTERNAL PROC TO CANCEL OUT FWAIT WITH MOV AX,AX
;CHANGES THE OLD INTERRUPT 3DH VECTOR
;============================================================================
ALIGN 2
RelFixISR PROC
        PUSH BP
        MOV BP,SP
        PUSH DI
        LFS DI, [bp + 2] ;LOAD 32 BIT RET PTR TO FS:DI  WHY NOT??
        MOV WORD PTR FS:[DI-2], 0C089H 
        POP DI
        POP BP
        IRET            ;INTERRUPT RETURN
RelFixISR ENDP


;============================================================================
;RELFFIX
;FIXUP WITH THE FWAIT BUG INSTALLER(INT 3DH VECTOR REWRITE)
;============================================================================

ALIGN 2
PUBLIC RelFfix
RelFfix PROC
        PUSH DS
        MOV AX, CS
        MOV DS,AX
        MOV DX, OFFSET RelFixISR
        MOV AX, 253DH           ;SET INTERRUPT VECTOR
        INT 21H                 ;DO IT
        POP DS
        RET
RelFfix ENDP


;============================================================================
;RELREMOVEFFIX
;FIXUP WITH THE FWAIT BUG REMOVER
;============================================================================

;ALIGN 2
;PUBLIC RelRemoveFfix
;RelRemoveFfix PROC
;        MOV DL, FfixInstalled
;        or  dl, dl
;        jz  @@RemoveEndFFix
;        cli
;        xor cx, cx
;        mov es, cx
;        mov eax, OldInt3DAddress
;        mov es:[0f4h], eax
;        sti
;        mov FfixInstalled, 0
;@@RemoveEndFFix:
;        ret
;RelRemoveFfix endp

END

