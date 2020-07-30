.include "Managers/modemanager.asm"
.include "Managers/vdpmanager.asm"
.include "Managers/inputmanager.asm"
.include "Utils/macros.asm"
.include "Utils/tile_routines.asm"

.include "../data/fonts/default_font.asm"

.SECTION "Mode - Main Menu" FREE

; Public
ModeMainMenu:
.DSTRUCT @Definition INSTANCEOF sApplicationMode VALUES:
    VideoInterruptJumpTarget    .DW _ModeMainMenu@InterruptHandler  ; Called when a video interrupt (V/HBlank) occurs.
    OnActive                    .DW _ModeMainMenu@OnActive          ; Called when this mode is made active (pushed, old one above popped, etc.)

    OnNMI                       .DW _ModeMainMenu@DoNothing         ; Called when a non-maskable interrupt (NMI) comes in.
    OnInactive                  .DW _ModeMainMenu@DoNothing         ; Called when this mode goes inactive (popped, new mode pushed on, etc.)
    OnUpdate                    .DW _ModeMainMenu@OnUpdate          ; Called when the application wants to update.
    OnRenderPrep                .DW _ModeMainMenu@DoNothing         ; Called when the application is prepping things for render.
    OnEvent                     .DW _ModeMainMenu@DoNothing         ; Called when a generic event occurs.
.ENDST

; Private
_ModeMainMenu:

@DoNothing:
    ; Do nothing.
    ret

@OnActive:
    ; If we're replacing what was on before us, do the full init.  Otherwise don't do anything.
    cp      MODE_MADE_ACTIVE
    jr      z, @@FullInit

    ret

@@FullInit:
    ; Turn off the display and interrupts while we do graphics things.

    di
    ; Turn off the display & VBlanks by OR'ing to the current value.
    ld      a, (gVDPManager.Registers.VideoModeControl2)
    and     $FF ~(VDP_REGISTER1_ENABLE_DISPLAY | VDP_REGISTER1_ENABLE_VBLANK)
    ld      e, VDP_COMMMAND_MASK_REGISTER1
    call    VDPManager_WriteRegisterImmediate

    ; Default us to both joypads active.
    xor     a                               ; 0 == Port 1
    ld      b, CONTROLLER_TYPE_SMS_JOYPAD
    ld      hl, Controller_Joypad_Port1_State
    call    InputManager_SetController

    ld      a, 1                            ; 1 == Port 2
    ld      b, CONTROLLER_TYPE_SMS_JOYPAD
    ld      hl, Controller_Joypad_Port2_State
    call    InputManager_SetController

    ; Clear the nametable
    call ClearNameTable

    ; Upload the font.
    ld      hl, $0020   ; Dest tile index
    CALC_VRAM_LOC_FOR_TILE_INDEX_IN_HL
    SET_VRAM_WRITE_LOC_FROM_HL
    ld      hl, DefaultFont_1bpp_Data@Begin                  ; Src data
    ld      bc, DefaultFont_1bpp_Data@End - DefaultFont_1bpp_Data@Begin ; Length of data
    ld      e, $00                                          ; Palette entry for 0s in 1bpp data
    ld      d, $01                                          ; Palette entry for 1s in 1bpp data
    call    Tile_Upload1BPPWithPaletteRemaps_VRAMPtrSet

    ; Upload the palette
    ld      b, (@Palette@End - @Palette) >> 1           ; #/entries (2 bytes per entry)
    ld      hl, @Palette
-:
    ld      e, (hl)     ; Get entry
    inc     hl
    ld      c, (hl)     ; Get color value
    inc     hl
    push    hl
    call    VDPManager_SetPaletteEntryImmediate
    pop     hl
    djnz    -

    ; We're ready to roll.  Turn on interrupts and the screen.
    ; Turn on the display, by OR'ing to the current value.
    ld      a, (gVDPManager.Registers.VideoModeControl2)
    or      VDP_REGISTER1_ENABLE_DISPLAY | VDP_REGISTER1_ENABLE_VBLANK
    ld      e, VDP_COMMMAND_MASK_REGISTER1
    call    VDPManager_WriteRegisterImmediate

    ei

    ret

@OnUpdate:
    ; Read input.
    call    InputManager_OnUpdate

    ret

@InterruptHandler:
    PUSH_ALL_REGS
        in  a, (VDP_STATUS_PORT)                ; Satisfy the interrupt
    POP_ALL_REGS
    ret

@Palette:
; BG Palette Entry 0 == color 0 (black)
.db VDP_PALETTE_BG_PALETTE_INDEX + 0, $00
; BG Palette Entry 1 == color $3F (white)
.db VDP_PALETTE_BG_PALETTE_INDEX + 1, (3 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
@@End:


.ENDS