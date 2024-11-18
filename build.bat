echo %date% %time% > time.txt

IF NOT EXIST OUT MKDIR OUT
asm68k /k /p /o ae-,c+ SRC/_MAIN.ASM, OUT/MD11.BIN >OUT/MD11.LOG, OUT/MD11.SYM, OUT/MD11.LST
convsym OUT/MD11.SYM OUT/MD11.BIN -a

del time.txt