asm86 queue.asm m1 db ep
asm86chk queue.asm
asm86 main.asm m1 db ep
asm86chk main.asm
link86 queue.obj, main.obj, hw3test.obj to queue.lnk
loc86 queue.lnk to queue NOIC AD(SM(CODE(400H), DATA(4000H), STACK(7000H)))
