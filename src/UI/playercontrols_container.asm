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
    OnNav                           .DW @OnNav
    OnUpdate                        .DW @OnUpdate
    OnWidgetSelectionStatusChanged  .DW @OnWidgetSelectionStatusChanged
.ENDST

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
    ; First off:  find out if we're being thrown to by another container,
    ; and if so, can we fulfill their request?
    ; Is the source container NULL?
    ld      a, e
    or      d
    jr      nz, @@FulfillThrowRequestFromAltContainer
    ; It was NULL, so see if we can handle the request internally.

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
    ; Fall through to Invalid Move.
@@InvalidMove:
    ; For an invalid move, we want to SET the carry
    ; AND set target index to UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    scf
    ld      c, UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    ret

@@Up:
    ; TODO:  Send it to the current mode window.
    ; Send it to the mode selection, with NO specific control requested.
    ld      de, gUIContainer_ModeSelectControls
    ld      c, UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    and     a   ; Clear carry to indicate keep moving.
    ret

@@Right:
    ; Controls are set up left -> right in increasing order.
    inc     a
    ; Did we roll over?
    cp      PLAYERCONTROLS_BUTTON_COUNT
    jr      c, @@CheckSelectable
    ; Skip it.
    jr      @@InvalidMove

@@Left:
    ; Controls are set up left -> right in increasing order.
    dec     a
    ; Did we roll over?
    jp      p, @@CheckSelectable
    ; Yes, we rolled over.  Send it to the mode select.
    ld      de, gUIContainer_ModeSelectControls
    ld      c, MODESELECT_BUTTON_LOADSONG
    and     a   ; Clear carry to indicate keep throwing.
    ret

@@CheckSelectable:
    call    @IsButtonSelectable
    ; If it wasn't selectable (no carry), keep trying.
    jr      nc, @@OnNavAttempt
    ; We were selectable and our choice is in A.
    ld      c, a    ; Store in C
    scf             ; Indicate success
    ret

@@FulfillThrowRequestFromAltContainer:
    ; Another container threw to us.  Lets see if we can fulfill it.
    ; Were they requesting a specific control?
    ld      a, c
    cp      UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    jr      z, @@@ChooseBestControl
    ; Yes, they were asking for a specific control.
    ; Is it selectable?
    call    @IsButtonSelectable
    jr      nc, @@@ChooseBestControl
    ; Yes, it was selectable so let's go with that one.
    ; It's already in C so leave it there.
    scf     ; Indicate success
    ret

@@@ChooseBestControl:
    ; Do we already have one selected?
    ld      a, (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex)
    ; Is it selectable?
    call    @IsButtonSelectable
    jr      nc, @@@@ScanForFirstSelectable
    ; It was selectable, so use that.
    ld      c, a
    scf     ; Indicate success
    ret

@@@@ScanForFirstSelectable:
    ; Let's treat it as a right joypad input, starting on our leftmost selection.
    xor     a   ; First control index is 0
    ld      b, 1 << CONTROLLER_JOYPAD_RIGHT_BITPOS
    jr      @@OnNavAttempt

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
    ld      a, b
    and     a
    ; Was it to be selected?
    jr      nz, @@MakeSelected
    ; No, make it unselected.
    ; Find out what state the unselected button SHOULD be.
    ld      a, c
    call    @IsButtonSelectable
    ; Assume selectable at first.
    ld      b, BUTTON_STATE_NORMAL
    jr      c, @@HaveDesiredState
    ld      b, BUTTON_STATE_DISABLED
@@HaveDesiredState:
    ld      a, c
    call    @GetButtonFromIndex
    ld      a, b    ; Get the desired state enum into A
    call    UIButton@SetButtonState
    ret
@@MakeSelected:
    ; Make this the selected one.
    ld      a, c
    ld      (gUIContainer_PlayerControls.BaseContainerInstance.CurrSelectedWidgetIndex), a
    ld      b, BUTTON_STATE_SELECTED
    jr      @@HaveDesiredState

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