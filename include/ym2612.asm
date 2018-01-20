; Register naming courtesy of ChaosTracker:
; https://github.com/LeviathaninWaves/ChaosTracker/blob/master/v005/YM2612/YGlobals.asm

; low frequency oscillator
YM2612_LFO:			= $22

; Timer A
YM2612_Timer_A_MSB:		= $24
YM2612_Timer_A_LSB:		= $25

; Timer B
YM2612_Timer_B:			= $26

; Timers and Ch3/6 mode
YM2612_Timers_Ch36_Mode:	= $27

; Key on/off
YM2612_Key_On_Off:		= $28

; DAC
YM2612_DAC:			= $2A
YM2612_DAC_Enable:		= $2B

;Register name      | Actual | bits  | Actual | bits
;Detune and Multiple| DT1    | b6-b4 | MUL    | b3-b0

YM2612_Ch1_Ch4_Op1_Det_Mult:	= $30
YM2612_Ch2_Ch5_Op1_Det_Mult:	= $31
YM2612_Ch3_Ch6_Op1_Det_Mult:	= $32

YM2612_Ch1_Ch4_Op2_Det_Mult:	= $34
YM2612_Ch2_Ch5_Op2_Det_Mult:	= $35
YM2612_Ch3_Ch6_Op2_Det_Mult:	= $36

YM2612_Ch1_Ch4_Op3_Det_Mult:	= $38
YM2612_Ch2_Ch5_Op3_Det_Mult:	= $39
YM2612_Ch3_Ch6_Op3_Det_Mult:	= $3a

YM2612_Ch1_Ch4_Op4_Det_Mult:	= $3c
YM2612_Ch2_Ch5_Op4_Det_Mult:	= $3d
YM2612_Ch3_Ch6_Op4_Det_Mult:	= $3e

;Register name      | Actual | bits
;Total Level        | TL     | b6-b0

YM2612_Ch1_Ch4_Op1_TotalLevel:	= $40
YM2612_Ch2_Ch5_Op1_TotalLevel:	= $41
YM2612_Ch3_Ch6_Op1_TotalLevel:	= $42

YM2612_Ch1_Ch4_Op2_TotalLevel:	= $44
YM2612_Ch2_Ch5_Op2_TotalLevel:	= $45
YM2612_Ch3_Ch6_Op2_TotalLevel:	= $46

YM2612_Ch1_Ch4_Op3_TotalLevel:	= $48
YM2612_Ch2_Ch5_Op3_TotalLevel:	= $49
YM2612_Ch3_Ch6_Op3_TotalLevel:	= $4A

YM2612_Ch1_Ch4_Op4_TotalLevel:	= $4C
YM2612_Ch2_Ch5_Op4_TotalLevel:	= $4D
YM2612_Ch3_Ch6_Op4_TotalLevel:	= $4E

;Register name            | Actual | bits  | Actual | bits
;Rate Scaling Attack Rate | RS     | b7-b6 | AR     | b4-b0

YM2612_Ch1_Ch4_Op1_RateScaling_AttackRate: = $50
YM2612_Ch2_Ch5_Op1_RateScaling_AttackRate: = $51
YM2612_Ch3_Ch6_Op1_RateScaling_AttackRate: = $52

YM2612_Ch1_Ch4_Op2_RateScaling_AttackRate: = $54
YM2612_Ch2_Ch5_Op2_RateScaling_AttackRate: = $55
YM2612_Ch3_Ch6_Op2_RateScaling_AttackRate: = $56

YM2612_Ch1_Ch4_Op3_RateScaling_AttackRate: = $58
YM2612_Ch2_Ch5_Op3_RateScaling_AttackRate: = $59
YM2612_Ch3_Ch6_Op3_RateScaling_AttackRate: = $5A

YM2612_Ch1_Ch4_Op4_RateScaling_AttackRate: = $5C
YM2612_Ch2_Ch5_Op4_RateScaling_AttackRate: = $5D
YM2612_Ch3_Ch6_Op4_RateScaling_AttackRate: = $5E

;Register name            | Actual | bits  | Actual | bits
;First Decay Rate Amp Mod | AM     | b7    | D1R    | b4-b0 

YM2612_Ch1_Ch4_Op1_Decay1_AmpMod:	= $60
YM2612_Ch2_Ch5_Op1_Decay1_AmpMod:	= $61
YM2612_Ch3_Ch6_Op1_Decay1_AmpMod:	= $62

YM2612_Ch1_Ch4_Op2_Decay1_AmpMod:	= $64
YM2612_Ch2_Ch5_Op2_Decay1_AmpMod:	= $65
YM2612_Ch3_Ch6_Op2_Decay1_AmpMod:	= $66

YM2612_Ch1_Ch4_Op3_Decay1_AmpMod:	= $68
YM2612_Ch2_Ch5_Op3_Decay1_AmpMod:	= $69
YM2612_Ch3_Ch6_Op3_Decay1_AmpMod:	= $6A

YM2612_Ch1_Ch4_Op4_Decay1_AmpMod:	= $6C
YM2612_Ch2_Ch5_Op4_Decay1_AmpMod:	= $6D
YM2612_Ch3_Ch6_Op4_Decay1_AmpMod:	= $6E

;Register name            | Actual | bits  
;Secondary Decay Rate     | D2R    | b4-b0

YM2612_Ch1_Ch4_Op1_Decay2:	= $70
YM2612_Ch2_Ch5_Op1_Decay2:	= $71
YM2612_Ch3_Ch6_Op1_Decay2:	= $72

YM2612_Ch1_Ch4_Op2_Decay2:	= $74
YM2612_Ch2_Ch5_Op2_Decay2:	= $75
YM2612_Ch3_Ch6_Op2_Decay2:	= $76

YM2612_Ch1_Ch4_Op3_Decay2:	= $78
YM2612_Ch2_Ch5_Op3_Decay2:	= $79
YM2612_Ch3_Ch6_Op3_Decay2:	= $7A

YM2612_Ch1_Ch4_Op4_Decay2:	= $7C
YM2612_Ch2_Ch5_Op4_Decay2:	= $7D
YM2612_Ch3_Ch6_Op4_Decay2:	= $7E

;Register name            | Actual | bits  | Actual | bits
;Decay Level Release Rate | D1L    | b7-b4 | RR     | b3-b0

YM2612_Ch1_Ch4_Op1_DecayLevel_RelRate:	= $80
YM2612_Ch2_Ch5_Op1_DecayLevel_RelRate:	= $81
YM2612_Ch3_Ch6_Op1_DecayLevel_RelRate:	= $82

YM2612_Ch1_Ch4_Op2_DecayLevel_RelRate:	= $84
YM2612_Ch2_Ch5_Op2_DecayLevel_RelRate:	= $85
YM2612_Ch3_Ch6_Op2_DecayLevel_RelRate:	= $86

YM2612_Ch1_Ch4_Op3_DecayLevel_RelRate:	= $88
YM2612_Ch2_Ch5_Op3_DecayLevel_RelRate:	= $89
YM2612_Ch3_Ch6_Op3_DecayLevel_RelRate:	= $8A

YM2612_Ch1_Ch4_Op4_DecayLevel_RelRate:	= $8C
YM2612_Ch2_Ch5_Op4_DecayLevel_RelRate:	= $8D
YM2612_Ch3_Ch6_Op4_DecayLevel_RelRate:	= $8E

;Register name            | Actual | bits
;SSG-EG                   | SSG-EG | b3-b0

YM2612_Ch1_Ch4_Op1_SSGEG:	= $90
YM2612_Ch2_Ch5_Op1_SSGEG:	= $91
YM2612_Ch3_Ch6_Op1_SSGEG:	= $92

YM2612_Ch1_Ch4_Op2_SSGEG:	= $94
YM2612_Ch2_Ch5_Op2_SSGEG:	= $95
YM2612_Ch3_Ch6_Op2_SSGEG:	= $96

YM2612_Ch1_Ch4_Op3_SSGEG:	= $98
YM2612_Ch2_Ch5_Op3_SSGEG:	= $99
YM2612_Ch3_Ch6_Op3_SSGEG:	= $9A

YM2612_Ch1_Ch4_Op4_SSGEG:	= $9C
YM2612_Ch2_Ch5_Op4_SSGEG:	= $9D
YM2612_Ch3_Ch6_Op4_SSGEG:	= $9e

;Register name            | Actual  | bits
;Frequency LSB            | FreqLSB | b7-b0

YM2612_Ch1_Ch4_FreqLSB:		= $A0
YM2612_Ch2_Ch5_FreqLSB:		= $A1
YM2612_Ch3_Ch6_FreqLSB:		= $A2

;Register name              | Actual | bits  | Actual  | bits
;Frequency MSB Octave Block | Block  | b5-b3 | FreqMSB | b2-b0

YM2612_Ch1_Ch4_Octave_FreqMSB:	= $A4
YM2612_Ch2_Ch5_Octave_FreqMSB:	= $A5
YM2612_Ch3_Ch6_Octave_FreqMSB:	= $A6

;Register name                             | Actual  | bits
;Channel 3 Supplement Frequency Number LSB | FreqLSB | b7-b0

YM2612_Ch3_Mode_Op2_FrequencyLSB:	= $A8
YM2612_Ch3_Mode_Op3_FrequencyLSB:	= $A9
YM2612_Ch3_Mode_Op4_FrequencyLSB:	= $AA

;Register name                               | Actual  | bits  | Actual  | bits
;Ch3 Suppl. Octave Block Ch3 Suppl. Freq MSB | Block   | b5-b3 | FreqMSB | b2-b0

YM2612_Ch3_Mode_Op2_Octave_FrequencyMSB:	= $AC
YM2612_Ch3_Mode_Op3_Octave_FrequencyMSB:	= $AD
YM2612_Ch3_Mode_Op4_Octave_FrequencyMSB:	= $AE

;Register name      | Actual   | bits  | Actual    | bits
;Feedback Algorithm | Feedback | b5-b3 | Algorithm | b2-b0

YM2612_Ch1_Ch4_Feedback_Algo:	= $B0
YM2612_Ch2_Ch5_Feedback_Algo:	= $B1
YM2612_Ch3_Ch6_Feedback_Algo:	= $B2

;Register name          | Actual | bits | Actual | bits | Actual | bits  | Actual | bits
;Stereo LFO Sensitivity | L      | b7   | R      | b6   | AMS    | b5-b3 | FMS    | b1-b0

YM2612_Ch1_Ch4_Stereo_LFO_Sens:	= $B4
YM2612_Ch2_Ch5_Stereo_LFO_Sens:	= $B5
YM2612_Ch3_Ch6_Stereo_LFO_Sens:	= $B6
