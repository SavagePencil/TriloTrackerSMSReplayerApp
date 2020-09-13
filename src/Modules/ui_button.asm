.IFNDEF __UI_BUTTON_ASM__
.DEFINE __UI_BUTTON_ASM__

.INCLUDE "Actions/action_upload_vramdata.asm"
.INCLUDE "Modules/execute_buffer.asm"
.INCLUDE "Utils/fsm.asm"

.STRUCT sUIButtonDescriptor
    ; Execute Buffer payload for rendering to the nametable.
    pUploadNameTableHeader          DW

    ; Execute Buffer payloads for uploading pattern data to VRAM
    pUploadPatternPayload_Disabled  DW
    pUploadPatternPayload_Normal    DW
    pUploadPatternPayload_Selected  DW
    pUploadPatternPayload_Pressed   DW
.ENDST

.STRUCT sUIButtonInstance
    FSM                 INSTANCEOF sFSM
.ENDST

.SECTION "UI Button" FREE
UIButtonState:
.DSTRUCT @Disabled INSTANCEOF sState VALUES
    OnEnter     .DW _UIButton@StateFuncs@DisabledOnEnter
.ENDST
.DSTRUCT @Normal INSTANCEOF sState VALUES
    OnEnter     .DW _UIButton@StateFuncs@NormalOnEnter
.ENDST
.DSTRUCT @Selected INSTANCEOF sState VALUES
    OnEnter     .DW _UIButton@StateFuncs@SelectedOnEnter
.ENDST
.DSTRUCT @Pressed INSTANCEOF sState VALUES
    OnEnter     .DW _UIButton@StateFuncs@PressedOnEnter
.ENDST

UIButton:
;==============================================================================
; UIButton@Init
; Initializes a UI button, starting in the specified state.
; INPUTS:  DE:  Pointer to sUIButtonInstance.FSM
;          HL:  Initial state
;          IX:  Pointer to sUIButtonDescriptor
;          IY:  Pointer to ExecuteBuffer
; OUTPUTS:  None
; Does not preserve any registers.
;==============================================================================
@Init:
    call    FSM_DE@Init
    call    @SetVisible
    ret

@SetVisible:
    ; Reserve space for the action.
    ld      bc, _sizeof_sAction_UploadVRAMList_Indirect
    call    ExecuteBuffer_AttemptReserve_IY

    ; DE points to the destionation buffer.
    ; First do the callback in the sAction_UploadVRAMList_Indirect.ExecuteEntry
    ex      de, hl
    ld      (hl), <Action_UploadVRAMList_Indirect
    inc     hl
    ld      (hl), >Action_UploadVRAMList_Indirect
    inc     hl

    ; Get the right payload
    ld      e, (ix + sUIButtonDescriptor.pUploadNameTableHeader + 0)
    ld      d, (ix + sUIButtonDescriptor.pUploadNameTableHeader + 1)
    ; Inject the pointer to the payload into the ExecuteBuffer.
    ld      (hl), e
    inc     hl
    ld      (hl), d

    ret

_UIButton:
;==============================================================================
; _UIButton@SetupExecBufferFor1bppUpload
; Prepares an execute buffer to accept a 1bpp upload action.
; INPUTS:   IY:  Pointer to ExecuteBuffer
; OUTPUTS:  HL:  Points to loc in exec buffer to write pointer to payload.
; Destroys BC, HL
;==============================================================================
@SetupExecBufferFor1bppUpload:
    ; Reserve space for the action.
    ld      bc, _sizeof_sAction_Upload1bppToVRAM_Indirect
    call    ExecuteBuffer_AttemptReserve_IY

    ; DE points to the destination buffer.
    ; First do the callback in the sAction_Upload1bppToVRAM_Indirect.ExecuteEntry
    ex      de, hl
    ld      (hl), <Action_Upload1bppToVRAM_Indirect
    inc     hl
    ld      (hl), >Action_Upload1bppToVRAM_Indirect
    inc     hl
    ret


@StateFuncs:

.MACRO UI_BUTTON_ENQUEUE_PAYLOAD ARGS PAYLOAD_OFFSET
    ; Prep the execute buffer
    call    @SetupExecBufferFor1bppUpload
    ; Get the right payload
    ld      e, (ix + PAYLOAD_OFFSET + 0)
    ld      d, (ix + PAYLOAD_OFFSET + 1)
    ; Inject the pointer to the payload into the ExecuteBuffer.
    ld      (hl), e
    inc     hl
    ld      (hl), d
.ENDM

@@NormalOnEnter:
    UI_BUTTON_ENQUEUE_PAYLOAD sUIButtonDescriptor.pUploadPatternPayload_Normal

    and     a   ; Clear carry
    ret

@@SelectedOnEnter:
    UI_BUTTON_ENQUEUE_PAYLOAD sUIButtonDescriptor.pUploadPatternPayload_Selected

    and     a   ; Clear carry
    ret

@@PressedOnEnter:
    UI_BUTTON_ENQUEUE_PAYLOAD sUIButtonDescriptor.pUploadPatternPayload_Pressed

    and     a   ; Clear carry
    ret

@@DisabledOnEnter:
    UI_BUTTON_ENQUEUE_PAYLOAD sUIButtonDescriptor.pUploadPatternPayload_Disabled

    and     a   ; Clear carry
    ret

.ENDS

.ENDIF  ;__UI_BUTTON_ASM__