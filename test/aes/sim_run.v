include rounds.v;
include decrypt_tables.v;
include common_tables.v;

module RUN_ENCRYPT#(
    parameter INPUT_SIZE = 16 // in bytes
) (
    input wire clk
);

reg [INPUT_SIZE+1:0] count = 0;
always @(posedge clk) begin
    count <= count + 1;
end

// hardcode the key because it doesn't matter for our purposes
wire [127:0] key;
assign key = {8'h0,8'h4,8'h8,8'hc,8'h1,8'h5,8'h9,8'hd,8'h2,8'h6,8'ha,8'he,8'h3,8'h7,8'hb,8'hf};

reg [INPUT_SIZE*8-1:0] plaintext;
reg [INPUT_SIZE*8-1:0] ciphertext;

// read the input into a register
wire [7:0] rdata;
(*__file="input.mem", __count=1*)
Fifo#(16,8) fifo (
    .clock(clock.val),
    .rreq(count < INPUT_SIZE),
    .wreq(0),
    .rdata(rdata)
); 
wire [31:0] index;
assign index = ((INPUT_SIZE-count)%INPUT_SIZE)*8;
always @(posedge clk) begin
    if (count > 0 && count <= INPUT_SIZE) begin
        // assign bit-by-bit to get around non-static array indices error
        plaintext[index+7] <= rdata[7];
        plaintext[index+6] <= rdata[6];
        plaintext[index+5] <= rdata[5];
        plaintext[index+4] <= rdata[4];
        plaintext[index+3] <= rdata[3];
        plaintext[index+2] <= rdata[2];
        plaintext[index+1] <= rdata[1];
        plaintext[index] <= rdata[0];
    end
end

reg signed [31:0] currentInputBlockIndex = (INPUT_SIZE-16)*8;
reg signed [32:0] currentOutputBlockIndex = (INPUT_SIZE-16)*8;
wire [127:0] currentInputBlock;
wire [127:0] currentOutputBlock;
genvar i;
for (i = 0; i < 128; i = i + 1) begin
    assign currentInputBlock[i] = plaintext[currentInputBlockIndex+i];
    always @(posedge clk) begin
        ciphertext[currentOutputBlockIndex+i] <= currentOutputBlock[i];
    end
end
wire blockEncrypted;
ENCRYPT#(
    .NROUNDS(10)
) encrypt (
    .clk(clk),
    .validIn(count > INPUT_SIZE),
    .in(currentInputBlock),
    .key(key),
    .out(currentOutputBlock),
    .validOut(blockEncrypted),
    .sbox(sbox),
    .rcon(rcon)
);

always @(posedge clk) begin
    if (count==INPUT_SIZE+1) begin 
    end
    if (count > INPUT_SIZE && currentInputBlockIndex > 0) begin
        currentInputBlockIndex <= currentInputBlockIndex - 16*8;
        $display("input index: %d", currentInputBlockIndex);
    end
    if (count > INPUT_SIZE+39 && currentOutputBlockIndex > 0) begin
        currentOutputBlockIndex <= currentOutputBlockIndex - 16*8;
    end
end

// stop when time = [time to read the input] + [time to fill the pipeline]
// + [time to encrypt all the chunks]
wire done = count == INPUT_SIZE + 40 + INPUT_SIZE/16;
always @(posedge done) begin
    $display("encrypt cycles: %d", count - INPUT_SIZE);
    $finish(0);
end
endmodule

module RUN_DECRYPT#(
    parameter INPUT_SIZE = 16 // in bytes
) (
    input wire clk
);

reg [INPUT_SIZE+1:0] count = 0;
always @(posedge clk) begin
    count <= count + 1;
end

// hardcode the key because it doesn't matter for our purposes
wire [127:0] key;
assign key = {8'h0,8'h4,8'h8,8'hc,8'h1,8'h5,8'h9,8'hd,8'h2,8'h6,8'ha,8'he,8'h3,8'h7,8'hb,8'hf};

reg [INPUT_SIZE*8-1:0] ciphertext;
reg [INPUT_SIZE*8-1:0] plaintext;

// read the input into a register
wire [7:0] rdata;
(*__file="input.mem", __count=1*)
Fifo#(16,8) fifo (
    .clock(clock.val),
    .rreq(count < INPUT_SIZE),
    .wreq(0),
    .rdata(rdata)
); 
wire [31:0] index;
assign index = ((INPUT_SIZE-count)%INPUT_SIZE)*8;
always @(posedge clk) begin
    if (count > 0 && count <= INPUT_SIZE) begin
        // assign bit-by-bit to get around non-static array indices error
        ciphertext[index+7] <= rdata[7];
        ciphertext[index+6] <= rdata[6];
        ciphertext[index+5] <= rdata[5];
        ciphertext[index+4] <= rdata[4];
        ciphertext[index+3] <= rdata[3];
        ciphertext[index+2] <= rdata[2];
        ciphertext[index+1] <= rdata[1];
        ciphertext[index] <= rdata[0];
    end
end

reg signed [31:0] currentInputBlockIndex = (INPUT_SIZE-16)*8;
reg signed [32:0] currentOutputBlockIndex = (INPUT_SIZE-16)*8;
wire [127:0] currentInputBlock;
wire [127:0] currentOutputBlock;
genvar i;
for (i = 0; i < 128; i = i + 1) begin
    assign currentInputBlock[i] = ciphertext[currentInputBlockIndex+i];
    always @(posedge clk) begin
        plaintext[currentOutputBlockIndex+i] <= currentOutputBlock[i];
    end
end
wire blockEncrypted;
DECRYPT#(
    .NROUNDS(10)
) decrypt (
    .clk(clk),
    .validIn(count > INPUT_SIZE),
    .in(currentInputBlock),
    .key(key),
    .out(currentOutputBlock),
    .validOut(blockEncrypted),
    .sbox(sbox),
    .rcon(rcon)
);

always @(posedge clk) begin
    if (count==INPUT_SIZE+1) begin 
    end
    if (count > INPUT_SIZE && currentInputBlockIndex > 0) begin
        currentInputBlockIndex <= currentInputBlockIndex - 16*8;
        $display("input index: %d", currentInputBlockIndex);
    end
    if (count > INPUT_SIZE+39 && currentOutputBlockIndex > 0) begin
        currentOutputBlockIndex <= currentOutputBlockIndex - 16*8;
    end
end

// stop when time = [time to read the input] + [time to fill the pipeline]
// + [time to encrypt all the chunks]
wire done = count == INPUT_SIZE + 40 + INPUT_SIZE/16;
always @(posedge done) begin
    $display("decrypt cycles: %d", count - INPUT_SIZE);
    $display("count: %d", count);
    $finish(1);
end
endmodule
