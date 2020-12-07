.IFNDEF __PLAYERCONTROLS_CONTAINER_UI_DEFS_ASM__
.DEFINE __PLAYERCONTROLS_CONTAINER_UI_DEFS_ASM__

PlayerControls_Container_UIDefs:

@LoadSongButton:
; Upper-left loc in the nametable for this button
;                    NAME                                      COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_LOAD_SONG, 8, 16 EXPORT

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

@PlayButton:
; Upper-left loc in the nametable for this button
;                    NAME                                 COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PLAY, 14, 16 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                      SOURCE_PATTERN_DATA       SOURCE_PATTERN_LENGTH                              0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY * _sizeof_sTile, ButtonGfx_Play1bpp@Begin, ButtonGfx_Play1bpp@End - ButtonGfx_Play1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PLAY
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PLAY + 3, 0,        0,        0,          0,           0
@@@@End:

@PauseButton:
; Upper-left loc in the nametable for this button
;                    NAME                                  COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_PAUSE, 14, 16 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                       SOURCE_PATTERN_DATA        SOURCE_PATTERN_LENGTH                                0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE * _sizeof_sTile, ButtonGfx_Pause1bpp@Begin, ButtonGfx_Pause1bpp@End - ButtonGfx_Pause1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_PAUSE
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                 HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_PAUSE + 3, 0,        0,        0,          0,           0
@@@@End:

@FadeButton:
; Upper-left loc in the nametable for this button
;                    NAME                                 COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_FADE, 20, 16 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                      SOURCE_PATTERN_DATA        SOURCE_PATTERN_LENGTH                             0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE * _sizeof_sTile, ButtonGfx_Fade1bpp@Begin, ButtonGfx_Fade1bpp@End - ButtonGfx_Fade1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_FADE
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_FADE + 3, 0,        0,        0,          0,           0
@@@@End:

@TransposeButton:
; Upper-left loc in the nametable for this button
;                    NAME                                      COL ROW
DEFINE_NAMETABLE_LOC MAIN_MENU_NAMETABLE_LOC_BUTTON_TRANSPOSE, 26, 16 EXPORT

.DSTRUCT @@Descriptor INSTANCEOF sUIButtonDescriptor VALUES
    pUploadNameTableHeader          .DW @@NameTableDefinition
    pUploadPatternPayload_Disabled  .DW @@Disabled
    pUploadPatternPayload_Normal    .DW @@Normal
    pUploadPatternPayload_Selected  .DW @@Selected
    pUploadPatternPayload_Pressed   .DW @@Pressed
.ENDST
;                                   VRAM Loc for Pattern Data                                           SOURCE_PATTERN_DATA            SOURCE_PATTERN_LENGTH                                        0s                                                    1s
@@Disabled:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED
@@Normal:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_NORMAL
@@Selected:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_BLACK,             MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED
@@Pressed:
DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE * _sizeof_sTile, ButtonGfx_Transpose1bpp@Begin, ButtonGfx_Transpose1bpp@End - ButtonGfx_Transpose1bpp@Begin, MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_SELECTED,    MAIN_MENU_DATA_UI_PAL_ENTRY_BUTTON_STATE_DISABLED

@@NameTableDefinition:
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Indirect_Header VALUES
    NumRuns                 .DB 1   ; Only 1 run
.ENDST
; Run definitions (horizontal spans)
.DSTRUCT INSTANCEOF sAction_UploadVRAMList_Run VALUES
    VRAMLoc                 .DW MAIN_MENU_NAMETABLE_LOC_BUTTON_TRANSPOSE
    RunLengthInBytes        .DB @@@NameTableEntries@End - @@@NameTableEntries
.ENDST
; The nametable data itself
@@@NameTableEntries:
;DEFINE_NAMETABLE_ENTRY ARGS PATTERN_INDEX0_511,                                     HFLIP0_1, VFLIP0_1, PALETTE0_1, PRIORITY0_1, USER_FLAGS0_7
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 0, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 1, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 2, 0,        0,        0,          0,           0
DEFINE_NAMETABLE_ENTRY       MAIN_MENU_DEST_VRAM_PATTERN_INDEX_BUTTON_TRANSPOSE + 3, 0,        0,        0,          0,           0
@@@@End:


.ENDIF  ;__PLAYERCONTROLS_CONTAINER_UI_DEFS_ASM__