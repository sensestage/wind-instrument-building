EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_01x08 J5
U 1 1 629A4C90
P 6075 3050
F 0 "J5" H 6155 3042 50  0000 L CNN
F 1 "ESP32-S2" H 6155 2951 50  0000 L CNN
F 2 "Pinheader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 6075 3050 50  0001 C CNN
F 3 "~" H 6075 3050 50  0001 C CNN
	1    6075 3050
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x08 J3
U 1 1 629A523B
P 5325 3900
F 0 "J3" V 5197 4280 50  0000 L CNN
F 1 "MPU6050" V 5288 4280 50  0000 L CNN
F 2 "Pinheader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 5325 3900 50  0001 C CNN
F 3 "~" H 5325 3900 50  0001 C CNN
	1    5325 3900
	0    1    1    0   
$EndComp
Wire Wire Line
	5875 2750 5800 2750
Wire Wire Line
	4325 3350 5325 3350
$Comp
L Connector_Generic:Conn_01x08 J1
U 1 1 629A4657
P 4125 3050
F 0 "J1" H 4043 3567 50  0000 C CNN
F 1 "ESP32-S2" H 4043 3476 50  0000 C CNN
F 2 "Pinheader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 4125 3050 50  0001 C CNN
F 3 "~" H 4125 3050 50  0001 C CNN
	1    4125 3050
	-1   0    0    -1  
$EndComp
$Comp
L Device:R_Small R0
U 1 1 629AEE42
P 4950 2950
F 0 "R0" V 4950 3275 50  0000 C CNN
F 1 "R_Small" V 4950 3025 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 4950 2950 50  0001 C CNN
F 3 "~" H 4950 2950 50  0001 C CNN
	1    4950 2950
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R1
U 1 1 629AF446
P 4950 3050
F 0 "R1" V 4950 3375 50  0000 C CNN
F 1 "R_Small" V 4950 3125 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 4950 3050 50  0001 C CNN
F 3 "~" H 4950 3050 50  0001 C CNN
	1    4950 3050
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R2
U 1 1 629AFC32
P 4950 3150
F 0 "R2" V 4950 3475 50  0000 C CNN
F 1 "R_Small" V 4950 3250 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 4950 3150 50  0001 C CNN
F 3 "~" H 4950 3150 50  0001 C CNN
	1    4950 3150
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R3
U 1 1 629B0121
P 4950 3250
F 0 "R3" V 4950 3575 50  0000 C CNN
F 1 "R_Small" V 4950 3350 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" H 4950 3250 50  0001 C CNN
F 3 "~" H 4950 3250 50  0001 C CNN
	1    4950 3250
	0    1    1    0   
$EndComp
Wire Wire Line
	5050 3250 5175 3250
Wire Wire Line
	5175 3250 5175 3150
Wire Wire Line
	5175 2750 4325 2750
Wire Wire Line
	5050 3150 5175 3150
Connection ~ 5175 3150
Wire Wire Line
	5175 3150 5175 3050
Wire Wire Line
	5050 3050 5175 3050
Connection ~ 5175 3050
Wire Wire Line
	5175 3050 5175 2950
Wire Wire Line
	5050 2950 5175 2950
Connection ~ 5175 2950
Wire Wire Line
	5175 2750 5175 2950
Connection ~ 5800 2750
Wire Wire Line
	4450 2950 4325 2950
Wire Wire Line
	4550 3050 4325 3050
Wire Wire Line
	4650 3150 4325 3150
Wire Wire Line
	4750 3250 4325 3250
Wire Wire Line
	4850 2950 4450 2950
Connection ~ 4450 2950
Wire Wire Line
	4850 3050 4550 3050
Connection ~ 4550 3050
Wire Wire Line
	4850 3150 4650 3150
Connection ~ 4650 3150
Wire Wire Line
	4850 3250 4750 3250
Connection ~ 4750 3250
Wire Wire Line
	5800 2400 5800 2750
Wire Wire Line
	5800 2300 5800 2400
Connection ~ 5800 2400
Wire Wire Line
	5800 2200 5800 2300
Connection ~ 5800 2300
Wire Wire Line
	5800 2100 5800 2200
Connection ~ 5800 2200
Wire Wire Line
	4750 2400 4750 3250
Wire Wire Line
	4650 2300 4650 3150
Wire Wire Line
	4550 2200 4550 3050
Wire Wire Line
	4450 2100 4450 2950
Wire Wire Line
	5175 3250 5625 3250
Wire Wire Line
	5625 3250 5625 3700
Connection ~ 5175 3250
Wire Wire Line
	5525 2750 5525 3700
Wire Wire Line
	5525 2750 5700 2750
$Comp
L power:GND #PWR0101
U 1 1 629DAF1B
P 5700 2800
F 0 "#PWR0101" H 5700 2550 50  0001 C CNN
F 1 "GND" H 5705 2627 50  0000 C CNN
F 2 "" H 5700 2800 50  0001 C CNN
F 3 "" H 5700 2800 50  0001 C CNN
	1    5700 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 2800 5700 2750
Connection ~ 5700 2750
Wire Wire Line
	5700 2750 5800 2750
$Comp
L power:+3.3V #PWR0102
U 1 1 629DCEB1
P 5175 2700
F 0 "#PWR0102" H 5175 2550 50  0001 C CNN
F 1 "+3.3V" H 5190 2873 50  0000 C CNN
F 2 "" H 5175 2700 50  0001 C CNN
F 3 "" H 5175 2700 50  0001 C CNN
	1    5175 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5175 2700 5175 2750
Connection ~ 5175 2750
Text Label 4325 3350 0    50   ~ 0
SDA
Text Label 4325 2950 0    50   ~ 0
A0
Text Label 4325 3050 0    50   ~ 0
A1
Text Label 4325 3150 0    50   ~ 0
A2
Text Label 4325 3250 0    50   ~ 0
A3
$Comp
L Connector_Generic:Conn_02x04_Odd_Even J2
U 1 1 629C649E
P 5075 2200
F 0 "J2" H 5125 2150 50  0000 C CNN
F 1 "sensors" H 5125 1900 50  0000 C CNN
F 2 "Pinheader_2.54mm:PinHeader_2x04_P2.54mm_Horizontal" H 5075 2200 50  0001 C CNN
F 3 "~" H 5075 2200 50  0001 C CNN
	1    5075 2200
	1    0    0    -1  
$EndComp
Text Label 4325 3450 0    50   ~ 0
SCL
Wire Wire Line
	4450 2100 4875 2100
Wire Wire Line
	4550 2200 4875 2200
Wire Wire Line
	4650 2300 4875 2300
Wire Wire Line
	4750 2400 4875 2400
Wire Wire Line
	5375 2400 5800 2400
Wire Wire Line
	5375 2200 5800 2200
Wire Wire Line
	5375 2100 5800 2100
Wire Wire Line
	5375 2300 5800 2300
Wire Wire Line
	5425 3450 5425 3700
Wire Wire Line
	4325 3450 5425 3450
Wire Wire Line
	5325 3350 5325 3700
$EndSCHEMATC
