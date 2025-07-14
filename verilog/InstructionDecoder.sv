/**
 * S: opcode[6,5,4] == 010
 * U: opcode[6,4,2] == 011
 * R: opcode[6,5,4,2] == 0110
 * B: opcode[6,5,4,3,2] == 11000
 * J: opcode[6,5,4,3] == 1101
 * I: opcode[5,4] == 00 OR
 *    opcode[6,4] == 11 OR
 *    opcode[6,3,2] == 101 OR
 *    opcode[5,3,2] == 000
 */

module InstructionDecoder(
    input [31:0] instruction,
    output [31:0] immediate,
    output S, 
    output U, 
    output R, 
    output B, 
    output J, 
    output I);

    wire [6:0] opcode;

    assign opcode = instruction[6:0];

    // Decode Immediate:
    assign immediate[31] = instruction[31];
    assign immediate[30:20] = U ? instruction[30:20] : {(11){instruction[31]}};
    assign immediate[19:12] = U|J ? instruction[19:12] : {(8){instruction[31]}};
    assign immediate[11] = (U|J)&(B|J)  ? instruction[20] :
                           (U|J)&~(B|J) ? 0 :
                           ~(U|J)&(B|J) ? instruction[7] :
                                          instruction[31];
    assign immediate[10:5] = U ? 6'b000000 : instruction[30:25];
    assign immediate[4:1] = U ? 5'b00000 : 
                                S|B ? instruction[11:8] : instruction[24:21];
    assign immediate[0] = U|B|J ? 1'b0 :
                                  S ? instruction[7] : instruction[20];

    // S: opcode[6,5,4] == 010:
    assign S = opcode[6:4] == 3'b010;

    // U: opcode[6,4,2] == 3'b011:
    assign U = {opcode[6], opcode[4], opcode[2]} == 3'b011;

    // R: opcode[6,5,4,2] == 0110:
    assign R = {opcode[6:4], opcode[2]} == 4'b0110;

    // B: opcode == 11000:
    assign B = opcode[6:2] == 5'b11000;

    // J: opcode[6,5,4,3] == 1101:
    assign J = opcode[6:3] == 4'b1101;
    
    // I: opcode[5,4] == 00 OR
    //    opcode[6,4] == 11 OR
    //    opcode[6,3,2] == 101 OR
    //    opcode[5,3,2] == 000:
    assign I = 
        opcode[5:4] == 2'b00 | 
        {opcode[6],opcode[4]} == 2'b11 | 
        {opcode[6],opcode[3:2]} == 3'b101 |
        {opcode[5],opcode[3:2]} == 3'b000;

endmodule

module testID;

    reg [31:0] instruction;
    wire[31:0] immediate;
    wire [6:0] opcode; 
    wire S;
    wire U;
    wire R;
    wire B;
    wire J;
    wire I;

    InstructionDecoder id(instruction, immediate, S, U, R, B, J, I);

    reg [6:0] testCode [39:0];
    reg [6:0] types [39:0];

    assign opcode = id.opcode;
    
    integer i;

    initial begin
        $display("Immediate Decode Test:");
        #1 instruction = 32'h0c300093;
        #1 $display("I-type, expected 000000c3, got %h", immediate);
        #1 instruction = 32'h01000237;
        #1 $display("U-type, expected 01000000, got %h", immediate);
        #1 instruction = 32'h0040a423;
        #1 $display("S-type, expected 00000008, got %h", immediate);
        #1 instruction = 32'h014000ef;
        #1 $display("J-type, expected 00000014, got %h", immediate);
        #1 instruction = 32'h00209663;
        #1 $display("B-type, expected 0000000c, got %h", immediate);

        #1 instruction = 32'haaa08093;
        #1 $display("I-type, expected fffffaaa got %h", immediate);
        #1 instruction = 32'h55508093;
        #1 $display("I-type, expected 00000555 got %h", immediate);
        #1 instruction = 32'haaaaa0b7;
        #1 $display("U-type, expected aaaaa000 got %h", immediate);
        #1 instruction = 32'h555550b7;
        #1 $display("U-type, expected 55555000 got %h", immediate);
        #1 instruction = 32'haa112523;
        #1 $display("S-type, expected fffffaaa got %h", immediate);
        #1 instruction = 32'h54112aa3;
        #1 $display("S-type, expected 00000555 got %h", immediate);
        #1 instruction = 32'h0e000a63;
        #1 $display("B-type, expected 000000f4 got %h", immediate);
        #1 instruction = 32'h0e000263;
        #1 $display("B-type, expected 000000e4 got %h", immediate);
        #1 instruction = 32'h0ec0006f;
        #1 $display("J-type, expected 000000ec got %h", immediate);
        #1 instruction = 32'h0dc0006f;
        #1 $display("J-type, expected 000000dc got %h", immediate);

        #1;

        $display("Opcode Decode Test:");
        testCode[0] = 7'b0000011;
        testCode[1] = 7'b0000011;
        testCode[2] = 7'b0000011;
        testCode[3] = 7'b0000011;
        testCode[4] = 7'b0000011;
        testCode[5] = 7'b0001111;
        testCode[6] = 7'b0010011;
        testCode[7] = 7'b0010011;
        testCode[8] = 7'b0010011;
        testCode[9] = 7'b0010011;
        testCode[10] = 7'b0010011;
        testCode[11] = 7'b0010011;
        testCode[12] = 7'b0010011;
        testCode[13] = 7'b0010011;
        testCode[14] = 7'b0010011;
        testCode[15] = 7'b0010111;
        testCode[16] = 7'b0100011;
        testCode[17] = 7'b0100011;
        testCode[18] = 7'b0100011;
        testCode[19] = 7'b0110011;
        testCode[20] = 7'b0110011;
        testCode[21] = 7'b0110011;
        testCode[22] = 7'b0110011;
        testCode[23] = 7'b0110011;
        testCode[24] = 7'b0110011;
        testCode[25] = 7'b0110011;
        testCode[26] = 7'b0110011;
        testCode[27] = 7'b0110011;
        testCode[28] = 7'b0110011;
        testCode[29] = 7'b0110111;
        testCode[30] = 7'b1100011;
        testCode[31] = 7'b1100011;
        testCode[32] = 7'b1100011;
        testCode[33] = 7'b1100011;
        testCode[34] = 7'b1100011;
        testCode[35] = 7'b1100011;
        testCode[36] = 7'b1100111;
        testCode[37] = 7'b1101111;
        testCode[38] = 7'b1110011;
        testCode[39] = 7'b1110011;

        types[0]  = "I";
        types[1]  = "I";
        types[2]  = "I";
        types[3]  = "I";
        types[4]  = "I";
        types[5]  = "I";
        types[6]  = "I";
        types[7]  = "I";
        types[8]  = "I";
        types[9]  = "I";
        types[10] = "I";
        types[11] = "I";
        types[12] = "I";
        types[13] = "I";
        types[14] = "I";
        types[15] = "U";
        types[16] = "S";
        types[17] = "S";
        types[18] = "S";
        types[19] = "R";
        types[20] = "R";
        types[21] = "R";
        types[22] = "R";
        types[23] = "R";
        types[24] = "R";
        types[25] = "R";
        types[26] = "R";
        types[27] = "R";
        types[28] = "R";
        types[29] = "U";
        types[30] = "B";
        types[31] = "B";
        types[32] = "B";
        types[33] = "B";
        types[34] = "B";
        types[35] = "B";
        types[36] = "I";
        types[37] = "J";
        types[38] = "I";
        types[39] = "I";

        for(i = 0; i < 40; i = i + 1) begin
            instruction[6:0] = testCode[i];
            #1 $display("%b (%s): S=%b, U=%b, R=%b, B=%b, J=%b, I=%b", opcode, types[i], S, U, R, B, J, I);
            #1;
        end
    end

endmodule