/**
    RISC-V Immediate Construction:

        31	30	29	28	27	26	25	24	23	22	21	20	19	18	17	16	15	14	13	12	11	10	9	8	7	6	5	4	3	2	1	0
        ------------------------------------------------------------------------------------------------------------------------------
    I |	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	30	29	28	27	26	25	24	23	22	21	20
    S |	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	30	29	28	27	26	25	11	10	9	8	7
    U |	31	30	29	28	27	26	25	24	23	22	21	20	19	18	17	16	15	14	13	12	0	0	0	0	0	0	0	0	0	0	0	0
                                                                                                                                    
    B |	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	31	7	30	29	28	27	26	25	11	10	9	8	0
    J |	31	31	31	31	31	31	31	31	31	31	31	31	19	18	17	16	15	14	13	12	20	30	29	28	27	26	25	24	23	22	21	0
 */

module ImmediateDecoder
#(
    parameter XLEN = 32
)
(
    input[31:0] instruction,
    output[XLEN-1:0] immediate
);
    wire[6:0] opcode;
    wire u, j, b, s;

    assign opcode = instruction[6:0];

    assign u = opcode == 7'b0010111 || opcode == 7'b0110111;
    assign j = opcode == 7'b1101111;
    assign b = opcode == 7'b1100011;
    assign s = opcode == 7'b0100011;

    assign immediate[XLEN-1:31] = instruction[31];
    assign immediate[30:20]     = u      ? instruction[30:20] : {(11){instruction[31]}};
    assign immediate[19:12]     = u || j ? instruction[19:12] : {(8){instruction[31]}};
    assign immediate[11]        = b      ? instruction[7]     :
                                  j      ? instruction[20]    :
                                  u      ? 1'b0               : instruction[31];
    assign immediate[10:5]      = u      ? 6'b000000          : instruction[30:25];
    assign immediate[4:1]       = u      ? 4'b0000            :
                                  s || b ? instruction[11:8]  : instruction[24:21];
    assign immediate[0]         = s      ? instruction[7]     :
                                  b || j || u ? 1'b0          : instruction[20];

endmodule