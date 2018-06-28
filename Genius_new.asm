#disp_width:  	512		
#disp_height: 	256		
#unit_width: 	8 
#unit_height: 	8
.data
white_color: 	.word	0xFFFFFFFF
red_color: 	.word  	0xffb2b2
yellow_color: 	.word 	0xfffbb2
blue_color: 	.word 	0xb2c1ff
green_color:	.word 	0xb2ffb3
red_neon: 	.word	0xf41111
yellow_neon: 	.word 	0xeaff30
blue_neon: 	.word 	0x03469e
green_neon: 	.word 	0x12a601
n_jogadas: 	.asciiz "At� quantas repeti��es voc� deseja jogar?\n"
sucesso: 	.asciiz "	PARAB�NS!\n	Voc� ganhou!\n"
fracasso:	.asciiz "	GAME OVER\n"
menu: 		.asciiz "1- Iniciar o jogo\n2- Encerrar o programa\n"
velocidade: 	.asciiz "Qual a velocidade desejada? (100ms, 200ms, 300ms)"
res: 		.asciiz "digita:\n"
.align 2
struct_pilha: 	.space 84	#20 * 4 bytes + 4 bytes

#-----------------------------------	
#a0 		48(sp)	
#---------------48(sp)
#		44(sp)
#s5		40(sp)
#s4		36(sp)
#s3		32(sp)
#s2		28(sp)	---> numero digitado para comparacao
#s1		24(sp)	--->cor
#s0		20(sp)	--->j
#---------------
#ra		16(sp)--->ra
#---------------
#a3		12(sp)--->i
#a2		8(sp)--->struct pilha
#a1		4(sp)--->velocidade
#a0		0(sp)--->n� de jogadas

.text
.globl main
main:
	la	$a0, menu
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	
	beq	$v0, 1, start_game
	beq	$v0, 2, exit_program
start_game:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	jal	show_screen
	
	la	$a0, n_jogadas
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a0, $v0			# a0 = numero de jogadas
	sw	$a0, 0($sp)
	
	la	$a0, velocidade
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$a1, $v0			# a1 = velocidade
	sw	$a1, 4($sp)
	
		
	la	$a2, struct_pilha		# a2 = pilha_cores
	sw	$a2, 8($sp)
	
	li	$a3, 0				#i
	sw	$a3, 12($sp)
	
	li	$s0, 0				# j = topo
	sw	$s0, 20($sp)
for_sorteia:
	#lw	$s0, 20($a2)			# carregar o topo da pilha (topo = pilha->topo)			
	lw	$a0, 0($sp)			# n_jogadas
	bge	$s0, $a0, end_success		# if (topo >= n� jogadas) ==>success
	
	#sorteia_cor
	li	$a1, 4
	li	$v0, 42
	syscall 				# cor_sorteada no a0
	
	#adiciona na pilha
	addi	$s0, $s0, 1			# topo++
	sw	$s0, 20($sp)			#armazena o valor do topo	
		
	sw	$a0, 0($a2)			#armazena a cor sorteada na pilha
end_for_sorteia:
	lw	$s0, 20($sp)			
	lw	$a2, 8($sp)
	sll	$t0, $s0, 2
	add	$a2, $a2, $t0			#endereco na pilha = endereco inicial + topo
	b	for_sorteia
#--------------------------------------------------
end_success:	
	li	$v0, 31
	li	$a0, 65
	li	$a1, 10000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 69
	li	$a1, 10000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 65
	li	$a1, 10000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 69
	li	$a1, 100000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 65
	li	$a1, 1000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 69
	li	$a1, 1000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	li	$v0, 31
	li	$a0, 65
	li	$a1, 1000
	li	$a2, 27
	li	$a3, 127
	syscall
	
	la	$a0, sucesso
	li	$v0, 4
	syscall
	
	j	end
#--------------------------------------------------
set_yellow:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	jal	yellow_on
	#som
	li	$v0, 31
	li	$a0, 71
	li	$a1, 1000
	li	$a2, 40
	li	$a3, 100
	syscall
	
	#lw	$a1, 4($sp)
	#move	$a0, $a1
	li	$a0, 1000
	li	$v0, 32
	syscall 
	jal	yellow_off			# 8 (teclado)
	li	$s2, 0
	sw	$s2, 28($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
set_red:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	jal	red_on				# 2 (teclado)
	#som
	li	$v0, 31
	li	$a0, 61
	li	$a1, 1000
	li	$a2, 17
	li	$a3, 100
	syscall
	
	#lw	$a1, 4($sp)
	#move	$a0, $a1
	li	$a0, 1000
	li	$v0, 32
	syscall 
	jal	red_off
	li	$s2, 1
	sw	$s2, 28($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
set_blue:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)	
	jal	blue_on				# 6 (teclado)
	#som
	li	$v0, 31
	li	$a0, 72
	li	$a1, 1000
	li	$a2, 14
	li	$a3, 127
	syscall
	
	#lw	$a1, 4($sp)
	#move	$a0, $a1
	li	$a0, 1000
	li	$v0, 32
	syscall 
	jal	blue_off
	li	$s2, 3
	sw	$s2, 28($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
set_green:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	jal	green_on			# 4 (teclado)
	#som
	li	$v0, 31
	li	$a0, 68
	li	$a1, 1000
	li	$a2, 25
	li	$a3, 100
	syscall
	
	#lw	$a1, 4($sp)
	#move	$a0, $a1
	li	$a0, 1000
	li	$v0, 32
	syscall 
	jal	green_off
	li	$s2, 2
	sw	$s2, 28($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------
show_screen:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	jal	red_off
	jal	yellow_off
	jal	green_off
	jal	blue_off
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------
#-------------turn off colors-----------------------		
yellow_off:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 24			# x0
	li	$a2, 37			# x1
	
	li	$a1, 1			# y0
	li	$a3, 1			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, yellow_color
for_yellow:
	bgt	$a1, 7, end_yellow
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_yellow	
end_yellow:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------
red_off:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 24			# x0
	li	$a2, 37			# x1
	
	li	$a1, 24			# y0
	li	$a3, 24			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, red_color
for_red:
	bgt	$a1, 30, end_red
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_red	
end_red:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
green_off:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 14			# x0
	li	$a2, 22			# x1
	
	li	$a1, 9			# y0
	li	$a3, 9			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, green_color	
for_green:
	bgt	$a1, 22, end_green
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_green	
end_green:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
blue_off:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 39			# x0
	li	$a2, 47			# x1
	
	li	$a1, 9			# y0
	li	$a3, 9			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, blue_color	
for_blue:
	bgt	$a1, 22, end_blue
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_blue	
end_blue:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
#-------------turn on colors-----------------------	
yellow_on:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 24			# x0
	li	$a2, 37			# x1
	
	li	$a1, 1			# y0
	li	$a3, 1			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, yellow_neon
for_yellow_on:
	bgt	$a1, 7, end_yellow_on
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_yellow_on	
end_yellow_on:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------
red_on:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 24			# x0
	li	$a2, 37			# x1
	
	li	$a1, 24			# y0
	li	$a3, 24			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, red_neon
for_red_on:
	bgt	$a1, 30, end_red_on
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_red_on	
end_red_on:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
green_on:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 14			# x0
	li	$a2, 22			# x1
	
	li	$a1, 9			# y0
	li	$a3, 9			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, green_neon	
for_green_on:
	bgt	$a1, 22, end_green_on
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_green_on	
end_green_on:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
blue_on:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	li	$a0, 39			# x0
	li	$a2, 47			# x1
	
	li	$a1, 9			# y0
	li	$a3, 9			# y1
	
	sw	$a0, 0($sp)
	sw	$a2, 8($sp)
	lw	$s0, blue_neon	
for_blue_on:
	bgt	$a1, 22, end_blue_on
	lw	$a0, 0($sp)
	lw	$a2, 8($sp)
	jal	draw_line
	addi	$a1, $a1, 1		# y0++
	addi	$a3, $a3, 1		# y1++
	b 	for_blue_on	
end_blue_on:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------
game_over:
	li	$v0, 31
	li	$a0, 71
	li	$a1, 1000
	li	$a2, 12
	li	$a3, 80
	syscall
	
	li	$v0, 31
	li	$a0, 69
	li	$a1, 1000
	li	$a2, 12
	li	$a3, 70
	syscall
	
	li	$v0, 31
	li	$a0, 67
	li	$a1, 1000
	li	$a2, 12
	li	$a3, 60
	syscall
	
	li	$v0, 31
	li	$a0, 65
	li	$a1, 10000
	li	$a2, 12
	li	$a3, 60
	syscall
	
	li	$v0, 31
	li	$a0, 64
	li	$a1, 10000
	li	$a2, 12
	li	$a3, 60
	syscall
	
	li	$v0, 31
	li	$a0, 62
	li	$a1, 10000
	li	$a2, 12
	li	$a3, 50
	syscall

	li	$v0, 31
	li	$a0, 60
	li	$a1, 10000
	li	$a2, 12
	li	$a3, 40
	syscall
	
	la	$a0, fracasso
	li	$v0, 4
	syscall
	
	j	end
#--------------------------------------------------	
#void setPixel(int x, int y, int color);
set_pixel:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	
	la	$t0, 0x10010000
	mul	$t2, $a1, 256		# y * 256
	sll	$t1, $a0, 2		# x * 4
	add	$t9, $t1, $t2		# (y * 256) + (x * 4)
	add	$t9, $t9, $t0		# 0x10010000 +  (y * 256) + (x * 4)
	sw	$s0, 0($t9)		# armazena a cor na pos (x, y)
	
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
#--------------------------------------------------	
#void drawLine(int x0, int y0, int x1, int y1, int color);
draw_line:
	addiu	$sp, $sp, -48
	sw	$ra, 16($sp)
	sub	$s1, $a2, $a0		#dx = x1 - x0
	sw	$s1, 24($sp)
	sub	$s2, $a3, $a1		#dy = y1 - y0
	sw	$s2, 28($sp)
	sll	$s3, $s2, 1		#2 * dy 
	sub	$s3, $s3, $s1		#D = 2*dy - dx
	sw	$s3, 32($sp)
	add	$s5, $a1, $zero		# y = y0
	sw	$s5, 40($sp)
	add 	$s4, $a0, $zero		# x = x0
	sw	$s4, 36($sp)
for:
	bgt	$s4, $a2, end_draw	# if x > x1
	move	$a0, $s4
	move	$a1, $s5
	jal	set_pixel
	lw	$s3, 32($sp)
	blez	$s3, end_if		#D <= 0
	lw	$s5, 40($sp)
	lw	$s1, 24($sp)
	lw	$s2, 28($sp)
	addi	$s5, $s5, 1		# y = y + 1
	sll	$t0, $s1, 1		# 2 * dx
	sub	$s3, $s3, $t0		# D = D - 2 * dx	
end_if:
	lw	$s3, 32($sp)
	lw	$s2, 28($sp)
	sll	$t1, $s2, 1
	add	$s3, $s3, $t1
	addi	$s4, $s4 1
	sw	$s3, 32($sp)
	j	for	
end_draw:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48
	jr	$ra
end:
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 48	
exit_program:
	li	$v0, 10
	syscall