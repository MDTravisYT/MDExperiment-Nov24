SOUL.DIR	=	$20
SOUL.TIME	=	$22

SOUL:
		MOVEQ	#0,	D0
		MOVE.B	OBJ.ACTION(A0),	D0
		MOVE.W	@INDEX(PC,D0.W),	D1
		JMP		@INDEX(PC,D1.W)
		
	@INDEX:
		DC.W	@init-@INDEX
		DC.W	@do-@INDEX
		DC.W	@move-@INDEX
	;	DC.W	@delete-@INDEX
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
		MOVEQ	#0,	D1
		MOVE.B	JOYPAD,	D0
	@uptst:
		btst	#bitUp,	D0
		beq.s	@dntst
		subi.w	#1,	d1
	@dntst:
		btst	#bitDn,	D0
		beq.s	@apply
		addi.w	#1,	d1
	@apply:
		tst.b	d1
		beq.s	@skip
		addi.b	#2,		OBJ.ACTION(A0)
		move.b	#16,	SOUL.TIME(A0)
		move.w	d1,		SOUL.DIR(A0)
	@skip:
		JMP		_OBJECTDISPLAY
;	===================================================
	@move:
		tst.b	SOUL.TIME(A0)
		beq.s	@end
		subi.b	#1,	SOUL.TIME(A0)
		move.w	SOUL.DIR(A0),D0
		add.w	D0,OBJ.Y(A0)
		JMP		_OBJECTDISPLAY
	@end:
		subi.b	#2,		OBJ.ACTION(A0)
		rts
		
MAP_SOUL:
		INCBIN	"SRC/OBJ/SOUL.MAP"