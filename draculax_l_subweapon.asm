lorom

; Original at $849151:
;   jsl $848679
;
; Replace it with a jump to our code.
org $849151
    autoclean jml remap_subweapon_button

freecode

remap_subweapon_button:
    ; If L was newly pressed, use the subweapon.
    lda $28
    bit #$0010
    bne .use_subweapon

    ; Otherwise run the original input helper.
    jsl $848679

    ; If the original result was Up+Y/subweapon,
    ; replace it with Y-only behavior instead.
    cmp #$000C
    bne .continue_normally

    lda #$0004

.continue_normally:
    jml $849155

.use_subweapon:
    jml $8491A6