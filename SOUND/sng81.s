;=======================================================;
;			*$$SNG81.S	(Song Data)						;
;						ORG. MDSNG111.S					;
;				'Sound-Source'							;
;				 for Mega Drive (68K)					;
;						Ver  1.1 / 1990.9.1				;
;									  By  H.Kubota		;
;=======================================================;

;		public	S81

;		list off
;		include	mdEQ11.LIB
;		include	mdMCR11.LIB
;		include	mdTB11.LIB
;		list on

		even

;===============================================;
;												;
;					 ASSIGN						;
;												;
;===============================================;
;=====< S81 CHANNEL TOTAL >=====;
FM81	EQU		6				; FM Channel Total
PSG81	EQU		3				; PSG Channel Total
;=========< S81 TEMPO >=========;
TP81	EQU		2				; Tempo
DL81	EQU		5				; Delay
;==========< S81 BIAS >=========;
FB810	EQU		12				; FM 0ch
FB811	EQU		0				; FM 1ch
FB812	EQU		0				; FM 2ch
FB814	EQU		0				; FM 4ch
FB815	EQU		0				; FM 5ch
FB816	EQU		0				; FM 6ch (if don't use PCM drum)
PB818	EQU		-12*3			; PSG 80ch
PB81A	EQU		-12*3			; PSG A0ch
PB81C	EQU		0				; PSG C0ch
;==========< S81 VOLM >=========;
FA810	EQU		$16				; FM 0ch
FA811	EQU		$04				; FM 1ch
FA812	EQU		$16				; FM 2ch
FA814	EQU		$16				; FM 4ch
FA815	EQU		$16				; FM 5ch
FA816	EQU		$10				; FM 6ch (if don't use PCM drum)
PA818	EQU		$07				; PSG 80ch
PA81A	EQU		$07				; PSG A0ch
PA81C	EQU		$03				; PSG C0ch
;==========< S81 ENVE >=========;
PE818	EQU		0				; PSG 80ch
PE81A	EQU		0				; PSG A0ch
PE81C	EQU		4				; PSG C0ch

;===============================================;
;												;
;					 HEADER						;
;												;
;===============================================;
S81:
		TDW		TIMB81,S81				; Voice Top Address
		DC.B	FM81,PSG81,TP81,DL81	; FM Total,PSG Total,Tempo,Delay

		TDW		TAB81D,S81				; PCM Drum Table Pointer
		DC.B	0,0						; Bias,Volm (Dummy)

		TDW		TAB810,S81				; FM 0ch Table Pointer
		DC.B	FB810,FA810				; Bias,Volm

		TDW		TAB811,S81				; FM 1ch Table Pointer
		DC.B	FB811,FA811				; Bias,Volm

		TDW		TAB812,S81				; FM 2ch Table Pointer
		DC.B	FB812,FA812				; Bias,Volm

		TDW		TAB814,S81				; FM 4ch Table Pointer
		DC.B	FB814,FA814				; Bias,Volm

		TDW		TAB815,S81				; FM 5ch Table Pointer
		DC.B	FB815,FA815				; Bias,Volm

		TDW		TAB818,S81				; PSG 80ch Table Pointer
		DC.B	PB818,PA818,0,PE818		; Bias,Volm,Dummy,Enve

		TDW		TAB81A,S81				; PSG A0ch Table Pointer
		DC.B	PB81A,PA81A,0,PE81A		; Bias,Volm,Dummy,Enve

		TDW		TAB81C,S81				; PSG C0ch Table Pointer
		DC.B	PB81C,PA81C,0,PE81C		; Bias,Volm,Dummy,Enve

;===============================================;
;												;
;				   SONG TABLE					;
;												;
;===============================================;
;===============================================;
;					 FM 0ch						;
;===============================================;
TAB810	EQU		*
		DC.B	FEV,0
T8100	EQU		*
		DC.B	NL,L1+L1,NL
T810A	EQU		*
T810A_0	EQU		*
		DC.B	CMCALL
		JDW		SUB8100M
		DC.B	CMREPT,0,3
		JDW		T810A_0
		DC.B	NL,L8,FVR,0BH,1,0F0H,0FFH,BF2,L8,VROFF,BF2,L16,BF2,AF2,BF2
		DC.B	CN3,L8,FVR,1,1,3,4,CN3,VROFF,NL,BF2,L16,CN3
		DC.B	DF3,L8,FVR,1,1,3,4,DF3,VROFF,NL,CN3,L16,DF3
		DC.B	BN2,1,TIE,CN3,L8-1,FVR,1,1,4,4,AF2,L8+2,VROFF,NL,L8-2,NL,L8
		
T810B	EQU		*
T810B_0	EQU		*
		DC.B	CMCALL
		JDW		SUB810B
		
		DC.B	CMREPT,0,3
		JDW		T810B_0
		
		DC.B	BF2,L16,BF2,BF2,FN3,FVR,1,1,6,4,EF3,L8,VROFF,BF2,L8
		DC.B	NL,L4,FN3,L16,FN3,FN3,FN3
		DC.B	FVR,1,1,6,4,AF3,L8,VROFF,FN3,L16,NL,L16+L8,FN3,L16,FN3
		DC.B	CMVADD,-2,FVR,1,1,6,4,AF3,L8,VROFF,CMVADD,2,FN3,L16,NL
		DC.B	CMVADD,-2,FVR,1,1,6,4,AF3,L8,VROFF,CMVADD,2,BF3,L16,NL
		
T810C	EQU		*
		DC.B	LRPAN,LSET
		DC.B	CMCALL
		JDW		SUB810C
		DC.B	NL,L8
T810D	EQU		*
		DC.B	LRPAN,LRSET
		DC.B	CMCALL
		JDW		SUB810B
		
		DC.B	CMREPT,0,3
		JDW		T810D
		
T810D2	EQU		*
		
		DC.B	CMCALL
		JDW		SUB810D
		
		DC.B	CMJUMP
		JDW		T8100
SUB8100	EQU		*
		DC.B	NL,L8,BF2,L8,BF2,L16,BF2,AF2,BF2
		DC.B	CN3,L8,CN3,NL,BF2,L16,CN3
		DC.B	DF3,L8,DF3,NL,CN3,L16,DF3
		DC.B	CN3,L8,AF2
		DC.B	CMRET
SUB8100M		EQU		*
		DC.B	NL,L8,FVR,0BH,1,0F0H,0FFH,BF2,L8,VROFF,BF2,L16,BF2,AF2,BF2
		DC.B	CN3,L8,FVR,1,1,3,4,CN3,VROFF,NL,BF2,L16,CN3
		DC.B	DF3,L8,FVR,1,1,3,4,DF3,VROFF,NL,CN3,L16,DF3
		DC.B	BN2,1,TIE,CN3,L8-1,FVR,1,1,4,4,AF2,L8+2,VROFF,NL,L8-2,BF2,L8
		DC.B	CMRET
SUB810B	EQU		*
		DC.B	BF2,L16,BF2,BF2,FN3,FVR,1,1,6,4,EF3,L8,VROFF,BF2,L8
		DC.B	NL,L4,BF2,L16,BF2,BF2,FN3
		DC.B	FVR,1,1,6,4,EF3,L8,VROFF,BF2,NL,BF2,L16,BF2
		DC.B	CN3,L16,NL,AF2,L8,L16,BF2,NL,L8
		DC.B	CMRET
SUB810C	EQU		*
		DC.B	NL,L4
		DC.B	FN4,L16,FN4,FN4,FN4
		DC.B	FVR,0,1,6,4
		
		DC.B	CMCALL
		JDW		SUB810C0
		
		DC.B	NL,L8,FN4,L16,L16,VRON,L8,VROFF,L16,L16
		DC.B	VRON,EF4,L8,VROFF,CN4,NL,DF4,L16,EF4
		DC.B	DF4,L16,NL,VRON,BF3,L8,VROFF,NL,CN4,L16,DF4
		DC.B	CN4,L8,CN4,EF4,VRON,FN4,L8+2,VROFF
		
		DC.B	NL,L8-2,FN4,L16,FN4,FN4,FN4,VRON,FN4,L8
		
		DC.B	CMCALL
		JDW		SUB810C0
		
		DC.B	NL,L8,FN4,L16,L16,L16,L16,L16,L16
		DC.B	VRON,EF4,L8,VROFF,CN4,NL,DF4,L16,EF4
		DC.B	DF4,L16,NL,BF3,L8,NL,DF4,L16,DF4
		DC.B	VRON,EF4,L8,VROFF,CN4,L8+3,NL,L8-3
		DC.B	CMRET
SUB810C0		EQU		*
		DC.B	EF4,L8,VROFF,CN4,NL,DF4,L16,EF4
		DC.B	VRON,DF4,L8,VROFF,BF3,NL,DF4,L16,DF4
		DC.B	VRON,EF4,L8,VROFF,CN4,L8+3,NL,L8-3,NL,L8
		DC.B	CMRET
SUB810D	EQU		*
		DC.B	EN3,1,CMTAB,FN3,L8-1,CMVADD,4,CN3,L8,CMVADD,-4,EF3,FVR,10H,1,0E0H,0FFH,EF3,L4-2
		DC.B	VROFF,NL,L8+2,EN3,1,CMTAB,FN3,L8-1,CMVADD,4,CN3,L8,CMVADD,-4
		DC.B	EF3,FVR,10H,1,0E0H,0FFH,EF3,L4-2,VROFF,NL,2,FN3,L16,FN3
		DC.B	FVR,1,1,8,4,EN3,1,CMTAB,FN3,LF8-1,VROFF,L16,EF3,L16,DF3,BF2,L8
		DC.B	CMRET
;===============================================;
;					 FM 1ch						;
;===============================================;
TAB811	EQU		*
		DC.B	FEV,1
T8110	EQU		*
T811A	EQU		*
		DC.B	CMCALL
		JDW		SUB8100
		DC.B	NL,BF2
		DC.B	CMREPT,0,5
		JDW		T8110
		DC.B	NL,L8,BF2,L8,BF2,L16,BF2,AF2,BF2
		DC.B	CN3,L8,CN3,NL,BF2,L16,CN3
		DC.B	DF3,L8,DF3,NL,CN3,L16,DF3
		DC.B	CN3,L8,AF2
		DC.B	NL,GF2
T811B	EQU		*
		DC.B	CMCALL
		JDW		SUB811B
		DC.B	AF2,LF4,GF2,L8
		
		DC.B	TIE,L8,GF2,L8,GF2,L4
		DC.B	GF2,L8,L8,L4
		DC.B	FN2,FN2
		DC.B	FN2,L8,GN2,AF2,BF2
		
T811C	EQU		*
		DC.B	CMCALL
		JDW		SUB811C
		DC.B	NL,L16,GN2,AF2,L8,BF2
		
		DC.B	CMCALL
		JDW		SUB811C
		DC.B	GN2,L8,AN2,GF2
		
T811D	EQU		*
		DC.B	CMCALL
		JDW		SUB811B
		DC.B	AF2,L4,GF2
		
T811D2	EQU		*
		DC.B	CMVADD,-4
		DC.B	FN2,L4,NL
		DC.B	FN2,L8,FN2,NL,L4+L4
		DC.B	FN2,L4
		DC.B	NL,LF4,BF2,L8
		DC.B	CMVADD,4
		
		DC.B	CMJUMP
		JDW		T8110
SUB811C	EQU		*
		DC.B	CMCALL
		JDW		SUB811C0
		DC.B	AF2,L8,AF2,AF2,BF2
		
		DC.B	CMCALL
		JDW		SUB811C0
		DC.B	FN2,L8
		DC.B	CMRET
SUB811C0		EQU		*
		DC.B	NL,L8,BF2,BF2,BF2,L16,BF2
		DC.B	AF2,L8,AF2,L8,NL,AF2,L16,AF2
		DC.B	GF2,L8,GF2,L8,NL,GF2,L16,GF2
		DC.B	CMRET
SUB811B	EQU		*
		DC.B	TIE,L8,GF2,GF2,L4
		DC.B	GF2,L8,GF3,L4,GF2,L8
		DC.B	L8,GF3,GF2,L4
		DC.B	AF2,LF4,GF2,L8
		
		DC.B	CMREPT,0,2
		JDW		SUB811B
		DC.B	TIE,L8,GF2,GF2,L4
		DC.B	GF2,L8,GF3,L4,GF2,L8
		DC.B	L8,GF3,GF2,L4
		DC.B	CMRET
;===============================================;
;					 FM 2ch						;
;===============================================;
TAB812	EQU		*
T8120	EQU		*
		DC.B	CMVADD,-4
		DC.B	FEV,2
		DC.B	LRPAN,LSET
T8120_0	EQU		*
		DC.B	CMCALL
		JDW		SUB8100
		DC.B	NL,BF2
		DC.B	CMREPT,0,2
		JDW		T8120_0
		DC.B	CMVADD,4
T812A	EQU		*
		DC.B	FEV,3
		DC.B	LRPAN,LSET
T812A_0	EQU		*
		DC.B	NL,L2
		DC.B	CN3,L8,CN3,NL,NL
		DC.B	DF3,DF3,NL,NL
		DC.B	CN3,CN3,NL,BF2
		DC.B	CMREPT,0,3
		JDW		T812A_0
		DC.B	NL,L2
		DC.B	CN3,L8,CN3,NL,NL
		DC.B	DF3,DF3,NL,NL
		DC.B	CN3,CN3,NL
T812B	EQU		*
		DC.B	FEV,4
		DC.B	LRPAN,LSET
		DC.B	CMVADD,10
		DC.B	FVR,32,1,4,5
		DC.B	BF3
T812B_0	EQU		*
		DC.B	CMTAB,L1+L2,CN4,L4,BF3,L4
		DC.B	CMREPT,0,3
		JDW		T812B_0
		DC.B	CMTAB,L1,AN3
		
		DC.B	CMVADD,-10
		DC.B	CMVADD,2
T812C	EQU		*
		DC.B	LRPAN,LRSET
		DC.B	FEV,0
		DC.B	NL,L4,DF5,L16,DF5,DF5,DF5
		DC.B	FVR,1,1,6,4,CN5,L8,VROFF,AF4,NL,BF4,L16,CN5
		DC.B	VRON,BF4,L8,VROFF,GF4,NL,BF4,L16,BF4
		DC.B	VRON,CN5,L8,VROFF,AF4,L8+3,NL,L8-3,NL,L8
		
		DC.B	NL,L8,DF5,L16,L16,VRON,L8,VROFF,L16,L16
		DC.B	VRON,CN5,L8,VROFF,AF4,NL,BF4,L16,CN5
		DC.B	BF4,L16,NL,VRON,GF4,L8,VROFF,NL,AF4,L16,BF4
		DC.B	VRON,AN4,L8,VROFF,AN4,CN5,VRON,DF5,L8+2,VROFF
		
		DC.B	NL,L8-2,DF5,L16,DF5,DF5,DF5,VRON,DF5,L8
		DC.B	CN5,L8,VROFF,AF4,NL,BF4,L16,CN5
		DC.B	VRON,BF4,L8,VROFF,GF4,NL,BF4,L16,BF4
		DC.B	VRON,CN5,L8,VROFF,AF4,L8+3,NL,L8-3,NL,L8
		
		DC.B	NL,L8,DF5,L16,L16,L16,L16,L16,L16
		DC.B	VRON,CN5,L8,VROFF,AF4,NL,BF4,L16,CN5
		DC.B	BF4,L16,NL,VRON,GF4,L8,VROFF,NL,BF4,L16,BF4
		DC.B	VRON,CN5,L8,VROFF,AN4,L8+3,NL,L8-3
		
		DC.B	CMVADD,-2
T812D	EQU		*
		DC.B	LRPAN,LSET
		DC.B	FEV,4
		DC.B	CMVADD,10
		DC.B	FVR,32,1,4,5
		DC.B	BF3,L8
T812D_0	EQU		*
		DC.B	CMTAB,L1+L2,CN4,L4,BF3,L4
		DC.B	CMREPT,0,3
		JDW		T812D_0
		DC.B	CMVADD,-10
T812D2	EQU		*
		DC.B	FEV,0
		DC.B	CMCALL
		JDW		SUB810D
		
		DC.B	CMJUMP
		JDW		T8120
		
;===============================================;
;					 FM 4ch						;
;===============================================;
TAB814	EQU		*
T8140	EQU		*
		DC.B	FEV,5
		DC.B	LRPAN,RSET
		DC.B	CMVADD,-4
T8140_0	EQU		*
		DC.B	CMCALL
		JDW		SUB8100
		DC.B	NL,BF2
		DC.B	CMREPT,0,2
		JDW		T8140_0
		DC.B	CMVADD,4
T814A	EQU		*
		DC.B	FEV,3
		DC.B	LRPAN,RSET
		DC.B	NL,L2
		DC.B	EF3,L8,EF3,NL,NL
		DC.B	FN3,FN3,NL,NL
		DC.B	EF3,EF3,NL,DF3
		DC.B	CMREPT,0,3
		JDW		T814A
		DC.B	NL,L2
		DC.B	EF3,L8,EF3,NL,NL
		DC.B	FN3,FN3,NL,NL
		DC.B	EF3,EF3,NL
T814B	EQU		*
		DC.B	FEV,4
		DC.B	LRPAN,LRSET
		DC.B	CMVADD,10
		DC.B	FVR,34,1,4,5
		DC.B	DF3
T814B_0	EQU		*
		DC.B	CMTAB,L1+L2,EF3,L4,DF3,L4
		DC.B	CMREPT,0,3
		JDW		T814B_0
		DC.B	CMTAB,L1,CN3
		
		DC.B	CMVADD,-10
		DC.B	CMVADD,2
T814C	EQU		*
		DC.B	FEV,0
		DC.B	LRPAN,LRSET
		
		DC.B	NL,L4,BF4,L16,BF4,BF4,BF4
		DC.B	FVR,2,1,6,4,AF4,L8,VROFF,EF4,NL,GF4,L16,AF4
		DC.B	VRON,GF4,L8,VROFF,DF4,NL,GF4,L16,GF4
		DC.B	VRON,AF4,L8,VROFF,EF4,L8+3,NL,L8-3,NL,L8
		
		DC.B	NL,L8,BF4,L16,L16,VRON,L8,VROFF,L16,L16
		DC.B	VRON,AF4,L8,VROFF,EF4,NL,GF4,L16,AF4
		DC.B	GF4,L16,NL,VRON,DF4,L8,VROFF,NL,EF4,L16,GF4
		DC.B	VRON,FN4,L8,VROFF,FN4,AF4,VRON,BF4,L8+2,VROFF
		
		DC.B	NL,L8-2,BF4,L16,L16,L16,L16,VRON,L8,VROFF
		DC.B	AF4,L8,VROFF,EF4,NL,GF4,L16,AF4
		DC.B	VRON,GF4,L8,VROFF,DF4,NL,GF4,L16,GF4
		DC.B	VRON,AF4,L8,VROFF,EF4,L8+3,NL,L8-3,NL,L8
		
		DC.B	NL,L8,BF4,L16,L16,L16,L16,L16,L16
		DC.B	VRON,AF4,L8,VROFF,EF4,NL,GF4,L16,AF4
		DC.B	GF4,L16,NL,VRON,DF4,L8,VROFF,NL,GF4,L16,GF4
		DC.B	VRON,AN4,L8,VROFF,FN4,L8+3,NL,L8-3
		
		DC.B	CMVADD,-2
T814D	EQU		*
		DC.B	FEV,4
		DC.B	LRPAN,LRSET
		DC.B	CMVADD,10
		DC.B	FVR,34,1,4,5
		DC.B	DF3,L8
T814D_0	EQU		*
		DC.B	CMTAB,L1+L2,EF3,L4,DF3,L4
		DC.B	CMREPT,0,3
		JDW		T814D_0
		
		DC.B	CMVADD,-10
T814D2	EQU		*
		DC.B	FEV,0
		DC.B	FDT,-2
		DC.B	LRPAN,RSET
		DC.B	CMCALL
		JDW		SUB810D
		DC.B	FDT,0
		
		
		DC.B	CMJUMP
		JDW		T8140
		
;===============================================;
;					 FM 5ch						;
;===============================================;
TAB815	EQU		*
T8150	EQU		*
		DC.B	FEV,1
		DC.B	CMCALL
		JDW		SUB8100
		DC.B	NL,BF2
		DC.B	CMREPT,0,2
		JDW		T8150
T815A	EQU		*
		DC.B	FEV,5
		DC.B	CMCALL
		JDW		SUB8100
		DC.B	NL,BF2
		DC.B	CMREPT,0,3
		JDW		T815A
		DC.B	NL,L8,BF2,L8,BF2,L16,BF2,AF2,BF2
		DC.B	CN3,L8,CN3,NL,BF2,L16,CN3
		DC.B	DF3,L8,DF3,NL,CN3,L16,DF3
		DC.B	CN3,L8,AF2,NL
T815B	EQU		*
		DC.B	FEV,4
		DC.B	LRPAN,RSET
		DC.B	CMVADD,10
		DC.B	FVR,36,1,4,5
		DC.B	GF3
T815B_0	EQU		*
		DC.B	CMTAB,L1+L2,AF3,L4,GF3,L4
		DC.B	CMREPT,0,3
		JDW		T815B_0
		DC.B	CMTAB,L1,FN3
T815C	EQU		*
T815C_0	EQU		*
		DC.B	FEV,0
		DC.B	CMVADD,-10
		DC.B	CMCALL
		JDW		SUB810C
		DC.B	CMVADD,10
T815D	EQU		*
		DC.B	FEV,4
		DC.B	FVR,36,1,4,5
		DC.B	GF3,L8
T815D_0	EQU		*
		DC.B	CMTAB,L1+L2,AF3,L4,GF3,L4
		DC.B	CMREPT,0,3
		JDW		T815D_0
		
		DC.B	CMVADD,-10
T815D2	EQU		*
		DC.B	FEV,6
		DC.B	CMVADD,-8
		DC.B	LRPAN,LRSET
		DC.B	NL,L2,081H,L8,LF4+L4
		DC.B	L2,L8,L8
		DC.B	CMVADD,8
		
		
		DC.B	CMJUMP
		JDW		T8150
		
		
;===============================================;
;					 PSG 80ch					;
;===============================================;
TAB818	EQU		*
T8180	EQU		*
		DC.B	NL,L1+L1,NL
T818A	EQU		*
		DC.B	FVR,1,1,2,4
		DC.B	NL,L2
		DC.B	EF4,L8,EF4,NL,NL
		DC.B	FN4,FN4,NL,NL
		DC.B	EF4,EF4,NL,DF4
		DC.B	CMREPT,0,3
		JDW		T818A
		DC.B	NL,L2
		DC.B	EF4,L8,EF4,NL,NL
		DC.B	FN4,FN4,NL,NL
		DC.B	EF4,EF4,NL
T818B	EQU		*
		DC.B	BF3
T818B0	EQU		*
		DC.B	CMTAB,L1+L2,CN4,L4,BF3,L4
		DC.B	CMREPT,0,3
		JDW		T818B0
		DC.B	CMTAB,L1,AN3
T818C	EQU		*
		DC.B	FVR,8,1,3,4
		DC.B	PVADD,-2
		DC.B	DF4,L2,CN4,BF3,CN4,LF4
		DC.B	DF4,L8+L2,CN4,L2,BF3,AN3,LF4
		DC.B	DF4,L8+L2,CN4,L2,BF3,CN4,LF4
		DC.B	DF4,L8+L2,CN4,L2,BF3,AN3,LF4
		DC.B	PVADD,2
		
T810PD	EQU		*
		DC.B	BF3,L8
T810PD0	EQU		*
		DC.B	CMTAB,L1+L2,CN4,L4,BF3,L4
		DC.B	CMREPT,0,3
		JDW		T810PD0
		DC.B	NL,L1+L1
		
		DC.B	CMJUMP
		JDW		T8180
		
;===============================================;
;					 PSG A0ch					;
;===============================================;
TAB81A	EQU		*
T81A0	EQU		*
		DC.B	NL,L1+L1,NL
T81AA	EQU		*
		DC.B	FVR,1,1,2,4
		DC.B	NL,L2
		DC.B	CN4,L8,CN4,NL,NL
		DC.B	DF4,DF4,NL,NL
		DC.B	CN4,CN4,NL,DF3
		DC.B	CMREPT,0,3
		JDW		T81AA
		DC.B	NL,L2
		DC.B	CN4,L8,CN4,NL,NL
		DC.B	DF4,DF4,NL,NL
		DC.B	CN4,CN4,NL
T81AB	EQU		*
		DC.B	GF3
T81AB0	EQU		*
		DC.B	CMTAB,L1+L2,AF3,L4,GF3,L4
		DC.B	CMREPT,0,3
		JDW		T81AB0
		DC.B	CMTAB,L1,FN3
T81AC	EQU		*
		DC.B	FVR,8,1,3,4
		DC.B	BF3,L2,AF3,GF3,AF3,LF4
		DC.B	BF3,L8+L2,AF3,L2,GF3,FN3,LF4
		DC.B	BF3,L8+L2,AF3,L2,GF3,AF3,LF4
		DC.B	BF3,L8+L2,AF3,L2,GF3,FN3,LF4
T81AD	EQU		*
		DC.B	FVR,1,1,2,4
		DC.B	GF3,L8
T81AD0	EQU		*
		DC.B	CMTAB,L1+L2,AF3,L4,GF3,L4
		DC.B	CMREPT,0,3
		JDW		T81AD0
		DC.B	NL,L1+L1
		
		DC.B	CMJUMP
		JDW		T81A0
;===============================================;
;					 PSG C0ch					;
;===============================================;
TAB81C	EQU		*
		DC.B	CMNOIS,NOIS7
T81C00	EQU		*
		DC.B	CMGATE,2
		DC.B	NL,L8,0C6H,PVADD,-2,CMGATE,10,L8,PVADD,2,CMGATE,2,L8
T81C00_0		EQU		*
		DC.B	0C6H,L8,L8,PVADD,-2,CMGATE,10,L8,PVADD,2,CMGATE,2,L8
		DC.B	CMREPT,0,2
		JDW		T81C00_0
		DC.B	0C6H,L8,L8,CMGATE,10,L8,PVADD,-2,CMGATE,OFF,L8,PVADD,2
T81C0	EQU		*
T81CA	EQU		*
		DC.B	CMCALL
		JDW		SUB81C0
		DC.B	CMREPT,2,4
		JDW		T81C0
		DC.B	CMCALL
		JDW		SUB81C1
T81CB	EQU		*
T81CC	EQU		*
		DC.B	CMCALL
		JDW		SUB81C0
		DC.B	CMREPT,2,8
		JDW		T81CB
T81CD	EQU		*
		DC.B	CMCALL
		JDW		SUB81C0
		DC.B	CMREPT,2,2
		JDW		T81CD
		DC.B	CMCALL
		JDW		SUB81C1
T81CD2	EQU		*
		DC.B	PVADD,2,CMGATE,2,L8,L8,PVADD,-3,CMGATE,10,L8,PVADD,3,CMGATE,2,L8
		DC.B	PVADD,-3,CMGATE,10,L8,L8,L8,PVADD,3,CMGATE,2,L8
		DC.B	L8,L8,PVADD,-3,CMGATE,10,L8,PVADD,3,CMGATE,2,L8
		DC.B	L8,L8,PVADD,-2,CMGATE,10,L8,L8
		
		
		DC.B	CMCALL
		JDW		SUB81C0
		
		
		DC.B	CMJUMP
		JDW		T81C0
		
SUB81C0	EQU		*
		DC.B	CMGATE,2
SUB81C0_0		EQU		*
		DC.B	0C6H,L8,L8,PVADD,-2,CMGATE,10,L8,PVADD,2,CMGATE,2,L8
		DC.B	CMREPT,0,3
		JDW		SUB81C0_0
		DC.B	0C6H,L8,L8,CMGATE,10,L8,PVADD,-2,CMGATE,OFF,L8,PVADD,2
		DC.B	CMRET
SUB81C1	EQU		*
		DC.B	CMGATE,2
SUB81C1_0		EQU		*
		DC.B	0C6H,L8,L8,PVADD,-2,CMGATE,10,L8,PVADD,2,CMGATE,2,L8
		DC.B	CMREPT,0,4
		JDW		SUB81C1_0
		DC.B	CMRET
;===============================================;
;					 PCM DRUM					;
;===============================================;
TAB81D	EQU		*
T81D0	EQU		*
T81DA	EQU		*
		DC.B	CMCALL
		JDW		SUB81D0
		DC.B	CMREPT,0,5
		JDW		T81D0
		
		DC.B	CMCALL
		JDW		SUB81D1
		
T81DB	EQU		*
T81DC	EQU		*
		DC.B	CMCALL
		JDW		SUB81D0
		DC.B	CMREPT,0,7
		JDW		T81DB
		
		DC.B	CMCALL
		JDW		SUB81D1
		
T81DD	EQU		*
		DC.B	CMCALL
		JDW		SUB81D0
		DC.B	CMREPT,0,2
		JDW		T81DD
		
		DC.B	CMCALL
		JDW		SUB81D1
		
T81DD2	EQU		*
		DC.B	B,L8,NL,S,NL,S,S,S,NL
		DC.B	NL,NL,S,NL,NL,NL,S,NL
		
		DC.B	CMJUMP
		JDW		T81D0
		
SUB81D0	EQU		*
		DC.B	NL,L8,B,S,B,B,B,S,B
		DC.B	B,B,S,B,B,B,S,NL
		DC.B	CMRET
SUB81D1	EQU		*
		DC.B	B,B,S,B
		DC.B	CMREPT,0,4
		JDW		SUB81D1
		DC.B	CMRET
		
;===============================================;
;												;
;					  VOICE						;
;												;
;===============================================;
TIMB81	EQU		*
;===================< FEV00 >===================;
		CNF		5,7
		MD		1,0,1,0,1,0,1,0
		RSAR	2,14,1,18,0,20,1,12
		D1R		8,8,14,3
		D2R		0,0,0,0
		RRL		15,1,15,1,15,1,15,1
		TL		27,0,0,0
;===================< FEV01 >===================;
		CNF		2,0
		MD		0,0,0,0,0,0,0,0
		RSAR	1,28,1,20,0,28,3,16
		D1R		12,8,10,5
		D2R		0,0,0,0
		RRL		15,15,15,15,15,15,15,15
		TL		36,27,34,0
;===================< FEV02 >===================;
		CNF		1,7
		MD		1,0,1,5,0,0,0,0
		RSAR	0,31,1,31,1,31,1,31
		D1R		16,17,9,9
		D2R		7,0,0,0
		RRL		15,12,15,15,15,15,15,15
		TL		28,34,31,0
;===================< FEV03 >===================;
		CNF		4,5
		MD		1,6,3,0,1,0,3,3
		RSAR	1,31,2,20,1,31,2,20
		D1R		5,5,5,7
		D2R		2,2,2,2
		RRL		15,1,15,6,15,1,15,10
		TL		30,0,30,0
;===================< FEV04 >===================;
		CNF		5,7
		MD		1,0,2,0,2,0,2,0
		RSAR	0,31,0,8,2,10,0,10
		D1R		8,8,8,8
		D2R		0,1,0,0
		RRL		15,0,15,1,15,1,15,1
		TL		31,8,8,7
;===================< FEV05 >===================;
		CNF		3,7
		MD		3,0,1,0,0,3,1,0
		RSAR	0,28,3,28,3,28,1,30
		D1R		20,19,15,12
		D2R		12,5,10,7
		RRL		15,10,15,10,15,5,15,6
		TL		22,17,17,0
;===================< FEV06 >===================;
		CNF		5,7
		MD		8,0,1,0,1,0,1,0
		RSAR	0,31,0,31,0,31,0,31
		D1R		19H,19H,25,17
		D2R		5,11H,0,15
		RRL		15,0,15,7,15,15,15,15
		TL		0,0,0,0

; vim: set ft=asm68k sw=4 ts=4 noet:
