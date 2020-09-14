.IFNDEF __UI_ASM__
.DEFINE __UI_ASM__

.ENUMID 0 EXPORT
.ENUMID UI_WIDGET_TYPE_CONTAINER
.ENUMID UI_WIDGET_TYPE_BUTTON
.ENUMID UI_WIDGET_TYPE_TOGGLE

.STRUCT sUIWidgetInstance
    ; One of UI_WIDGET_* enums
    UIWidgetType                    DB
    ; Pointer to an sWidgetContainerInstance (or NULL if none)
    pParentContainer                DW
.ENDST

.ENDIF  ;__UI_ASM__