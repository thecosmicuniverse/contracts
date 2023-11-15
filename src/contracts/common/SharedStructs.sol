// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface SharedStructs {
    enum Rarity {
        Common,
        Uncommon,
        Rare,
        Mythical,
        Legendary
    }
    enum Profession {
        Alchemy,
        Architecture,
        Carpentry,
        Cooking,
        CrystalExtraction,
        Farming,
        Fishing,
        GemCutting,
        Herbalism,
        Mining,
        Tailoring,
        Woodcutting
    }
}