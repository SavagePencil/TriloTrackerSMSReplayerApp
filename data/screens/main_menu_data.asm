.IFNDEF __MAIN_MENU_DATA_ASM__
.DEFINE __MAIN_MENU_DATA_ASM__

.SECTION "Mode - Main Menu Data" FREE
Mode_MainMenu_Data:
@Palette:
; BG Palette Entry 0 == color 0 (black)
.db VDP_PALETTE_BG_PALETTE_INDEX + 0, $00
; BG Palette Entry 1 == color $3F (white)
.db VDP_PALETTE_BG_PALETTE_INDEX + 1, (3 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
@@End:

@Strings:
@@Title:
    .DB "TriloTracker SMS Player"
@@@End:

@@Instructions1:
    .DB "D-Pad: Choose Options"
@@@End:
@@Instructions2:
    .DB "Btn 1: Cancel  Btn 2: Select"
@@@End:

@@LoadSong:
    .DB "Load Song"
@@@End:
@@PlaySong:
    .DB "Play Song"
@@@End:

@@Option_Selected:
    .DB "->"
@@@End:
@@Option_NotSelected:
    .DB "  "
@@@End:

; The main menu waits for the player to release all buttons before accepting input.
.DSTRUCT @DebounceParams INSTANCEOF sDebounceModule_Parameters VALUES
    DesiredVal  .DB CONTROLLER_JOYPAD_UP_RELEASED | CONTROLLER_JOYPAD_DOWN_RELEASED | CONTROLLER_JOYPAD_LEFT_RELEASED | CONTROLLER_JOYPAD_RIGHT_RELEASED | CONTROLLER_JOYPAD_BUTTON1_RELEASED | CONTROLLER_JOYPAD_BUTTON2_RELEASED
    Mask        .DB CONTROLLER_JOYPAD_UP_RELEASED | CONTROLLER_JOYPAD_DOWN_RELEASED | CONTROLLER_JOYPAD_LEFT_RELEASED | CONTROLLER_JOYPAD_RIGHT_RELEASED | CONTROLLER_JOYPAD_BUTTON1_RELEASED | CONTROLLER_JOYPAD_BUTTON2_RELEASED
.ENDST

.ENDS

.ENDIF  ;__MAIN_MENU_DATA_ASM__