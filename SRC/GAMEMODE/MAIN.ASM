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
	COPYTILEMAP		BOARDMAP,	PLANE_W+$A00,	40,	8
	
		MOVE.B	#$01,	(OBJSLOT00)
		LEA		(OBJSLOT00),	A0
		MOVE.W	#112+8,	OBJ.X(A0)
		MOVE.W	#100+8,	OBJ.Y(A0)
		MOVE.W	#112,	HSCROLLTABLE
		MOVE.W	#-104,	VDP_SCREENPOSY
		
		move.b	#$81,	D0
		jsr		PlaySound
		
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
		MOVE.W	#$9200+%10010001,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
		bra.s	@windowon
	@no:
		bra.s	@loop
;	===============================================
	@windowon:
		MOVE.B	#1,	(VBLANKCMD).W
		jsr		VSYNC
		btst	#bitC,	JOYPADPRESS
		beq.s	@no2
		move.b	#$A0,	D0
		jsr		PlaySound
		bra.s	@windowoff
	@no2:
	
		
	
		bra.w	@windowon
;	===============================================
	@windowoff:
		MOVE.W	#$9200,(VDPCTRL)      ;	WINDOW PLANE VERTICAL
		bra.w	@loop
		
CN = 1	;	continue
SL = 2	;	shift line
CB = 3	;	clear box
EX = 4	;	end
		
TXTTST:
;	ref		"XXXXXXXXXXXXXXXXXX"
	dc.b	"Hey there, player!",CN
	dc.b	"Did you know that",SL
	dc.b	"Super Mario Bros.",SL
	dc.b	"2 is actually a",SL
	dc.b	"reskin of a game",SL
	dc.b	"called Doki Doki",SL
	dc.b	"Panic?",CB
	dc.b	"Pretty coo, right?",EX
		
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