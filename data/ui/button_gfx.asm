.IFNDEF __BUTTON_GFX_ASM__
.DEFINE __BUTTON_GFX_ASM__

.SECTION "Button Gfx - Profile 1bpp" FREE
; ((char - 32) * 3) + 7
ButtonGfx_Profile1bpp:
@Begin:
; P
.db $7C,$66,$66,$7C
.db $60,$60,$60,$00

; R
.db $7C,$66,$66,$7C
.db $6C,$66,$66,$00

; O
.db $3C,$66,$66,$66
.db $66,$66,$3C,$00

; F
.db $7E,$60,$60,$7C
.db $60,$60,$60,$00
@End:
.ENDS

.SECTION "Button Gfx - Visualizer 1bpp" FREE
ButtonGfx_Visualizer1bpp:
@Begin:
; V
.db $66,$66,$66,$66
.db $66,$3C,$18,$00

; I
.db $7E,$18,$18,$18
.db $18,$18,$7E,$00

; Z
.db $7E,$06,$0C,$18
.db $30,$60,$7E,$00

; .
.db $00,$00,$00,$00
.db $00,$18,$18,$00
@End:
.ENDS

.SECTION "Button Gfx - Info 1bpp" FREE
ButtonGfx_Info1bpp:
@Begin:
; I
.db $7E,$18,$18,$18
.db $18,$18,$7E,$00

; N
.db $66,$66,$76,$7E
.db $6E,$66,$66,$00

; F
.db $7E,$60,$60,$7C
.db $60,$60,$60,$00

; O
.db $3C,$66,$66,$66
.db $66,$66,$3C,$00
@End:
.ENDS

.SECTION "Button Gfx - Load Song 1bpp" FREE
ButtonGfx_LoadSong1bpp:
@Begin:
; L
.db $60,$60,$60,$60
.db $60,$60,$7E,$00

; O
.db $3C,$66,$66,$66
.db $66,$66,$3C,$00

; A
.db $3C,$66,$66,$7E
.db $66,$66,$66,$00

; D
.db $78,$6C,$66,$66
.db $66,$6C,$78,$00
@End:
.ENDS

.SECTION "Button Gfx - Play 1bpp" FREE
ButtonGfx_Play1bpp:
@Begin:
; P
.db $7C,$66,$66,$7C
.db $60,$60,$60,$00

; L
.db $60,$60,$60,$60
.db $60,$60,$7E,$00

; A
.db $3C,$66,$66,$7E
.db $66,$66,$66,$00

; Y
.db $66,$66,$66,$3C
.db $18,$18,$18,$00
@End:
.ENDS

.SECTION "Button Gfx - Pause 1bpp" FREE
ButtonGfx_Pause1bpp:
@Begin:
; P
.db $7C,$66,$66,$7C
.db $60,$60,$60,$00

; A
.db $3C,$66,$66,$7E
.db $66,$66,$66,$00

; U
.db $66,$66,$66,$66
.db $66,$66,$3C,$00

; S
.db $3C,$66,$60,$3C
.db $06,$66,$3C,$00
@End:
.ENDS

.SECTION "Button Gfx - Fade 1bpp" FREE
ButtonGfx_Fade1bpp:
@Begin:
; F
.db $7E,$60,$60,$7C
.db $60,$60,$60,$00

; A
.db $3C,$66,$66,$7E
.db $66,$66,$66,$00

; D
.db $78,$6C,$66,$66
.db $66,$6C,$78,$00

; E
.db $7E,$60,$60,$7C
.db $60,$60,$7E,$00
@End:
.ENDS

.SECTION "Button Gfx - Transpose 1bpp" FREE
ButtonGfx_Transpose1bpp:
@Begin:
; T
.db $7E,$18,$18,$18
.db $18,$18,$18,$00

; R
.db $7C,$66,$66,$7C
.db $6C,$66,$66,$00

; N
.db $66,$66,$76,$7E
.db $6E,$66,$66,$00

; S
.db $3C,$66,$60,$3C
.db $06,$66,$3C,$00

@End:
.ENDS


.ENDIF