module ROTWORD(
    input wire clk,
    input wire [31:0] in,
    output reg [31:0] out
);
    always @(posedge clk) begin
        out[31:24] <= in[23:16];
        out[23:16] <= in[15:8];
        out[15:8] <= in[7:0];
        out[7:0] <= in[31:24];
    end
endmodule

module SUB_BYTES#(
    parameter NBYTES = 16
)(
    input wire clk,
    input wire validIn,
    input wire [NBYTES*8-1:0] in,
    input wire [2047:0] sbox,
    output reg [NBYTES*8-1:0] out,
    output reg validOut
);
    
    genvar i;
    genvar j;
    for (j = 0; j < 256; j = j + 1) begin : OUTERLOOP
        wire [7:0] sboxvalue;
        assign sboxvalue = sbox[(j+1)*8-1:j*8];
        for (i = 0; i < NBYTES; i = i + 1) begin : LOOP
            wire [7:0] index;
            assign index = 255-in[(i+1)*8-1:i*8];
            always @(posedge clk) begin
                if (index == j) begin
                    out[(i+1)*8-1:i*8] <= sboxvalue;
                end
            end
        end
    end
    always @(posedge clk) begin
        validOut <= validIn;
    end
endmodule

module INV_SUB_BYTES#(
    parameter NBYTES = 16
)(
    input wire clk,
    input wire validIn,
    input wire [NBYTES*8-1:0] in,
    input wire [2047:0] inv_sbox,
    output reg [NBYTES*8-1:0] out,
    output reg validOut
);
    
    genvar i;
    genvar j;
    for (j = 0; j < 256; j = j + 1) begin : OUTERLOOP
        wire [7:0] sboxvalue;
        assign sboxvalue = inv_sbox[(j+1)*8-1:j*8];
        for (i = 0; i < NBYTES; i = i + 1) begin : LOOP
            wire [7:0] index;
            assign index = 255-in[(i+1)*8-1:i*8];
            always @(posedge clk) begin
                if (index == j) begin
                    out[(i+1)*8-1:i*8] <= sboxvalue;
                end
            end
        end
    end
    always @(posedge clk) begin
        validOut <= validIn;
    end
endmodule

/*
module SUB_BYTES_MEM(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    input reg [3:0] sboxraddr1,
    input reg [3:0] sboxraddr2,
    input reg [7:0] sboxrdata1,
    input reg [7:0] sboxrdata2,
    output reg [127:0] out,
    output wire validOut
);
    reg [7:0] memcount;
    initial begin
        memcount <= 0;
    end
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin : LOOP
        always @(posedge clk) begin
            // on the first cycle, put the address into raddr
            if (validIn && i < 8 && memcount == i) begin
                sboxraddr1 <= in[127-i*8:120-i*8];
                sboxraddr2 <= in[63-i*8:56-i*8];
                memcount <= memcount + 1;
            end
            // on the next cycle, get the data from rdata
            if (validIn && memcount == i+1) begin
                out[127-i*8:120-i*8] <= sboxrdata1;
                out[63-i*8:56-i*8] <= sboxrdata2;
            end
        end
    end 
    assign validOut = (memcount == 8);
endmodule
*/

module SHIFT_ROWS(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    output wire [127:0] out,
    output reg validOut
);
    // turn the input and output into arrays of bytes
    // (inputs to modules can only have one dimension)
    wire [7:0] in2d [15:0];
    reg [7:0] out2d [15:0];
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin
        assign in2d[i] = in[(i+1)*8-1:i*8];
        assign out[(i+1)*8-1:i*8] = out2d[i];
    end
    // do the shift
    // the first row gets shifted by 0, second row by 1, third by 2 and fourth
    // by 3
    // the matrix is in column-major form
    always @(posedge clk) begin
        out2d[15] <= in2d[15];
        out2d[14] <= in2d[10];
        out2d[13] <= in2d[5];
        out2d[12] <= in2d[0];
        out2d[11] <= in2d[11];
        out2d[10] <= in2d[6];
        out2d[9] <= in2d[1];
        out2d[8] <= in2d[12];
        out2d[7] <= in2d[7];
        out2d[6] <= in2d[2];
        out2d[5] <= in2d[13];
        out2d[4] <= in2d[8];
        out2d[3] <= in2d[3];
        out2d[2] <= in2d[14];
        out2d[1] <= in2d[9];
        out2d[0] <= in2d[4];
        validOut <= validIn;
    end
endmodule

module INV_SHIFT_ROWS(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    output wire [127:0] out,
    output reg validOut
);
    // turn the input and output into arrays of bytes
    // (inputs to modules can only have one dimension)
    wire [7:0] in2d [15:0];
    reg [7:0] out2d [15:0];
    genvar i;
    for (i = 0; i < 16; i = i + 1) begin
        assign in2d[i] = in[(i+1)*8-1:i*8];
        assign out[(i+1)*8-1:i*8] = out2d[i];
    end
    // do the reverse shift (left shift)
    // the first row gets shifted by 0, second row by 1, third by 2 and fourth
    // by 3
    // the matrix is in column-major form
    always @(posedge clk) begin
        out2d[15] <= in2d[15];
        out2d[14] <= in2d[2];
        out2d[13] <= in2d[5];
        out2d[12] <= in2d[8];
        out2d[11] <= in2d[11];
        out2d[10] <= in2d[14];
        out2d[9] <= in2d[1];
        out2d[8] <= in2d[4];
        out2d[7] <= in2d[7];
        out2d[6] <= in2d[10];
        out2d[5] <= in2d[13];
        out2d[4] <= in2d[0];
        out2d[3] <= in2d[3];
        out2d[2] <= in2d[6];
        out2d[1] <= in2d[9];
        out2d[0] <= in2d[12];
        validOut <= validIn;
    end
endmodule

module ADD_ROUND_KEY(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    input wire [127:0] key,
    output reg [127:0] out,
    output reg validOut
);
    always @(posedge clk) begin
        out <= in ^ key;
        validOut <= validIn;
    end
endmodule

module MIX_COLUMNS(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    output wire [127:0] out,
    output reg validOut
);
    // assign the input and output to matrices of bytes
    // (inputs to modules can only have one dimension)
    wire [7:0] in3d [3:0][3:0];
    reg [7:0] out3d [3:0][3:0];
    genvar i1;
    genvar i2;
    for (i1 = 0; i1 < 4; i1 = i1 + 1) begin
        for (i2 = 0; i2 < 4; i2 = i2 + 1) begin
            assign in3d[i1][i2] = in[(i1*4+i2+1)*8-1:(i1*4+i2)*8];
            assign out[(i1*4+i2+1)*8-1:(i1*4+i2)*8] = out3d[i1][i2];
        end
    end
    // do the mix columns operation
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin : LOOP
        wire [7:0] xors;
        wire [7:0] t0, t1, t2, t3;
        assign xors = in3d[i][3] ^ in3d[i][2] ^ in3d[i][1] ^ in3d[i][0];
        assign t0 = in3d[i][3] ^ in3d[i][2];
        assign t1 = in3d[i][2] ^ in3d[i][1];
        assign t2 = in3d[i][1] ^ in3d[i][0];
        assign t3 = in3d[i][0] ^ in3d[i][3];
        always @(posedge clk) begin
            out3d[i][3] <= in3d[i][3] ^ (t0 << 1) ^ (((t0 >> 7) & 8'h1) * 8'h1b) ^ xors;
            out3d[i][2] <= in3d[i][2] ^ (t1 << 1) ^ (((t1 >> 7) & 8'h1) * 8'h1b) ^ xors;
            out3d[i][1] <= in3d[i][1] ^ (t2 << 1) ^ (((t2 >> 7) & 8'h1) * 8'h1b) ^ xors;
            out3d[i][0] <= in3d[i][0] ^ (t3 << 1) ^ (((t3 >> 7) & 8'h1) * 8'h1b) ^ xors;
            validOut <= validIn;
        end
    end
endmodule

module INV_MIX_COLUMNS(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    input wire [2047:0] mul9,
    input wire [2047:0] mul11,
    input wire [2047:0] mul13,
    input wire [2047:0] mul14,
    output wire [127:0] out,
    output reg validOut
);
    // assign the input and output to matrices of bytes
    // (inputs to modules can only have one dimension)
    wire [7:0] in3d [3:0][3:0];
    reg [7:0] out3d [3:0][3:0];
    genvar i1;
    genvar i2;
    for (i1 = 0; i1 < 4; i1 = i1 + 1) begin
        for (i2 = 0; i2 < 4; i2 = i2 + 1) begin
            assign in3d[i1][i2] = in[(i1*4+i2+1)*8-1:(i1*4+i2)*8];
            assign out[(i1*4+i2+1)*8-1:(i1*4+i2)*8] = out3d[i1][i2];
        end
    end
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin : LOOP
        wire [11:0] i3;
        wire [11:0] i2;
        wire [11:0] i1;
        wire [11:0] i0;
        assign i3 = (256-in3d[i][3])*8-1;
        assign i2 = (256-in3d[i][2])*8-1;
        assign i1 = (256-in3d[i][1])*8-1;
        assign i0 = (256-in3d[i][0])*8-1;
        always @(posedge clk) begin

            out3d[i][3] <= {
                mul14[i3]^mul11[i2]^mul13[i1]^mul9[i0],
                mul14[i3-1]^mul11[i2-1]^mul13[i1-1]^mul9[i0-1],
                mul14[i3-2]^mul11[i2-2]^mul13[i1-2]^mul9[i0-2],
                mul14[i3-3]^mul11[i2-3]^mul13[i1-3]^mul9[i0-3],
                mul14[i3-4]^mul11[i2-4]^mul13[i1-4]^mul9[i0-4],
                mul14[i3-5]^mul11[i2-5]^mul13[i1-5]^mul9[i0-5],
                mul14[i3-6]^mul11[i2-6]^mul13[i1-6]^mul9[i0-6],
                mul14[i3-7]^mul11[i2-7]^mul13[i1-7]^mul9[i0-7]};
            out3d[i][2] <= {
                mul9[i3]^mul14[i2]^mul11[i1]^mul13[i0],
                mul9[i3-1]^mul14[i2-1]^mul11[i1-1]^mul13[i0-1],
                mul9[i3-2]^mul14[i2-2]^mul11[i1-2]^mul13[i0-2],
                mul9[i3-3]^mul14[i2-3]^mul11[i1-3]^mul13[i0-3],
                mul9[i3-4]^mul14[i2-4]^mul11[i1-4]^mul13[i0-4],
                mul9[i3-5]^mul14[i2-5]^mul11[i1-5]^mul13[i0-5],
                mul9[i3-6]^mul14[i2-6]^mul11[i1-6]^mul13[i0-6],
                mul9[i3-7]^mul14[i2-7]^mul11[i1-7]^mul13[i0-7]};
            out3d[i][1] <= {
                mul13[i3]^mul9[i2]^mul14[i1]^mul11[i0],
                mul13[i3-1]^mul9[i2-1]^mul14[i1-1]^mul11[i0-1],
                mul13[i3-2]^mul9[i2-2]^mul14[i1-2]^mul11[i0-2],
                mul13[i3-3]^mul9[i2-3]^mul14[i1-3]^mul11[i0-3],
                mul13[i3-4]^mul9[i2-4]^mul14[i1-4]^mul11[i0-4],
                mul13[i3-5]^mul9[i2-5]^mul14[i1-5]^mul11[i0-5],
                mul13[i3-6]^mul9[i2-6]^mul14[i1-6]^mul11[i0-6],
                mul13[i3-7]^mul9[i2-7]^mul14[i1-7]^mul11[i0-7]};
            out3d[i][0] <= {
                mul11[i3]^mul13[i2]^mul9[i1]^mul14[i0],
                mul11[i3-1]^mul13[i2-1]^mul9[i1-1]^mul14[i0-1],
                mul11[i3-2]^mul13[i2-2]^mul9[i1-2]^mul14[i0-2],
                mul11[i3-3]^mul13[i2-3]^mul9[i1-3]^mul14[i0-3],
                mul11[i3-4]^mul13[i2-4]^mul9[i1-4]^mul14[i0-4],
                mul11[i3-5]^mul13[i2-5]^mul9[i1-5]^mul14[i0-5],
                mul11[i3-6]^mul13[i2-6]^mul9[i1-6]^mul14[i0-6],
                mul11[i3-7]^mul13[i2-7]^mul9[i1-7]^mul14[i0-7]};
            validOut <= validIn;

        end
    end
endmodule

module EXPAND_KEY#(
    parameter NROUNDS = 10
)(
    input wire clk,
    input wire validIn,
    input wire [127:0] in, // prev key
    input wire [2047:0] sbox,
    input wire [119:0] rcon, // size is 15B * 8B/b
    output wire [128*NROUNDS-1:0] out,
    output reg validOut = 0
);
    reg [31:0] count = 0;
    always @(posedge clk) begin
        // update count
        if (validIn) begin 
            count <= (count + 1);
        end
        validOut <= (count == NROUNDS-1);
    end
    genvar i;
    for (i = 0; i < NROUNDS; i = i + 1) begin : ROUNDS
        wire [31:0] tempRot;
        wire [31:0] tempSub;
        wire [127:0] inI;
        reg [127:0] outI;
        assign out[128*(NROUNDS-i)-1:128*(NROUNDS-i-1)] = outI;
        if (i == 0) begin
            assign inI = in;
        end else begin
            assign inI = ROUNDS[i-1].outI;
        end
        ROTWORD rw(
            .clk(clk),
            .in(inI[31:0]),
            .out(tempRot)
        );
        SUB_BYTES#(
            .NBYTES(4)
        ) sw(
            .clk(clk),
            .in(tempRot),
            .sbox(sbox),
            .out(tempSub)
        );
        always @(posedge clk) begin
            outI[127:120] <= inI[127:120] ^ tempSub[31:24] ^ rcon[120-(i+1)*8-1:120-(i+1)*8-8];
            outI[119:96] <= inI[119:96] ^ tempSub[23:0];
        end
        // go through each wordk
        genvar k;
        for (k = 1; k < 4; k = k + 1) begin : LOOP
            always @(posedge clk) begin
                // current word = w[i - Nk] (first row from prevKey)  XOR temp
                outI[128-32*k-1:128-32*(k+1)] <= inI[128-32*k-1:128-32*(k+1)] ^ outI[128-32*(k-1)-1:128-32*k];
            end 
        end
    end
endmodule
