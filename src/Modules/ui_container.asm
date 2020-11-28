.IFNDEF __UI_CONTAINER_ASM__
.DEFINE __UI_CONTAINER_ASM__
.INCLUDE "Modules/ui_button.asm"

; Constant for when no widget is selected.
.DEFINE UI_CONTAINER_NO_WIDGET_SELECTED_INDEX   $FF

.STRUCT sUIContainerInstance
    ; Pointer to the descriptor for this container
    pDescriptor             DW

    ; Index of the currently selected widget
    CurrSelectedWidgetIndex DB
.ENDST

; Function pointers for an instance, which may be in ROM.
.STRUCT sUIContainerDescriptor
    ; Called when the selected widget is changed (allows custom logic)
    OnSetSelected       DW
    ; Called whenever navigation needs to be resolved 
    ; (e.g., d-pad right is pressed, where does it go?)
    OnNav               DW
    ; Called on each tick.
    OnUpdate            DW
.ENDST

.SECTION "UI Container" FREE
UIContainer:
;==============================================================================
; UIContainer@Init
; Initializes a UI container.
; INPUTS:  IX:  Pointer to sUIContainerInstance
;          DE:  Pointer to sUIContainerDescriptor
; OUTPUTS: None
; Does not alter any registers.
;==============================================================================
@Init:
    ld      (ix + sUIContainerInstance.pDescriptor + 0), e
    ld      (ix + sUIContainerInstance.pDescriptor + 1), d
    ; Start with nothing selected.
    ld      (ix + sUIContainerInstance.CurrSelectedWidgetIndex), UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    ret

;==============================================================================
; UIContainer@OnEvent
; Invokes a container's descriptor events, if one is defined.
; INPUTS:  IX:  Pointer to sUIContainerInstance
;          DE:  Event offset in sUIContainerDescriptor 
;               (e.g., sUIContainerDescriptor.OnUpdate)
;          TBD: See specific events for other inputs/outputs.
; OUTPUTS: None
; Potentially destroys all registers.
;==============================================================================
.MACRO UICONTAINER_ONEVENT ARGS EVENT_OFFSET
    ; Get the descriptor.
    ld      l, (ix + sUIContainerInstance.pDescriptor + 0)
    ld      h, (ix + sUIContainerInstance.pDescriptor + 1)
    .REPT EVENT_OFFSET
        inc hl
    .ENDR
    ld      a, (hl)
    inc     hl
    ld      h, (hl)
    ld      l, a
    or      h
    ret     z       ; Get out if the event handler was NULL.
    ; HL is valid.  Jump there.
    jp      (hl)
.ENDM

@Update:
    UICONTAINER_ONEVENT sUIContainerDescriptor.OnUpdate

;==============================================================================
; @OnNav
; Allows the container to make a decision about any nav requests.  May cause
; it to throw the input over to another container.
; INPUTS:   B:  Controller state (combo of CONTROLLER_JOYPAD_* flags)
;          DE:  Container that threw to us (NULL if none)
;          IY:  Execute Buffer for any VRAM changes that need to be queued.
; OUTPUTS: DE:  Container to throw to (only valid if carry is set)
;          SETS CARRY FLAG IF THE CALLER NEEDS TO THROW TO A NEW CONTAINER.
; Destroys A, C, HL, IX
;==============================================================================
@OnNav:
    UICONTAINER_ONEVENT sUIContainerDescriptor.OnNav

;==============================================================================
; @OnSetSelected
; Makes the given container the selected one.  A container may have memory of
; which control was last selected, and select it, or it may override to a
; default.
; INPUTS:  IY:  Execute Buffer for any VRAM changes that need to be queued.
; OUTPUTS: None
; Destroys A, BC, DE, HL, IX
;==============================================================================
@OnSetSelected:
    UICONTAINER_ONEVENT sUIContainerDescriptor.OnSetSelected

.ENDS


.ENDIF  ;__UI_CONTAINER_ASM__