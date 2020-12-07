.IFNDEF __DEBOUNCE_MODULE_ASM__
.DEFINE __DEBOUNCE_MODULE_ASM__

.INCLUDE "Utils/fsm.asm"

.SECTION "Debounce Module" FREE

; The parameters that drive debounce logic.  Can be in ROM or RAM.
.STRUCT sDebounceModule_Parameters
    DesiredVal              DB ; What value are we looking for to know when we're done?
    Mask                    DB ; Current val is AND'd against this
.ENDST

; Maintains the state of a debounce module.  Must be in RAM.
.STRUCT sDebounceModule_Instance
    DebounceFSM INSTANCEOF  sFSM
    DebounceParams          DW ; Pointer to parameters
    CurrentVal              DB ; Current value to be tested against
.ENDST

; Public
DebounceModule:

; State definitions
; When we're waiting for debounce to occur.
.DSTRUCT @WaitForDebounceState INSTANCEOF sState VALUES
    ; Uses the same functionality when entering as updating; can go straight to done.
    OnEnter                 .DW _DebounceModule@_WaitForDebounceState@CompareVsDesired
    OnUpdate                .DW _DebounceModule@_WaitForDebounceState@CompareVsDesired
.ENDST

; State when a debounce has occurred.
.DSTRUCT @DebouncedState INSTANCEOF sState VALUES
.ENDST

;==============================================================================
; DebounceModule@IsDebounced
; Sets the Z flag if this state machine is debounced
; INPUTS:  IX:  Pointer to DebounceModule_Instance
; OUTPUTS: Flag Z:  Debounced, otherwise NOT set
; Destroys DE, HL
;==============================================================================
@IsDebounced:
    ; Are we in the debounced state?
    ld  l, (ix + sDebounceModule_Instance.DebounceFSM.CurrentState + 0)
    ld  h, (ix + sDebounceModule_Instance.DebounceFSM.CurrentState + 1)
    ld  de, @DebouncedState
    and a       ; Clear carry.
    sbc hl, de
    ret


; Private
_DebounceModule:
@_WaitForDebounceState:
@@CompareVsDesired:
    ; Take current value and apply the success mask.
    ld      a, (ix + sDebounceModule_Instance.CurrentVal)

    ; Get ptr to constants and put them in IY
    ld      l, (ix + sDebounceModule_Instance.DebounceParams + 0)
    ld      h, (ix + sDebounceModule_Instance.DebounceParams + 1)
    push    hl
    pop     iy

    ; Now apply success mask and compare to desired value
    and     (iy + sDebounceModule_Parameters.Mask)
    cp      (iy + sDebounceModule_Parameters.DesiredVal)
    jr  nz, @@@StayInState

    ; Proceed to next state
    ld  hl, DebounceModule@DebouncedState
    scf
    ret

@@@StayInState:
    and a   ; Clear carry; stay in same state.
    ret

.ENDS

.ENDIF  ;__DEBOUNCE_MODULE_ASM__