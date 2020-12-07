.IFNDEF __ACTION_UPLOAD_VRAMDATA_ASM__
.DEFINE __ACTION_UPLOAD_VRAMDATA_ASM__

.INCLUDE "Modules/execute_buffer.asm"

.SECTION "Action - Upload Data to VRAM Indirect" FREE
; Uploads data to VRAM that is located elsewhere (e.g., ROM).

.STRUCT sAction_UploadVRAMData_Indirect
    ExecuteEntry    INSTANCEOF sExecuteEntry    ; Callback
    DestVRAMLoc     DW                          ; Where in VRAM will this go?
    Length          DW                          ; Length in bytes?
    pData           DW                          ; Where's the src data?
.ENDST

;==============================================================================
; Action_UploadVRAMData_Indirect
; Execute Buffer action to upload data that is pointed to into VRAM.
; INPUTS:  DE:  Start of sAction_UploadVRAMData_Indirect
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_UploadVRAMData_Indirect:
    ex  de, hl

    ; Get DestVRAM Loc
    ld  e, (hl)
    inc hl
    ld  d, (hl)
    inc hl

    ; Get Length of Data
    ld  c, (hl)
    inc hl
    ld  b, (hl)
    inc hl

    ; Get Ptr to Data
    ld  a, (hl)
    inc hl
    push    hl  ; Preserve next pos
        ld      h, (hl)
        ld      l, a

        call    VDP_UploadDataToVRAMLoc
    pop     de

    inc     de

    ret


.ENDS

.SECTION "Action - Upload VRAM Data Implicit" FREE
; Uploads data that is located here in the execute buffer (not pointed to elsewhere) to VRAM.

.STRUCT sAction_UploadVRAMData_Implicit
    ExecuteEntry    INSTANCEOF sExecuteEntry    ; Callback
    DestVRAMLoc     DW                          ; Where in VRAM will this go?
    Length          DW                          ; Length in bytes?
    ; Data goes after this, of variable size.
.ENDST

;==============================================================================
; Action_UploadVRAMData_Implicit
; Execute Buffer action to upload data in the buffer to VRAM.
; INPUTS:  DE:  Start of sAction_UploadVRAMData_Implicit
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_UploadVRAMData_Implicit:
    ex  de, hl

    ; Get DestVRAM Loc
    ld  e, (hl)
    inc hl
    ld  d, (hl)
    inc hl

    ; Get Length of Data
    ld  c, (hl)
    inc hl
    ld  b, (hl)
    inc hl

    ; HL now points to the implicit data.
    call    VDP_UploadDataToVRAMLoc

    ; HL now points to byte past end of buffer, which is perfect.  Now move it to DE
    ex      de, hl
@Done:
    ret


.ENDS

.SECTION "Action - Upload VRAM List Implicit" FREE
; Uploads data that is located here in the execute buffer (not pointed to elsewhere) to VRAM.
; Data is uploaded as a sequence of linear runs.
.STRUCT sAction_UploadVRAMList_Implicit
    ExecuteEntry        INSTANCEOF sExecuteEntry    ; Callback
    NumRuns             DB                          ; How many runs?
    ; A series of sAction_UploadVRAMList_Run go after this.
.ENDST

.STRUCT sAction_UploadVRAMList_Run
    VRAMLoc             DW                          ; Start pos of run
    RunLengthInBytes    DB                          ; #/bytes in run.

    ; Data goes after this, of variable size.
.ENDST

;==============================================================================
; Action_UploadVRAMList_Implicit
; Execute Buffer action to upload data in the buffer to VRAM.
; INPUTS:  DE:  Start of sAction_UploadVRAMList_Implicit
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_UploadVRAMList_Implicit:
    ex      de, hl

    ld      d, (hl)     ; Get #/runs
    inc     hl          ; Point to first Run

    ld      c, VDP_DATA_PORT
-:
    ; Start of sAction_UploadNameTable_Run
    ld      a, (hl)                     ; VRAM loc
    inc     hl
    out     (VDP_CONTROL_PORT), a
    ld      a, (hl)
    inc     hl
    or      VDP_COMMAND_MASK_VRAM_WRITE
    out     (VDP_CONTROL_PORT), a

    ld      b, (hl)                     ; Get run length
    inc     hl

    otir                                ; UL VRAM data

    dec     d                           ; Next run
    jp      nz, -

    ; HL now points to byte past end of buffer, which is perfect.  Now move it to DE
    ex      de, hl

    ret


.ENDS

.SECTION "Action - Upload VRAM List Indirect" FREE
; Uploads data that is located elsewhere (e.g., ROM) to VRAM.
; Data is uploaded as a sequence of linear runs.
.STRUCT sAction_UploadVRAMList_Indirect
    ExecuteEntry        INSTANCEOF sExecuteEntry    ; Callback
    pHeader             DW                          ; Pointer to sAction_UploadVRAMList_Indirect_Header 
.ENDST

.STRUCT sAction_UploadVRAMList_Indirect_Header
    NumRuns             DB                          ; How many runs?
    ; A series of sAction_UploadVRAMList_Run go after this.
.ENDST

;==============================================================================
; Action_UploadVRAMList_Indirect
; Execute Buffer action to upload data that is pointed to into VRAM.
; INPUTS:  DE:  Start of sAction_UploadVRAMList_Indirect
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_UploadVRAMList_Indirect:
    ld      a, (de)
    ld      l, a
    inc     de
    ld      a, (de)
    ld      h, a
    inc     de      ; DE points to next byte in Execute Buffer, HL holds the ptr to sAction_UploadVRAMList_Indirect_Header

    push    de
        ld      d, (hl) ; Get #/runs
        inc     hl      ; Point to first Run

        ld      c, VDP_DATA_PORT
-:
        ; Start of sAction_UploadVRAMList_Run
        ld      a, (hl) ; VRAM loc
        inc     hl
        out     (VDP_CONTROL_PORT), a
        ld      a, (hl)
        inc     hl
        or      VDP_COMMAND_MASK_VRAM_WRITE
        out     (VDP_CONTROL_PORT), a

        ld      b, (hl) ; Run length
        inc     hl

        otir

        dec     d       ; Next run
        jp  nz, -
    
    pop de
    ret
.ENDS

.SECTION "Action - Upload String Indirect" FREE
; Uploads a string to VRAM that is located elsewhere (e.g., ROM).

.STRUCT sAction_UploadString_Indirect
    ExecuteEntry    INSTANCEOF sExecuteEntry    ; Callback
    Row             DB                          ; Row of string
    Col             DB                          ; Column of string
    Attribute       DB                          ; Attribute to interleave between string characters
    Length          DB                          ; Length in bytes?
    pData           DW                          ; Where's the src data?
.ENDST

;==============================================================================
; Action_UploadString_Indirect
; Execute Buffer action to upload a string (one byte per char)
; INPUTS:  DE:  Start of sAction_UploadString_Indirect
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_UploadString_Indirect:
    ex      de, hl

    ; Get Row
    ld      d, (hl)
    inc     hl

    ; Get Col
    ld      e, (hl)
    inc     hl

    ; Get Attribute
    ld      c, (hl)
    inc     hl

    ; Get Length
    ld      b, (hl)
    inc     hl

    ; HL points to the pData
    push    hl
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a

        call    VDP_UploadStringToNameTable
    pop     de  ; DE == pData

    ; Move past the pData
    inc     de
    inc     de

    ret


.ENDS

.SECTION "Action - Upload 1bpp Data to VRAM Implicit" FREE
.STRUCT sColorRemap_1bpp
    Color0s             DB      ; What palette entry to substitute for 0s?
    Color1s             DB      ; ...and the 1s?
.ENDST

.STRUCT sAction_Upload1bppToVRAM_Payload
    DestVRAMLoc     DW                          ; Where is it going?
    SourceLength    DW                          ; How many bytes is the source data?
    ColorRemaps     INSTANCEOF sColorRemap_1bpp ; How are the colors being remapped?
    p1bppData       DW                          ; Where is the data?
.ENDST

.MACRO DECLARE_UPLOAD_1BPP_TO_VRAM_PAYLOAD ARGS DEST_PATTERN_VRAM_LOC, SOURCE_PATTERN_DATA, SOURCE_PATTERN_LENGTH, COLOR_REMAP_0s, COLOR_REMAP_1s
.DSTRUCT INSTANCEOF sAction_Upload1bppToVRAM_Payload VALUES
    DestVRAMLoc                     .DW DEST_PATTERN_VRAM_LOC
    SourceLength                    .DW SOURCE_PATTERN_LENGTH
    p1bppData                       .DW SOURCE_PATTERN_DATA
    ColorRemaps.Color0s             .DB COLOR_REMAP_0s
    ColorRemaps.Color1s             .DB COLOR_REMAP_1s
.ENDST

.ENDM

; Converts 1bpp graphical data and uploads it to VRAM, remapping the color values.
; The payload is embedded directly into the execute buffer.
.STRUCT sAction_Upload1bppToVRAM_Implicit
    ExecuteEntry    INSTANCEOF sExecuteEntry    ; Callback
    Payload         INSTANCEOF sAction_Upload1bppToVRAM_Payload
.ENDST

;==============================================================================
; Action_Upload1bppToVRAM_Implicit
; Execute Buffer action to upload 1bpp graphical data to VRAM.  The payload
; is embedded directly into the execute buffer.
; INPUTS:  DE:  Start of sAction_Upload1bppToVRAM_Implicit
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_Upload1bppToVRAM_Implicit:
    ; Get the Dest VRAM loc
    ex      de, hl

    ; HL points to sAction_Upload1bppToVRAM_Implicit.DestVRAMLoc
    ld      e, (hl)
    inc     hl
    ld      d, (hl)

    ; Set the VRAM loc before we actually upload stuff.
    SET_VRAM_WRITE_LOC_FROM_DE

    inc     hl      ; Now to SourceLength
    ld      c, (hl)
    inc     hl
    ld      b, (hl) ; BC has the len

    inc     hl      ; Now to palette remaps
    ld      e, (hl) ; 0s color
    inc     hl
    ld      d, (hl) ; 1s color
    
    inc     hl      ; Now to pData
    ld      a, (hl)
    inc     hl
    push    hl      ; Preserve it
        ld      h, (hl)
        ld      l, a

        call    Tile_Upload1BPPWithPaletteRemaps_VRAMPtrSet
    pop     de      ; Restore it *TO DE*

    inc     de      ; Move past last byte in this Action

    ret
.ENDS 

.SECTION "Action - Upload 1bpp Data to VRAM Indirect" FREE
; Converts 1bpp graphical data and uploads it to VRAM, remapping the color values.
; The payload is stored as a pointer in the execute buffer.
.STRUCT sAction_Upload1bppToVRAM_Indirect
    ExecuteEntry    INSTANCEOF sExecuteEntry    ; Callback
    pPayload        DW                          ; Pointer to an sAction_Upload1bppToVRAM_Payload
.ENDST

;==============================================================================
; Action_Upload1bppToVRAM_Indirect
; Execute Buffer action to upload 1bpp graphical data to VRAM.  The payload
; is stored as a pointer in the execute buffer.
; INPUTS:  DE:  Start of sAction_Upload1bppToVRAM_Indirect
; OUTPUTS:  DE: Next byte in Execute Buffer
; Destroys Everything
;==============================================================================
Action_Upload1bppToVRAM_Indirect:
    ; Get the pointer value.
    ld      a, (de)
    ld      l, a
    inc     de
    ld      a, (de)
    ld      h, a
    inc     de

    push    de
        ; Get the Dest VRAM loc
        ; HL points to sAction_Upload1bppToVRAM_Indirect.DestVRAMLoc
        ld      e, (hl)
        inc     hl
        ld      d, (hl)

        ; Set the VRAM loc before we actually upload stuff.
        SET_VRAM_WRITE_LOC_FROM_DE

        inc     hl      ; Now to SourceLength
        ld      c, (hl)
        inc     hl
        ld      b, (hl) ; BC has the len

        inc     hl      ; Now to palette remaps
        ld      e, (hl) ; 0s color
        inc     hl
        ld      d, (hl) ; 1s color
        
        inc     hl      ; Now to pData
        ld      a, (hl)
        inc     hl
        ld      h, (hl)
        ld      l, a

        call    Tile_Upload1BPPWithPaletteRemaps_VRAMPtrSet
    pop     de          ; Restore to next byte in Execute Buffer.

    ret

.ENDS
.ENDIF  ; __ACTION_UPLOAD_VRAMDATA_ASM__