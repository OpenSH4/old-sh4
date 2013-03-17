#!/bin/sh
killall -9 mgcamd.sh4
killall -9 vizcam.sh4
killall -9 oscam
USERNAME=`cat /var/keys/Benutzerdaten/.emu/user`
PASSWORD=`cat /var/keys/Benutzerdaten/.emu/pass`
DYNDNS=`cat /var/keys/Benutzerdaten/.emu/dyndns`
NEWPORT1=`cat /var/keys/Benutzerdaten/.emu/portnewcamd1`
NEWPORT2=`cat /var/keys/Benutzerdaten/.emu/portnewcamd2`
CCCPORT=`cat /var/keys/Benutzerdaten/.emu/portcccam`
CAMD3=`cat /var/keys/Benutzerdaten/.emu/camd3`
echo "schreibe Daten" > /dev/vfd
if [ -e /var/keys/Benutzerdaten/.emu/portnewcamd1 ]; then
/bin/echo "CWS_KEEPALIVE = 300
CWS_INCOMING_PORT = 21000
CWS = $DYNDNS $NEWPORT1 $USERNAME $PASSWORD 01 02 03 04 05 06 07 08 09 10 11 12 13 14
CWS = $DYNDNS $NEWPORT2 $USERNAME $PASSWORD 01 02 03 04 05 06 07 08 09 10 11 12 13 14" > /var/keys/newcamd.list
/bin/echo "##################################################################
########################### global ###############################
[global]
logfile             = stdout
#logfile            = /tmp/vizcam.log
clienttimeout       = 5000
fallbacktimeout     = 2500
clientmaxidle       = 5
cachedelay          = 200
bindwait            = 120
nice                = -25
serialreadertimeout = 1500
maxlogsize          = 2
saveinithistory     = 1
waitforcards        = 0
lb_mode   	    = 0
lb_save             = 200

[webif]
httpport       = 8888
httpuser       = root
httppwd        = vizcam
httpallowed    = 127.0.0.1,192.168.0.0-192.168.255.255

#[monitor]
#appendchaninfo = 1
#nocrypt        = 127.0.0.1,192.168.0.0-192.168.255.255

########################### readers ##############################
#               enable = 0/1 (off/on this reader)                #
##################################################################
[reader]
enable   = 1
label    = Slot-HD-Plus
protocol = internal
detect   = CD
device   = /dev/sci1
group    = 4
n3_rsakey  = BF358B5461863130686FC933FB541FFCED682F3680F09DBC1A23829FB3B2F766B9DD1BF3B3ECC9AD6661B753DCC3A9624156F9EB64E8168EF09E4D9C5CCA4DD5
n3_boxkey   = A7642F57BC96D37C

[reader]
enable   = 1
label    = Slot-ALL-Card
protocol = internal
detect   = CD
device   = /dev/sci0
group    = 4
############ remote ###############
[reader]
enable       = 0
label        = cccam-reader
protocol     = cccam
device       = IP,PORT
user         = USER
password     = PASS
group        = 1
emmcache     = 1,1,2
cccmaxhop    = 4

[reader]
enable       = 0
label        = camd35-reader
protocol     = camd35
device       = IP,PORT
user         = USER
password     = PASS
group        = 1
emmcache     = 1,1,2

[reader]
enable       = 1
label        = sky
protocol     = newcamd
key          = 0102030405060708091011121314
device       = $DYNDNS,$NEWPORT1
user         = $USERNAME
password     = $PASSWORD
group        = 1
emmcache     = 1,1,2

[reader]
enable       = 1
label        = hd+
protocol     = newcamd
key          = 0102030405060708091011121314
device       = $DYNDNS,$NEWPORT2
user         = $USERNAME
password     = $PASSWORD
group        = 1
emmcache     = 1,1,2
########################### DVBAPI ###############################
######### die " ! " entfernen fuer jeweiliges Paket ##############
##################################################################
[account]
user         = vizcam
pwd          = pass
group        = 1
au           = 1
services     = 
betatunnel   = 1833.FFFF:1702
keepalive    = 1
uniq         = 0

[dvbapi]
enabled      = 1
AU           = 1
user         = vizcam
boxtype       = dbox2   
########################### services #############################
[hdplus]
caid=1830,1843
srvid=277E,EF10,EF11,EF74,EF75,EF76,EF14,EF15,EF77

[skyde]
caid=1702,1833,09c4
srvid=006f,0070,0071,0072,006B,006A,0077,007A,007B,007C,0084,0081,007e,0080,0083,0082,000F,000A,0001,007F,000B,002b,0009,0029,001b,002a,000e,0044,003e,18b2,000d,000C,0034,0017,0008,0204,0014,0024,0032,4462,4461,003c,0298,0043,0010,0206,0016,0203,003f,001d,0045,0018,0042,0022,0019,001a,700a,001c,0013,3393,003d,6ff1,00df,0011,00dd,00de,00fd,014d,0143,0139,012f,0125,011b,0107,0111,016b,0175,0035,3331,00a8,7009,6fff,0015,0201,0159,0163,016d,0046,00fb,0105,010f,0119,0123,012d,0137,0141,014b,0106,0110,011a,0124,012e,0138,0142,014c,0156,0160,00fc,0096,0097,0098,0099,009A,009B,009C,2EFE,0075,07FF,0040,0041

[orf]
caid=0D05,0D95
srvid=132F,1330,3332,32C9,32CA,32CB,32CC,32CD,32CE,32CF,32D0,32D1,32D2,32D3,32D4,4E27

[austriasat]
caid=0D05,0D95
srvid=003E,07FF,4462,4461,2EFE,6FEE,6FEF,6FF0,6FFD,6FFF,07FA,07FD,0046,0045

[kdhome]
caid=1702,1722,1834
srvid=c41c,c43c,c425,c424,c423,c41e,c41f,c42f,c420,c432,c427,c42b,c42d,c42e,c419,c41a,c438,c437,c433,c443,c446,c447,c445,c430,c438,c439,c43a,c43b,c43f,c441,c442,cf6d,cf74,d09a,d09f,cf71,d09d,cf78,c612,cf79,cf7a,cfd8,d109,d0a0,d048,2714,cf7b,cf09,c3bb,c480,d0a4,c3bc,d0a5,c3ba,c481,c47f,c618,c619,d035,c614,c3b9,d099,c3bd,d03e,c3b8,c60d,d0a3,d036,c47d,d0a1,c482,c3b6,d09c,c617,c611,c483,c616,c615,d16b,c3bf,cf73,cf70,c610,c60f,c3b7,c47e,c613,d166,d174,d049,d10b,d045,d176,d175,d161,d163,d17a,d164,d098,d171,c4e2,d179,d17b,d041,cf77,cf0e,d168,c490,cf0a,d162,d178,cf12,d167,cf76,d172,cf0d,d169,c3be,d177,d16c,d17e,d173,cf17,d170,c499,d10a,d16f,cf7e,d16e,d038,cf0c,d046,cf09,d0a2,d16d,d165,cfdd,cfdb,d04d,d10d,d10e,d10f,d03f,d040,d039,d047,d047,d044,d042,cf7f,c3b5,d03a,cfd1,d043,cf75,d03b,cfe3,d04a,cf0f,d04c,d04b,d03d,cfd3,cfd5,cfda,d100,d106,d0fd,d107,d0fe,d108,d0ff,cfe2,cfd2,cfdc,d03c,cfdf,d101,d102,d103,cfd4,cf72,cfe0,d104,d105,cf6d,cf74,d09a,d09f,cf71,d09d,cf78,c612,cf79,cf7a,cfd8,d109,d0a0,d048,2714,cf7b,cf09,cfe1,cfd6,cfd9

[mtv]
caid=0B00
srvid=6FF3,6FEE,6FEF,6FF1,6FF0,6FFF

[srg]
caid=0500
srvid=36B3,36B2,36B8,36B9,0385,038B,03DE

[canalnl]
caid=0100,0622
srvid=4F7E,6FEF,6FF0,6FF1,6FF3,6FB8,1F47,1F4C,6FFF,7007,2267,2270,4F50,4F56,4F57,219F,07D4,07D5,07D6,07DA,07DF,07E4,07E9,07EE,07F9,07FD,0820,4F8E,0FA5,0FA6,0FA7,0FAE,0FAF,0FC8,138D,1397,139C,139F,13A4,13A5,13A6,13A8,31E7,31E8,177F,1784,1789,178E,1793,1798,179D,17A2,17A7,17AC,17B1,17B6,1B62,1B67,1B6C,1B71,1B76,1B7B,5156,5158,13B1,13B2,4F56,4F57,07F3,0FAE,0FAF,0FC8,0FCD,138C,138D,1397,139C,31E8,0fab,0fac,0fad,0fab

[skyuk]
caid=0963
srvid=f29,f29,ef2,3881,ef9,ee6,f2d,3833,3806,eda,3802,3862,f16,3821,eed,13f2,16a9,2485,ccb5,ccba,ccbf,ccd8,ccdd,cb90,1979,1dce,183a,d00c,c5c6,2463,2494,d35b,c7c9,122f,1dbb,1bbe,1bbd,1774,cc09,177e,1776,1788,1bc5,1bbc,1591,1772,177c,cc08,2f03,2f08,1bbf,cb8f,1710,c481,1537,c4f4,d444,2484,cbc9,13a1,196a,1dc8,2328,ccb0,ccd3,183f,183b,d016,cfd5,183e,1841,1839,cfee,183c,2329,232f,232a,232b,cd32,d2f9,cb84,ccc4,ccce,ccc9,2586,168a,2f12,2f0d,1966,c49f,c74d,164e,1391,c4ae,1e14,1e15,1e16,1e17,1e1e,1e1f,1e23,1e24,c357,158b,2487,1968,1db5,d7cb,196c,1dce,1392,c7a6,122d,138b,1965,1e0a,1db1,1db0,1840,1842,2f4e,2f6c,2f45,2f44,2f62,2e58,2486,1585,12c4,1582,1771,cc0a,1775,1773,1777,cc06,1583,d421,2efe,d057,d0fc,d101,1b81,1b59,1b62,1b5f,1b66,1b5e,1b6d,1b5b,1b5d,1b64,0ffa,11ff,1647,1200,139d,d453,15e6,15e5,d026,15e1,15e3,15e2,d426,15e4,d7d3,d15d,232c,2332,d156,16ac,c5a8,1dc4,1dc4,1139,14bc,d2ff,d2fb,c5b2,c5b7,d2f1,d2f6,d2fc,12fc,125d,10ce,11fc,247e,10d1,10cf,157e,1133,10d2,122a,122c,1233,138d,10d0,11fa,122b,107d,1332,1076,1078,1070,107e,157f,107b,119f,11a1,2481,155f,1560,1561,1562,1563,1564,1565,1566,156e,152b,152a,1569,1570,156d,1528,1527,1571,156f,156c,1525,156a,1523,156b,1524,1529,1526,132b,132d,132e,132c,1519,151c,153a,247d,125f,1261,13f0,13ef,247c,0f41,2460,c350,cb91,1320,131f,cb8c,1652,1592,1456,d43f,1b61,1bc4,183d,113a,2587,1976,1970,196b,1db6,125e,12ca,12cc,12cd,1567,1210,120f,17d7,2fa7,c355,1b5a,1b60,cc07,cc0b,1978,1dbf,1969,d04d

[skyit]
caid=093b
srvid=3BC5,3BC9,3BCD,3BD0,3BE3,3BE5,3BE6,3BE7,3BE8,3BE9,3BEA,3BEB,3BEC,3BED,3BFE,BFF,3C00,3C04,3C06,3C0A,3C0B,3C0C,3C0D,3C0E,3C0F,3C10,3C11,3C12,3C13,3C14,3C15,3C16,3C17,3C18,3C19,3C1A,3C1C,38C1,38CC,38D0,38DF,38E3,38F3,3900,38D1,38D2,38D3,38D4,38D5,38D6,38D7,38D8,38D9,38DA,38DB,38DC,20EC,20ED,0D49,0D4A,0D4B,0DC0,0DC1,0DC7,0DCA,0DCC,0DCF,0DFA,0E04,10E1,10E3,10E7,10E8,10E9,10EA,10EC,1109,110A,110B,1123,1128,0E2E,0E2F,0E30,0E31,0E33,0E39,2AB3,2AB4,1FB9,1FBA,1FBB,1FBC,1FBD,1FBE,1FC1,1FC3,1FC5,1FC9,1FCB,2B67,2B6E,2B70,2B7A,2B7C,2DC6,2DC7,2BCF,2BD1,2BD3,2BD5,2BD7,2BD9,0582,0595,0597,0599,05A3,05AD,05B9,05BB,0F6D,0F6F,24CF,24E4,24E5,24E6,24E7,2500,2501,2503,2504,2507,2C27,2C28,2C2A,2C33,2C36,2C37,2C38,2C9C,2CBA,2CBE,2CC1,2CC4,3420,3437,3439,2CF7,2CFE,2CFF,2D02,2D03,2D04,2D08,2D13,2D16,2D17,2D52,2B5D,2B5F,2B61,2B6B,2DCA,2DCC,0F71

[tivusat]
CAID=183d
srvid=0001,0002,0003,0004,0005,0D49,0D4A,0D4B,213F,2140, 2141,2142,0CEA,0D52,0D66,0E1E,2136

[cyfra+]
caid=0100
srvid=1132,1135,1136,1137,1139,113D,113E,114D,114E,114F,1150,3D55,3D57,3D5D,3D5E,3D5F,3D60,3D61,3D62,0E06,21CB,12C1,12C2,12C4,12C5,12C6,12C7,12C8,12C9,12CB,1D2A,1D2B,1D2C,0001,0002,0004,000A,3914,3915,1C9C,332F,35E9,3607,3635,3B63,3B65,3B66,3B67,32DD,32DE,32DF,32E1,32E2,3305,10D7,10D8,10D9,10DE,10DF,10E0,13F0,13F1,13F6,13F7,1402,1C86,1C87,1C89,1C8B,1C93,1C96,1CAC,1CB5,1CCA,1CCF,0069,0C1F,0C21,2909,2918,3A35,3A36,

[polsat]
caid=1803
srvid=390A,390B,390C,390D,332D,332E,3330,3331,3332,3336,0C23,290C,290D,0C25

[absat]
caid=0100,0500,1811
srvid=427F,427D,427C,4286,428C,428A,4289,4285,4281,4287,428D,428B,4282,4280,4286,4284,4290

[xxx]
caid=0500,0100,093b,4AE1
srvid=000A,0014,001E,35C0,35C1,43B8,43B7,43B6,43B5,35C8,35C7,35C6,35C3,35C4,35C2,4F55,4F62,378F,378D,378C,3788,378A,1251,3786,31F4,24C1,0082,0086,004A,004B,1251

[nova]
caid=0604
srvid=11F9,1D4D,1D4E,1D4F,1D51,1D52,1D53,1D54,1D55,1D56,1D57,1D7E,1D88,1D8F,1D97,1D99,1D9A,1D59,1D6A,1D83,1D84,1D94,1D95,1D93,35E9,3607,012D,012F,0130,0132,0133,0134,013C,013D,013E,013F,0140,0141,0142,0144,0145,0146,0147,0135,0136,0137,0138,0139,013A,0143,0148,0149,1BBE,1BBF,1BC0,1BC2,1BC3,1BC4,1BC5,1BC7,1BC8,1BC9,1BCA,1BCB,1BCC,1BCE,1BD0,1BD1,1BD2,1BC1,1BCD,1BD3,1BBD,015F,0160,0161,0162,0163,0164,0165,0166,0168,0169,016A,016B,016F,0170,0171,0178,0179,017A,017C,017D,017F,016C,016D,016E,0172,0173,0174,0175

[digital]
caid=0100,1810
srvid=768E,768F,7690,7691,7692,7694,7695,7696,7699,74FE,74FF,7500,7501,7503,7504,7505,7506,7509,750A,75AC,7788,7789,778A,778B,778C,778D,778E,778F,7790,7792,7793,779C,779D,77BB,77BD,77BE,77BF,77C1,77C2,77C3,77C6,77C7,77C9,77CB,77D8,76C0,76C1,76C3,76C4,76C5,76C6,76C7,76C8,76CA,76CC,7564,7565,7566,7567,7568,7569,756A,756B,756C,756E,756F,7729,772B,772D,772E,772F,7730,7731,7732,7738,773A,7469,746A,746B,746C,746D,746E,746F,7470,7471,7472,7473,7474,7475,7476,74CC,74CD,74CF,75FE,7601,7602,7603,760C,7604,6FEB,6FF0,6FF3,6FF4

[d-smart]
caid=092B
srvid=070B,070D,070E,070F,0712,0713,0714,0715,0716,0717,0718,071C,071D,057B,057D,057F,0580,0581,0582,0583,0584,0587,0589,058A,058B,058C,058D,011E,000A,0022,0024,0025,05E2,05E7,05E8,05EA,05EB,05EC,05F0,0641,0642,0643,0644,0645,0646,0647,0648

[digiturk]
CAID=0D00,0664
srvid=00CC,00CD,00CE,00D0,00D1,044E,044F,0451,0453,0454,0455,0456,0457,1D4D,1D4E,1D4F,1D50,1D51,1D53,1D54,1D56,1D58,1D59,1D5B,1D5C,1D5D,05DD,05DE,05E0,05E1,05E6,05EC,061A,061B,14B5,14B6,14B7,14B8,14BF,14C3,14C4,14C5,14C7,14C8,14D3,14D4,14D5,14D6,14DA,14DB,14DC,14DD,14DE,14DF,14E0,06A5,06A6,06A8,06A9,06AA,06AB,06AC,06AE,06AF,06B0,06B1,1DB1,1DB2,1DB3,1DB4,1DB5,1DB6,1DB8,1DB9,08FD,08FE,0903,0905,0906,0907,0909,0916,0917,0924,0932,1902,1903,1904,1906,1907,1908,190A,190B,1914,193D,194C,1921,193C,1951,1C85,1C86,1C88,1C8A,1C8B,1C8D,1C8E,1CC0,1CE9,1CEA,1CEB,1CEC,1CED,1CEE,1CEF,1CF0,1CF1,1CF2,1CF3,1CF4,1CF5,1CF6,1CF7,1CF8,1CF9,1CFA,1CFB,1CFC,1CFD,1CFE,1CFF,1D00,1D01,1D02,1D09,1D0A,1D0F,1D10,1D03,1D06,1CCD,025A,025B,025C,025D,0260,0263,027C,027E,028C,0294,02B2,10CD,10CE,10CF,10D0,10D1,10D2,10D4,10DA,10DC,10DD,14F0,14F1,0299,150E




" > /var/keys/vizcam.conf
fi
if [ -e /var/keys/Benutzerdaten/.emu/portcccam ]; then
/bin/echo "C: $DYNDNS $CCCPORT $USERNAME $PASSWORD yes" > /var/keys/cccamd.list
fi
emu=`cat /var/keys/Benutzerdaten/.emu/mgcamd_oder_cccam`
if [ "$emu" = "mgcamd" ]; then
/bin/echo "# oscam.server generated automatically by Streamboard OSCAM 1.10rc-svn build #5954
# Read more: http://streamboard.gmc.to/svn/oscam/trunk/Distribution/doc/txt/oscam.server.txt

[reader]
label                         = sky
protocol                      = newcamd
device                        = $DYNDNS,$NEWPORT1
key                           = 0102030405060708091011121314
user                          = $USERNAME
password                      = $PASSWORD
group                         = 1


[reader]
label                         = hd-plus
protocol                      = newcamd
device                        = $DYNDNS,$NEWPORT2
key                           = 0102030405060708091011121314
user                          = $USERNAME
password                      = $PASSWORD
group                         = 1
" > /var/keys/oscam.server
else
/bin/echo "# oscam.server generated automatically by Streamboard OSCAM 1.10rc-svn build #5954
# Read more: http://streamboard.gmc.to/svn/oscam/trunk/Distribution/doc/txt/oscam.server.txt

[reader]
 Label = cccam
 protocol = cccam
 device = $DYNDNS,$CCCPORT
 account = $USERNAME,$PASSWORD
 group = 1
" > /var/keys/oscam.server
fi
if [ -e /var/keys/Benutzerdaten/.emu/camd3 ]; then
/bin/echo "cs357x://$USERNAME:$PASSWORD@$DYNDNS:$CAMD3" > /var/keys/camd3.servers
fi
echo "alle Daten wurden erfolgreich geschrieben" > /dev/vfd
sleep 5
echo "Benutzerdaten gesetzt"
exit 0
