include rounds.v;
include decrypt_tables.v;
include common_tables.v;


// Time out after 255 cycles
reg [8:0] count = 0;
wire [127:0] in;
wire [127:0] in1;
wire [127:0] in2;
wire [127:0] in3;
wire [127:0] rev_in;
wire [127:0] key;
assign in1 = {8'h0,8'h1,8'h2,8'h3,8'h4,8'h5,8'h6,8'h7,8'h8,8'h9,8'ha,8'hb,8'hc,8'hd,8'he,8'hf};
// this is just the output of mixcolumns for in (so that we can reverse and
// check that it matches)
assign in2 = {8'h63,8'h7c,8'h77,8'h7b,8'hf2,8'h6b,8'h6f,8'hc5,8'h30,8'h1,8'h67,8'h2b,8'hfe,8'hd7,8'hab,8'h76};
assign in3 = {8'h0,8'h5,8'ha,8'hf,8'h4,8'h9,8'he,8'h3,8'h8,8'hd,8'h2,8'h7,8'hc,8'h1,8'h6,8'hb};
assign rev_in = {8'h55,8'h2b,8'h5c,8'h77,8'h4f,8'h28,8'hd6,8'h75,8'h6,8'ha7,8'h5f,8'h21,8'h2d,8'he5,8'h2c,8'h2d};
assign key = {8'h0,8'h4,8'h8,8'hc,8'h1,8'h5,8'h9,8'hd,8'h2,8'h6,8'ha,8'he,8'h3,8'h7,8'hb,8'hf};
wire [127:0] out;
wire done;
reg [3:0] raddr1;
reg [3:0] raddr2;
reg [7:0] rdata1;
reg [7:0] rdata2;

initial begin
    count <= 0;
end

assign in = rev_in;
/*
INV_SHIFT_ROWS sb(
    .clk(clock.val),
    .validIn(1),
    .in(in),
    .out(out),
    .validOut(done)
);
*/

DECRYPT #(
    .NROUNDS(10)
) decrypt(
    .clk(clock.val),
    .validIn(1),
    .in(in),
    .key(key),
    .out(out),
    .validOut(done),
    .inv_sbox(inv_sbox),
    .sbox(sbox),
    .mul9(mul9),
    .mul11(mul11),
    .mul13(mul13),
    .mul14(mul14),
    .rcon(rcon)
);

always @(posedge clock.val) begin
    if (count == 0) begin
        $display("%h %h %h %h", in[127:120], in[119:112], in[111:104], in[103:96]);
        $display("%h %h %h %h", in[95:88], in[87:80], in[79:72], in[71:64]);
        $display("%h %h %h %h", in[63:56], in[55:48], in[47:40], in[39:32]);
        $display("%h %h %h %h", in[31:24], in[23:16], in[15:8], in[7:0]);
    end
    count <= (count + 1);
    if (done | (&count)) begin
        $display("count: %d", count);
        $display("%h %h %h %h", out[127:120], out[119:112], out[111:104], out[103:96]);
        $display("%h %h %h %h", out[95:88], out[87:80], out[79:72], out[71:64]);
        $display("%h %h %h %h", out[63:56], out[55:48], out[47:40], out[39:32]);
        $display("%h %h %h %h", out[31:24], out[23:16], out[15:8], out[7:0]);
        $finish(1);
    end
end
