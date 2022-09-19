const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const fs = require('fs');
require("dotenv").config()

const badgeInfo = {
  badgeOfHonor: {
    id: 0,
    name: "Badge of Honor",
    description: "The rarest and most prized badge in the cosmic realm"
  },
  badgeOfCourage: {
    id: 1,
    name: "Badge of Courage",
    description: "Indicates true courage to venture into unexplored lands"
  },
  badgeOfAdventure: {
    id: 2,
    name: "Badge of Adventure",
    description: "Possessed by a true explorer and used to gain entry into new realms"
  },
  speedRunnerBadge: {
    id: 3,
    name: "Speedrunner Badge",
    description: "Allows the player to race across land at exceptional speed"
  },
  energyBadge: {
    id: 4,
    name: "Energy Badge",
    description: "Restores energy without the need to meditate"
  },
  powerUpBadge: {
    id: 5,
    name: "Power-Up Badge",
    description: "Restores 50% of energy without the need to meditate"
  },
  timeCrystal: {
    id: 6,
    name: "Time Crystal",
    description: "Accelerates the build time of any structure by 10x"
  }
}

const badgeOwners = {
  badgeOfHonor: [
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 1
    },
    {
      "address": "0xca9d4e6372f9a44d4a7eaf62124f7432bff24d17",
      "count": 1
    },
    {
      "address": "0xb13b9e1c8c15f789795b4a3cdfbb172e37673208",
      "count": 1
    },
    {
      "address": "0x833a4a119c1195b4ac1c7f1471152de8b65a3ef5",
      "count": 1
    },
    {
      "address": "0x59d0fedd82fbe01b04b92afc8900d56c24d0fad1",
      "count": 1
    },
    {
      "address": "0xfa0f82f943393651b8d902523e57db1336305c41",
      "count": 1
    },
    {
      "address": "0x2cf9de17288446eaa9a41a192767d1d046868a57",
      "count": 1
    },
    {
      "address": "0x5c57fec3e02e5b64f8c3b47b39942ef682e51459",
      "count": 1
    },
    {
      "address": "0x2d2e638299bc57b90a93a46c10de2d6cf0c90690",
      "count": 1
    },
    {
      "address": "0xe680ba443942b363046e2ccfc286ad6404014eb3",
      "count": 1
    },
    {
      "address": "0x72a773aadc0e928c9248ae71260120e6e73bd447",
      "count": 1
    },
    {
      "address": "0xd0458b0fe631c04ea1ce7ab75f3bffd2c6d69e29",
      "count": 1
    },
    {
      "address": "0x348d391e6576048332b9ab44a7bd29b1565eebe3",
      "count": 1
    }
  ],
  badgeOfCourage: [
    {
      "address": "0xb88d5496411b41e69ac7e49b013a5da6447acce6",
      "count": 1
    },
    {
      "address": "0x224f1db94d4c9498d28d186d677aba53bd353c4d",
      "count": 1
    },
    {
      "address": "0x87dd9282247d03e8415c37025137752522defce1",
      "count": 4
    },
    {
      "address": "0xcc0561ba1db49978618aed16db43d3f5f8fbdf62",
      "count": 1
    },
    {
      "address": "0x85d382c1915cd79e85eda89231f2bdd130c31d0d",
      "count": 1
    },
    {
      "address": "0x0b09f2845a509655797db011ba5e5581cf9afd65",
      "count": 1
    },
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 2
    },
    {
      "address": "0xf3ac100a849171b7f78208bcaba243045e7ffc97",
      "count": 1
    },
    {
      "address": "0x80d07efcec5be1a1fa64be6d9382d4bbb2c6a7ba",
      "count": 1
    },
    {
      "address": "0xb13b9e1c8c15f789795b4a3cdfbb172e37673208",
      "count": 3
    },
    {
      "address": "0x369b55ea583491395b24b6973c3c2d3e4f3a46ef",
      "count": 1
    },
    {
      "address": "0x4584e62a46a658fdd9adb3012088772174f8c848",
      "count": 1
    },
    {
      "address": "0x4b4fc126620ca034f214ca231496d444c77fb9f5",
      "count": 1
    },
    {
      "address": "0xd92f143a1a057b302caa00b11e7029dbd88bb5b6",
      "count": 1
    },
    {
      "address": "0x5b788136f1ca790b11e4f69a4720278f5f10072d",
      "count": 1
    },
    {
      "address": "0xfa0f82f943393651b8d902523e57db1336305c41",
      "count": 2
    },
    {
      "address": "0x2f4397dbde395e628448f7aebaf67b60d3fdd04e",
      "count": 1
    },
    {
      "address": "0x9c1cbe6dbde00d48b5266cb0427c152602a7ce69",
      "count": 1
    },
    {
      "address": "0x5c57fec3e02e5b64f8c3b47b39942ef682e51459",
      "count": 1
    },
    {
      "address": "0x2d2e638299bc57b90a93a46c10de2d6cf0c90690",
      "count": 1
    },
    {
      "address": "0xb95e047cea71bdc6c2c608adeacb45c37663e15b",
      "count": 3
    },
    {
      "address": "0xdd5f2127986b7f13de74db0690ec10c3e8b553ae",
      "count": 1
    },
    {
      "address": "0x600faaea72b6aec384b917a0b21d9f42106ece30",
      "count": 1
    },
    {
      "address": "0xe64159e5aec2510c04f9f049129414078a0e760a",
      "count": 1
    },
    {
      "address": "0xa6a8f1c01b0ac1b3f23ac8f1c5fec49284f6c98c",
      "count": 1
    }
  ],
  badgeOfAdventure: [
    {
      "address": "0xba610c1e291d094c808b47f2e44c13d9d79026a9",
      "count": 1
    },
    {
      "address": "0x224f1db94d4c9498d28d186d677aba53bd353c4d",
      "count": 1
    },
    {
      "address": "0x87dd9282247d03e8415c37025137752522defce1",
      "count": 1
    },
    {
      "address": "0xcc0561ba1db49978618aed16db43d3f5f8fbdf62",
      "count": 6
    },
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 2
    },
    {
      "address": "0x4584e62a46a658fdd9adb3012088772174f8c848",
      "count": 1
    },
    {
      "address": "0x12e74275b50179c79d24acb00c08da76150a4313",
      "count": 2
    },
    {
      "address": "0xfa0f82f943393651b8d902523e57db1336305c41",
      "count": 4
    },
    {
      "address": "0x9c1cbe6dbde00d48b5266cb0427c152602a7ce69",
      "count": 1
    },
    {
      "address": "0x2d2e638299bc57b90a93a46c10de2d6cf0c90690",
      "count": 1
    },
    {
      "address": "0xe0fb55d97959c6fa2b04eccb2fd6689583256be9",
      "count": 2
    },
    {
      "address": "0xe960df98002f725c59c07f1045005d35feaab917",
      "count": 1
    },
    {
      "address": "0x839375339b030c4a8a2f8bcedd85c308d898307a",
      "count": 2
    },
    {
      "address": "0xb95e047cea71bdc6c2c608adeacb45c37663e15b",
      "count": 8
    },
    {
      "address": "0x7e9dadd8eadaf80f5572ee216b126c37f07c1c76",
      "count": 1
    },
    {
      "address": "0x7b68466eacc651d2e463f53d024ff464741e1795",
      "count": 1
    },
    {
      "address": "0xe38ba03eb8b6f13f96b9ed7ec0790ed84c1feddf",
      "count": 1
    },
    {
      "address": "0x877444579532453050720ced6a8a66c0c60b04c8",
      "count": 1
    },
    {
      "address": "0xe8ea4886fc6b793ee89ab956bd3bb7cdbdac8c94",
      "count": 1
    },
    {
      "address": "0x8844f817aa14e06a386abd5e55459bc04edaa65d",
      "count": 1
    },
    {
      "address": "0xcb2bd1803b2eeb6663bdf6e3de4eb43a165d6f7e",
      "count": 2
    },
    {
      "address": "0xe09e00c09c67a38129e8b13411ac4510fcd8aa05",
      "count": 1
    },
    {
      "address": "0xe64159e5aec2510c04f9f049129414078a0e760a",
      "count": 2
    }
  ],
  speedRunnerBadge: [
    {
      "address": "0x13fb94ad7a73b61d0818499dc32111bd750255c8",
      "count": 1
    }
  ],
  energyBadge: [
    {
      "address": "0x224f1db94d4c9498d28d186d677aba53bd353c4d",
      "count": 1
    },
    {
      "address": "0xdfe875f84e76843dd87ffff8a08d65980700cfb5",
      "count": 1
    },
    {
      "address": "0x87dd9282247d03e8415c37025137752522defce1",
      "count": 2
    },
    {
      "address": "0xcc0561ba1db49978618aed16db43d3f5f8fbdf62",
      "count": 3
    },
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 2
    },
    {
      "address": "0x833a4a119c1195b4ac1c7f1471152de8b65a3ef5",
      "count": 1
    },
    {
      "address": "0x71557b39e2da7d3bffcad660e9f24211c61e145d",
      "count": 1
    },
    {
      "address": "0xfa0f82f943393651b8d902523e57db1336305c41",
      "count": 3
    },
    {
      "address": "0x4c7bb6d580610877dd283d431bc30fde3a40f49b",
      "count": 1
    },
    {
      "address": "0x9c1cbe6dbde00d48b5266cb0427c152602a7ce69",
      "count": 2
    },
    {
      "address": "0xe0250374a32ff0a14a977c5c50c7950b65870f45",
      "count": 1
    },
    {
      "address": "0x2d2e638299bc57b90a93a46c10de2d6cf0c90690",
      "count": 1
    },
    {
      "address": "0x7f5980e75e4d31258231cd9594366039f39daf5e",
      "count": 4
    },
    {
      "address": "0xcb2bd1803b2eeb6663bdf6e3de4eb43a165d6f7e",
      "count": 1
    },
    {
      "address": "0xe64159e5aec2510c04f9f049129414078a0e760a",
      "count": 3
    },
    {
      "address": "0xa6a8f1c01b0ac1b3f23ac8f1c5fec49284f6c98c",
      "count": 1
    },
    {
      "address": "0xfa89fbd463fab90dd743ea3c891db3a3af4ccc88",
      "count": 1
    },
    {
      "address": "0xdd5f2127986b7f13de74db0690ec10c3e8b553ae",
      "count": 2
    },
    {
      "address": "0xfc7d8d61658febbd842f039d2f75ba6cc916a019",
      "count": 2
    }
  ],
  powerUpBadge: [
    {
      "address": "0xbd9d5f836cbc585ef0caee2270c2d0a33d9b65b2",
      "count": 1
    },
    {
      "address": "0xb88d5496411b41e69ac7e49b013a5da6447acce6",
      "count": 2
    },
    {
      "address": "0x224f1db94d4c9498d28d186d677aba53bd353c4d",
      "count": 1
    },
    {
      "address": "0x87dd9282247d03e8415c37025137752522defce1",
      "count": 1
    },
    {
      "address": "0xe1a127e4c452a134b525a3bc2771599bb86518e8",
      "count": 1
    },
    {
      "address": "0x4620bf29774e0332a8c6f525c2e397184ab9d890",
      "count": 1
    },
    {
      "address": "0xae30f9b73318f42f5e01e597b97c902f4f556df4",
      "count": 1
    },
    {
      "address": "0x8222d56098e57124fb7b4c852d142e6802032cf3",
      "count": 1
    },
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 1
    },
    {
      "address": "0xb930bdd203237cc3b92b9e25a51c82e1a2ccbb3d",
      "count": 2
    },
    {
      "address": "0x1c74b8a0bd85b6b1e981aae0ce918787fdab754a",
      "count": 1
    },
    {
      "address": "0x841a9465857df6d719e1d7a09d236c76eaa5b017",
      "count": 1
    },
    {
      "address": "0xcf6546a86c44b73722ae97d187e8c6f3238d20ae",
      "count": 1
    },
    {
      "address": "0x5cfa4abd4e01ca3a112313385f607cf616c2ccc2",
      "count": 1
    },
    {
      "address": "0x137ac4cf11813706f19b838cf0c4893bbb405fe3",
      "count": 1
    },
    {
      "address": "0xa069f2204cab4862c861925ad40b113d158a5e2f",
      "count": 1
    },
    {
      "address": "0xd92f143a1a057b302caa00b11e7029dbd88bb5b6",
      "count": 1
    },
    {
      "address": "0x8803c0fa17c7050000895b12170d6e412a48ecd2",
      "count": 1
    },
    {
      "address": "0x4221bf9804f555cb948e25a7299f7bb337a7efa5",
      "count": 2
    },
    {
      "address": "0x0415a0d5ba8f215b790aea2fe82226c99dbe9700",
      "count": 1
    },
    {
      "address": "0x9c1cbe6dbde00d48b5266cb0427c152602a7ce69",
      "count": 1
    },
    {
      "address": "0x6246e3a125914dba0b729d0565f0ad69c0fc25e0",
      "count": 1
    },
    {
      "address": "0x3dec42c1644f614b8c6f16c78c04a08207826e37",
      "count": 1
    },
    {
      "address": "0x87987266deff7068041b46d847121f4fac48d452",
      "count": 3
    },
    {
      "address": "0xba50488ac0dfd8996ca057c72bdf3cbf3003458b",
      "count": 1
    },
    {
      "address": "0x9bf2bfad54bb7542e96899980b44e0686e9a4d0c",
      "count": 1
    },
    {
      "address": "0x2e73c8326d16ac3a94542467acacdff6e3e7303a",
      "count": 1
    },
    {
      "address": "0xcb2bd1803b2eeb6663bdf6e3de4eb43a165d6f7e",
      "count": 1
    },
    {
      "address": "0xbd192a189ef64dea328403873347608ed594ddc2",
      "count": 1
    },
    {
      "address": "0x23360c3992e141714cdd1ba8acfa3afb8288825d",
      "count": 1
    },
    {
      "address": "0x086d8f892ecdea3990c3e65c67d25e191f7c0684",
      "count": 1
    },
    {
      "address": "0x3b3da81711d765bb232e4b41e18eb95c124f41f9",
      "count": 2
    },
    {
      "address": "0xfc7d8d61658febbd842f039d2f75ba6cc916a019",
      "count": 1
    },
    {
      "address": "0x7985616469f787ed0b5d003cdbcebdba461387d5",
      "count": 1
    },
    {
      "address": "0x48422cab6d357bf0891bd860a44225adcbf4d28f",
      "count": 2
    },
    {
      "address": "0xadca1cdbde071c8ce819d51899c1605bcc797202",
      "count": 2
    },
    {
      "address": "0x4523faa8955dfd3fed53b35a1ddb424d86a2ea7d",
      "count": 1
    },
    {
      "address": "0x9333ae43c422eb8f0aaba77fdd6733750faeb362",
      "count": 1
    },
    {
      "address": "0xe211affcef83ad0e8c2a789fdf6d05736d87f798",
      "count": 1
    },
    {
      "address": "0x014c594d63aa02454659e1517abd1c1b1feb1f07",
      "count": 2
    },
    {
      "address": "0xa6a8f1c01b0ac1b3f23ac8f1c5fec49284f6c98c",
      "count": 1
    },
    {
      "address": "0x09c76e1f683efbc6e3aa552cc42f9eaaaebeec74",
      "count": 1
    },
    {
      "address": "0x848be39d1e89f413f31957f229406069900aa20b",
      "count": 1
    },
    {
      "address": "0x936ecd13d2acc9c45bec00111964dda2b6ee9ac7",
      "count": 4
    },
    {
      "address": "0xcbd9ba7a19af1f925c8eb3200c87b607c863109f",
      "count": 3
    },
    {
      "address": "0xd77a95bb11d0e564da812d71b9d06d30a3cbb897",
      "count": 2
    },
    {
      "address": "0x4129842c20a32479a3d2866b6a884a9d700fab76",
      "count": 1
    },
    {
      "address": "0x2d956fdb7452aefbb9d17cf9b1fdfd4f3e3e340f",
      "count": 2
    },
    {
      "address": "0xb5621c2772c3278cdd18daa702670051a62d93a2",
      "count": 1
    }
  ],
  timeCrystal: [
    {
      "address": "0xba610c1e291d094c808b47f2e44c13d9d79026a9",
      "count": 2
    },
    {
      "address": "0xbd9d5f836cbc585ef0caee2270c2d0a33d9b65b2",
      "count": 1
    },
    {
      "address": "0xc2885d7a952640e5c7b609eef4a8baf3abb34264",
      "count": 2
    },
    {
      "address": "0x87dd9282247d03e8415c37025137752522defce1",
      "count": 3
    },
    {
      "address": "0xcc0561ba1db49978618aed16db43d3f5f8fbdf62",
      "count": 2
    },
    {
      "address": "0xe1a127e4c452a134b525a3bc2771599bb86518e8",
      "count": 1
    },
    {
      "address": "0xf8fab446e40ca05e87d9c32b089b093616dba71d",
      "count": 2
    },
    {
      "address": "0x4620bf29774e0332a8c6f525c2e397184ab9d890",
      "count": 1
    },
    {
      "address": "0x480afd5737eec69fd8aadcc465942a93b236a5d7",
      "count": 2
    },
    {
      "address": "0x0b09f2845a509655797db011ba5e5581cf9afd65",
      "count": 1
    },
    {
      "address": "0xae30f9b73318f42f5e01e597b97c902f4f556df4",
      "count": 1
    },
    {
      "address": "0xd3a10634598ecad9dec0b9f89b9f2d5a4704d26a",
      "count": 1
    },
    {
      "address": "0x8bbef539c1ed386bac9dbd50b53adc4c58a028fc",
      "count": 4
    },
    {
      "address": "0x455e186103be1500c48a2a9087930c78b9cd19dc",
      "count": 1
    },
    {
      "address": "0xb13b9e1c8c15f789795b4a3cdfbb172e37673208",
      "count": 5
    },
    {
      "address": "0xff676b883a38efa6f002267db180372c77e885a5",
      "count": 1
    },
    {
      "address": "0x369b55ea583491395b24b6973c3c2d3e4f3a46ef",
      "count": 1
    },
    {
      "address": "0xcf6546a86c44b73722ae97d187e8c6f3238d20ae",
      "count": 1
    },
    {
      "address": "0x5cfa4abd4e01ca3a112313385f607cf616c2ccc2",
      "count": 2
    },
    {
      "address": "0x332c4fe929680e12f6140557f505757173666af6",
      "count": 1
    },
    {
      "address": "0x1ba7b4fc4c4d1994d75b4d69ba03d235afb732c3",
      "count": 1
    },
    {
      "address": "0xd92f143a1a057b302caa00b11e7029dbd88bb5b6",
      "count": 1
    },
    {
      "address": "0x60c8097b8870972f298525aa80684f5971c2ba5c",
      "count": 1
    },
    {
      "address": "0x4618f344f19dbab977d5919d3e3a3256274d043d",
      "count": 1
    },
    {
      "address": "0x8803c0fa17c7050000895b12170d6e412a48ecd2",
      "count": 1
    },
    {
      "address": "0x71557b39e2da7d3bffcad660e9f24211c61e145d",
      "count": 1
    },
    {
      "address": "0x4221bf9804f555cb948e25a7299f7bb337a7efa5",
      "count": 3
    },
    {
      "address": "0xb53ecf285790f4c60da89c1e0e0ad3dfa7da11c4",
      "count": 1
    },
    {
      "address": "0x48fda4c03bec8d10cecc2d088b329a796e5360b6",
      "count": 2
    },
    {
      "address": "0xfa0f82f943393651b8d902523e57db1336305c41",
      "count": 2
    },
    {
      "address": "0xe0d3b203853fd07904ec42188836b967afdda690",
      "count": 1
    },
    {
      "address": "0x4c7bb6d580610877dd283d431bc30fde3a40f49b",
      "count": 1
    },
    {
      "address": "0xab6c573cc3d06c8f5a8625e2449062ee16936c5f",
      "count": 2
    },
    {
      "address": "0x9c1cbe6dbde00d48b5266cb0427c152602a7ce69",
      "count": 3
    },
    {
      "address": "0xaa29f503cde18ab560c32708195c8ec43f26748b",
      "count": 1
    },
    {
      "address": "0xfeffe72b889c2538d91bda61f6d3061be83e28d7",
      "count": 1
    },
    {
      "address": "0x2d2e638299bc57b90a93a46c10de2d6cf0c90690",
      "count": 1
    },
    {
      "address": "0xa0f08df421443555a5837b4217db8c052ac6221d",
      "count": 1
    },
    {
      "address": "0x93fbc643dd5f892fc68d908b9f2e54357bc03287",
      "count": 1
    },
    {
      "address": "0x3dec42c1644f614b8c6f16c78c04a08207826e37",
      "count": 1
    },
    {
      "address": "0x5c034258633e26f472739c1403e494b2bbb42bbd",
      "count": 1
    },
    {
      "address": "0x87987266deff7068041b46d847121f4fac48d452",
      "count": 3
    },
    {
      "address": "0x04b9ecea8f535c106c5ff7ffc4f5ebe24fbdc3dc",
      "count": 1
    },
    {
      "address": "0x9abb05e2421ee4cf44a4605cc56aed922a4a0375",
      "count": 1
    },
    {
      "address": "0x084d634f80b36fd815effb38092aeb8074c28ebe",
      "count": 4
    },
    {
      "address": "0x8bacf86066d0e1fa13d750712ec155672298a0b4",
      "count": 2
    },
    {
      "address": "0xea7b634b09c4bf35eb5f12ede6e32d1e249aadeb",
      "count": 1
    },
    {
      "address": "0x454161f0eb99e13c0b1083969f9e0519a59543fb",
      "count": 1
    },
    {
      "address": "0x3ac1473b8a3d601eea17f3b85a26cc2a0fc64d01",
      "count": 1
    },
    {
      "address": "0xce666b50db3cbebf7485415c2e5935f7b7a3e2f7",
      "count": 1
    },
    {
      "address": "0x4db0a35e09924dd9e4b5cc658657b2407c31a9cc",
      "count": 1
    },
    {
      "address": "0x19f105a84030b3e7fa4c1007a0896fbaa49762d1",
      "count": 1
    },
    {
      "address": "0x8232aa231e17b54e7b2bf641d9f473abc42d3d2e",
      "count": 1
    },
    {
      "address": "0xba50488ac0dfd8996ca057c72bdf3cbf3003458b",
      "count": 1
    },
    {
      "address": "0xb59965147da87119cbdcfdee1d04304381cc6ec5",
      "count": 1
    },
    {
      "address": "0x804604f55fe79ad0237696465c57d3de997c14c1",
      "count": 1
    },
    {
      "address": "0x2e73c8326d16ac3a94542467acacdff6e3e7303a",
      "count": 1
    },
    {
      "address": "0x23360c3992e141714cdd1ba8acfa3afb8288825d",
      "count": 1
    },
    {
      "address": "0x6246e3a125914dba0b729d0565f0ad69c0fc25e0",
      "count": 1
    },
    {
      "address": "0x6261db3f64170138b0925d6f14f0d6bf1eba5d3f",
      "count": 2
    },
    {
      "address": "0xbd192a189ef64dea328403873347608ed594ddc2",
      "count": 20
    },
    {
      "address": "0x0dcd5287b93c5933c9dbb81022c79cd6a0ade095",
      "count": 1
    },
    {
      "address": "0xef78588fe8db415d603acab4224380278ef1c1c8",
      "count": 1
    }
  ]
}

async function main() {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt("CosmicBadges", "0x03A37A09be3E90bE403e263238c1aCb14a341DEf", accounts[0]);
  const data = badgeInfo.badgeOfCourage;
  const owners = badgeOwners.badgeOfCourage;
  console.log(`Setting Badge ${data.id} to ${data.name} with a description of "${data.description}"`)
  const tx = await contract.batchSetAttributeName(data.id, [1000, 1001], [data.name, data.description]);
  await tx.wait();

  const addresses = [];
  const amounts = [];
  owners.map(o => {
    addresses.push(o.address);
    amounts.push(o.count)
  })
  console.log(`Minting to owners`)
  const mintTx = await contract.reallocate(data.id, addresses, amounts);
  await mintTx.wait()
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })