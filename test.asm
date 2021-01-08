	nop
	addiu  $1,$0,8
	ori  $2,$0,2
	add  $3,$2,$1
	sub  $5,$3,$2
	and  $4,$5,$2
	or  $8,$4,$2
	
label1:	
	sll  $8,$8,1
	bne $8,$1,label1
	slti  $6,$2,4
	slti  $7,$6,-1
	sltiu $6,$6,-1
	
label2:	
	addi  $7,$7,8
	beq  $7,$1,label2
	addi  $1,$0,-1
	
label3:	addiu  $10,$10,1
	bltz  $10,label3
	andi  $11,$2,2
label4:	jal  label9
	xor $8, $2, $11
	nor $8, $6, $11
	addu $8, $8, $11
	subu, $8, $8, $6
	srl $1, $1, 1
	sra $8, $8, 2
	lui $9, 7
	slt $10, $1, $8
	sltu $10, $1, $8
	sllv $4, $8, $6
label5:	addi $4, $4, 1
	blez $4, label5
	bltzal $8, label8
label6:	addi $2, $2, -1
	bgtz $2, label6
label7:	addi $11, $11, -1
	bgez $11, label7
	bgezal $0, label8
	srlv $12, $8, $7
	srav $12, $8, $7
	clo $2, $12
	sll $12, $12, 4
	clo $2, $12
	clz $2, $8
	srl $8, $8, 7
	clz $2, $8
	mul $1, $2, $3
	mult $2, $11
	multu $2, $11
	div $7, $5
	divu $1, $7
	mfhi $4
	mflo $6
	mthi $5
	mtlo $1
	j end
label8:	jr $ra
label9:	addi $30, $ra, 0
	jalr $30
end:	madd $10, $11
	maddu $10, $11
	msub $5, $6
	msubu $10, $11
	
	sw $8, 0($5)
	sh $8, 4($5)
	sb $8, 8($5)
	lw $1, 0($5)
	addi $1, $1, 0
	lw $1, 4($5)
	addi $1, $1, 0
	lw $1, 8($5)
	addi $1, $1, 0
	
	lh $1, 0($5)
	addi $1, $1, 0
	lhu $1, 0($5)
	addi $1, $1, 0
	lb $1, 0($5)
	addi $1, $1, 0
	lbu $1, 0($5)
	addi $1, $1, 0
	xori $1, $11, -1
