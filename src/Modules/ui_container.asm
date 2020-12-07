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
    ; Called to determine where navigation SHOULD go
    ; (e.g., d-pad right is pressed, where does it go?)
    ; This may cause it to skip this container and go
    ; to an entirely different one altogether.
    OnNav                           DW
    ; Called on each tick.
    OnUpdate                        DW
    ; Called when a specific widget in this container
    ; is to be selected or deselected.
    OnWidgetSelectionStatusChanged  DW
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
; Potentially destroys all registers, but directly destroys HL, AF
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
; Lets the container say where a given nav input might lead.  Does not actually
; make the navigation change.  May result in a destination that is in another 
; container.
; INPUTS:   B:  Controller state (combo of CONTROLLER_JOYPAD_* flags)
;           C:  Specific control index being requested to be selected (can be
;               UI_CONTAINER_NO_WIDGET_SELECTED_INDEX if none)
;           DE: Source container making the nav request (can be NULL).
; OUTPUTS:  
; Carry Set C             DE               Result
; N         Invalid Index Ptr to Container Try container (no control requested)
; N         Valid Index   Ptr to Container Try container (specific control requested)
; Y         Invalid Index <Anything>       Invalid move
; Y         Valid Index   <Anything>       Make move within this container
; Destroys (OnEvent: AF, HL), B
;==============================================================================
@OnNav:
    UICONTAINER_ONEVENT sUIContainerDescriptor.OnNav

;==============================================================================
; @OnWidgetSelectionStatusChanged
; Changes the specified widget's status.  This can result in side effects such
; as button graphics needing to be uploaded, etc.
; INPUTS:   C:  ID of control to change
;           B:  0 == unselected, Not-0 == selected
;          IY:  Execute buffer for VRAM changes to queue
; OUTPUTS:  None
; Destroys (OnEvent: AF, HL), B
;==============================================================================
@OnWidgetSelectionStatusChanged:
    UICONTAINER_ONEVENT sUIContainerDescriptor.OnWidgetSelectionStatusChanged

.ENDS


.ENDIF  ;__UI_CONTAINER_ASM__