.IFNDEF __PLAYERCONTROLS_CONTAINER_ASM__
.DEFINE __PLAYERCONTROLS_CONTAINER_ASM__

.INCLUDE "Modules/ui_button.asm"
.INCLUDE "Modules/ui_container.asm"
.include "../data/ui/playercontrols_container_ui_defs.asm"
.include "Utils/Controllers/controller_joypad.asm"

.ENUMID 0 EXPORT
; These are laid out Left to Right in ascending order.
.ENUMID PLAYERCONTROLS_BUTTON_PLAYPAUSE
.ENUMID PLAYERCONTROLS_BUTTON_FADE
.ENUMID PLAYERCONTROLS_BUTTON_TRANSPOSE
.ENUMID PLAYERCONTROLS_BUTTON_COUNT


.STRUCT sUIContainer_PlayerControls
    ; This MUST go first.
    BaseContainerInstance       INSTANCEOF sUIContainerInstance

    .UNION
        UIButtons                   INSTANCEOF sUIButtonInstance PLAYERCONTROLS_BUTTON_COUNT
    .NEXTU
        ; Dependent on SONGPLAYER_BUTTON_* enum ordering.
        UIButton_PlayPause          INSTANCEOF sUIButtonInstance
        UIButton_Fade               INSTANCEOF sUIButtonInstance
        UIButton_Transpose          INSTANCEOF sUIButtonInstance
    .ENDU
.ENDST

.RAMSECTION "UI Container - Song Player Controls Instance" SLOT 3
    gUIContainer_PlayerControls  INSTANCEOF sUIContainer_PlayerControls
.ENDS

.SECTION "UI Container - Player Controls" FREE
PlayerControlsContainer:
;==============================================================================
; PlayerControls@Init
; Initializes the song player controls UI container.
; INPUTS:  IY:  Pointer to execute buffer
; OUTPUTS: IY:  Pointer to execute buffer
; Destroys IX, BC, DE, HL, A
;==============================================================================
@Init:
    ; Do the base init first.
    ld      ix, gUIContainer_PlayerControls
    ld      de, _PlayerControlsContainer@Descriptor
    call    UIContainer@Init

    ; Now each of our child buttons.

    ; PLAYPAUSE (starts as Play)
    ld      ix, gUIContainer_PlayerControls.UIButton_PlayPause
    ld      hl, PlayerControls_Container_UIDefs@PlayButton
    call    UIButton@Init

    ; FADE
    ld      ix, gUIContainer_PlayerControls.UIButton_Fade
    ld      hl, PlayerControls_Container_UIDefs@FadeButton
    call    UIButton@Init

    ; TRANSPOSE
    ld      ix, gUIContainer_PlayerControls.UIButton_Transpose
    ld      hl, PlayerControls_Container_UIDefs@TransposeButton
    call    UIButton@Init

    ; Set each button visible and initial state.
    ; PLAYPAUSE
    ld      ix, gUIContainer_PlayerControls.UIButton_PlayPause
    ld      a, BUTTON_STATE_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; FADE
    ld      ix, gUIContainer_PlayerControls.UIButton_Fade
    ld      a, BUTTON_STATE_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; TRANSPOSE
    ld      ix, gUIContainer_PlayerControls.UIButton_Transpose
    ld      a, BUTTON_STATE_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ret


_PlayerControlsContainer:

.DSTRUCT @Descriptor INSTANCEOF sUIContainerDescriptor VALUES
    OnSetSelected       .DW @OnSetSelected
    OnNav               .DW @OnNav
    OnUpdate            .DW @OnUpdate
.ENDST

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
    ; Did we have a button selected before?
    ld      a, (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex)
    cp      UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    jr      nz, @@HaveWidgetToSelect
    ; Otherwise, pick one by default.
    ld      a, PLAYERCONTROLS_BUTTON_PLAYPAUSE
    ld      (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex), a

@@HaveWidgetToSelect:
    ; Get the currently selected button from index in A
    call    @GetButtonFromIndex ; Gets the button into IX
    ld      a, BUTTON_STATE_SELECTED
    call    UIButton@SetButtonState

    ret

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
    ; Start with our currently selected item.
    ld  a, (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex)

    ; This is a re-entrant location.  For example, if the navigation flow is:
    ; A -> B -> C
    ; ...A is the current selection and the user presses Right.
    ; We start here with A, which checks to see if B is a valid target.  If B is
    ; disabled, we then try to check C.
@@OnNavAttempt:
    ; Which dir was it?
    bit CONTROLLER_JOYPAD_UP_BITPOS, b
    jr  z, @@Up
    bit CONTROLLER_JOYPAD_LEFT_BITPOS, b
    jr  z, @@Left
    bit CONTROLLER_JOYPAD_RIGHT_BITPOS, b
    jr  z, @@Right

    ; Ignore.  Clear carry.
@@IgnoreInput:
    and     a
    ret

@@Up:
    ; TODO:  Send it to the current mode window.
    ; Send it to the mode selection.
    ld      de, gUIContainer_ModeSelectControls
    scf
    ret

@@Right:
    ; Controls are set up left -> right in increasing order.
    inc     a
    ; Did we roll over?
    cp      PLAYERCONTROLS_BUTTON_COUNT
    jr      c, @@CheckSelectable
    ; Skip it.
    jr      @@IgnoreInput

@@Left:
    ; Controls are set up left -> right in increasing order.
    dec     a
    ; Did we roll over?
    jp      p, @@CheckSelectable
    ; Yes.  Skip it.
    jr      @@IgnoreInput

@@CheckSelectable:
    call    @IsButtonSelectable
    jr      c, @@MakeSelection
    ; This button wasn't selectable, but maybe the next one will be.
    ; Keep going.
    jr      @@OnNavAttempt

@@MakeSelection:
    ; Turn off the current selection
    push    af
        ld  a, (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex)

        ; Get the currently selected button from index in A
        call    @GetButtonFromIndex ; Gets the button into IX
        ld      a, BUTTON_STATE_NORMAL
        call    UIButton@SetButtonState
    pop     af

    ; Now turn on the new selection.
    ld      (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex), a
    ; Get the currently selected button from index in A
    call    @GetButtonFromIndex ; Gets the button into IX
    ld      a, BUTTON_STATE_SELECTED
    call    UIButton@SetButtonState

    ; Clear carry.
    and     a
    ret

@OnUpdate:
    ret

;==============================================================================
; @IsButtonSelectable
; Returns whether a given button is selectable or disabled.
; INPUTS:  A:  Button index to test (SONGPLAYER_BUTTON_*)
; OUTPUTS: Sets Carry if button is selectable, otherwise disabled.
; Destroys TODO
;==============================================================================
@IsButtonSelectable:
    ;TODO query if a song is either playing or loaded into memory.
    scf     ; Sure.
    ret

;==============================================================================
; @IsPlayPause_InPlayState
; Returns whether the PlayPause button should be in Play state, or Pause state
; INPUTS:  None
; OUTPUTS: Sets Carry if button should be Play mode, otherwise Pause.
; Destroys TODO
;==============================================================================
@IsPlayPause_InPlayState:
    ;TODO query if a song is playing.
    scf     ; Sure.
    ret

;==============================================================================
; @GetButtonFromIndex
; Returns pointer to button of the index passed in (SONGPLAYER_BUTTON_*).
; INPUTS:  A:  SONGPLAYER_BUTTON_* index value
; OUTPUTS: IX: Pointer to button, or $0000 if none selected
;          Sets Carry if index is invalid/UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
; Destroys A, IX, Carry
;==============================================================================
@GetButtonFromIndex:
    cp      PLAYERCONTROLS_BUTTON_PLAYPAUSE
    jr      z, @@PlayPause
    cp      PLAYERCONTROLS_BUTTON_FADE
    jr      z, @@Fade
    cp      PLAYERCONTROLS_BUTTON_TRANSPOSE
    jr      z, @@Transpose
    ; Otherwise failed.
    ld      ix, $0000
    scf
    ret
@@PlayPause:
    ld      ix, gUIContainer_PlayerControls.UIButton_PlayPause
    and     a
    ret
@@Fade:
    ld      ix, gUIContainer_PlayerControls.UIButton_Fade
    and     a
    ret
@@Transpose:
    ld      ix, gUIContainer_PlayerControls.UIButton_Transpose
    and     a
    ret
    
.ENDS
.ENDIF  ; __PLAYERCONTROLS_CONTAINER_ASM__