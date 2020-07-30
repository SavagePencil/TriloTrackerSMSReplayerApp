;****IMPORTANT****
; This needs to be the first thing the assembler touches,
; so that it can find routines from the SMSFramework.
; Ensure we can get to the SMSFramework.
.INCDIR "../../SMSFramework/"

.include "bankdetails.asm"
.include "interrupts.asm"
.include "vdpmemorymap.asm"
.include "Utils/boot.asm"
.include "Managers/modemanager.asm"
.include "Managers/vdpmanager.asm"
.include "Managers/inputmanager.asm"
.include "Modes/mode_init.asm"

;==============================================================
; SDSC tag and SMS rom header
;==============================================================
.SDSCTAG 1.2,"SMS TriloTracker Replayer App","SMSFramework app to play TriloTracker SMS songs","SavagePencil"


.SECTION "Application Main Loop" FREE
; This routine is called by the framework when we're ready to enter
; the main loop.
Application_MainLoop_InitialEntry:
    ei                                  ; Turn on interrupts

Application_MainLoop:    
    call ModeManager_OnUpdate           ; Update for current mode
    call ModeManager_OnRenderPrep       ; Prepare things for rendering
    halt                                ; Wait for VBlank
    jp   Application_MainLoop           
.ENDS

.SECTION "Application Bootstrap" FREE
; This routine sets up an initial state as part of the bootstrapping.
; It should set a mode for the initial program.
Application_Bootstrap:
    ld      de, ModeInit@Definition
    call    ModeManager_Init
    ret

.ENDS

.SECTION "Default Interrupt Handler" FREE
DefaultVideoInterruptHandler:
    ex      af, af'
        in  a, (VDP_STATUS_PORT)    ; Satisfy the interrupt
    ex      af, af'
    ret

.ENDS

; Helper fn to clear the name table.
.SECTION "Clear Name Table" FREE
ClearNameTable:
    ld  hl, VDP_NAMETABLE_START_LOC
    SET_VRAM_WRITE_LOC_FROM_HL

    ; Now clear all of VRAM for the nametable.  
    ; Each write to the data port increments the address.
    xor     a
    ld      bc, VDP_NAMETABLE_SIZE >> 8
-:
        out     (VDP_DATA_PORT), a
        djnz    -
    dec     c
    jr      nz, -
    ret

.ENDS
