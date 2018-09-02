/*
 * Declarations for the YM2612.
 *
 * http://www.smspower.org/maxim/Documents/YM2612
 */

#ifndef _ASM_YM2612_REGS_H
#define _ASM_YM2612_REGS_H

/* low frequency oscillator */
#define YM2612_REG_LFO			0x22
#define YM2612_LFO_ENABLE		0x10
#define YM2612_LFO_FREQ_3_98		0x00
#define YM2612_LFO_FREQ_5_56		0x01
#define YM2612_LFO_FREQ_6_02		0x02
#define YM2612_LFO_FREQ_6_37		0x03
#define YM2612_LFO_FREQ_6_88		0x04
#define YM2612_LFO_FREQ_9_63		0x05
#define YM2612_LFO_FREQ_48_1		0x06
#define YM2612_LFO_FREQ_72_2		0x07

/* Timer A */
#define YM2612_REG_TIMERAH		0x24
#define YM2612_REG_TIMERAL		0x25

/* Timer B */
#define YM2612_REG_TIMERB		0x26

/* Timers and Ch3/6 mode */
#define YM2612_REG_CH36MODE		0x27
#define YM2612_CH36MODE_CH3_SPECIAL 	0x40
#define YM2612_CH36MODE_RESETB		0x20
#define YM2612_CH36MODE_RESETA		0x10
#define YM2612_CH36MODE_ENABLEB		0x08
#define YM2612_CH36MODE_ENABLEA		0x04
#define YM2612_CH36MODE_LOADB		0x02
#define YM2612_CH36MODE_LOADA		0x01

/* Key on/off */
#define YM2612_REG_KEYONOFF		0x28
#define YM2612_KEYONOFF_OP4		0x80
#define YM2612_KEYONOFF_OP3		0x40
#define YM2612_KEYONOFF_OP2		0x20
#define YM2612_KEYONOFF_OP1		0x10
#define YM2612_KEYONOFF_ALL_OPS		0x80

/* DAC */
#define YM2612_REG_DACDATA		0x2A
#define YM2612_REG_DACENBL		0x2B
#define YM2612_DACENBL_ENABLE		0x80

/*
 * Register name      | Actual | bits  | Actual | bits
 * Detune and Multiple| DT1    | b6-b4 | MUL    | b3-b0
 */

#define YM2612_REG_CH1OP1_DETMUL	0x30
#define YM2612_REG_CH2OP1_DETMUL	0x31
#define YM2612_REG_CH3OP1_DETMUL	0x32

#define YM2612_REG_CH1OP2_DETMUL	0x34
#define YM2612_REG_CH2OP2_DETMUL	0x35
#define YM2612_REG_CH3OP2_DETMUL	0x36

#define YM2612_REG_CH1OP3_DETMUL	0x38
#define YM2612_REG_CH2OP3_DETMUL	0x39
#define YM2612_REG_CH3OP3_DETMUL	0x3A

#define YM2612_REG_CH1OP4_DETMUL	0x3C
#define YM2612_REG_CH2OP4_DETMUL	0x3D
#define YM2612_REG_CH3OP4_DETMUL	0x3E

/*
 * Register name      | Actual | bits
 * Total Level        | TL     | b6-b0
 */

#define YM2612_REG_CH1OP1_TL		0x40
#define YM2612_REG_CH2OP1_TL		0x41
#define YM2612_REG_CH3OP1_TL		0x42

#define YM2612_REG_CH1OP2_TL		0x44
#define YM2612_REG_CH2OP2_TL		0x45
#define YM2612_REG_CH3OP2_TL		0x46

#define YM2612_REG_CH1OP3_TL		0x48
#define YM2612_REG_CH2OP3_TL		0x49
#define YM2612_REG_CH3OP3_TL		0x4A

#define YM2612_REG_CH1OP4_TL		0x4C
#define YM2612_REG_CH2OP4_TL		0x4D
#define YM2612_REG_CH3OP4_TL		0x4E

/*
 * Register name            | Actual | bits  | Actual | bits
 * Rate Scaling Attack Rate | RS     | b7-b6 | AR     | b4-b0
 */

#define YM2612_REG_CH1OP1_RATEH		0x50
#define YM2612_REG_CH2OP1_RATEH		0x51
#define YM2612_REG_CH3OP1_RATEH		0x52

#define YM2612_REG_CH1OP2_RATEH		0x54
#define YM2612_REG_CH2OP2_RATEH		0x55
#define YM2612_REG_CH3OP2_RATEH		0x56

#define YM2612_REG_CH1OP3_RATEH		0x58
#define YM2612_REG_CH2OP3_RATEH		0x59
#define YM2612_REG_CH3OP3_RATEH		0x5A

#define YM2612_REG_CH1OP4_RATEH		0x5C
#define YM2612_REG_CH2OP4_RATEH		0x5D
#define YM2612_REG_CH3OP4_RATEH		0x5E

/*
 * Register name            | Actual | bits  | Actual | bits
 * First Decay Rate Amp Mod | AM     | b7    | D1R    | b4-b0
 */
#define YM2612_REG_CH1OP1_RATEMH	0x60
#define YM2612_REG_CH2OP1_RATEMH	0x61
#define YM2612_REG_CH3OP1_RATEMH	0x62

#define YM2612_REG_CH1OP2_RATEMH	0x64
#define YM2612_REG_CH2OP2_RATEMH	0x65
#define YM2612_REG_CH3OP2_RATEMH	0x66

#define YM2612_REG_CH1OP3_RATEMH	0x68
#define YM2612_REG_CH2OP3_RATEMH	0x69
#define YM2612_REG_CH3OP3_RATEMH	0x6A

#define YM2612_REG_CH1OP4_RATEMH	0x6C
#define YM2612_REG_CH2OP4_RATEMH	0x6D
#define YM2612_REG_CH3OP4_RATEMH	0x6E

/*
 * Register name            | Actual | bits  
 * Secondary Decay Rate     | D2R    | b4-b0
 */

#define YM2612_REG_CH1OP1_RATEML	0x70
#define YM2612_REG_CH2OP1_RATEML	0x71
#define YM2612_REG_CH3OP1_RATEML	0x72

#define YM2612_REG_CH1OP2_RATEML	0x74
#define YM2612_REG_CH2OP2_RATEML	0x75
#define YM2612_REG_CH3OP2_RATEML	0x76

#define YM2612_REG_CH1OP3_RATEML	0x78
#define YM2612_REG_CH2OP3_RATEML	0x79
#define YM2612_REG_CH3OP3_RATEML	0x7A

#define YM2612_REG_CH1OP4_RATEML	0x7C
#define YM2612_REG_CH2OP4_RATEML	0x7D
#define YM2612_REG_CH3OP4_RATEML	0x7E

/*
 * Register name            | Actual | bits  | Actual | bits
 * Decay Level Release Rate | D1L    | b7-b4 | RR     | b3-b0
 */

#define YM2612_REG_CH1OP1_RATEL		0x80
#define YM2612_REG_CH2OP1_RATEL		0x81
#define YM2612_REG_CH3OP1_RATEL		0x82

#define YM2612_REG_CH1OP2_RATEL		0x84
#define YM2612_REG_CH2OP2_RATEL		0x85
#define YM2612_REG_CH3OP2_RATEL		0x86

#define YM2612_REG_CH1OP3_RATEL		0x88
#define YM2612_REG_CH2OP3_RATEL		0x89
#define YM2612_REG_CH3OP3_RATEL		0x8A

#define YM2612_REG_CH1OP4_RATEL		0x8C
#define YM2612_REG_CH2OP4_RATEL		0x8D
#define YM2612_REG_CH3OP4_RATEL		0x8E

/*
 * Register name            | Actual | bits
 * SSG-EG                   | SSG-EG | b3-b0
 */

#define YM2612_REG_CH1OP1_SSGEG		0x90
#define YM2612_REG_CH2OP1_SSGEG		0x91
#define YM2612_REG_CH3OP1_SSGEG		0x92

#define YM2612_REG_CH1OP2_SSGEG		0x94
#define YM2612_REG_CH2OP2_SSGEG		0x95
#define YM2612_REG_CH3OP2_SSGEG		0x96

#define YM2612_REG_CH1OP3_SSGEG		0x98
#define YM2612_REG_CH2OP3_SSGEG		0x99
#define YM2612_REG_CH3OP3_SSGEG		0x9A

#define YM2612_REG_CH1OP4_SSGEG		0x9C
#define YM2612_REG_CH2OP4_SSGEG		0x9D
#define YM2612_REG_CH3OP4_SSGEG		0x9E

/*
 * Register name            | Actual  | bits
 * Frequency LSB            | FreqLSB | b7-b0
 */

#define YM2612_REG_CH1_FREQL		0xA0
#define YM2612_REG_CH2_FREQL		0xA1

/*
 * Register name              | Actual | bits  | Actual  | bits
 * Frequency MSB Octave Block | Block  | b5-b3 | FreqMSB | b2-b0
 */

#define YM2612_REG_CH1_FREQH		0xA4
#define YM2612_REG_CH2_FREQH		0xA5

/*
 * Register name                             | Actual  | bits
 * Channel 3 Supplement Frequency Number LSB | FreqLSB | b7-b0
 */

#define YM2612_REG_CH3OP1_FREQL		0xA2
#define YM2612_REG_CH3OP2_FREQL		0xA8
#define YM2612_REG_CH3OP3_FREQL		0xA9
#define YM2612_REG_CH3OP4_FREQL		0xAA

/*
 * Register name                               | Actual  | bits  | Actual  | bits
 * Ch3 Suppl. Octave Block Ch3 Suppl. Freq MSB | Block   | b5-b3 | FreqMSB | b2-b0
 */

#define YM2612_REG_CH3OP1_FREQH		0xA6
#define YM2612_REG_CH3OP2_FREQH		0xAC
#define YM2612_REG_CH3OP3_FREQH		0xAD
#define YM2612_REG_CH3OP4_FREQH		0xAE

/*
 * Register name      | Actual   | bits  | Actual    | bits
 * Feedback Algorithm | Feedback | b5-b3 | Algorithm | b2-b0
 */

#define YM2612_REG_CH1_ALGO		0xB0
#define YM2612_REG_CH2_ALGO		0xB1
#define YM2612_REG_CH3_ALGO		0xB2

/*
 * Register name          | Actual | bits | Actual | bits | Actual | bits  | Actual | bits
 * Stereo LFO Sensitivity | L      | b7   | R      | b6   | AMS    | b5-b3 | FMS    | b1-b0
 */

#define YM2612_REG_CH1_STSENS		0xB4
#define YM2612_REG_CH2_STSENS		0xB5
#define YM2612_REG_CH3_STSENS		0xB6

#endif
