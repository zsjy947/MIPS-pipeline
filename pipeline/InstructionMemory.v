module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])			
//		addi $a0 $zero 5	# x = 5
//		lui $t0 0x4000
//		addi $t0 $t0 0		# $t0 = address of reg_op
//		sw $a0 0($t0)		# set reg_op = 5
//		lui $t1 0x4000
//		addi $t1 $t0 8		# $t1 = address of reg_start
//		addi $a1 $zero 1	# $a1 = 1
//		sw $a1 0($t1)		# set reg_start = 1
//		addi $a0 $zero 7	# y = 7
//		jal h_y				# calc y^2 + y
//		addi $s1 $v0 0		# $s1 = h(y)
//		lui $t2 0x4000
//		addi $t2 $t2 4		# $t2 = address of reg_ans
//		lw $s0 0($t2)		# $s0 = g(x)
//		sub $s2 $s0 $s1		# $s2 = f(x, y)
//	loop:
//		j loop
//	h_y:
//		add $t0 $zero $a0	# partial sum $t0 = y
//		mul $t1 $a0 $a0		# $t1 = y^2
//		add $t0 $t0 $t1		# $t0 = y + y^2
//		addi $v0 $t0 0		# $v0 = $t0
//		jr $ra				# return h(y)


8'd0:   Instruction <= 32'h0x3c011001;
8'd1:   Instruction <= 32'h0x34240000;
8'd2:   Instruction <= 32'h0x24050000;
8'd3:   Instruction <= 32'h0x24060000;
8'd4:   Instruction <= 32'h0x2402000d;
8'd5:   Instruction <= 32'h0x0000000c;
8'd6:   Instruction <= 32'h0x00022021;
8'd7:   Instruction <= 32'h0x3c011001;
8'd8:   Instruction <= 32'h0x34250010;
8'd9:   Instruction <= 32'h0x24061004;
8'd10:   Instruction <= 32'h0x2402000e;
8'd11:   Instruction <= 32'h0x0000000c;
8'd12:   Instruction <= 32'h0x24020010;
8'd13:   Instruction <= 32'h0x0000000c;
8'd14:   Instruction <= 32'h0x3c011001;
8'd15:   Instruction <= 32'h0x34280010;
8'd16:   Instruction <= 32'h0x8d100000;
8'd17:   Instruction <= 32'h0x00102021;
8'd18:   Instruction <= 32'h0x21050004;
8'd19:   Instruction <= 32'h0x3c011001;
8'd20:   Instruction <= 32'h0x34261014;
8'd21:   Instruction <= 32'h0x3c011001;
8'd22:   Instruction <= 32'h0x34261014;
8'd23:   Instruction <= 32'h0xacc00000;
8'd24:   Instruction <= 32'h0x2409ffff;
8'd25:   Instruction <= 32'h0x20100001;
8'd26:   Instruction <= 32'h0x0204082a;
8'd27:   Instruction <= 32'h0x10200005;
8'd28:   Instruction <= 32'h0x00105880;
8'd29:   Instruction <= 32'h0x00cb5020;
8'd30:   Instruction <= 32'h0xad490000;
8'd31:   Instruction <= 32'h0x22100001;
8'd32:   Instruction <= 32'h0x0810001a;
8'd33:   Instruction <= 32'h0x20100001;
8'd34:   Instruction <= 32'h0x0204082a;
8'd35:   Instruction <= 32'h0x10200024;
8'd36:   Instruction <= 32'h0x20110000;
8'd37:   Instruction <= 32'h0x0224082a;
8'd38:   Instruction <= 32'h0x1020001f;
8'd39:   Instruction <= 32'h0x00114940;
8'd40:   Instruction <= 32'h0x20120000;
8'd41:   Instruction <= 32'h0x0244082a;
8'd42:   Instruction <= 32'h0x10200019;
8'd43:   Instruction <= 32'h0x01324020;
8'd44:   Instruction <= 32'h0x00084080;
8'd45:   Instruction <= 32'h0x01054020;
8'd46:   Instruction <= 32'h0x8d0a0000;
8'd47:   Instruction <= 32'h0x2001ffff;
8'd48:   Instruction <= 32'h0x102a0011;
8'd49:   Instruction <= 32'h0x12320010;
8'd50:   Instruction <= 32'h0x00114080;
8'd51:   Instruction <= 32'h0x01064020;
8'd52:   Instruction <= 32'h0x8d0b0000;
8'd53:   Instruction <= 32'h0x2001ffff;
8'd54:   Instruction <= 32'h0x102b000b;
8'd55:   Instruction <= 32'h0x00124080;
8'd56:   Instruction <= 32'h0x01064020;
8'd57:   Instruction <= 32'h0x8d0c0000;
8'd58:   Instruction <= 32'h0x016a6820;
8'd59:   Instruction <= 32'h0x2001ffff;
8'd60:   Instruction <= 32'h0x102c0003;
8'd61:   Instruction <= 32'h0x01ac082a;
8'd62:   Instruction <= 32'h0x14200001;
8'd63:   Instruction <= 32'h0x08100042;
8'd64:   Instruction <= 32'h0xad0d0000;
8'd65:   Instruction <= 32'h0x08100042;
8'd66:   Instruction <= 32'h0x22520001;
8'd67:   Instruction <= 32'h0x08100029;
8'd68:   Instruction <= 32'h0x22310001;
8'd69:   Instruction <= 32'h0x08100025;
8'd70:   Instruction <= 32'h0x22100001;
8'd71:   Instruction <= 32'h0x08100022;
8'd72:   Instruction <= 32'h0x20080000;
8'd73:   Instruction <= 32'h0x8cc90000;
8'd74:   Instruction <= 32'h0x01094020;
8'd75:   Instruction <= 32'h0x8cc90004;
8'd76:   Instruction <= 32'h0x01094020;
8'd77:   Instruction <= 32'h0x8cc90008;
8'd78:   Instruction <= 32'h0x01094020;
8'd79:   Instruction <= 32'h0x8cc9000c;
8'd80:   Instruction <= 32'h0x01094020;
8'd81:   Instruction <= 32'h0x8cc90010;
8'd82:   Instruction <= 32'h0x01094020;
8'd83:   Instruction <= 32'h0x8cc90014;
8'd84:   Instruction <= 32'h0x01094020;
8'd85:   Instruction <= 32'h0x210a0000;
8'd86:   Instruction <= 32'h0x200c0000;
8'd87:   Instruction <= 32'h0x200b000a;
8'd88:   Instruction <= 32'h0x014b5022;
8'd89:   Instruction <= 32'h0x218c0001;
8'd90:   Instruction <= 32'h0x1d40fffd;
8'd91:   Instruction <= 32'h0x1140fffc;
8'd92:   Instruction <= 32'h0x014b8020;
8'd93:   Instruction <= 32'h0x218cffff;
8'd94:   Instruction <= 32'h0x218a0000;
8'd95:   Instruction <= 32'h0x200c0000;
8'd96:   Instruction <= 32'h0x200b0064;
8'd97:   Instruction <= 32'h0x014b5022;
8'd98:   Instruction <= 32'h0x218c0001;
8'd99:   Instruction <= 32'h0x1d40fffd;
8'd100:   Instruction <= 32'h0x1140fffc;
8'd101:   Instruction <= 32'h0x014b8820;
8'd102:   Instruction <= 32'h0x218cffff;
8'd103:   Instruction <= 32'h0x218a0000;
8'd104:   Instruction <= 32'h0x200c0000;
8'd105:   Instruction <= 32'h0x200b03e8;
8'd106:   Instruction <= 32'h0x014b5022;
8'd107:   Instruction <= 32'h0x218c0001;
8'd108:   Instruction <= 32'h0x1d40fffd;
8'd109:   Instruction <= 32'h0x1140fffc;
8'd110:   Instruction <= 32'h0x014b9020;
8'd111:   Instruction <= 32'h0x218cffff;
8'd112:   Instruction <= 32'h0x218a0000;
8'd113:   Instruction <= 32'h0x200c0000;
8'd114:   Instruction <= 32'h0x200b2710;
8'd115:   Instruction <= 32'h0x014b5022;
8'd116:   Instruction <= 32'h0x218c0001;
8'd117:   Instruction <= 32'h0x1d40fffd;
8'd118:   Instruction <= 32'h0x1140fffc;
8'd119:   Instruction <= 32'h0x014b9820;
8'd120:   Instruction <= 32'h0x218cffff;
8'd121:   Instruction <= 32'h0x02002020;
8'd122:   Instruction <= 32'h0x0c100086;
8'd123:   Instruction <= 32'h0x20540800;
8'd124:   Instruction <= 32'h0x02202020;
8'd125:   Instruction <= 32'h0x0c100086;
8'd126:   Instruction <= 32'h0x20550400;
8'd127:   Instruction <= 32'h0x02402020;
8'd128:   Instruction <= 32'h0x0c100086;
8'd129:   Instruction <= 32'h0x20560200;
8'd130:   Instruction <= 32'h0x02602020;
8'd131:   Instruction <= 32'h0x0c100086;
8'd132:   Instruction <= 32'h0x20570100;
8'd133:   Instruction <= 32'h0x081000af;
8'd134:   Instruction <= 32'h0x20080000;
8'd135:   Instruction <= 32'h0x10880012;
8'd136:   Instruction <= 32'h0x20080001;
8'd137:   Instruction <= 32'h0x10880012;
8'd138:   Instruction <= 32'h0x20080002;
8'd139:   Instruction <= 32'h0x10880012;
8'd140:   Instruction <= 32'h0x20080003;
8'd141:   Instruction <= 32'h0x10880012;
8'd142:   Instruction <= 32'h0x20080004;
8'd143:   Instruction <= 32'h0x10880012;
8'd144:   Instruction <= 32'h0x20080005;
8'd145:   Instruction <= 32'h0x10880012;
8'd146:   Instruction <= 32'h0x20080006;
8'd147:   Instruction <= 32'h0x10880012;
8'd148:   Instruction <= 32'h0x20080007;
8'd149:   Instruction <= 32'h0x10880012;
8'd150:   Instruction <= 32'h0x20080008;
8'd151:   Instruction <= 32'h0x10880012;
8'd152:   Instruction <= 32'h0x20080009;
8'd153:   Instruction <= 32'h0x10880012;
8'd154:   Instruction <= 32'h0x2002003f;
8'd155:   Instruction <= 32'h0x081000ae;
8'd156:   Instruction <= 32'h0x20020006;
8'd157:   Instruction <= 32'h0x081000ae;
8'd158:   Instruction <= 32'h0x2002005b;
8'd159:   Instruction <= 32'h0x081000ae;
8'd160:   Instruction <= 32'h0x2002004f;
8'd161:   Instruction <= 32'h0x081000ae;
8'd162:   Instruction <= 32'h0x20020066;
8'd163:   Instruction <= 32'h0x081000ae;
8'd164:   Instruction <= 32'h0x2002006d;
8'd165:   Instruction <= 32'h0x081000ae;
8'd166:   Instruction <= 32'h0x2002007d;
8'd167:   Instruction <= 32'h0x081000ae;
8'd168:   Instruction <= 32'h0x20020007;
8'd169:   Instruction <= 32'h0x081000ae;
8'd170:   Instruction <= 32'h0x2002007f;
8'd171:   Instruction <= 32'h0x081000ae;
8'd172:   Instruction <= 32'h0x2002006f;
8'd173:   Instruction <= 32'h0x081000ae;
8'd174:   Instruction <= 32'h0x03e00008;
8'd175:   Instruction <= 32'h0x20080001;
8'd176:   Instruction <= 32'h0x20180064;
8'd177:   Instruction <= 32'h0x11180012;
8'd178:   Instruction <= 32'h0x21080001;
8'd179:   Instruction <= 32'h0x00c0c820;
8'd180:   Instruction <= 32'h0xaf340000;
8'd181:   Instruction <= 32'h0x0c1000bd;
8'd182:   Instruction <= 32'h0xaf350000;
8'd183:   Instruction <= 32'h0x0c1000bd;
8'd184:   Instruction <= 32'h0xaf360000;
8'd185:   Instruction <= 32'h0x0c1000bd;
8'd186:   Instruction <= 32'h0xaf370000;
8'd187:   Instruction <= 32'h0x0c1000bd;
8'd188:   Instruction <= 32'h0x081000b1;
8'd189:   Instruction <= 32'h0x20090001;
8'd190:   Instruction <= 32'h0x200a0064;
8'd191:   Instruction <= 32'h0x112a0003;
8'd192:   Instruction <= 32'h0x21290001;
8'd193:   Instruction <= 32'h0x00000000;
8'd194:   Instruction <= 32'h0x081000bf;
8'd195:   Instruction <= 32'h0x03e00008;
8'd196:   Instruction <= 32'h0x00000000;





endcase
		
endmodule
