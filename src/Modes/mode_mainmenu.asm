.include "Actions/action_upload_vramdata.asm"
.include "Managers/inputmanager.asm"
.include "Managers/modemanager.asm"
.include "Managers/vdpmanager.asm"
.include "Modules/debounce_module.asm"
.include "Modules/execute_buffer.asm"
.include "Modules/profiler_module.asm"
.include "UI/modeselect_container.asm"
.include "UI/playercontrols_container.asm"
.include "Utils/macros.asm"
.include "Utils/tile_routines.asm"

.include "../data/fonts/default_font.asm"
.include "../data/screens/main_menu_data.asm"
.include "../data/ui/button_gfx.asm"

.STRUCT sMainMenuScreen
    ; Module used to ensure the player releases buttons before we accept input from them.
    Controller1DebounceModule   INSTANCEOF sDebounceModule_Instance

    ; What graphics commands do we intend to execute?
    ExecuteBufferDescriptor     INSTANCEOF sExecuteBufferDescriptor
    ExecuteBufferMemory         DSB 128 ; Bytes of RAM for the Execute Buffer

    ; Temp action for the execute buffer (re-useable)
    .UNION
        TempUploadStringAction      INSTANCEOF sAction_UploadString_Indirect
    .NEXTU
        TempUpload1bppAction        INSTANCEOF sAction_Upload1bppToVRAM_Implicit
    .ENDU

    ; Which of our containers is currently selected?
    pCurrContainerSelection     DW

    ; Create a profiler for each section
    ProfilerUpdate              INSTANCEOF sProfilerInstance
    ProfilerRenderPrep          INSTANCEOF sProfilerInstance
    ProfilerVBlank              INSTANCEOF sProfilerInstance
.ENDST

.RAMSECTION "Mode - Main Menu Screen Context" SLOT 3
    gMainMenuScreen INSTANCEOF sMainMenuScreen
.ENDS

.SECTION "Mode - Main Menu" FREE

; What line do we start rendering the profiling info at?
.DEFINE MAIN_MENU_PROFILER_HBLANK_LINE      100

; Public
ModeMainMenu:

.DSTRUCT @Definition INSTANCEOF sApplicationMode VALUES:
    VideoInterruptJumpTarget    .DW _ModeMainMenu@InterruptHandler  ; Called when a video interrupt (V/HBlank) occurs.
    OnActive                    .DW _ModeMainMenu@OnActive          ; Called when this mode is made active (pushed, old one above popped, etc.)

    OnNMI                       .DW _ModeMainMenu@DoNothing         ; Called when a non-maskable interrupt (NMI) comes in.
    OnInactive                  .DW _ModeMainMenu@DoNothing         ; Called when this mode goes inactive (popped, new mode pushed on, etc.)
    OnUpdate                    .DW _ModeMainMenu@OnUpdate          ; Called when the application wants to update.
    OnRenderPrep                .DW _ModeMainMenu@OnRenderPrep      ; Called when the application is prepping things for render.
    OnEvent                     .DW _ModeMainMenu@DoNothing         ; Called when a generic event occurs.
.ENDST

; Private
_ModeMainMenu:

@DoNothing:
    ; Do nothing.
    ret

@OnActive:
    ; Clear everything and start anew.

    ; Turn off the display and interrupts while we do graphics things.

    di
    ; Turn off the display & VBlanks by OR'ing to the current value.
    ld      a, (gVDPManager.Registers.VideoModeControl2)
    and     ~(VDP_REGISTER1_ENABLE_DISPLAY | VDP_REGISTER1_ENABLE_VBLANK)
    ld      e, VDP_COMMMAND_MASK_REGISTER1
    call    VDPManager_WriteRegisterImmediate

    ; Set our border color palette entry.
    ld      a, MAIN_MENU_BORDER_PAL_ENTRY & $0F
    ld      e, VDP_COMMMAND_MASK_REGISTER7
    call    VDPManager_WriteRegisterImmediate

    ; Default us to joypad 1 active.
    xor     a                               ; 0 == Port 1
    ld      b, CONTROLLER_TYPE_SMS_JOYPAD
    ld      hl, Controller_Joypad_Port1_State
    call    InputManager_SetController

    ; Clear the nametable
    call ClearNameTable

    ; Init our execute buffer
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    ld      de, gMainMenuScreen.ExecuteBufferMemory          ; Loc of buffer
    ld      bc, _sizeof_gMainMenuScreen.ExecuteBufferMemory  ; How big it is.
    call    ExecuteBuffer_Init

    ; Upload the font.
    ld      hl, $0020   ; Dest tile index
    CALC_VRAM_LOC_FOR_TILE_INDEX_IN_HL
    SET_VRAM_WRITE_LOC_FROM_HL
    ld      hl, DefaultFont_1bpp_Data@Begin                  ; Src data
    ld      bc, DefaultFont_1bpp_Data@End - DefaultFont_1bpp_Data@Begin ; Length of data
    ld      e, $00                                          ; Palette entry for 0s in 1bpp data
    ld      d, $01                                          ; Palette entry for 1s in 1bpp data
    call    Tile_Upload1BPPWithPaletteRemaps_VRAMPtrSet

    ; Upload the palette
    ld      b, (Mode_MainMenu_Data@Palette@End - Mode_MainMenu_Data@Palette) >> 1           ; #/entries (2 bytes per entry)
    ld      hl, Mode_MainMenu_Data@Palette
-:
    ld      e, (hl)     ; Get entry
    inc     hl
    ld      c, (hl)     ; Get color value
    inc     hl
    push    hl
    call    VDPManager_SetPaletteEntryImmediate
    pop     hl
    djnz    -

    ; Upload all the screen data.

    ; Title string
    ; Position should be center - len / 2.
    ld      e, 16 - ( ( Mode_MainMenu_Data@Strings@Title@End - Mode_MainMenu_Data@Strings@Title ) / 2 )   ; Col
    ld      d, 1    ; Row
    
    ld      b, Mode_MainMenu_Data@Strings@Title@End - Mode_MainMenu_Data@Strings@Title  ; Len
    ld      c, $00  ; Common attributes
    ld      hl, Mode_MainMenu_Data@Strings@Title
    call    VDP_UploadStringToNameTable

    ; Instructions 1
    ; Position should be center - len / 2.
    ld      e, 16 - ( ( Mode_MainMenu_Data@Strings@Instructions1@End - Mode_MainMenu_Data@Strings@Instructions1 ) / 2 )   ; Col
    ld      d, 21    ; Row
    
    ld      b, Mode_MainMenu_Data@Strings@Instructions1@End - Mode_MainMenu_Data@Strings@Instructions1  ; Len
    ld      c, $00  ; Common attributes
    ld      hl, Mode_MainMenu_Data@Strings@Instructions1
    call    VDP_UploadStringToNameTable

    ; Instructions 2
    ; Position should be center - len / 2.
    ld      e, 16 - ( ( Mode_MainMenu_Data@Strings@Instructions2@End - Mode_MainMenu_Data@Strings@Instructions2 ) / 2 )   ; Col
    ld      d, 22    ; Row
    
    ld      b, Mode_MainMenu_Data@Strings@Instructions2@End - Mode_MainMenu_Data@Strings@Instructions2  ; Len
    ld      c, $00  ; Common attributes
    ld      hl, Mode_MainMenu_Data@Strings@Instructions2
    call    VDP_UploadStringToNameTable

    ; Init the Mode Select Controls Container
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    call    ModeSelectControlsContainer@Init

    ; Init the Song Player Controls Container
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    call    PlayerControlsContainer@Init

    ; Start our UI for the initial selection.
    ld      ix, gUIContainer_PlayerControls
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    ld      c, PLAYERCONTROLS_BUTTON_PLAYPAUSE
    ld      b, 1    ; Indicate selection
    ld      (gMainMenuScreen.pCurrContainerSelection), ix
    call    UIContainer@OnWidgetSelectionStatusChanged

    ; With all of our graphical changes queued, go ahead and flush the execute buffer.
    ; Execute the execute buffer
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    call    ExecuteBuffer_Execute

    ; Reset the execute buffer
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
    call    ExecuteBuffer_Reset

    ; Make sure we're not reading input until all controls are released.
    call @SetupForDebounce

    ; We're ready to roll.  Turn on interrupts and the screen.

    ; Indicate that we want HBlank Interrupts.
    ld      a, MAIN_MENU_PROFILER_HBLANK_LINE
    ld      e, VDP_COMMMAND_MASK_REGISTER10
    call    VDPManager_WriteRegisterImmediate

    ld      a, (gVDPManager.Registers.VideoModeControl1)
    or      VDP_REGISTER0_ENABLE_HBLANK
    ld      e, VDP_COMMMAND_MASK_REGISTER0
    call    VDPManager_WriteRegisterImmediate

    ; Read the status port so that we don't immediately get an interrupt
    ; after turning them on.
    in      a, (VDP_STATUS_PORT)

    ; Turn on the display and indicate that we want VBlank interrupts, 
    ; by OR'ing to the current value.
    ld      a, (gVDPManager.Registers.VideoModeControl2)
    or      VDP_REGISTER1_ENABLE_DISPLAY | VDP_REGISTER1_ENABLE_VBLANK
    ld      e, VDP_COMMMAND_MASK_REGISTER1
    call    VDPManager_WriteRegisterImmediate

    ei

    ret

@OnUpdate:
    ; Start our profiler.
    ld      hl, gMainMenuScreen.ProfilerUpdate
    call    ProfilerModule@Begin

    ; Read input.
    call    InputManager_OnUpdate

    ; Get current val from Controller 1
    ld      a, (gInputManager.Controller1.Joypad.Data.CurrentButtons)
    ld      (gMainMenuScreen.Controller1DebounceModule.CurrentVal), a

    ; Check to see if we've already debounced.
    ld      ix, gMainMenuScreen.Controller1DebounceModule.DebounceFSM
    call    FSM_IX@OnUpdate
    call    DebounceModule@IsDebounced
    jr      nz, @@InputCheckComplete    ; If NZ, that means we're not yet debounced.

    ; We're debounced.  See if any inputs were pressed.
    ld      a, (gMainMenuScreen.Controller1DebounceModule.CurrentVal)
    ld      b, CONTROLLER_JOYPAD_UP_RELEASED | CONTROLLER_JOYPAD_DOWN_RELEASED | CONTROLLER_JOYPAD_LEFT_RELEASED | CONTROLLER_JOYPAD_RIGHT_RELEASED | CONTROLLER_JOYPAD_BUTTON1_RELEASED | CONTROLLER_JOYPAD_BUTTON2_RELEASED
    and     b
    cp      b
    jr      z, @@InputCheckComplete     ; If Z, no controller inputs are pressed.

    ; Start with assumption that we're not throwing input from another container.
    ld      de, $0000
    ; Our temp container will be our current one to start with.
    ld      ix, (gMainMenuScreen.pCurrContainerSelection)
    ; ...and that no specific index has been requested.
    ld      c, UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
@@ContainerHandleNav:
    ; Pass the inputs on to the currently selected container.
    ld      a, (gMainMenuScreen.Controller1DebounceModule.CurrentVal)
    ld      b, a
    call    UIContainer@OnNav
    ; If carry is set, then we don't need to throw the nav attempt to anyone else.
    jr      c, @@NavDetermined
    ; Nav not determined.  Lets throw it to the next container to try and resolve it.
    ; DE == container to throw to.  C == specific control requested, if any.
    push    de
    push    ix
    pop     de      ; DE = old container
    pop     ix      ; IX = new container to throw to.
    jr      @@ContainerHandleNav

@@NavDetermined:
    ; Was the move valid?
    ld      a, c
    cp      UI_CONTAINER_NO_WIDGET_SELECTED_INDEX
    jr      z, @@NavResolved
    ; Move was valid.
    ld      iy, gMainMenuScreen.ExecuteBufferDescriptor ; Get the execute buffer for gfx changes.
    push    bc  ; Preserve the new choice index
        ;**************************************************************************
        ; Unselect old choice
        ;**************************************************************************
        push    ix
            ld      ix, (gMainMenuScreen.pCurrContainerSelection)
            ld      c, (ix + sUIContainerInstance.CurrSelectedWidgetIndex)
            ld      b, 0   ; B == 0:  Unselect it.
            call    UIContainer@OnWidgetSelectionStatusChanged
        pop     ix
        ; Store new container as currently-selected one
        ld      (gMainMenuScreen.pCurrContainerSelection), ix
    pop     bc  ; Get the selection choice back into C
    ; Select new choice
    ld      b, 1    ; If B is NZ, it means to select it.
    call    UIContainer@OnWidgetSelectionStatusChanged

@@NavResolved:
    ; Now debounce the controller
    call    @SetupForDebounce

@@InputCheckComplete:

    ; End our profiler.
    ld      hl, gMainMenuScreen.ProfilerUpdate
    call    ProfilerModule@End
    ret

@OnRenderPrep:
    ; Start our profiler.
    ld      hl, gMainMenuScreen.ProfilerRenderPrep
    call    ProfilerModule@Begin

    ; End our profiler.
    ld      hl, gMainMenuScreen.ProfilerRenderPrep
    call    ProfilerModule@End

    ; Wait for VBL.
    ld      a, 1
    ld      (gWatitingForVBlank), a

    ret

@RenderProfile:
    ; Render our profilers as sections of the overscan/border area.

    ; VBlank
    ld      hl, gMainMenuScreen.ProfilerVBlank
    call    ProfilerModule@GetElapsed
    ld      b, a    ; #/lines
    ld      c, MAIN_MENU_PROFILER_PAL_ENTRY_VBLANK & $0F
    call    @RenderInOverscan

    ; Update
    ld      hl, gMainMenuScreen.ProfilerUpdate
    call    ProfilerModule@GetElapsed
    ld      b, a    ; #/lines
    ld      c, MAIN_MENU_PROFILER_PAL_ENTRY_UPDATE  & $0F
    call    @RenderInOverscan

    ; RenderPrep
    ld      hl, gMainMenuScreen.ProfilerRenderPrep
    call    ProfilerModule@GetElapsed
    ld      b, a    ; #/lines
    ld      c, MAIN_MENU_PROFILER_PAL_ENTRY_RENDER_PREP & $0F
    call    @RenderInOverscan

    ; Done; revert to the cleared color.
    ld      b, 0
    ld      c, MAIN_MENU_BORDER_PAL_ENTRY & $0F
    call    @RenderInOverscan

    ret

@InterruptHandler:
    PUSH_ALL_REGS
        in      a, (VDP_STATUS_PORT)                ; Satisfy the interrupt
        ; Is this a VBlank or an HBlank?
        add     a, a                                ; Left shift one (faster than bit 7, a)
        jr      c, @@VBlank
@@HBlank:
        call    @RenderProfile
    POP_ALL_REGS
    ret

@@VBlank:
        ; Start our profiler.
        ld      hl, gMainMenuScreen.ProfilerVBlank
        call    ProfilerModule@Begin

        ; Execute the execute buffer
        ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
        call    ExecuteBuffer_Execute

        ; Reset the execute buffer
        ld      iy, gMainMenuScreen.ExecuteBufferDescriptor
        call    ExecuteBuffer_Reset

        ; End our profiler.
        ld      hl, gMainMenuScreen.ProfilerVBlank
        call    ProfilerModule@End

        ; No longer waiting for VBlank.
        xor     a
        ld      (gWatitingForVBlank), a
    POP_ALL_REGS
    ret

;==============================================================================
; After an input is detected, sets up to ensure no other inputs are
; processed until all are released.
;==============================================================================
@SetupForDebounce:
    ; **** SETUP DEBOUNCE MODULE FOR CONTROLLER 1 ****
    ; Setup our debounce module to ensure the player releases buttons before we accept input.

    ; Set the params    
    ld      hl, Mode_MainMenu_Data@DebounceParams
    ld      (gMainMenuScreen.Controller1DebounceModule.DebounceParams), hl

    ; Get current val from Controller 1
    ld      a, (gInputManager.Controller1.Joypad.Data.CurrentButtons)
    ld      (gMainMenuScreen.Controller1DebounceModule.CurrentVal), a

    ; Init the FSM
    ld      hl, DebounceModule@WaitForDebounceState
    ld      ix, gMainMenuScreen.Controller1DebounceModule.DebounceFSM
    call    FSM_IX@Init

    ret

;==============================================================================
; @RenderInOverscan
; Renders a color in the overscan area (border) for the specified #/lines.
; INPUTS:   B: #/lines to draw for (0 == 1 line)
;           C: Palette entry
; OUTPUTS: None
; Destroys Everything
;==============================================================================
@RenderInOverscan:
    ; Wait for a new line.
    in      a, (VDP_VCOUNTER_PORT)
    ld      d, a
-:
    in      a, (VDP_VCOUNTER_PORT)
    cp      d
    jr      z, -

    ; New line just started.
    ld      d, a    ; Hold onto current line

    ; Set our border color palette entry.
    ld      a, c
    ld      e, VDP_COMMMAND_MASK_REGISTER7
    call    VDPManager_WriteRegisterImmediate

    ; Loop waiting for the duration.
-:
    ld      a, b
    and     a
    ret     z       ; If done with lines, get out.

--:
    in      a, (VDP_VCOUNTER_PORT)
    cp      d
    jr      z, --   ; Wait until it changes

    ; Store new line as current.
    ld      d, a
    dec     b
    jr      -

.ENDS
