`default_nettype none

module vga
    (input logic CLOCK_50, reset,
     output logic HS, VS, blank,
     output logic [9:0] row,
     output logic [9:0] col);

     logic v_sync_en, v_sync_clear, v_sync_load, v_sync_up;
     logic [31:0] v_sync_D, v_sync_Q;
     Counter #(10) c1(.en(v_sync_en), .clear(v_sync_clear),
                      .load(reset), .clock(CLOCK_50),
                      .D('0), .Q(v_sync_Q)); // counts an entire period of Ts for VS

     logic end_of_period;
     Comparator #(32) cp1(.A(v_sync_Q), .B(16'd833600), .AeqB(end_of_period));
     assign v_sync_en = ~end_of_period;

     logic v_in_pw;
     range_check #(32) r1(.low('0), .high(16'd3200), .val(v_sync_Q), .is_between(v_in_pw));
     assign VS = ~v_in_pw;

     logic v_ready_to_count;
     range_check #(32) r2(.low(16'd49600), .high(16'd817600), .val(v_sync_Q), .is_between(v_ready_to_count));

     logic clear_row;
     Counter #(10) c2(.en(v_ready_to_count), .clear(clear_row),
                      .loa(reset), .clock(CLOCK_50),
                      .D('0), .Q(row));

     logic v_empty_left;
     logic v_empty_right;
     logic v_empty;
     assign v_empty = v_empty_left | v_empty_right;
     range_check #(32) r3(.low('0), .high(16'd49600), .val(v_sync_Q), .is_between(v_empty_left));
     range_check #(32) r4(.low(16'd817600), .high(833600), .val(v_sync_Q), .is_between(v_empty_right));
     assign blank = v_empty;
     assign col = 1;

endmodule: vga

module vga_test;
    logic CLOCK_50, reset, HS, VS, blank;
    logic [9:0] row, col;

    vga v(.*);

    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        reset = 0;
        #500;
        reset = 1;
        #40000000 $finish;
    end

endmodule: vga_test

