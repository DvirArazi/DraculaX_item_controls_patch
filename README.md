# Dracula X L-Button Sub-Weapon Patch

## Overview

ROM hack for **Castlevania: Dracula X** on the SNES that changes sub-weapon throw from `Up + Y` to `L`.

## How to Apply the Patch

Use a patching tool such as [Floating IPS](https://www.romhacking.net/utilities/1040/).

1. Open Floating IPS.
2. Choose **Apply Patch**.
3. Select the `.bps` patch file from this repository.
4. Select your clean original ROM.
5. Save the patched ROM.
6. Load the patched ROM in your emulator.

Known tested target:

```text
Castlevania - Dracula X (USA).sfc
```

## How to Build the Patch

This patch is written for **Asar**.

To apply the ASM patch manually:
```bash
cp "Castlevania - Dracula X (USA).sfc" "Castlevania - Dracula X (USA) [patched].sfc"
asar draculax_l_subweapon.asm "Castlevania - Dracula X (USA) [patched].sfc"
```

To create a distributable `.bps` patch afterward, use Floating IPS:

1. Choose **Create Patch**.
2. Select the clean original ROM.
3. Select the patched ROM.
4. Save the resulting `.bps` file.

## Motivation

In the original game, sub-weapons are used with `Up + Y`.

This can be awkward on stairs since pressing `Up` affects the player's facing direction, which makes using a sub-weapon when facing the descending direction of the stairs unreliable.

This patch moves sub-weapon usage to the unused `L` button to mitigate this.

## Technical Notes

The patch hijacks the input-to-action helper at:

```text
$848679
```

This helper normally converts the game's processed input value at `$9C` into an action-table index.

Relevant RAM values discovered during debugging:

```text
$20/$21 = currently held buttons
$28/$29 = newly pressed buttons
$26/$27 = combined currently held buttons
$2E/$2F = combined newly pressed buttons
```

The relevant button values are:

```text
Y newly pressed = $4000
Up held         = $0800
L newly pressed = $0010
```

The original `Up + Y` sub-weapon input maps to helper result:

```text
$000C
```

Normal `Y` attack maps to:

```text
$0004
```

The patch changes the helper behavior so that:

```c
if (L was newly pressed) {
    return 0x000C; // sub-weapon action
}

if (the helper result is 0x000C
    && Y was newly pressed
    && Up is currently held) {
    return 0x0004; // treat original Up+Y like normal Y
}

return original_helper_result;
```

This avoids faking `Up` input globally, which is important because the goal is to prevent stair-direction issues rather than reproduce them through remapped input.

The patch was developed and tested using:

- bsnes-plus
- RetroArch cheat search
- Asar
- Floating IPS
