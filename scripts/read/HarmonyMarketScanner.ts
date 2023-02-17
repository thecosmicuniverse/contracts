import hre, { ethers, upgrades } from 'hardhat';
const cliProgress = require('cli-progress');
import fs from 'fs';
const sales = [
  {
    saleId: 396,
    saleType: 1,
    seller: '0xA0Fb85CF5B0d9966468F9D9BE0A824565b310db6',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1646242283,
    duration: 172800,
    extensionDuration: 900,
    endTime: 1646415083,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2000000000000000000000'
  },
  {
    saleId: 528,
    saleType: 1,
    seller: '0x480aFd5737eEC69FD8aAdcC465942A93b236A5d7',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1646272948,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1646877748,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '285000000000000000000'
  },
  {
    saleId: 530,
    saleType: 1,
    seller: '0x480aFd5737eEC69FD8aAdcC465942A93b236A5d7',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1646273118,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1648865118,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '5000000000000000000000'
  },
  {
    saleId: 531,
    saleType: 1,
    seller: '0x480aFd5737eEC69FD8aAdcC465942A93b236A5d7',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1646273204,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1646878004,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '300000000000000000000'
  },
  {
    saleId: 1070,
    saleType: 1,
    seller: '0x480aFd5737eEC69FD8aAdcC465942A93b236A5d7',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1646633961,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1647238761,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1111000000000000000000'
  },
  {
    saleId: 1564,
    saleType: 1,
    seller: '0xe7D1C2A29a6c1D1fa460ba4c26f06B97b76eE931',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1647238032,
    duration: 864000,
    extensionDuration: 900,
    endTime: 1648102032,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '500000000000000000000'
  },
  {
    saleId: 1705,
    saleType: 1,
    seller: '0xaCc261f95c552386Da8350a6FffE3A0b9Ca67E0B',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1647354123,
    duration: 864000,
    extensionDuration: 900,
    endTime: 1648218123,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '10000000000000000000000'
  },
  {
    saleId: 1980,
    saleType: 1,
    seller: '0xd81B80266B9015d21B8A70d260833eC995a9884c',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1647537393,
    duration: 432000,
    extensionDuration: 900,
    endTime: 1647969393,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1000000000000000000000'
  },
  {
    saleId: 3059,
    saleType: 1,
    seller: '0x5A84A383BBCdce1Ddf04d3b482C5B0DD64Dc3006',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1648821064,
    duration: 259200,
    extensionDuration: 900,
    endTime: 1649080264,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '3225000000000000000000'
  },
  {
    saleId: 3147,
    saleType: 1,
    seller: '0xa87D98510dc098c7363E72994b1062412ACE3F03',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1648987029,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1651579029,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2000000000000000000000'
  },
  {
    saleId: 3148,
    saleType: 1,
    seller: '0xa87D98510dc098c7363E72994b1062412ACE3F03',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1648987095,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1651579095,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '30000000000000000000000'
  },
  {
    saleId: 3428,
    saleType: 1,
    seller: '0x807fB3Dca069266C6AfD5BcDc35d821d3D0cA16e',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1649516489,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1652108489,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2998000000000000000000'
  },
  {
    saleId: 3553,
    saleType: 1,
    seller: '0x9d5A91d64d88555Bc4b931862ffD7831A1079a05',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1649780422,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1650385222,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2000000000000000000000'
  },
  {
    saleId: 3554,
    saleType: 1,
    seller: '0x9d5A91d64d88555Bc4b931862ffD7831A1079a05',
    contractAddress: '0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1649780491,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1650385291,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2000000000000000000000'
  },
  {
    saleId: 3744,
    saleType: 1,
    seller: '0xcA956196FD1772BE1D6E6a631E9Ca9cd2182D829',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650287931,
    duration: 1209600,
    extensionDuration: 900,
    endTime: 1651497531,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '10000000000000000000000'
  },
  {
    saleId: 3786,
    saleType: 1,
    seller: '0x6dAc62E20F3C62819e98148BD346E44506778024',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650312214,
    duration: 1209600,
    extensionDuration: 900,
    endTime: 1651521814,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '10000000000000000000000'
  },
  {
    saleId: 3787,
    saleType: 1,
    seller: '0x6dAc62E20F3C62819e98148BD346E44506778024',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650312310,
    duration: 1209600,
    extensionDuration: 900,
    endTime: 1651521910,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '10000000000000000000000'
  },
  {
    saleId: 3853,
    saleType: 1,
    seller: '0x6a5B0A0c161A825f3064946184A3EF08561a7453',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650383697,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1652975697,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8149000000000000000000'
  },
  {
    saleId: 3920,
    saleType: 1,
    seller: '0x7bdB3b90F8870A78D757959bbf7f7F0d2aF94a5A',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650519388,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1651124188,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '690000000000000000000'
  },
  {
    saleId: 4140,
    saleType: 1,
    seller: '0xd6eD364cc14e9e3bAE13b2df9FAd515d6d277f79',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650986861,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1653578861,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '42690000000000000000000'
  },
  {
    saleId: 4141,
    saleType: 1,
    seller: '0xd6eD364cc14e9e3bAE13b2df9FAd515d6d277f79',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650986965,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1653578965,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '24900000000000000000000'
  },
  {
    saleId: 4142,
    saleType: 1,
    seller: '0xd6eD364cc14e9e3bAE13b2df9FAd515d6d277f79',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1650987029,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1653579029,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '29000000000000000000000'
  },
  {
    saleId: 4458,
    saleType: 1,
    seller: '0x42654365Dd6A5924A1982985918138089818B41E',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1651658240,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1652263040,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '850000000000000000000'
  },
  {
    saleId: 5009,
    saleType: 1,
    seller: '0x092E4cf1C4De7c2C78e58EDD964F1dd9DAECF3c6',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652555963,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1655147963,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1200000000000000000000'
  },
  {
    saleId: 5025,
    saleType: 1,
    seller: '0x3dec42C1644f614b8C6f16C78C04a08207826e37',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652579307,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1655171307,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '4000000000000000000000'
  },
  {
    saleId: 5064,
    saleType: 1,
    seller: '0x3643a16eb6a10d951300c10909e914F957cD438a',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652653974,
    duration: 25920000,
    extensionDuration: 900,
    endTime: 1678573974,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1100000000000000000000'
  },
  {
    saleId: 5089,
    saleType: 1,
    seller: '0xf48443c8e441A29Ac3aD8560E6C46bcF0c82cFD1',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652671850,
    duration: 432000,
    extensionDuration: 900,
    endTime: 1653103850,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '500000000000000000000'
  },
  {
    saleId: 5090,
    saleType: 1,
    seller: '0xf48443c8e441A29Ac3aD8560E6C46bcF0c82cFD1',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652671932,
    duration: 432000,
    extensionDuration: 900,
    endTime: 1653103932,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '850000000000000000000'
  },
  {
    saleId: 5091,
    saleType: 1,
    seller: '0xf48443c8e441A29Ac3aD8560E6C46bcF0c82cFD1',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652672008,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653276808,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '500000000000000000000'
  },
  {
    saleId: 5092,
    saleType: 1,
    seller: '0xf48443c8e441A29Ac3aD8560E6C46bcF0c82cFD1',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652672072,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653276872,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '450000000000000000000'
  },
  {
    saleId: 5213,
    saleType: 1,
    seller: '0xEB37c1E7A7A83886876F659bc558c8784386F28a',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652989496,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653594296,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1899000000000000000000'
  },
  {
    saleId: 5215,
    saleType: 1,
    seller: '0xEB37c1E7A7A83886876F659bc558c8784386F28a',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1652989812,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653594612,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1999000000000000000000'
  },
  {
    saleId: 5257,
    saleType: 1,
    seller: '0x7B3ae92Ec93d4801ec01FCa81AF2A81c3c8A3607',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653136725,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653741525,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '149000000000000000000'
  },
  {
    saleId: 5292,
    saleType: 1,
    seller: '0x8Abfb033160D91f0c937a9e1D7B91F7E5a8A44D1',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653234476,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653839276,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2500000000000000000000'
  },
  {
    saleId: 5309,
    saleType: 1,
    seller: '0x5624937f595d3b1B6565d0405584452532cb9962',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653265340,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653870140,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '400000000000000000000'
  },
  {
    saleId: 5315,
    saleType: 1,
    seller: '0x3A0D8daa2d467c81D410a8EE8Bd3a445674664b7',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653277740,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1653882540,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1399000000000000000000'
  },
  {
    saleId: 5395,
    saleType: 1,
    seller: '0x7A5F6A8f97f8aF495F040c54f3cc75f7bc6bc59c',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653399118,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1654003918,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2899000000000000000000'
  },
  {
    saleId: 5460,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558170,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150170,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '7500000000000000000000'
  },
  {
    saleId: 5461,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558300,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150300,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 5462,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558372,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150372,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 5463,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558494,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150494,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 5464,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558612,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150612,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 5465,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558755,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150755,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '10000000000000000000000'
  },
  {
    saleId: 5466,
    saleType: 0,
    seller: '0xD4b6f06F2817970dcFCE6DC3E9bA6298e9e85Aea',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653558870,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656150870,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 5539,
    saleType: 1,
    seller: '0xF79E4cc7A5Dedc344F711f7769cd10a6Bb1d0DE1',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1653748498,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656340498,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2800000000000000000000'
  },
  {
    saleId: 5656,
    saleType: 1,
    seller: '0xd666115C3D251BecE7896297BF446eA908cAF035',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654075803,
    duration: 7776000,
    extensionDuration: 900,
    endTime: 1661851803,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '4800000000000000000000'
  },
  {
    saleId: 5673,
    saleType: 1,
    seller: '0x3dec42C1644f614b8C6f16C78C04a08207826e37',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654199596,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1656791596,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '7500000000000000000000'
  },
  {
    saleId: 5782,
    saleType: 1,
    seller: '0xFE3A593fB8a90185A8E31eDC8eb02E7d889D52f0',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654677571,
    duration: 345600,
    extensionDuration: 900,
    endTime: 1655023171,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '110000000000000000000'
  },
  {
    saleId: 5783,
    saleType: 1,
    seller: '0xFE3A593fB8a90185A8E31eDC8eb02E7d889D52f0',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654677653,
    duration: 259200,
    extensionDuration: 900,
    endTime: 1654936853,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '175000000000000000000'
  },
  {
    saleId: 5813,
    saleType: 1,
    seller: '0x67430abAA14e5fe522C9eE50fF6987912A8C3338',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654847941,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655452741,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '150000000000000000000'
  },
  {
    saleId: 5814,
    saleType: 1,
    seller: '0x67430abAA14e5fe522C9eE50fF6987912A8C3338',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654847989,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655452789,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '150000000000000000000'
  },
  {
    saleId: 5815,
    saleType: 1,
    seller: '0x67430abAA14e5fe522C9eE50fF6987912A8C3338',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654848046,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655452846,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '150000000000000000000'
  },
  {
    saleId: 5826,
    saleType: 1,
    seller: '0x3F9023DC53798fFbd321B296E9480729FB4d870A',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654856200,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655461000,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '159000000000000000000'
  },
  {
    saleId: 5827,
    saleType: 1,
    seller: '0x3F9023DC53798fFbd321B296E9480729FB4d870A',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654856272,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655461072,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '159000000000000000000'
  },
  {
    saleId: 5828,
    saleType: 1,
    seller: '0x3F9023DC53798fFbd321B296E9480729FB4d870A',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654856452,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655461252,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '159000000000000000000'
  },
  {
    saleId: 5914,
    saleType: 1,
    seller: '0x8DBc169a6fb0FE34149a4BA21E51DC31d1f677EF',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1654971073,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1657563073,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1800000000000000000000'
  },
  {
    saleId: 5996,
    saleType: 1,
    seller: '0x1A2b734125d61AcB6d29c44574b2f43076FC99a5',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1655135526,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1657727526,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '9400000000000000000000'
  },
  {
    saleId: 6012,
    saleType: 1,
    seller: '0x4baBae7d0b230d459669CAd7BF397F6b35549252',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1655166453,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1655771253,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '300000000000000000000'
  },
  {
    saleId: 6013,
    saleType: 1,
    seller: '0x1A2b734125d61AcB6d29c44574b2f43076FC99a5',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1655182214,
    duration: 2592000,
    extensionDuration: 900,
    endTime: 1657774214,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '6050000000000000000000'
  },
  {
    saleId: 6093,
    saleType: 1,
    seller: '0x0EAcf6718Cda374b632519F29dBd4C1309731A04',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1655447581,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1656052381,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '500000000000000000000'
  },
  {
    saleId: 6179,
    saleType: 1,
    seller: '0x268Db78Eac1940edD6D9D842B0465C1c8E023214',
    contractAddress: '0xdC48cECc5443cC1982926060a89392c7dF1d4892',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1655931690,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1656536490,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1050000000000000000000'
  },
  {
    saleId: 6215,
    saleType: 1,
    seller: '0xB035948E4F3a4e89FF565A5d7b592db57bfCC05c',
    contractAddress: '0x41e928EF2F2523518172f4FeDdE59C815398FAaB',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1656067336,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1656672136,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '2250000000000000000000'
  },
  {
    saleId: 6347,
    saleType: 1,
    seller: '0xC9F1C0206e852eC32239d70404979B26E0CCF091',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1656404059,
    duration: 1209600,
    extensionDuration: 900,
    endTime: 1657613659,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '1390000000000000000000'
  },
  {
    saleId: 6426,
    saleType: 1,
    seller: '0x7eA836A3aa958a69131D363f72Da6660119CA032',
    contractAddress: '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1656768358,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1657373158,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '8000000000000000000000'
  },
  {
    saleId: 6477,
    saleType: 1,
    seller: '0x34bA4c3769703Ee50f104bE89D719327Ee5e38e8',
    contractAddress: '0xF22348e477753Bc6252237333d9a94B1FCe9c1D3',
    tokenType: 0,
    bidToken: '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7',
    startTime: 1657189196,
    duration: 604800,
    extensionDuration: 900,
    endTime: 1657793996,
    bidder: '0x0000000000000000000000000000000000000000',
    bidAmount: '100000000000000000000'
  }
]
const saleIds = [396,528,530,531,1070,1564,1705,1980,3059,3147,3148,3428,3553,3554,3744,3786,3787,3853,3920,4140,4141,4142,4458,5009,5025,5064,5089,5090,5091,5092,5213,5215,5257,5292,5309,5315,5395,5460,5461,5462,5463,5464,5465,5466,5539,5656,5673,5782,5783,5813,5814,5815,5826,5827,5828,5914,5996,6012,6013,6093,6179,6215,6347,6426,6477]
const scan = async () => {
  if (hre.network.config.chainId !== 1666600000) {
    throw "Not using Harmony network!";
  }
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt("MarketUpgradeable", "0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656", accounts[0])
  const sales = []
  for (let i = 0; i < saleIds.length; i++) {
    console.log("Scanning Old Sale ID", i+1, "out of", saleIds.length)
    const sale = await contract.saleIdToSale(saleIds[i]);
    if (sale.seller == ethers.constants.AddressZero) {
      console.log("Dropping");
      continue
    }
    sales.push({
      saleId: saleIds[i],
      saleType: sale.saleType,
      seller: sale.seller,
      contractAddress: sale.contractAddress,
      tokenType: sale.tokenType,
      bidToken: sale.bidToken,
      startTime: sale.startTime.toNumber(),
      duration: sale.duration.toNumber(),
      extensionDuration: sale.extensionDuration.toNumber(),
      endTime: sale.endTime.toNumber(),
      bidder: sale.bidder,
      bidAmount: sale.bidAmount.toString()
    })
  }
  console.log(sales)
}

const parse = async () => {
  if (hre.network.config.chainId !== 1666600000) {
    throw "Not using Harmony network!";
  }
  const signer = (await ethers.getSigners())[0]
  const contract = await ethers.getContractAt("MarketUpgradeable", "0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656", signer);
  const cosmicElvesTicket = [];
  const framedWizards = [];
  const wizards2D = [];
  const wizards = [];
  const land = [];
  for (let i = 0; i < sales.length; i++) {
    if (sales[i].contractAddress == "0xdC48cECc5443cC1982926060a89392c7dF1d4892") {
      cosmicElvesTicket.push(sales[i]);
    } else if (sales[i].contractAddress == "0xF22348e477753Bc6252237333d9a94B1FCe9c1D3") {
      framedWizards.push(sales[i]);
    } else if (sales[i].contractAddress == "0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67" ) {
      wizards2D.push(sales[i]);
    } else if (sales[i].contractAddress == "0xdC59f32a58Ba536f639ba39C47cE9a12106b232B" ) {
      wizards.push(sales[i]);
    } else if (sales[i].contractAddress == "0x41e928EF2F2523518172f4FeDdE59C815398FAaB" ) {
      land.push(sales[i]);
    } else {
      console.log("UH OH!", sales[i].contractAddress)
    }
  }
  const lostSaleIDs = [2985, 2986, 2987, 2989];
  const multibar = new cliProgress.MultiBar({
    clearOnComplete: false,
    hideCursor: true,
    format: 'progress [{bar}] {percentage}% | ETA: {eta}s | {value}/{total} | {data}'
  }, cliProgress.Presets.shades_grey);
  const lostIds = [4587, 4588, 4695, 4696]
  const foundEvents = [];
  const START_BLOCK = 24700676;
  const LAST_BLOCK = 32923843;
  const CHUNK_SIZE = 1000;
  const CHUNKS = Math.ceil((LAST_BLOCK - START_BLOCK) / CHUNK_SIZE);
  const b1 = multibar.create(sales.length, foundEvents.length);
  const b2 = multibar.create(CHUNKS, 0);
  for (let i = 0; i < CHUNKS; i++) {
    const FROM_BLOCK = START_BLOCK + (i * CHUNK_SIZE);
    const TO_BLOCK = FROM_BLOCK + CHUNK_SIZE;
    b2.increment({data: `${FROM_BLOCK} - ${TO_BLOCK}`});
    const events = await contract.queryFilter({
      address: contract.address,
      topics: contract.filters.SaleCreated().topics
    }, FROM_BLOCK, TO_BLOCK);
    if (events.length > 0) {
      b1.update(foundEvents.length, {data: "Last sale ID: " + events[events.length - 1].args.saleId.toNumber().toString()});
      // multibar.log( + "\n")
      const filtered = events.filter(e => lostSaleIDs.includes(e.args.saleId.toNumber()))
      if (filtered.length > 0) {
        b1.update(foundEvents.length + filtered.length);
        const sanitized = filtered.map(e => ({
          saleId: e.args.saleId.toNumber(),
          saleType: e.args.saleType,
          seller: e.args.seller,
          contractAddress: e.args.contractAddress,
          bidToken: e.args.bidToken,
          startTime: e.args.startTime.toNumber(),
          duration: e.args.duration.toNumber(),
          extensionDuration: e.args.extensionDuration.toNumber(),
          endTime: e.args.endTime.toNumber(),
          tokenIds: e.args.tokenIds.map((t: any) => t.toNumber()),
          transactionHash: e.transactionHash,
          blockNumber: e.blockNumber
        }))

        foundEvents.push(...sanitized)
        fs.writeFileSync("./data2.json", JSON.stringify(foundEvents))
      }
      if (foundEvents.length == 4) {
        b1.stop()
        b2.stop()
        console.log(JSON.stringify(foundEvents) + "\n");
        return;
      }
    } else {
      //b1.update(foundEvents.length, {data: "No Events"});
      // multibar.log("\n");
    }
  }
}

const findLost = async () => {
  if (hre.network.config.chainId !== 1666600000) {
    throw "Not using Harmony network!";
  }
  const signer = (await ethers.getSigners())[0]
  const contract = await ethers.getContractAt("MarketUpgradeable", "0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656", signer);

  const lostSaleIDs = [2985, 2986, 2987, 2989];
  const lostIds = [4587, 4588, 4695, 4696]
  const foundEvents = [];
  const START_BLOCK = 36324406;
  const LAST_BLOCK = START_BLOCK+1000;

  const events = await contract.queryFilter({
    address: contract.address,
    topics: contract.filters.SaleCanceled().topics
  }, START_BLOCK, LAST_BLOCK);
  if (events.length > 0) {
    console.log("Last sale ID: " + events[events.length - 1].args.saleId.toNumber().toString());
    console.log(events)
    const filtered = events.filter(e => lostSaleIDs.includes(e.args.saleId.toNumber()))
    if ( filtered.length > 0 ) {
      const sanitized = filtered.map(e => ({
        saleId: e.args.saleId.toNumber(),
        saleType: e.args.saleType,
        seller: e.args.seller,
        contractAddress: e.args.contractAddress,
        bidToken: e.args.bidToken,
        startTime: e.args.startTime.toNumber(),
        duration: e.args.duration.toNumber(),
        extensionDuration: e.args.extensionDuration.toNumber(),
        endTime: e.args.endTime.toNumber(),
        tokenIds: e.args.tokenIds.map((t: any) => t.toNumber()),
        transactionHash: e.transactionHash,
        blockNumber: e.blockNumber
      }))

      foundEvents.push(...sanitized)
      console.log(JSON.stringify(foundEvents) + "\n");
    }
  }
}


const rescue = async () => {
  if (hre.network.config.chainId !== 43114) {
    throw "Not using Avalanche network!";
  }
  const signer = (await ethers.getSigners())[0]
  const contract = await ethers.getContractAt("FramedWizards", "0xf7faa28f8934d3dcaf571ef3dd0a41bd5604915c", signer);

  const raw = fs.readFileSync("./data2.json", "utf8");
  const data = JSON.parse(raw);
  const cosmicElvesTicket = [];
  const framedWizards = [];
  const wizards2D = [];
  const wizards = [];
  const land = [];
  for (let i = 0; i < data.length; i++) {
    if (data[i].contractAddress == "0xdC48cECc5443cC1982926060a89392c7dF1d4892") {
      cosmicElvesTicket.push(data[i]);
    } else if (data[i].contractAddress == "0xF22348e477753Bc6252237333d9a94B1FCe9c1D3") {
      framedWizards.push(data[i]);
    } else if (data[i].contractAddress == "0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67" ) {
      wizards2D.push(data[i]);
    } else if (data[i].contractAddress == "0xdC59f32a58Ba536f639ba39C47cE9a12106b232B" ) {
      wizards.push(data[i]);
    } else if (data[i].contractAddress == "0x41e928EF2F2523518172f4FeDdE59C815398FAaB" ) {
      land.push(data[i]);
    } else {
      console.log("UH OH!", sales[i].contractAddress)
    }
  }
  console.log(wizards)
  const arAccounts: string[] = [];
  const arIDs: number[] = [];
  land.map(w => {
    arAccounts.push(w.seller);
    arIDs.push(w.tokenIds[0]);
  })
  console.log(arAccounts, arIDs);
  const tx = await contract.adminRescue("0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656", arAccounts, arIDs)
  await tx.wait();
}

const missingBridged = async () => {
  if (hre.network.config.chainId !== 43114) {
    throw "Not using Avalanche network!";
  }
  const signer = (await ethers.getSigners())[0]
  const contract = await ethers.getContractAt("CosmicWizards", "0xbf20c23d25fca8aa4e7946496250d67872691af2", signer);

  const raw = await contract.getAllTokenIds();
  const allTokenIDs = raw.map(t => t.toNumber());
  console.log(allTokenIDs);
  //const data = JSON.parse(raw);
  //const cosmicElvesTicket = [];
  //const framedWizards = [];
  //const wizards2D = [];
  //const wizards = [];
  //const land = [];
  //for (let i = 0; i < data.length; i++) {
  //  if (data[i].contractAddress == "0xdC48cECc5443cC1982926060a89392c7dF1d4892") {
  //    cosmicElvesTicket.push(data[i]);
  //  } else if (data[i].contractAddress == "0xF22348e477753Bc6252237333d9a94B1FCe9c1D3") {
  //    framedWizards.push(data[i]);
  //  } else if (data[i].contractAddress == "0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67" ) {
  //    wizards2D.push(data[i]);
  //  } else if (data[i].contractAddress == "0xdC59f32a58Ba536f639ba39C47cE9a12106b232B" ) {
  //    wizards.push(data[i]);
  //  } else if (data[i].contractAddress == "0x41e928EF2F2523518172f4FeDdE59C815398FAaB" ) {
  //    land.push(data[i]);
  //  } else {
  //    console.log("UH OH!", sales[i].contractAddress)
  //  }
  //}
  //console.log(wizards)
  //const arAccounts: string[] = [];
  //const arIDs: number[] = [];
  //land.map(w => {
  //  arAccounts.push(w.seller);
  //  arIDs.push(w.tokenIds[0]);
  //})
  //console.log(arAccounts, arIDs);
  //const tx = await contract.adminRescue("0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656", arAccounts, arIDs)
  //await tx.wait();
}
missingBridged()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })