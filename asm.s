addi x31, x0, 3
sw   x31, 64(x0)
lw   x1, 64(x0)
addi x2, x1, 123
addi x3, x2, 51
andi x3, x3, 63
sw   x3, 64(x0)
addi x0, x0, 0