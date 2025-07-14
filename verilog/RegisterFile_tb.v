`include "RegisterFile.v"

module RegisterFile_tb;

    reg clk;
    reg write_rd;
    reg[4:0] rs1, rs2, rd;
    reg[31:0] rd_val;
    wire[31:0] rs1_val, rs2_val;

    RegisterFile rf(clk, write_rd, rd, rs1, rs2, rd_val, rs1_val, rs2_val);

    wire[31:0] d;

    assign d = rf.data[rd];

    initial begin

        clk = 0;
      
        $monitor("RF[%h, %h] => [%h, %h]; RF[%h] = %h", rs1, rs2, rs1_val, rs2_val, rd, d);

        rd = 7;
        rd_val = 32'h123abc01;
        write_rd = 1;
        #1 clk = 1;
        #1 write_rd = 0;

        #1 
        rs1 = 7;
        rs2 = 7;

        #1 rd = 3;
        rd_val = 'hcdefbc0;
        clk = 0;
        #1 clk = 1;

        #1 write_rd = 1;
        #1 clk = 0;
        #1 clk = 1;
    end

endmodule