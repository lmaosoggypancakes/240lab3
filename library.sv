module Decoder
    (input logic en,
     input logic [2:0] I,
     output logic [7:0] D);

    always_comb begin
        if (en == 1'b0)
            assign D = 7'd0;
        else
            unique casez (I)
                3'b0: D = 8'b00000001;
                3'b01: D = 8'b00000010;
                3'b10: D = 8'b00000100;
                3'b11: D = 8'b00001000;
                3'b100: D = 8'b00010000;
                3'b101: D = 8'b00100000;
                3'b110: D = 8'b01000000;
                3'b111: D = 8'b10000000;
                default: D = 0;
            endcase
    end
endmodule: Decoder

module BarrelShifter
    (input logic [15:0] V,
     input logic [3:0] by,
     output logic [15:0] S);

    assign S = V << by;

endmodule: BarrelShifter


module Multiplexer
    (input logic [7:0] I,
     input logic [2:0] S,
     output logic Y);

    always_comb begin
        unique casez (S)
            3'd0: Y = I[0];
            3'd1: Y = I[1];
            3'd2: Y = I[2];
            3'd3: Y = I[3];
            3'd4: Y = I[4];
            3'd5: Y = I[5];
            3'd6: Y = I[6];
            3'd7: Y = I[7];
        endcase
    end
 endmodule: Multiplexer

 module Mux2to1
    (input logic [6:0] I0,
     input logic [6:0] I1,
     input logic S,
     output logic [6:0] Y);

    always_comb begin
        if (S == 1'b0)
            Y = I0;
        else
            Y = I1;
    end
 endmodule: Mux2to1

 module MagComparator
    (input logic [7:0] A,
     input logic [7:0] B,
     output logic AltB,
     output logic AeqB,
     output logic AgtB);

    always_comb begin
        if (A == B) begin
            AltB = 0;
            AeqB = 1;
            AgtB = 0;
        end
        else if (A > B) begin
            AltB = 0;
            AeqB = 0;
            AgtB = 1;
        end
        else begin
            AltB = 1;
            AeqB = 0;
            AgtB = 0;
        end
    end
 endmodule: MagComparator

 module Comparator
    (input logic [3:0] A,
     input logic [3:0] B,
     output logic AeqB);

    assign AeqB = (A == B) ? 1 : 0;

 endmodule: Comparator

module PriorityEncoder
    (output logic [2:0] Y,
     output logic       valid,
     input logic [7:0] A);


    always_comb begin
        casez (A)
            8'b0000_0000: begin
                          valid = 0;
                          Y = 3'b000;
                          end
            8'b1???_????: begin
                          valid = 1;
                          Y = 3'b111;
                          end
            8'b01??_????: begin
                          valid = 1;
                          Y = 3'b110;
                          end
            8'b001?_????: begin
                          valid = 1;
                          Y = 3'b101;
                          end
            8'b0001_????: begin
                          valid = 1;
                          Y = 3'b100;
                          end
            8'b0000_1???: begin
                          valid = 1;
                          Y = 3'b011;
                          end
            8'b0000_01??: begin
                          valid = 1;
                          Y = 3'b010;
                          end
            8'b0000_001?: begin
                          valid = 1;
                          Y = 3'b001;
                          end
            8'b0000_0001: begin
                          valid = 1;
                          Y = 3'b000;
                          end
        endcase
    end
endmodule: PriorityEncoder

module Adder
    (input logic cin,
     input logic [4:0] A,
     input logic [4:0] B,
     output logic cout,
     output logic [4:0] sum);

    logic [5:0] s;
 always_comb begin
    s = A + B + cin;
    cout = s[5];
    sum[0] = s[0];
    sum[1] = s[1];
    sum[2] = s[2];
    sum[3] = s[3];
    sum[4] = s[4];
 end
endmodule: Adder

module Comparator
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] A,
     input logic [WIDTH-1:0] B,
     output logic AeqB);

    assign AeqB = A == B;

endmodule: Comparator

module MagComp
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] A,
     input logic [WIDTH-1:0] B,
     output logic AltB,
                  AeqB,
                  AgtB);

    assign AltB = A < B;
    assign AeqB = A == B;
    assign AgtB = A > B;

endmodule: MagComp

module Adder
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] A, B,
     input logic cin,
     output logic cout,
     output logic [WIDTH-1:0] sum);

    logic [WIDTH:0] s;
    assign s = A + B + cin;
    assign cout = s[WIDTH];
    assign sum = s[WIDTH-1:0];

endmodule: Adder

module Subtracter
    #(parameter WIDTH = 8)
    (input logic bin,
     input logic [WIDTH-1:0] A, B,
     output logic bout,
     output logic [WIDTH-1:0] diff);

    // todo: figure out what bin and bout are
endmodule: Subtracter

module DFlipFlop
    (input logic preset_L, D, clock, reset_L,
     output logic Q);

    always_ff @(posedge clock, negedge reset_L, negedge preset_L) begin
        if (~preset_L)
            Q <= 1;
        else if (~reset_L)
            Q <= 0;
        else
            Q <= D;
    end

endmodule: DFlipFlop

module Register
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] D,
     input logic en, clear, clock,
     output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock, negedge reset_L)
        if (~reset_L)
            Q <= '0;
        else
            Q <= D;

endmodule: Register


module Counter
    #(parameter WIDTH = 8)
    (input logic en, clear, load, up, clock,
     input logic [WIDTH-1:0] D,
     output logic [WIDTH-1:0] Q);


endmodule: Counter

