`define ZERO 0
`define SP   2

module RegisterFile
#(
    parameter XLEN = 32,
    parameter RLEN = 32
)
(
    input clk,
    input write_rd,
    input[4:0] rd, rs1, rs2,
    input[XLEN-1:0] rd_val,
    output[XLEN-1:0] rs1_val, rs2_val
);

    reg[XLEN-1:0] data[RLEN-1:0];

    initial begin 
        data[`ZERO] = 0;
        data[`SP]   = 32'hfffffffc;
    end

    // Continuous read from source registers:
    assign rs1_val = data[rs1];
    assign rs2_val = data[rs2];

    // Synchronous write to desitination register:
    always @(posedge clk)
        if(write_rd && rd != 0)
            data[rd] = rd_val;

endmodule