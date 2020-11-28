.IFNDEF __MODESELECT_CONTAINER_UI_DEFS_ASM__
.DEFINE __MODESELECT_CONTAINER_UI_DEFS_ASM__
ModeSelect_Container_UIDefs:
@ProfileButton:
; Upper-left loc in the nametable for this button
;                    NAME                                    COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PROFILE, 10, 10 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                         SOURCE_PATTERN_DATA          SOURCE_PATTERN_LENGTH                                    0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE * _sizeof_sTile, ButtonGfx_Profile1bpp@Begin, ButtonGfx_Profile1bpp@End - ButtonGfx_Profile1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PROFILE
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                   HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PROFILE + 3, 0,        0,        0,          0,           0
@@@@End:

@VisualizerButton:
; Upper-left loc in the nametable for this button
;                    NAME                                       COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_VISUALIZER, 10, 12 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                            SOURCE_PATTERN_DATA             SOURCE_PATTERN_LENGTH                                          0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER * _sizeof_sTile, ButtonGfx_Visualizer1bpp@Begin, ButtonGfx_Visualizer1bpp@End - ButtonGfx_Visualizer1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_VISUALIZER
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                      HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_VISUALIZER + 3, 0,        0,        0,          0,           0
@@@@End:

@LoadSongButton:
; Upper-left loc in the nametable for this button
;                    NAME                                      COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_LOAD_SONG, 10, 14 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                           SOURCE_PATTERN_DATA           SOURCE_PATTERN_LENGTH                                      0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG * _sizeof_sTile, ButtonGfx_LoadSong1bpp@Begin, ButtonGfx_LoadSong1bpp@End - ButtonGfx_LoadSong1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_LOAD_SONG
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                     HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_LOAD_SONG + 3, 0,        0,        0,          0,           0
@@@@End:

.ENDIF  ;__MODESELECT_CONTAINER_UI_DEFS_ASM__