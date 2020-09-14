.IFNDEF __SONGPLAYER_CONTROLS_ASM__
.DEFINE __SONGPLAYER_CONTROLS_ASM__

.INCLUDE "Modules/ui.asm"
.INCLUDE "Modules/ui_button.asm"
.INCLUDE "Modules/ui_container.asm"
.include "../data/ui/button_gfx.asm"


.STRUCT sUIContainer_SongPlayerControls
    ; This MUST go first.
    BaseContainerInstance       INSTANCEOF sUIContainerInstance

    UIButton_Play               INSTANCEOF sUIButtonInstance
    UIButton_Pause              INSTANCEOF sUIButtonInstance
    UIButton_Fade               INSTANCEOF sUIButtonInstance
    UIButton_Transpose          INSTANCEOF sUIButtonInstance
.ENDST

.SECTION "UI Container - Song Player Controls" FREE
SongPlayerControls:
;==============================================================================
; SongPlayerControls@Init
; Initializes the song player controls UI container.
; INPUTS:  IX:  Pointer to sUIContainer_SongPlayerControls
;          IY:  Pointer to execute buffer
; OUTPUTS: None
; Destroys TODO
;==============================================================================
@Init:
    ; Do the base init first.
    ld      hl, $0000   ; No parent container
    ld      de, _SongPlayerControls@Descriptor
    call    UIContainer@Init

    ; Now each of our child buttons.
.MACRO CREATE_BUTTON ARGS BUTTON_INSTANCE_OFFSET, BUTTON_DATA, INITIAL_BUTTON_STATE
    push    ix
        push    ix
        pop     de

        ; DE holds pointer to container.
        ld      ix, BUTTON_INSTANCE_OFFSET
        add     ix, de  ; IX points to button

        ld      hl, BUTTON_DATA

        ld      a, INITIAL_BUTTON_STATE
        call    UIButton@Init
        call    UIButton@SetVisible
    pop     ix
.ENDM
    CREATE_BUTTON sUIContainer_SongPlayerControls.UIButton_Play,        Mode_MainMenu_Data@UIButtons@PlayButton, BUTTON_NORMAL
    CREATE_BUTTON sUIContainer_SongPlayerControls.UIButton_Fade,        Mode_MainMenu_Data@UIButtons@FadeButton, BUTTON_NORMAL
    CREATE_BUTTON sUIContainer_SongPlayerControls.UIButton_Transpose,   Mode_MainMenu_Data@UIButtons@TransposeButton, BUTTON_NORMAL
.UNDEF CREATE_BUTTON
    ret


_SongPlayerControls:
.DSTRUCT @Descriptor INSTANCEOF sUIContainerDescriptor VALUES
    OnSetSelected       .DW @OnSetSelected
    OnNav               .DW @OnNav
    OnUpdate            .DW @OnUpdate
.ENDST

@OnSetSelected:
    ret

@OnNav:
    ret

@OnUpdate:
    ret

.ENDS
.ENDIF  ; __SONGPLAYER_CONTROLS_ASM__