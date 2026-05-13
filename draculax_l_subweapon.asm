lorom

; Hijack the common input-to-action-index helper.
; Original helper begins at $848679.
org $848679
    autoclean jml remap_subweapon_helper

freecode

remap_subweapon_helper:
    ; L newly pressed?
    ; You confirmed this appears as $28 bit $0010.
    lda $28
    bit #$0010
    bne .l_subweapon

    ; Original helper logic:
    lda $9c
    lsr
    lsr
    lsr
    and #$001e
    cmp #$0010
    bcc .after_clamp
    lda #$0010

.after_clamp:
    ; Original Up+Y gives helper result $000C.
    ; Replace that with normal Y result $0004.
    cmp #$000c
    bne .return
    lda #$0004
    rtl

.l_subweapon:
    lda #$000c

.return:
    rtl