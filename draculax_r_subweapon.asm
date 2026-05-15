lorom

org $848679
    autoclean jml remap_subweapon_helper

freecode

remap_subweapon_helper:
    ; R newly pressed?
    ; Use combined newly-pressed input instead of raw $28.
    lda $2e
    bit #$0010
    bne .r_subweapon

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
    ; Only suppress actual Up+Y, not every helper result $000C.
    cmp #$000c
    bne .return

    ; Was Y newly pressed?
    lda $2e
    bit #$4000
    beq .return_0c

    ; Is Up currently held?
    lda $26
    bit #$0800
    beq .return_0c

    ; Treat Up+Y as plain Y.
    lda #$0004
    rtl

.return_0c:
    lda #$000c
    rtl

.l_subweapon:
    lda #$000c

.return:
    rtl