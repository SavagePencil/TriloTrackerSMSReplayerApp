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
.ENUMID MODESELECT_BUTTON_LOADSONG
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
        UIButton_LoadSong       INSTANCEOF sUIButtonInstance
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

    ; LOAD SONG
    ld      ix, gUIContainer_ModeSelectControls.UIButton_LoadSong
    ld      hl, ModeSelect_Container_UIDefs@LoadSongButton
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

    ; LOAD SONG
    ld      ix, gUIContainer_ModeSelectControls.UIButton_LoadSong
    ld      a, BUTTON_STATE_NORMAL
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ret


_ModeSelectControlsContainer:

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
    ld      a, (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex)
    cp      UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    jr      nz, @@HaveWidgetToSelect
    ; Otherwise, pick one by default.
    ld      a, MODESELECT_BUTTON_LOADSONG
    ld      (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex), a

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

    ; Ignore.  Clear carry.
@@IgnoreInput:
    and     a
    ret

@@Right:
    ; TODO:  Send it to the current mode window.
    scf
    ret

@@Down:
    ; Controls are set up top -> bottom in increasing order.
    inc     a
    ; Did we roll over?
    cp      MODESELECT_BUTTON_COUNT
    jr      c, @@CheckSelectable

    ; We were already on the bottom button.
    ; Return it to its proper state first.
    push    af
        dec     a                   ; Back to previous
        call    @GetButtonFromIndex ; Gets the button into IX
        ld      a, BUTTON_STATE_NORMAL
        call    UIButton@SetButtonState
    pop     af

    ; Send it to the Player Controls container.
    ld      de, gUIContainer_PlayerControls
    scf
    ret

@@Up:
    ; Controls are set up top -> bottom in increasing order.
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
        ld  a, (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex)

        ; Get the currently selected button from index in A
        call    @GetButtonFromIndex ; Gets the button into IX
        ld      a, BUTTON_STATE_NORMAL
        call    UIButton@SetButtonState
    pop     af

    ; Now turn on the new selection.
    ld      (gUIContainer_ModeSelectControls.BaseContainerInstance.CurrSelectedWidgetIndex), a
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
    cp      MODESELECT_BUTTON_LOADSONG
    jr      z, @@LoadSong
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
@@LoadSong:
    ld      ix, gUIContainer_ModeSelectControls.UIButton_LoadSong
    and     a
    ret
    
.ENDS
.ENDIF  ; __MODESELECT_CONTAINER_ASM__