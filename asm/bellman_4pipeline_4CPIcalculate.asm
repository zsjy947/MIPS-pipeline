.data
filename: .asciiz "test.dat"
.align 4
buffer:   .space  4100
dist:   .space  128
##### You may add more code HERE if necessary #####

.text
main:
# Open file
la   $a0, filename  # load filename
li   $a1, 0         # flag
li   $a2, 0         # mode
li   $v0, 13        # open file syscall index
syscall

# Read file
move $a0, $v0       # load file description to $a0
la   $a1, buffer    # buffer address
li   $a2, 4100      # buffer size
li   $v0, 14        # read file syscall index
syscall

# Close file
li   $v0, 16        # close file syscall index
syscall

# Parameters
la   $t0, buffer
lw   $s0, 0($t0)    # set $s0 to n
move $a0, $s0       # set $a0 to n
addi $a1, $t0, 4    # set $a1 to &graph
la $a2, dist            #a2 = dist

bellman_ford:
##### YOUR CODE HERE #####
    
    la $a2, dist            #a2 = dist        #a2 = dist
    sw $zero, 0 ($a2)

    li   $t1,-1             # t1 = -1
    addi $s0, $zero, 1      # s0����ʼ��ѭ��������iΪ1

init_loop:
    bge  $s0, $a0, init_loop2     # ���i >= n������
    sll  $t3, $s0, 2                   #t3 = i*4
    add  $t2, $a2, $t3                 #t2 = t3 + t0, ��dist[i]
    sw	 $t1, 0($t2)	        # 
    addi $s0, $s0, 1
    j init_loop

init_loop2:
    addi $s0, $zero, 1      #i = 1

init_i:
    bge  $s0,$a0, relax_loop_end   
    addi $s1, $zero, 0      # s1: u = 0
    
init_u:
    bge  $s1,$a0,next_i   # ���u >= n������ת��next_i��ǩ��
    sll  $t1, $s1, 5        # t1 = u<<5 
    addi $s2,$zero,0        # s2: vΪ0

inner_loop:                 # v��ѭ��
    bge  $s2,$a0,next_u     # ���v >= n������ת��next_u��ǩ��
    add  $t0,$t1,$s2        # addr: t0 = (u<<5) + v
    sll  $t0, $t0, 2
    add  $t0, $t0, $a1
    lw   $t2, 0($t0)          # ����graph[addr]��ֵ��$t2��
    beq  $t2,-1,next_v      # ���graph[addr] == -1������ת��next_v��ǩ��
    beq  $s1,$s2,next_v     # ���u == v������ת��next_v��ǩ��

    sll  $t0, $s1, 2
    add  $t0, $t0, $a2      # t0 = a2 + (s1<<2) 
    lw   $t3, 0($t0)        # ����dist[u]��ֵ��$t3��
    beq  $t3,-1,next_v      # ���dist[u] == -1������ת��next_v��ǩ��

    sll  $t0, $s2, 2
    add  $t0, $t0, $a2      # t0 = a2 + (s2<<2) 
    lw   $t4, 0($t0)        # ����dist[v]��ֵ��$t4��
    add  $t5,$t3,$t2        # t5 = dist[u]+graph[addr]

    beq  $t4,-1, update     # ���dist[v] == -1, ����

    bgt	 $t4, $t5, update	# ����
    j    next_v

update:
    sw   $t5, 0($t0)    # �洢dist[v]����ֵ��dist������
    j   next_v


next_v:
    addi $s2,$s2,1          # ѭ��������v��1
    j    inner_loop         # ��ת��inner_loop��ǩ������ѭ��

next_u:
    addi $s1,$s1,1          # ѭ��������u��1
    j    init_u             # ��ת��init u��ǩ������ѭ��

next_i:
    addi $s0,$s0,1          # ѭ��������i��1
    j    init_i             # ��ת��init i��ǩ������ѭ��

relax_loop_end:             # ����ѭ��

# Print results
# $t0: sum up dist
addi $t0, $zero, 0
lw $t1, 0($a2)              # get dist value, $a2:dist, $t1: tmp
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

# 16����ת4���Ĵ�����10���ƴ洢
# ѭ����������
addi $t2, $t0, 0    
addi $t4, $zero,0
addi $t3, $zero, 10
div_loop1:
  sub $t2, $t2, $t3    # �ñ�������ȥ����
  addi $t4, $t4, 1      #ͳ�Ƴ������
  bgtz $t2, div_loop1  # ���������ڵ��� 0������ѭ��
  beq  $t2, $zero, div_loop1
add $s0, $t2, $t3    # ������������С�� 0������ϳ���,s0���Ǹ�λ
addi $t4,$t4, -1        # �������

# sub $t0, $t0, $s0      # ��ȥ��λ����

addi $t2, $t4, 0
addi $t4, $zero,0       # ���㣬ͳ�Ƴ������
addi $t3, $zero, 100
div_loop2:
  sub $t2, $t2, $t3    # �ñ�������ȥ����
  addi $t4, $t4, 1      #ͳ�Ƴ������
  bgtz $t2, div_loop2  # ���������ڵ��� 0������ѭ��
  beq  $t2, $zero, div_loop2
add $s1, $t2, $t3    # ������С�� 0������ϳ���,s1����ʮλ
#sub $t0, $t0, $s1      # ��ȥʮλ����
addi $t4,$t4, -1        # �������

addi $t2, $t4, 0
addi $t4, $zero,0       # ���㣬ͳ�Ƴ������
addi $t3, $zero, 1000
div_loop3:
  sub $t2, $t2, $t3    # �ñ�������ȥ����
  addi $t4, $t4, 1      #ͳ�Ƴ������
  bgtz $t2,  div_loop3  # ���������ڵ��� 0������ѭ��
  beq  $t2, $zero, div_loop3
add $s2, $t2, $t3    # ������С�� 0������ϳ���,s2���ǰ�λ
#sub $t0, $t0, $s2      # ��ȥ��λ����
addi $t4,$t4, -1        # �������

addi $t2, $t4, 0
addi $t4, $zero,0       # ���㣬ͳ�Ƴ������
addi $t3, $zero, 10000
div_loop4:
  sub $t2, $t2, $t3    # �ñ�������ȥ����
  addi $t4, $t4, 1      #ͳ�Ƴ������
  bgtz $t2,  div_loop4  # ���������ڵ��� 0������ѭ��
  beq  $t2, $zero, div_loop4
add $s3, $t2, $t3    # ������С�� 0������ϳ���,s3����ǧλ
addi $t4,$t4, -1        # �������

# ��λ���룬s0��Ϊ��λ����s4�洢������
unit:
add $a0, $s0, $zero
jal tr
addi $s4, $v0, 0x800

# ʮλ���룬s1��Ϊʮλ����s5�洢������
decade:
add $a0, $s1, $zero
jal tr
addi $s5, $v0, 0x400

# ��λ���룬s2��Ϊ��λ����s6�洢������
hundred:
add $a0, $s2, $zero
jal tr
addi $s6, $v0, 0x200

# ǧλ���룬s3��Ϊǧλ����s7�洢������
thousand:
add $a0, $s3, $zero
jal tr
addi $s7, $v0, 0x100

j print                 # ��ʼ��ӡ

# ���뺯��,����a0,����ֵ��v0
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
    addi $t0, $t0, 1
    add $t9, $a2, $zero                  # the address for BCD control
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
    addi $t2, $zero, 100
    wait_loop:
        beq $t1, $t2, end_wait_loop
        addi $t1, $t1, 1
        nop
        j wait_loop
    end_wait_loop:
    jr $ra


final_end:
    nop
    
