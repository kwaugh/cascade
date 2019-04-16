include rounds.v;
include common_tables.v;


// Time out after 255 cycles
reg [7:0] count = 0;
wire [127:0] in;
wire [127:0] key;
assign in = {8'h0,8'h1,8'h2,8'h3,8'h4,8'h5,8'h6,8'h7,8'h8,8'h9,8'ha,8'hb,8'hc,8'hd,8'he,8'hf};
assign key = {8'h0,8'h4,8'h8,8'hc,8'h1,8'h5,8'h9,8'hd,8'h2,8'h6,8'ha,8'he,8'h3,8'h7,8'hb,8'hf};
wire [127:0] out;
wire done;
reg [3:0] raddr1;
reg [3:0] raddr2;
reg [7:0] rdata1;
reg [7:0] rdata2;
/*
(* __file="/tmp/init.mem"*)
Memory mem(
    .clock(clock.val),
    .raddr1(raddr1),
    .rdata1(rdata1),
    .raddr2(raddr2),
    .rdata2(rdata2)
);
*/
initial begin
    count <= 0;
end

// read the memory into sbox two bytes at a time: raddr1 and raddr2 are set to
// the addresses of the first and second half of the memory to be read
// respectively
// these formulas are silly because in verilog the most significant bit has
// the highest index
//genvar i;
//for (i = 0; i < 128; i = i + 1) begin
//    always @(posedge clock.val) begin
//        if (memcount == i) begin
//            raddr1 = i;
//            sbox[(256-i)*8-1:(255-i)*8] = rdata1;
//            raddr2 = i + 128;
//            sbox[(128-i)*8-1:(127-i)*8] = rdata2;
//            memcount = memcount + 1;
//        end
//    end
//end

/*
MIX_COLUMNS mc(
    .clk(clock.val),
    .validIn(1),
    .in(in),
    .out(out),
    .validOut(done)
);
*/

reg [3:0] round = 1;
ENCRYPT #(
    .NROUNDS(10)
) encrypt(
    .clk(clock.val),
    .validIn(1),
    .in(in),
    .key(key),
    .out(out),
    .validOut(done),
    .sbox(sbox),
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
