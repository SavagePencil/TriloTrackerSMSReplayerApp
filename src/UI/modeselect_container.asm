.IFNDEF __MODESELECT_CONTAINER_ASM__
.DEFINE __MODESELECT_CONTAINER_ASM__

.INCLUDE "Modules/ui_button.asm"
.INCLUDE "Modules/ui_container.asm"
.INCLUDE "../data/ui/modeselect_container_ui_defs.asm"
.include "Utils/Controllers/controller_joypad.asm"

.ENUMID 0 EXPORT
; These are laid out Top to Bottom in ascending order.
.ENUMID MODESELECT_BUTTON_PROFILE
.ENUMID MODESELECT_BUTTON_VISUALIZER
.ENUMID MODESELECT_BUTTON_INFO
.ENUMID MODESELECT_BUTTON_COUNT


.STRUCT sUIContainer_ModeSelectControls
    ; This MUST go first.
    BaseContainerInstance       INSTANCEOF sUIContainerInstance

    .UNION
        UIButtons               INSTANCEOF sUIButtonInstance MODESELECT_BUTTON_COUNT
    .NEXTU
        ; Dependent on MODESELECT_BUTTON_* enum ordering.
        UIButton_Profile        INSTANCEOF sUIButtonInstance
        UIButton_Visualizer     INSTANCEOF sUIButtonInstance
        UIButton_Info           INSTANCEOF sUIButtonInstance
    .ENDU
.ENDST

.RAMSECTION "UI Container - Mode Select Toggles Instance" SLOT 3
    gUIContainer_ModeSelectControls  INSTANCEOF sUIContainer_ModeSelectControls
.ENDS

.SECTION "UI Container - Mode Select Controls" FREE
ModeSelectControlsContainer:
;==============================================================================
; ModeSelectControlsContainer@Init
; Initializes the song mode controls UI container.
; INPUTS:  IY:  Pointer to execute buffer
; OUTPUTS: IY:  Pointer to execute buffer
; Destroys IX, BC, DE, HL, A
;==============================================================================
@Init:
    ; Do the base init first.
    ld      ix, gUIContainer_ModeSelectControls
    ld      de, _ModeSelectControlsContainer@Descriptor
    call    UIContainer@Init

    ; Now each of our child buttons.
    ; VISUALIZER
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Visualizer
    ld      hl, ModeSelect_Container_UIDefs@VisualizerButton
    call    UIButton@Init

    ; PROFILER
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Profile
    ld      hl, ModeSelect_Container_UIDefs@ProfileButton
    call    UIButton@Init

    ; INFO
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Info
    ld      hl, ModeSelect_Container_UIDefs@InfoButton
    call    UIButton@Init

    ; Set each button visible and initial state.
    ; VISUALIZER
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Visualizer
    ld      a, BUTTON_STATE_NORMAL
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; PROFILER
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Profile
    ld      a, BUTTON_STATE_NORMAL
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; INFO
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Info
    ld      a, BUTTON_STATE_NORMAL
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ret


_ModeSelectControlsContainer:

.DSTRUCT @Descriptor INSTANCEOF sUIContainerDescriptor VALUES
    OnNav                           .DW @OnNav
    OnWidgetSelectionStatusChanged  .DW @OnWidgetSelectionStatusChanged
    OnUpdate                        .DW @OnUpdate
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
    ld      a, (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex)
    cp      UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    jr      nz, @@HaveWidgetToSelect
    ; Otherwise, pick one by default.
    ld      a, MODESELECT_BUTTON_INFO
    ld      (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex), a

@@HaveWidgetToSelect:
    ; Get the currently selected button from index in A
    call    @GetButtonFromIndex ; Gets the button into IX
    ld      a, BUTTON_STATE_SELECTED
    call    UIButton@SetButtonState

    ret

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
    ld  a, (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex)

    ; This is a re-entrant location.  For example, if the navigation flow is:
    ; A -> B -> C
    ; ...A is the current selection and the user presses Right.
    ; We start here with A, which checks to see if B is a valid target.  If B is
    ; disabled, we then try to check C.
@@OnNavAttempt:
    ; Which dir was it?
    bit CONTROLLER_JOYPAD_UP_BITPOS, b
    jr  z, @@Up
    bit CONTROLLER_JOYPAD_DOWN_BITPOS, b
    jr  z, @@Down
    bit CONTROLLER_JOYPAD_RIGHT_BITPOS, b
    jr  z, @@Right

    ; Fall through to Invalid Move.
@@InvalidMove:
    ; For an invalid move, we want to SET the carry
    ; AND set target index to UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    scf
    ld      c, UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    ret

@@Right:
    ; TODO:  Send it to the current mode window.
    ; Send it to the Player Controls selection, with NO specific control requested.
    ld      de, gUIContainer_PlayerControls
    ld      c, UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    and     a   ; Clear carry to indicate keep moving.
    ret

@@Down:
    ; Controls are set up top -> bottom in increasing order.
    inc     a
    ; Did we roll over?
    cp      MODESELECT_BUTTON_COUNT
    jr      c, @@CheckSelectable

    ; We were already on the bottom button.

    ; Send it to the Player Controls selection, with a specific control requested.
    ld      de, gUIContainer_PlayerControls
    ld      c, PLAYERCONTROLS_BUTTON_PLAYPAUSE
    and     a   ; Clear carry to indicate keep moving.
    ret

@@Up:
    ; Controls are set up top -> bottom in increasing order.
    dec     a
    ; Did we roll over?
    jp      p, @@CheckSelectable
    ; Yes.  Skip it.
    jr      @@InvalidMove

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
    ld      a, (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex)
    ; Is it selectable?
    call    @IsButtonSelectable
    jr      nc, @@@@ScanForFirstSelectable
    ; It was selectable, so use that.
    ld      c, a
    scf     ; Indicate success
    ret

@@@@ScanForFirstSelectable:
    ; Let's treat it as an up joypad input, starting on our bottommost selection.
    ld      a, MODESELECT_BUTTON_COUNT - 1   ; Last control index
    ld      b, 1 << CONTROLLER_JOYPAD_UP_BITPOS
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
    ld      (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex), a
    ld      b, BUTTON_STATE_SELECTED
    jr      @@HaveDesiredState


@OnUpdate:
    ret

;==============================================================================
; @IsButtonSelectable
; Returns whether a given button is selectable or disabled.
; INPUTS:  A:  Button index to test (MODESELECT_BUTTON_*)
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
; Returns pointer to button of the index passed in (MODESELECT_BUTTON_*).
; INPUTS:  A:  MODESELECT_BUTTON_* index value
; OUTPUTS: IX: Pointer to button, or $0000 if none selected
;          Sets Carry if index is invalid/UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
; Destroys A, IX, Carry
;==============================================================================
@GetButtonFromIndex:
    cp      MODESELECT_BUTTON_VISUALIZER
    jr      z, @@Visualizer
    cp      MODESELECT_BUTTON_PROFILE
    jr      z, @@Profile
    cp      MODESELECT_BUTTON_INFO
    jr      z, @@Info
    ; Otherwise failed.
    ld      ix, $0000
    scf
    ret
@@Visualizer:
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Visualizer
    and     a
    ret
@@Profile:
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Profile
    and     a
    ret
@@Info:
    ld      ix, gUIContainer_ModeSelectControls.UIButton_Info
    and     a
    ret
    
.ENDS
.ENDIF  ; __MODESELECT_CONTAINER_ASM__