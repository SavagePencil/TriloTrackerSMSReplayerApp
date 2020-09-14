.IFNDEF __UI_BUTTON_ASM__
.DEFINE __UI_BUTTON_ASM__

.INCLUDE "Actions/action_upload_vramdata.asm"
.INCLUDE "Modules/execute_buffer.asm"
.INCLUDE "Utils/fsm.asm"

.ENUMID 0 EXPORT
.ENUMID UI_WIDGET_CONTAINER
.ENUMID UI_WIDGET_BUTTON
.ENUMID UI_WIDGET_TOGGLE

.ENUMID 0 EXPORT
; Do not change the order of these, as some
; structs depend on them.
.ENUMID BUTTON_DISABLED
.ENUMID BUTTON_NORMAL
.ENUMID BUTTON_SELECTED
.ENUMID BUTTON_PRESSED

.STRUCT sUIWidgetInstance
    ; One of UI_WIDGET_* enums
    UIWidgetType                    DB
    ; Pointer to an sWidgetContainerInstance (or NULL if none)
    pParentContainer                DW
.ENDST

.STRUCT sWidgetContainerInstance
    WidgetInstance      INSTANCEOF sUIWidgetInstance
    pCurrSelectedWidget DW
.ENDST

.STRUCT sUIButtonDescriptor
    ; Execute Buffer payload for rendering to the nametable.
    pUploadNameTableHeader          DW

    ; Execute Buffer payloads for uploading pattern data to VRAM
    ; ORDER MATTERS
    pUploadPatternPayload_Disabled  DW
    pUploadPatternPayload_Normal    DW
    pUploadPatternPayload_Selected  DW
    pUploadPatternPayload_Pressed   DW
.ENDST

.STRUCT sUIButtonInstance
    WidgetInstance      INSTANCEOF sUIWidgetInstance
    ; One of BUTTON_* enums
    ButtonState         DB
    ; Pointer to the descriptor for this button
    pDescriptor         DW
.ENDST

.SECTION "UI Button" FREE

UIButton:
;==============================================================================
; UIButton@Init
; Initializes a UI button, starting in the specified state.
; INPUTS:  IX:  Pointer to sUIButtonInstance
;          DE:  Pointer to sUIButtonDescriptor
;          IY:  Pointer to ExecuteBuffer
;          A:   Initial state (BUTTON_* enum)
; OUTPUTS: IX:  Pointer to sUIButtonInstance
;          IY:  Pointer to ExecuteBuffer
; Does not preserve any other registers.
;==============================================================================
@Init:
    ld      (ix + sUIButtonInstance.pDescriptor + 0), e
    ld      (ix + sUIButtonInstance.pDescriptor + 1), d
    call    @SetButtonState
    ret

;==============================================================================
; UIButton@SetButtonState
; Sets the button to the indicated BUTTON_* enum state.
; INPUTS:  IX:  Pointer to sUIButtonInstance
;          A:   Desired state (BUTTON_* enum)
;          IY:  Pointer to ExecuteBuffer
; OUTPUTS: IX:  Pointer to sUIButtonInstance
;          IY:  Pointer to ExecuteBuffer
; Does not preserve any other registers.
;==============================================================================
@SetButtonState:
    ; Store the new state
    ld      (ix + sUIButtonInstance.ButtonState), a

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
    ex      de, hl

    ; Get the descriptor.
    ld      l, (ix + sUIButtonInstance.pDescriptor + 0)
    ld      h, (ix + sUIButtonInstance.pDescriptor + 1)

    ; Move to the payloads in the descriptor
.REPT sUIButtonDescriptor.pUploadPatternPayload_Disabled
    inc     hl
.ENDR
    ; Get the offset based on the BUTTON_* enum.
    add     a, a
    ld      c, a
    ld      b, 0
    add     hl, bc

    ; HL points to the payload, and DE points to the buffer loc.
    ; Copy the payload pointer into the buffer.
    ldi
    ldi
    ret

;==============================================================================
; UIButton@SetVisible
; Enqueues the actions to make the specified button visible in the nametable.
; INPUTS:  IX:  Pointer to sUIButtonInstance
;          IY:  Pointer to ExecuteBuffer
; OUTPUTS: IX:  Pointer to sUIButtonInstance
;          IY:  Pointer to ExecuteBuffer
; Destroys HL, DE, BC
;==============================================================================
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
    ex      de, hl

    ; Get the descriptor.
    ld      l, (ix + sUIButtonInstance.pDescriptor + 0)
    ld      h, (ix + sUIButtonInstance.pDescriptor + 1)

    ; Move to the upload to name table
.REPT sUIButtonDescriptor.pUploadNameTableHeader
    inc     hl
.ENDR
    ; Inject the pointer to the payload into the ExecuteBuffer.
    ldi
    ldi

    ret

_UIButton:
.ENDS

.ENDIF  ;__UI_BUTTON_ASM__