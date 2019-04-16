include steps.v;

module ENCRYPT_ROUND#(
    parameter LAST = 0,
    parameter ROUND = 0
)(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    input wire [127:0] key,
    input wire [2047:0] sbox,
    output wire [127:0] out,
    output wire validOut
);
    wire subBytesValidOut;
    wire [127:0] subBytesOut;
    wire shiftRowsValidOut;
    wire [127:0] shiftRowsOut;
    wire mixColumnsValidOut;
    wire [127:0] mixColumnsOut;
    SUB_BYTES sb (
        .clk(clk),
        .validIn(validIn),
        .in(in),
        .sbox(sbox),
        .out(subBytesOut),
        .validOut(subBytesValidOut)
    );
    SHIFT_ROWS sr (
        .clk(clk),
        .validIn(subBytesValidOut),
        .in(subBytesOut),
        .out(shiftRowsOut),
        .validOut(shiftRowsValidOut)
    );
    if (LAST == 1) begin
        assign mixColumnsOut = shiftRowsOut;
        assign mixColumnsValidOut = shiftRowsValidOut;
    end else begin
        MIX_COLUMNS mc (
            .clk(clk),
            .validIn(shiftRowsValidOut),
            .in(shiftRowsOut),
            .out(mixColumnsOut),
            .validOut(mixColumnsValidOut)
        );
    end
    ADD_ROUND_KEY ark (
        .clk(clk),
        .validIn(mixColumnsValidOut),
        .in(mixColumnsOut),
        .key(key),
        .out(out),
        .validOut(validOut)
    );
endmodule

module DECRYPT_ROUND#(
    parameter LAST = 0,
    parameter ROUND = 0
)(
    input wire clk,
    input wire validIn,
    input wire [127:0] in,
    input wire [2047:0] mul9,
    input wire [2047:0] mul11,
    input wire [2047:0] mul13,
    input wire [2047:0] mul14,
    input wire [127:0] key,
    input wire [2047:0] inv_sbox,
    output wire [127:0] out,
    output wire validOut
);
    wire subBytesValidOut;
    wire [127:0] subBytesOut;
    wire shiftRowsValidOut;
    wire [127:0] shiftRowsOut;
    wire addRoundKeyValidOut;
    wire [127:0] addRoundKeyOut;
    INV_SHIFT_ROWS sr (
        .clk(clk),
        .validIn(validIn),
        .in(in),
        .out(shiftRowsOut),
        .validOut(shiftRowsValidOut)
    );
    INV_SUB_BYTES sb (
        .clk(clk),
        .validIn(shiftRowsValidOut),
        .in(shiftRowsOut),
        .inv_sbox(inv_sbox),
        .out(subBytesOut),
        .validOut(subBytesValidOut)
    );
    ADD_ROUND_KEY ark (
        .clk(clk),
        .validIn(subBytesValidOut),
        .in(subBytesOut),
        .key(key),
        .out(addRoundKeyOut),
        .validOut(addRoundKeyValidOut)
    );
    if (LAST == 1) begin
        assign out = addRoundKeyOut;
        assign validOut = addRoundKeyValidOut;
    end else begin
        INV_MIX_COLUMNS mc (
            .clk(clk),
            .validIn(addRoundKeyValidOut),
            .in(addRoundKeyOut),
            .mul9(mul9),
            .mul11(mul11),
            .mul13(mul13),
            .mul14(mul14),
            .out(out),
            .validOut(validOut)
        );
    end
endmodule

module ENCRYPT#(
    parameter NROUNDS = 10
) (
    input wire [127:0] in,
    output wire [127:0] out,
    input wire [127:0] key,
    input wire clk,
    input wire [2047:0] sbox,
    input wire [119:0] rcon,
    input wire validIn,
    output wire validOut
);
    wire [128*NROUNDS-1:0] roundKeys;
    wire ekValidOut;
    EXPAND_KEY#(
        .NROUNDS(NROUNDS)
    ) ek (
        .clk(clk),
        .validIn(validIn),
        .in(key),
        .sbox(sbox),
        .rcon(rcon),
        .validOut(ekValidOut),
        .out(roundKeys)
    );

    wire [127:0] ark1Out;
    wire ark1ValidOut;
    ADD_ROUND_KEY ark1 (
        .clk(clk),
        .validIn(ekValidOut),
        .in(in),
        .key(key),
        .out(ark1Out),
        .validOut(ark1ValidOut)
    );
    genvar i;
    for (i = 0; i < NROUNDS; i = i + 1) begin : ROUNDS_LOOP
        wire prevValid;
        wire [127:0] roundKey;
        wire [127:0] prevOut;
        wire [127:0] outKey;
        wire [127:0] outI;
        wire validOutI;
        if (i == 0) begin
            assign prevValid = ark1ValidOut;
            assign prevOut = ark1Out;
        end else begin
            assign prevValid = ROUNDS_LOOP[i-1].validOutI;
            assign prevOut = ROUNDS_LOOP[i-1].outI;
        end
        assign roundKey = roundKeys[128*(NROUNDS-i)-1:128*(NROUNDS-i-1)];

        ENCRYPT_ROUND#(
            .LAST(i==NROUNDS-1),
            .ROUND(i)
        ) round (
            .clk(clk),
            .validIn(prevValid),
            .in(prevOut),
            .key(roundKey),
            .sbox(sbox),
            .out(outI),
            .validOut(validOutI)
        );
    end
    assign out = ROUNDS_LOOP[NROUNDS-1].outI;
    assign validOut = ROUNDS_LOOP[NROUNDS-1].validOutI;
endmodule

module DECRYPT#(
    parameter NROUNDS = 10
) (
    input wire clk,
    input wire [127:0] in,
    input wire [127:0] key,
    input wire [2047:0] mul9,
    input wire [2047:0] mul11,
    input wire [2047:0] mul13,
    input wire [2047:0] mul14,
    input wire [2047:0] inv_sbox,
    input wire [2047:0] sbox,
    input wire [119:0] rcon,
    input wire validIn,
    output wire [127:0] out,
    output wire validOut
);
    wire [128*NROUNDS:0] roundKeys;
    wire ekValidOut;
    EXPAND_KEY#(
        .NROUNDS(NROUNDS)
    ) ek (
        .clk(clk),
        .validIn(validIn),
        .in(key),
        .sbox(sbox),
        .rcon(rcon),
        .validOut(ekValidOut),
        .out(roundKeys)
    );

    wire [127:0] ark1Out;
    wire ark1ValidOut;
    ADD_ROUND_KEY ark1 (
        .clk(clk),
        .validIn(ekValidOut),
        .in(in),
        .key(roundKeys[127:0]),
        .out(ark1Out),
        .validOut(ark1ValidOut)
    );
    genvar i;
    for (i = 0; i < NROUNDS; i = i + 1) begin : ROUNDS_LOOP
        wire [127:0] roundKey;
        wire prevValid;
        wire [127:0] prevOut;
        wire [127:0] outKey;
        wire [127:0] outI;
        wire validOutI;
        if (i == 0) begin
            assign prevValid = ark1ValidOut;
            assign prevOut = ark1Out;
        end else begin
            assign prevValid = ROUNDS_LOOP[i-1].validOutI;
            assign prevOut = ROUNDS_LOOP[i-1].outI;
        end
        if (i == NROUNDS-1) begin
            assign roundKey = key;
        end else begin
            assign roundKey = roundKeys[128*(i+2)-1:128*(i+1)];
        end
        DECRYPT_ROUND#(
            .LAST(i==NROUNDS-1),
            .ROUND(i)
        ) round (
            .clk(clk),
            .validIn(prevValid),
            .in(prevOut),
            .key(roundKey),
            .mul9(mul9),
            .mul11(mul11),
            .mul13(mul13),
            .mul14(mul14),
            .inv_sbox(inv_sbox),
            .out(outI),
            .validOut(validOutI)
        );
    end
    assign out = ROUNDS_LOOP[NROUNDS-1].outI;
    assign validOut = ROUNDS_LOOP[NROUNDS-1].validOutI;
endmodule
