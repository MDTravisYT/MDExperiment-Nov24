SOUL.DIR	=	$20
SOUL.TIME	=	$22

SOUL:
		MOVEQ	#0,	D0
		MOVE.B	OBJ.ACTION(A0),	D0
		MOVE.W	@INDEX(PC,D0.W),	D1
		JMP		@INDEX(PC,D1.W)
		
	@INDEX:
		DC.W	@init-@INDEX	;	0
		DC.W	@do-@INDEX		;	2	0010
		DC.W	@move-@INDEX	;	4	0100
		DC.W	@move-@INDEX	;	6	0110
;	===================================================
	@init:
		ADDQ.B	#2,			OBJ.ACTION(A0)
		MOVE.B	#$12,		OBJ.YRAD(A0)
		MOVE.B	#9,			OBJ.XRAD(A0)
		MOVE.L	#MAP_SOUL,	OBJ.MAP(A0)
		MOVE.W	#$0,		OBJ.TILE(A0)
		MOVE.B	#4,			OBJ.RENDERFLAGS(A0)
		MOVE.B	#2,			OBJ.PRIORITY(A0)
;	===================================================
;	UP+LEFT = UP
;	DOWN+LEFT = DOWN
;	UP+RIGHT = UP
;	DOWN+RIGHT = DOWN
;	up down gets checked first, followed by left right

	@do:
		MOVE.L	POS, POSBACKUP
		MOVEQ	#0,	D1
		MOVE.B	JOYPAD,	D0
	@uptst:
		btst	#bitUp,	D0
		beq.s	@dntst
		subi.w	#1,	d1
		subi.l	#32,	POS
	@dntst:
		btst	#bitDn,	D0
		beq.s	@apply
		addi.w	#1,	d1
		addi.l	#32,	POS
	@apply:
		tst.b	d1
		beq.s	@ltst
		addi.b	#2,		OBJ.ACTION(A0)
		move.b	#16,	SOUL.TIME(A0)
		move.w	d1,		SOUL.DIR(A0)
		jmp		@move
	@skip:
		JMP		_OBJECTDISPLAY
	@ltst:
		btst	#bitL,	D0
		beq.s	@rtst
		subi.w	#1,	d1
		subi.l	#1,	POS
	@rtst:
		btst	#bitR,	D0
		beq.s	@apply2
		addi.w	#1,	d1
		addi.l	#1,	POS
	@apply2:
		tst.b	d1
		beq.s	@skip
		addi.b	#4,		OBJ.ACTION(A0)
		move.b	#16,	SOUL.TIME(A0)
		move.w	d1,		SOUL.DIR(A0)
	;	JMP		_OBJECTDISPLAY
;	===================================================
	@move:
		lea		POS,	A1
		move.l	(A1),A1
		cmpi.b	#1,	(A1)
		beq.s	@wall
		tst.b	SOUL.TIME(A0)
		beq.s	@end
		subi.b	#1,	SOUL.TIME(A0)
		move.w	SOUL.DIR(A0),D0
		btst	#1,	OBJ.ACTION(A0)
		beq.s	@y
		sub.w	D0,HSCROLLTABLE
		JMP		_OBJECTDISPLAY
	@y:
		add.w	D0,VDP_SCREENPOSY
		JMP		_OBJECTDISPLAY
	@wall:
		move.b	#$A6,	D0
		jsr		PlaySound
		MOVE.L	POSBACKUP,POS
		move.b	#2,		OBJ.ACTION(A0)
		JMP		_OBJECTDISPLAY
	@end:
		move.b	#2,		OBJ.ACTION(A0)
		JMP		@do
		
MAP_SOUL:
		INCBIN	"SRC/OBJ/SOUL.MAP"