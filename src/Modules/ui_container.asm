.IFNDEF __UI_CONTAINER_ASM__
.DEFINE __UI_CONTAINER_ASM__
.INCLUDE "Modules/ui_button.asm"

.STRUCT sUIContainerInstance
    ; Pointer to the descriptor for this container
    pDescriptor         DW

    ; Pointer to the currently selected widget
    pCurrSelectedWidget DW
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
    ld      (ix + sUIContainerInstance.pCurrSelectedWidget + 0), $00
    ld      (ix + sUIContainerInstance.pCurrSelectedWidget + 1), $00
    ret

;==============================================================================
; UIContainer@OnEvent
; Invokes a container's descriptor events, if one is defined.
; INPUTS:  IX:  Pointer to sUIContainerInstance
;          DE:  Event offset in sUIContainerDescriptor 
;               (e.g., sUIContainerDescriptor.OnUpdate)
; OUTPUTS: None
; Potentially destroys all registers.
;==============================================================================
@OnEvent:
    ; Get the descriptor.
    ld      l, (ix + sUIContainerInstance.pDescriptor + 0)
    ld      h, (ix + sUIContainerInstance.pDescriptor + 1)
    add     hl, de
    ld      a, (hl)
    inc     hl
    ld      h, (hl)
    ld      l, a
    or      h
    ret     z       ; Get out if the event handler was NULL.
    ; HL is valid.  Jump there.
    jp      (hl)

@Update:
    ld      de, sUIContainerDescriptor.OnUpdate
    jp      @OnEvent

@OnNav:
    ld      de, sUIContainerDescriptor.OnNav
    jp      @OnEvent

@OnSetSelected:
    ld      de, sUIContainerDescriptor.OnSetSelected
    jp      @OnEvent

.ENDS


.ENDIF  ;__UI_CONTAINER_ASM__