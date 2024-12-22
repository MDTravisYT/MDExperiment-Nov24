MAIN:
		JSR		CLEARSCREEN
		
		move.l	#VRAMWRITE,	(VDPCTRL)	;	TODO: Optimize this into a list
		LEA		BATTLEART,		A0
		LEA		VDPDATA,	A1
		MOVE.W	#(BATTLEART_END-BATTLEART)/2-1,		D0
	@LOADGFX:
		MOVE.W	(A0)+,	(A1)
		DBF		D0,	@LOADGFX
		
		move.l	#VRAMWRITE,	(VDPCTRL)
		LEA		TXTART,		A0
		LEA		VDPDATA,	A1
		WRITEVRAM	$2000
		MOVE.W	#(TXTART_END-TXTART)/2-1,		D0
	@LOADGFX2:
		MOVE.W	(A0)+,	(A1)
		DBF		D0,	@LOADGFX2
		
		move.l	#VRAMWRITE,	(VDPCTRL)
		LEA		YOUART,		A0
		LEA		VDPDATA,	A1
		WRITEVRAM	$4000
		MOVE.W	#(YOUART_END-YOUART)/2-1,		D0
	@LOADGFX3:
		MOVE.W	(A0)+,	(A1)
		DBF		D0,	@LOADGFX3
		
		LEA		BATTLEPAL,	A0
		LEA		PALFADEBUFFER,	A1
		MOVE.B	#16,	D0
	@PALLOOP:
		MOVE.L	(A0)+,	(A1)+
		DBF		D0,	@PALLOOP
		
	COPYTILEMAP		BATTLEMAP,	PLANE_A,	64,	64
	COPYTILEMAP		BG,			PLANE_B,	32,	28
	
		MOVE.B	#$01,	(OBJSLOT00)
		LEA		(OBJSLOT00),	A0
		MOVE.W	#112+8,	OBJ.X(A0)
		MOVE.W	#100+8,	OBJ.Y(A0)
		MOVE.W	#112,	HSCROLLTABLE
		MOVE.W	#-104,	VDP_SCREENPOSY
		
	;	move.b	#$81,	D0
	;	jsr		PlaySound
		
		JSR		PALFADEIN
		MOVE.W	#$9200,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
		
		MOVE.L	#COLMAP,	POS
		MOVE.L	#COLMAP,	POSBACKUP
		
startposX	=	12
startposY	=	11

		sub.w	#startposX*16,HSCROLLTABLE
		add.w	#startposY*16,VDP_SCREENPOSY
		add.l	#startposX+(startposY*32),POS
		move.l	POS,POSBACKUP
;	===============================================
	@loop:
		MOVE.B	#1,	(VBLANKCMD).W
		jsr		VSYNC
		JSR		RUNOBJECTS
		JSR		PROCESSSPRITES
		
		btst	#bitC,	JOYPADPRESS
		beq.s	@no
		move.b	#$A0,	D0
		jsr		PlaySound
		move.w	#0,	TXTID
		bra.s	@windowon
	@no:
		bra.s	@loop
;	===============================================
	@windowon:
		MOVE.W	#$9200+%10010001,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
		MOVE.B	#3,	TXTWAIT
		clr.w	TXTPROG
		clr.w	TXTLINE
		COPYTILEMAP_W	BOARDMAP,	(PLANE_W+$44C),	20,	6
	@loopwindow:
		MOVE.B	#1,	(VBLANKCMD).W
		jsr		VSYNC
	;	btst	#bitC,	JOYPADPRESS
	;	beq.s	@no2
	;	move.b	#$A0,	D0
	;	jsr		PlaySound
	;	bra.w	@windowoff
	@no2:
		SUB.B	#1,	TXTWAIT
		MOVE.W	#TXTIDS,	A0	;	get the text pointer
		ADD.W	TXTID, A0
		ADD.W	(A0),A0
		SUB.W	TXTID,A0
		ADD.W	TXTPROG,A0
		
		CMPI.B	#EX,(A0)	;	exit test
		BEQ.S	@loopwindow
		
		CMPI.B	#CN,(A0)	;	continue test
		BNE.S	@nocont
		ADD.W	#45,TXTLINE
		ADD.W	#1,TXTPROG
	@nocont:
		CMPI.B	#SL,(A0)	;	shift test
		BEQ.W	@shiftwindow
	
		TST.B	TXTWAIT
		BNE.S	@loopwindow
		
		MOVE.W	#$6100,	D0	;	set up VRAM pointer for tile
		ADD.B	(A0),D0
		
		MOVE.L	#VRAMWRITE+(((PLANE_W+$4CE)&$3FFF)<<16)+(((PLANE_W+$4CE)&$C000)>>14),	D1
		MOVE.W	TXTPROG, D2
		ADD.W	TXTLINE,D2
		LSL.L	#8,	D2
		LSL.L	#8,	D2
		LSL.L	#1,	D2
		ADD.L	D2,	D1
		MOVE.L	D1,VDPCTRL
		
		MOVE.W	D0,VDPDATA
		ADD.W	#1,	TXTPROG
		MOVE.B	#3,	TXTWAIT
	
		bra.w	@loopwindow
;	===============================================
	@windowoff:
		MOVE.W	#$9200,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
		bra.w	@loop
;	===============================================
	@shiftwindow:
		MOVE.B	#1,	(VBLANKCMD).W
		jsr		VSYNC
		btst	#bitC,	JOYPADPRESS
		beq.s	@shiftwindow
		move.b	#$A0,	D0
		jsr		PlaySound
		ADD.W	#1,TXTPROG
		SUB.W	#19,TXTLINE
		
		move.l	#1,	d2
	@scrup:
		MOVE.B	#4,	TXTWAIT
		MOVE.L	#VRAMREAD+(((PLANE_W+$4CE)&$3FFF)<<16)+(((PLANE_W+$4CE)&$C000)>>14),	VDPCTRL
		LEA		VDPDATA,	A0
		LEA		TXTBUFFER,	A1
		bsr.w	V2B
		MOVE.L	#VRAMWRITE+(((PLANE_W+$48E)&$3FFF)<<16)+(((PLANE_W+$48E)&$C000)>>14),	VDPCTRL
		LEA		TXTBUFFER,	A1
		bsr.w	B2V
		
		MOVE.L	#VRAMREAD+(((PLANE_W+$50E)&$3FFF)<<16)+(((PLANE_W+$50E)&$C000)>>14),	VDPCTRL
		LEA		VDPDATA,	A0
		LEA		TXTBUFFER,	A1
		bsr.w	V2B
		MOVE.L	#VRAMWRITE+(((PLANE_W+$4CE)&$3FFF)<<16)+(((PLANE_W+$4CE)&$C000)>>14),	VDPCTRL
		LEA		TXTBUFFER,	A1
		bsr.w	B2V
		
		MOVE.L	#VRAMREAD+(((PLANE_W+$54E)&$3FFF)<<16)+(((PLANE_W+$54E)&$C000)>>14),	VDPCTRL
		LEA		VDPDATA,	A0
		LEA		TXTBUFFER,	A1
		bsr.w	V2B
		MOVE.L	#VRAMWRITE+(((PLANE_W+$50E)&$3FFF)<<16)+(((PLANE_W+$50E)&$C000)>>14),	VDPCTRL
		LEA		TXTBUFFER,	A1
		bsr.w	B2V
		
		MOVE.L	#VRAMWRITE+(((PLANE_W+$54E)&$3FFF)<<16)+(((PLANE_W+$54E)&$C000)>>14),	VDPCTRL
		bsr.w	clrLine
	@scrup_wait:
		sub.b	#1,	TXTWAIT
		MOVE.B	#1,	(VBLANKCMD).W
		jsr		VSYNC
		TST.B	TXTWAIT
		BNE.S	@scrup_wait
	dbf	d2,	@scrup
		MOVE.B	#3,	TXTWAIT
		bra.w	@loopwindow
;	===============================================
V2B:
		move.l	#10,d1
	@loop:
		MOVE.L	(A0),(A1)+
		dbf	d1,	@loop
		rts
B2V:
		move.l	#10,d1
	@loop:
		MOVE.L	(A1)+,(A0)
		dbf	d1,	@loop
		rts
		
clrLine:
		move.l	#8,d1
	@loop:
		MOVE.L	#$61006100,(A0)
		dbf	d1,	@loop
		rts

CN = 1	;	continue
SL = 2	;	shift line
CB = 3	;	clear box
EX = 4	;	end
		
TXTIDS:
	DC.W	TXTTST-TXTIDS	;	0
	DC.W	TXTTST2-TXTIDS	;	2
		
TXTTST:
;	ref		"XXXXXXXXXXXXXXXXXX"
	dc.b	"Hey there, player!",CN
	dc.b	"Did you know that ",SL
	dc.b	"Super Mario Bros. ",SL
	dc.b	"2 is actually a   ",SL
	dc.b	"reskin of a game  ",SL
	dc.b	"called Doki Doki  ",SL
	dc.b	"Panic?            ",CB
	dc.b	"Pretty cool right?",EX
	even
TXTTST2:
	dc.b	"dummy",EX
	even
		
COLMAP:
	dc.b	0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,1,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

BATTLEPAL:	INCBIN		"PAL/BATTLE.PAL"
BATTLEMAP:	INCBIN		"MAP/BATTLE.MAP"
BG:	INCBIN		"MAP/BG.MAP"
BOARDMAP:	INCBIN		"MAP/BOARD.MAP"
BATTLEART:	INCBIN		"ART/BATTLE.UNC"
	BATTLEART_END:
TXTART:	INCBIN		"ART/FONT.UNC"
	TXTART_END:
YOUART:	INCBIN		"ART/YOU.BIN"
	YOUART_END: