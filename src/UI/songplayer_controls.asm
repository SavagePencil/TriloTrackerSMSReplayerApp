.IFNDEF __SONGPLAYER_CONTROLS_ASM__
.DEFINE __SONGPLAYER_CONTROLS_ASM__

.INCLUDE "Modules/ui_button.asm"
.INCLUDE "Modules/ui_container.asm"
.include "../data/ui/button_gfx.asm"


.STRUCT sUIContainer_SongPlayerControls
    ; This MUST go first.
    BaseContainerInstance       INSTANCEOF sUIContainerInstance

    UIButton_PlayPause          INSTANCEOF sUIButtonInstance
    UIButton_Fade               INSTANCEOF sUIButtonInstance
    UIButton_Transpose          INSTANCEOF sUIButtonInstance
.ENDST

.RAMSECTION "UI Container - Song Player Controls Instance" SLOT 3
    gUIContainer_PlayerControls  INSTANCEOF sUIContainer_SongPlayerControls
.ENDS

.SECTION "UI Container - Song Player Controls" FREE
SongPlayerControls:
;==============================================================================
; SongPlayerControls@Init
; Initializes the song player controls UI container.
; INPUTS:  IY:  Pointer to execute buffer
; OUTPUTS: IY:  Pointer to execute buffer
; Destroys IX, BC, DE, HL, A
;==============================================================================
@Init:
    ; Do the base init first.
    ld      ix, gUIContainer_PlayerControls
    ld      de, _SongPlayerControls@Descriptor
    call    UIContainer@Init

    ; Now each of our child buttons.

    ; PLAYPAUSE (starts as Play)
    ld      ix, gUIContainer_PlayerControls.UIButton_PlayPause
    ld      hl, Mode_MainMenu_Data@UIButtons@PlayButton
    call    UIButton@Init

    ; FADE
    ld      ix, gUIContainer_PlayerControls.UIButton_Fade
    ld      hl, Mode_MainMenu_Data@UIButtons@FadeButton
    call    UIButton@Init

    ; TRANSPOSE
    ld      ix, gUIContainer_PlayerControls.UIButton_Transpose
    ld      hl, Mode_MainMenu_Data@UIButtons@TransposeButton
    call    UIButton@Init

    ; Set each button visible and initial state.
    ; PLAYPAUSE
    ld      ix, gUIContainer_PlayerControls.UIButton_PlayPause
    ld      a, BUTTON_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; FADE
    ld      ix, gUIContainer_PlayerControls.UIButton_Fade
    ld      a, BUTTON_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ; TRANSPOSE
    ld      ix, gUIContainer_PlayerControls.UIButton_Transpose
    ld      a, BUTTON_DISABLED
    call    UIButton@SetButtonState
    call    UIButton@SetVisible

    ret


_SongPlayerControls:
.DSTRUCT @Descriptor INSTANCEOF sUIContainerDescriptor VALUES
    OnSetSelected       .DW @OnSetSelected
    OnNav               .DW @OnNav
    OnUpdate            .DW @OnUpdate
.ENDST

;==============================================================================
; @OnSetSelected
; Makes the given widget the selected one.  A container may have memory of
; which control was last selected, and select it, or it may override to a
; default.
; INPUTS:  None
; OUTPUTS: None
; Destroys TODO
;==============================================================================
@OnSetSelected:
    ; Did we have a button selected before?
    ld      hl, (gUIContainer_PlayerControls.BaseContainerInstance.pCurrSelectedWidget)
    ld      de, $0000
    and     a
    sbc     hl, de
    jr      nz, @@HaveWidgetToSelect
    ; Otherwise, pick one by default.
    ld      hl, gUIContainer_PlayerControls.UIButton_PlayPause
@@HaveWidgetToSelect:
    push    hl
    pop     ix
    ld      a, BUTTON_SELECTED
    call    UIButton@SetButtonState

    ret

@OnNav:
    ret

@OnUpdate:
    ret

;==============================================================================
; SongPlayerControls@IsButtonSelectable
; Returns whether a given button is selectable or disabled.
; INPUTS:  DE:  Button to test
; OUTPUTS: Sets Carry if button is selectable, otherwise disabled.
; Destroys TODO
;==============================================================================
@IsButtonSelectable:
    ;TODO query if a song is either playing or loaded into memory.
    scf     ; Sure.
    ret

;==============================================================================
; SongPlayerControls@IsPlayPause_InPlayState
; Returns whether the PlayPause button should be in Play state, or Pause state
; INPUTS:  None
; OUTPUTS: Sets Carry if button should be Play mode, otherwise Pause.
; Destroys TODO
;==============================================================================
@IsPlayPause_InPlayState:
    ;TODO query if a song is playing.
    scf     ; Sure.
    ret

.ENDS
.ENDIF  ; __SONGPLAYER_CONTROLS_ASM__