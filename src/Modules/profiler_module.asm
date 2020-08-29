.IFNDEF __PROFILER_MODULE_ASM__
.DEFINE __PROFILER_MODULE_ASM__

.INCLUDE "Utils/vdp.asm"

.SECTION "Profiler Module" FREE

.STRUCT sProfilerInstance
    StartVCount     DB
    EndVCount       DB
.ENDST

ProfilerModule:
;==============================================================================
; ProfilerModule@Begin
; Records the VCounter at start of a profile
; INPUTS:  HL: Pointer to sProfilerInstance
; OUTPUTS: None
; Destroys A
;==============================================================================
@Begin:
    in      a, (VDP_VCOUNTER_PORT)
    ld      (hl), a
    ret

;==============================================================================
; ProfilerModule@End
; Records the VCounter at end of a profile
; INPUTS:  HL: Pointer to sProfilerInstance
; OUTPUTS: None
; Destroys A
;==============================================================================
@End:
    in      a, (VDP_VCOUNTER_PORT)
    inc     hl          ; Move to EndVCount
    ld      (hl), a
    dec     hl          ; ...and back
    ret

;==============================================================================
; ProfilerModule@GetElapsed
; Returns the amount of time between start and end
; TODO:  Does not currently take into account the deltas due going from
; Active display -> VBlank, or when End < Start.
; INPUTS:  HL: Pointer to sProfilerInstance
; OUTPUTS: A:  Delta between start and end.
; Destroys None
;==============================================================================
@GetElapsed:
    inc     hl          ; Move to EndVCount
    ld      a, (hl)     ; Get end time
    dec     hl          ; Back to StartVCount
    sub     (hl)        ; A = End - Start
    ret

.ENDS

.ENDIF  ; __PROFILER_MODULE_ASM__