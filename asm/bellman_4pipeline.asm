.text
main:
# Parameters
lw   $s0, 0($zero)    # set $s0 to n
move $a0, $s0       # set $a0 to n
addi $a1, $t0, 4    # set $a1 to &graph

# Call Bellman-Ford


bellman_ford:
##### YOUR CODE HERE #####
    
    addi $a2, $zero, 800         #a2 = dist
    sw $zero, 0 ($a2)

    li   $t1,-1             # t1 = -1
    addi $s0, $zero, 1     

init_loop:
    bge  $s0, $a0, init_loop2   
    sll  $t3, $s0, 2                   #t3 = i*4
    add  $t2, $a2, $t3                 #t2 = t3 + t0
    sw	 $t1, 0($t2)	        # 
    addi $s0, $s0, 1
    j init_loop

init_loop2:
    addi $s0, $zero, 1      #i = 1

init_i:
    bge  $s0,$a0, relax_loop_end   
    addi $s1, $zero, 0      # s1: u = 0
    
init_u:
    bge  $s1,$a0,next_i   
    sll  $t1, $s1, 5        # t1 = u<<5 
    addi $s2,$zero,0        # s2: v为0

inner_loop:                 
    bge  $s2,$a0,next_u    
    add  $t0,$t1,$s2        # addr: t0 = (u<<5) + v
    sll  $t0, $t0, 2
    add  $t0, $t0, $a1
    lw   $t2, 0($t0)          
    beq  $t2,-1,next_v     
    beq  $s1,$s2,next_v    

    sll  $t0, $s1, 2
    add  $t0, $t0, $a2      # t0 = a2 + (s1<<2) 
    lw   $t3, 0($t0)        
    beq  $t3,-1,next_v      

    sll  $t0, $s2, 2
    add  $t0, $t0, $a2      # t0 = a2 + (s2<<2) 
    lw   $t4, 0($t0)       
    add  $t5,$t3,$t2        

    beq  $t4,-1, update    

    bgt	 $t4, $t5, update	
    j    next_v

update:
    sw   $t5, 0($t0)   
    j   next_v


next_v:
    addi $s2,$s2,1         
    j    inner_loop       

next_u:
    addi $s1,$s1,1          
    j    init_u             

next_i:
    addi $s0,$s0,1          
    j    init_i             

relax_loop_end:             

# Print results
# $t0: sum up dist
addi $t0, $zero, 0
lw $t1, 0($a2)             
add  $t0, $t0, $t1
lw $t1, 4($a2)
add  $t0, $t0, $t1
lw $t1, 8($a2)
add  $t0, $t0, $t1
lw $t1, 12($a2)
add  $t0, $t0, $t1
lw $t1, 16($a2)
add  $t0, $t0, $t1
lw $t1, 20($a2)
add  $t0, $t0, $t1

#16进制转10进制存储
#循环计算余数
addi $t2, $t0, 0    
addi $t4, $zero,0
addi $t3, $zero, 10
div_loop1:
  sub $t2, $t2, $t3   			#被除数减除数
  addi $t4, $t4, 1      		#统计除法结果
  bgtz $t2, div_loop1 			#结果大于等于0，循环
  beq  $t2, $zero, div_loop1
add $s0, $t2, $t3    			#余数，结果小于0则加上出书
addi $t4,$t4, -1       			#结果


addi $t2, $t4, 0
addi $t4, $zero,0       
addi $t3, $zero, 100
div_loop2:
  sub $t2, $t2, $t3   
  addi $t4, $t4, 1      
  bgtz $t2, div_loop2  
  beq  $t2, $zero, div_loop2
add $s1, $t2, $t3   
addi $t4,$t4, -1       

addi $t2, $t4, 0
addi $t4, $zero,0      
addi $t3, $zero, 1000
div_loop3:
  sub $t2, $t2, $t3   
  addi $t4, $t4, 1      
  bgtz $t2,  div_loop3  
  beq  $t2, $zero, div_loop3
add $s2, $t2, $t3    
addi $t4,$t4, -1        

addi $t2, $t4, 0
addi $t4, $zero,0       
addi $t3, $zero, 10000
div_loop4:
  sub $t2, $t2, $t3   
  addi $t4, $t4, 1     
  bgtz $t2,  div_loop4  
  beq  $t2, $zero, div_loop4
add $s3, $t2, $t3   
addi $t4,$t4, -1        

unit:
add $a0, $s0, $zero
jal tr
addi $s4, $v0, 0x800

decade:
add $a0, $s1, $zero
jal tr
addi $s5, $v0, 0x400

hundred:
add $a0, $s2, $zero
jal tr
addi $s6, $v0, 0x200

thousand:
add $a0, $s3, $zero
jal tr
addi $s7, $v0, 0x100

j print

tr:
    addi $t0, $zero, 0
    beq $a0, $t0, case_0
    addi $t0, $zero, 1
    beq $a0, $t0, case_1
    addi $t0, $zero, 2
    beq $a0, $t0, case_2
    addi $t0, $zero, 3
    beq $a0, $t0, case_3
    addi $t0, $zero, 4
    beq $a0, $t0, case_4
    addi $t0, $zero, 5
    beq $a0, $t0, case_5
    addi $t0, $zero, 6
    beq $a0, $t0, case_6
    addi $t0, $zero, 7
    beq $a0, $t0, case_7
    addi $t0, $zero, 8
    beq $a0, $t0, case_8
    addi $t0, $zero, 9
    beq $a0, $t0, case_9

    case_0:
    addi $v0, $zero, 0x3f
    j end_tr
    case_1:
    addi $v0, $zero, 0x06
    j end_tr
    case_2:
    addi $v0, $zero, 0x5b
    j end_tr
    case_3:
    addi $v0, $zero, 0x4f
    j end_tr
    case_4:
    addi $v0, $zero, 0x66
    j end_tr
    case_5:
    addi $v0, $zero, 0x6d
    j end_tr
    case_6:
    addi $v0, $zero, 0x7d
    j end_tr
    case_7:
    addi $v0, $zero, 0x07
    j end_tr
    case_8:
    addi $v0, $zero, 0x7f
    j end_tr
    case_9:
    addi $v0, $zero, 0x6f
    j end_tr

end_tr:
    jr $ra

print:
addi $t0, $zero, 1              # t0: count time
addi $t8, $zero, 100
print_loop:
    beq $t0, $t8, final_end
    lui $t9, 0x4000          
    addi $t9, $t9, 0x0010                    # the address for BCD control
    sw $s4 , 0($t9)
    jal wait_func
    sw $s5 , 0($t9)
    jal wait_func
    sw $s6 , 0($t9)
    jal wait_func
    sw $s7 , 0($t9)
    jal wait_func
    j print_loop
    
wait_func:
    addi $t1, $zero, 1
    addi $t2, $zero, 10
    wait_loop:
        beq $t1, $t2, end_wait_loop
        addi $t1, $t1, 1
        nop
        j wait_loop
    end_wait_loop:
    jr $ra

final_end:
    nop
    
