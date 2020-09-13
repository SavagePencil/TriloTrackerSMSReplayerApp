.IFNDEF __MAIN_MENU_DATA_ASM__
.DEFINE __MAIN_MENU_DATA_ASM__

.SECTION "Mode - Main Menu Data" FREE
Mode_MainMenu_Data:

; Palette entries
; Font
.DEFINE MAIN_MENU_DATA_FONT_PAL_BG  0   EXPORT
.DEFINE MAIN_MENU_DATA_FONT_PAL_FG  1   EXPORT

; Buttons
.DEFINE MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK          0 EXPORT
.DEFINE MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED 4 EXPORT
.DEFINE MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL   5 EXPORT
.DEFINE MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED 6 EXPORT

; Buttons (disabled uses BG pal, active uses Sprite pal)
.DEFINE MAIN_MENU_DATA_BUTTON_PAL_BG 2  EXPORT
.DEFINE MAIN_MENU_DATA_BUTTON_PAL_FG 3  EXPORT

; Default border entry
.DEFINE MAIN_MENU_BORDER_PAL_ENTRY              VDP_PALETTE_SPRITE_PALETTE_INDEX + 0    EXPORT

; Profiler entries (these use the sprite palette)
.DEFINE MAIN_MENU_PROFILER_PAL_ENTRY_VBLANK         VDP_PALETTE_SPRITE_PALETTE_INDEX + 15   EXPORT
.DEFINE MAIN_MENU_PROFILER_PAL_ENTRY_UPDATE         VDP_PALETTE_SPRITE_PALETTE_INDEX + 14   EXPORT
.DEFINE MAIN_MENU_PROFILER_PAL_ENTRY_RENDER_PREP    VDP_PALETTE_SPRITE_PALETTE_INDEX + 13   EXPORT

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
; UI entries
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED,   (1 << VDP_PALETTE_RED_SHIFT) | (1 << VDP_PALETTE_GREEN_SHIFT) | (1 << VDP_PALETTE_BLUE_SHIFT)
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL,     (2 << VDP_PALETTE_RED_SHIFT) | (2 << VDP_PALETTE_GREEN_SHIFT) | (2 << VDP_PALETTE_BLUE_SHIFT)
.db VDP_PALETTE_BG_PALETTE_INDEX + MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,   (3 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)

; Profiler colors
.db MAIN_MENU_PROFILER_PAL_ENTRY_VBLANK, (2 << VDP_PALETTE_RED_SHIFT) | (2 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
.db MAIN_MENU_PROFILER_PAL_ENTRY_UPDATE, (0 << VDP_PALETTE_RED_SHIFT) | (3 << VDP_PALETTE_GREEN_SHIFT) | (3 << VDP_PALETTE_BLUE_SHIFT)
.db MAIN_MENU_PROFILER_PAL_ENTRY_RENDER_PREP, (3 << VDP_PALETTE_RED_SHIFT) | (0 << VDP_PALETTE_GREEN_SHIFT) | (0 << VDP_PALETTE_BLUE_SHIFT)

@@End:

; VRAM Pattern Locs
; Font
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_FONT              $0020   EXPORT
; UI
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE    $0080   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER $0084   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG  $0088   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY       $008C   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE      $008C   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE       $0090   EXPORT
.DEFINE MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE  $0094   EXPORT

@UIButtons:
@@ProfileButton:
; Upper-left loc in the nametable for this button
;                    NAME                                    COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PROFILE, 10, 10 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                         SOURCE_PATTERN_DATA          SOURCE_PATTERN_LENGTH                                    0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PROFILE
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                   HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 3, 0,        0,        0,          0,           0
@@@@@End:

@@VisualizerButton:
; Upper-left loc in the nametable for this button
;                    NAME                                       COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_VISUALIZER, 10, 12 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                            SOURCE_PATTERN_DATA             SOURCE_PATTERN_LENGTH                                          0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_VISUALIZER
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                      HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 3, 0,        0,        0,          0,           0
@@@@@End:

@@LoadSongButton:
; Upper-left loc in the nametable for this button
;                    NAME                                      COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_LOAD_SONG, 10, 14 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                           SOURCE_PATTERN_DATA           SOURCE_PATTERN_LENGTH                                      0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_LOAD_SONG
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                     HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 3, 0,        0,        0,          0,           0
@@@@@End:

@@PlayButton:
; Upper-left loc in the nametable for this button
;                    NAME                                 COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PLAY, 14, 16 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                      SOURCE_PATTERN_DATA       SOURCE_PATTERN_LENGTH                              0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PLAY
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 3, 0,        0,        0,          0,           0
@@@@@End:

@@PauseButton:
; Upper-left loc in the nametable for this button
;                    NAME                                  COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PAUSE, 14, 16 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                       SOURCE_PATTERN_DATA        SOURCE_PATTERN_LENGTH                                0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PAUSE
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                 HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 3, 0,        0,        0,          0,           0
@@@@@End:

@@FadeButton:
; Upper-left loc in the nametable for this button
;                    NAME                                 COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_FADE, 20, 16 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                      SOURCE_PATTERN_DATA        SOURCE_PATTERN_LENGTH                             0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_FADE
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 3, 0,        0,        0,          0,           0
@@@@@End:

@@TransposeButton:
; Upper-left loc in the nametable for this button
;                    NAME                                      COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_TRANSPOSE, 26, 16 EXPORT

.DSTRUCT @@@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@@Disabled
    pUploadPatternPayload_Normal    .DW @@@Normal
    pUploadPatternPayload_Selected  .DW @@@Selected
    pUploadPatternPayload_Pressed   .DW @@@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                           SOURCE_PATTERN_DATA            SOURCE_PATTERN_LENGTH                                        0s                                                    1s
@@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_TRANSPOSE
    RunLengthInBytes        .DB @@@@NameTableEntries@End - @@@@NameTableEntries
.ENDST
; The nametable data itself
@@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                     HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 3, 0,        0,        0,          0,           0
@@@@@End:


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