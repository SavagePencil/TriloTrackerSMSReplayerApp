.IFNDEF __MAIN_MENU_DATA_ASM__
.DEFINE __MAIN_MENU_DATA_ASM__

.SECTION "Mode - Main Menu Data" FREE
Mode_MainMenu_Data:

; Palette entries
; Font
.DEFINE MAIN_MENU_DATA_FONT_PAL_BG  0   EXPORT
.DEFINE MAIN_MENU_DATA_FONT_PAL_FG  1   EXPORT

; Buttons (disabled uses BG pal, active uses Sprite pal)
.DEFINE MAIN_MENU_DATA_BUTTON_PAL_BG 2  EXPORT
.DEFINE MAIN_MENU_DATA_BUTTON_PAL_FG 3  EXPORT

; Profiler entries
.DEFINE MAIN_MENU_BORDER_PAL_ENTRY              VDP_PALETTE_SPRITE_PALETTE_INDEX + 0    EXPORT

; What colors do we change the border for each step of profiling?
.DEFINE MAIN_MENU_PROFILER_VBLANK_COLOR         (2 << VDP_PALETTE_RED_SHIFT) | (2 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)   EXPORT
.DEFINE MAIN_MENU_PROFILER_UPDATE_COLOR         (0 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)   EXPORT
.DEFINE MAIN_MENU_PROFILER_RENDER_PREP_COLOR    (3 << VDP_PALETTE_RED_SHIFT) | (0 << VDP_PALETTE_GREEN_SHIFT) | (0 << VDP_PALETTE_BLUE_SHIFT)   EXPORT
.DEFINE MAIN_MENU_PROFILER_NO_COLOR             (0 << VDP_PALETTE_RED_SHIFT) | (0 << VDP_PALETTE_GREEN_SHIFT) | (0 << VDP_PALETTE_BLUE_SHIFT)   EXPORT

@Palette:
; Font entries
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_FONT_PAL_BG, $00
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_FONT_PAL_FG, (3 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
; Buttons
; BG == disabled
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_BUTTON_PAL_BG, $00
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_BUTTON_PAL_FG, (1 << VDP_PALETTE_RED_SHIFT) | (1 << VDP_PALETTE_GREEN_SHIFT) | (1 << VDP_PALETTE_BLUE_SHIFT)
; Sprite == active
.db VDP_PALETTE_SPRITE_PALETTE_INDEX + MAIN_MENU_DATA_BUTTON_PAL_BG, $00
.db VDP_PALETTE_SPRITE_PALETTE_INDEX + MAIN_MENU_DATA_BUTTON_PAL_FG, (3 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
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