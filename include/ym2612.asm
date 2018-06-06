; low frequency oscillator
YM2612_REG_LFO			equ $22

; Timer A
YM2612_REG_TIMERAH		equ $24
YM2612_REG_TIMERAL		equ $25

; Timer B
YM2612_REG_TIMERB		equ $26

; Timers and Ch3/6 mode
YM2612_REG_CH36MODE		equ $27

; Key on/off
YM2612_REG_KEYONOFF		equ $28

; DAC
YM2612_REG_DACDATA		equ $2A
YM2612_REG_DACENBL		equ $2B

;Register name      | Actual | bits  | Actual | bits
;Detune and Multiple| DT1    | b6-b4 | MUL    | b3-b0

YM2612_REG_CH1OP1_DETMUL	equ $30
YM2612_REG_CH2OP1_DETMUL	equ $31
YM2612_REG_CH3OP1_DETMUL	equ $32

YM2612_REG_CH1OP2_DETMUL	equ $34
YM2612_REG_CH2OP2_DETMUL	equ $35
YM2612_REG_CH3OP2_DETMUL	equ $36

YM2612_REG_CH1OP3_DETMUL	equ $38
YM2612_REG_CH2OP3_DETMUL	equ $39
YM2612_REG_CH3OP3_DETMUL	equ $3A

YM2612_REG_CH1OP4_DETMUL	equ $3C
YM2612_REG_CH2OP4_DETMUL	equ $3D
YM2612_REG_CH3OP4_DETMUL	equ $3E

;Register name      | Actual | bits
;Total Level        | TL     | b6-b0

YM2612_REG_CH1OP1_TL		equ $40
YM2612_REG_CH2OP1_TL		equ $41
YM2612_REG_CH3OP1_TL		equ $42

YM2612_REG_CH1OP2_TL		equ $44
YM2612_REG_CH2OP2_TL		equ $45
YM2612_REG_CH3OP2_TL		equ $46

YM2612_REG_CH1OP3_TL		equ $48
YM2612_REG_CH2OP3_TL		equ $49
YM2612_REG_CH3OP3_TL		equ $4A

YM2612_REG_CH1OP4_TL		equ $4C
YM2612_REG_CH2OP4_TL		equ $4D
YM2612_REG_CH3OP4_TL		equ $4E

;Register name            | Actual | bits  | Actual | bits
;Rate Scaling Attack Rate | RS     | b7-b6 | AR     | b4-b0

YM2612_REG_CH1OP1_RATEH		equ $50
YM2612_REG_CH2OP1_RATEH		equ $51
YM2612_REG_CH3OP1_RATEH		equ $52

YM2612_REG_CH1OP2_RATEH		equ $54
YM2612_REG_CH2OP2_RATEH		equ $55
YM2612_REG_CH3OP2_RATEH		equ $56

YM2612_REG_CH1OP3_RATEH		equ $58
YM2612_REG_CH2OP3_RATEH		equ $59
YM2612_REG_CH3OP3_RATEH		equ $5A

YM2612_REG_CH1OP4_RATEH		equ $5C
YM2612_REG_CH2OP4_RATEH		equ $5D
YM2612_REG_CH3OP4_RATEH		equ $5E

;Register name            | Actual | bits  | Actual | bits
;First Decay Rate Amp Mod | AM     | b7    | D1R    | b4-b0 

YM2612_REG_CH1OP1_RATEMH	equ $60
YM2612_REG_CH2OP1_RATEMH	equ $61
YM2612_REG_CH3OP1_RATEMH	equ $62

YM2612_REG_CH1OP2_RATEMH	equ $64
YM2612_REG_CH2OP2_RATEMH	equ $65
YM2612_REG_CH3OP2_RATEMH	equ $66

YM2612_REG_CH1OP3_RATEMH	equ $68
YM2612_REG_CH2OP3_RATEMH	equ $69
YM2612_REG_CH3OP3_RATEMH	equ $6A

YM2612_REG_CH1OP4_RATEMH	equ $6C
YM2612_REG_CH2OP4_RATEMH	equ $6D
YM2612_REG_CH3OP4_RATEMH	equ $6E

;Register name            | Actual | bits  
;Secondary Decay Rate     | D2R    | b4-b0

YM2612_REG_CH1OP1_RATEML	equ $70
YM2612_REG_CH2OP1_RATEML	equ $71
YM2612_REG_CH3OP1_RATEML	equ $72

YM2612_REG_CH1OP2_RATEML	equ $74
YM2612_REG_CH2OP2_RATEML	equ $75
YM2612_REG_CH3OP2_RATEML	equ $76

YM2612_REG_CH1OP3_RATEML	equ $78
YM2612_REG_CH2OP3_RATEML	equ $79
YM2612_REG_CH3OP3_RATEML	equ $7A

YM2612_REG_CH1OP4_RATEML	equ $7C
YM2612_REG_CH2OP4_RATEML	equ $7D
YM2612_REG_CH3OP4_RATEML	equ $7E

;Register name            | Actual | bits  | Actual | bits
;Decay Level Release Rate | D1L    | b7-b4 | RR     | b3-b0

YM2612_REG_CH1OP1_RATEL		equ $80
YM2612_REG_CH2OP1_RATEL		equ $81
YM2612_REG_CH3OP1_RATEL		equ $82

YM2612_REG_CH1OP2_RATEL		equ $84
YM2612_REG_CH2OP2_RATEL		equ $85
YM2612_REG_CH3OP2_RATEL		equ $86

YM2612_REG_CH1OP3_RATEL		equ $88
YM2612_REG_CH2OP3_RATEL		equ $89
YM2612_REG_CH3OP3_RATEL		equ $8A

YM2612_REG_CH1OP4_RATEL		equ $8C
YM2612_REG_CH2OP4_RATEL		equ $8D
YM2612_REG_CH3OP4_RATEL		equ $8E

;Register name            | Actual | bits
;SSG-EG                   | SSG-EG | b3-b0

YM2612_REG_CH1OP1_SSGEG		equ $90
YM2612_REG_CH2OP1_SSGEG		equ $91
YM2612_REG_CH3OP1_SSGEG		equ $92

YM2612_REG_CH1OP2_SSGEG		equ $94
YM2612_REG_CH2OP2_SSGEG		equ $95
YM2612_REG_CH3OP2_SSGEG		equ $96

YM2612_REG_CH1OP3_SSGEG		equ $98
YM2612_REG_CH2OP3_SSGEG		equ $99
YM2612_REG_CH3OP3_SSGEG		equ $9A

YM2612_REG_CH1OP4_SSGEG		equ $9C
YM2612_REG_CH2OP4_SSGEG		equ $9D
YM2612_REG_CH3OP4_SSGEG		equ $9E

;Register name            | Actual  | bits
;Frequency LSB            | FreqLSB | b7-b0

YM2612_REG_CH1_FREQL		equ $A0
YM2612_REG_CH2_FREQL		equ $A1

;Register name              | Actual | bits  | Actual  | bits
;Frequency MSB Octave Block | Block  | b5-b3 | FreqMSB | b2-b0

YM2612_REG_CH1_FREQH		equ $A4
YM2612_REG_CH2_FREQH		equ $A5

;Register name                             | Actual  | bits
;Channel 3 Supplement Frequency Number LSB | FreqLSB | b7-b0

YM2612_REG_CH3OP1_FREQL		equ $A2
YM2612_REG_CH3OP2_FREQL		equ $A8
YM2612_REG_CH3OP3_FREQL		equ $A9
YM2612_REG_CH3OP4_FREQL		equ $AA

;Register name                               | Actual  | bits  | Actual  | bits
;Ch3 Suppl. Octave Block Ch3 Suppl. Freq MSB | Block   | b5-b3 | FreqMSB | b2-b0

YM2612_REG_CH3OP1_FREQH		equ $A6
YM2612_REG_CH3OP2_FREQH		equ $AC
YM2612_REG_CH3OP3_FREQH		equ $AD
YM2612_REG_CH3OP4_FREQH		equ $AE

;Register name      | Actual   | bits  | Actual    | bits
;Feedback Algorithm | Feedback | b5-b3 | Algorithm | b2-b0

YM2612_REG_CH1_ALGO		equ $B0
YM2612_REG_CH2_ALGO		equ $B1
YM2612_REG_CH3_ALGO		equ $B2

;Register name          | Actual | bits | Actual | bits | Actual | bits  | Actual | bits
;Stereo LFO Sensitivity | L      | b7   | R      | b6   | AMS    | b5-b3 | FMS    | b1-b0

YM2612_REG_CH1_STSENS		equ $B4
YM2612_REG_CH2_STSENS		equ $B5
YM2612_REG_CH3_STSENS		equ $B6
