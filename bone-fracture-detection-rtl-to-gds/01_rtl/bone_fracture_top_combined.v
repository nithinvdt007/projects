`timescale 1ns / 1ps
`default_nettype none

module top_level_final_decision #(
    parameter IMAGE_WIDTH  = 16,
    parameter PIXEL_WIDTH  = 8,
    parameter ADDR_WIDTH   = 8,
    parameter SCORE_WIDTH  = 16,
    parameter BRIGHTNESS_WIDTH = 24,
    parameter WINDOW_SIZE  = 9
)(
    input  wire clk,
    input  wire reset,
    input  wire start,

    input  wire                          mem_wr_en,
    input  wire [ADDR_WIDTH-1:0]         mem_wr_addr,
    input  wire [PIXEL_WIDTH-1:0]        mem_wr_data,

    input  wire [SCORE_WIDTH-1:0]        thresh_cluster,
    input  wire [SCORE_WIDTH-1:0]        thresh_corner,
    input  wire [SCORE_WIDTH-1:0]        thresh_chaos,
    input  wire [BRIGHTNESS_WIDTH-1:0]   thresh_brightness,

    output reg                           final_diagnosis_out,
    output reg                           output_valid,
    output wire [7:0]                    edge_pixel_out_dbg,
    output wire [SCORE_WIDTH-1:0]        dbg_cluster_score,
    output wire [SCORE_WIDTH-1:0]        dbg_corner_score,
    output wire [SCORE_WIDTH-1:0]        dbg_chaos_score,
    output wire [BRIGHTNESS_WIDTH-1:0]   dbg_brightness_score,
    output wire [2:0]                    dbg_vote_count
);

    localparam S_IDLE = 2'b00;
    localparam S_READ = 2'b01;
    localparam S_PIPE = 2'b10;
    localparam S_DONE = 2'b11;
    localparam LATENCY_CYCLES = (WINDOW_SIZE - 1) * IMAGE_WIDTH + WINDOW_SIZE;

    reg [1:0] state;
    reg [ADDR_WIDTH-1:0] addr;
    reg [15:0] latency_cnt;

    wire [PIXEL_WIDTH-1:0] pixel_from_mem;
    wire mem_read_en = (state == S_READ) && !mem_wr_en;
    wire [ADDR_WIDTH-1:0] mem_addr = mem_wr_en ? mem_wr_addr : addr;
    sram #(.WIDTH(PIXEL_WIDTH), .DEPTH(1 << ADDR_WIDTH)) u_sram (
        .clk(clk),
        .cs(1'b1),
        .wr_en(mem_wr_en),
        .rd_en(mem_read_en),
        .reset(reset),
        .data_in(mem_wr_data),
        .address(mem_addr),
        .data_out(pixel_from_mem)
    );

    wire [PIXEL_WIDTH-1:0] lb1_out;
    wire [PIXEL_WIDTH-1:0] lb2_out;
    linebuffer #(.WIDTH(PIXEL_WIDTH), .DEPTH(IMAGE_WIDTH)) u_lb1 (
        .clk(clk),
        .reset(reset),
        .data_in(pixel_from_mem),
        .data_out(lb1_out)
    );
    linebuffer #(.WIDTH(PIXEL_WIDTH), .DEPTH(IMAGE_WIDTH)) u_lb2 (
        .clk(clk),
        .reset(reset),
        .data_in(lb1_out),
        .data_out(lb2_out)
    );

    reg [PIXEL_WIDTH-1:0] line0_shift [0:2];
    reg [PIXEL_WIDTH-1:0] line1_shift [0:2];
    reg [PIXEL_WIDTH-1:0] line2_shift [0:2];

    always @(posedge clk) begin
        if (reset) begin
            line0_shift[0] <= 0;
            line0_shift[1] <= 0;
            line0_shift[2] <= 0;
            line1_shift[0] <= 0;
            line1_shift[1] <= 0;
            line1_shift[2] <= 0;
            line2_shift[0] <= 0;
            line2_shift[1] <= 0;
            line2_shift[2] <= 0;
        end else begin
            line0_shift[0] <= line0_shift[1];
            line0_shift[1] <= line0_shift[2];
            line0_shift[2] <= lb2_out;
            line1_shift[0] <= line1_shift[1];
            line1_shift[1] <= line1_shift[2];
            line1_shift[2] <= lb1_out;
            line2_shift[0] <= line2_shift[1];
            line2_shift[1] <= line2_shift[2];
            line2_shift[2] <= pixel_from_mem;
        end
    end

    wire [PIXEL_WIDTH-1:0] p11 = line0_shift[0];
    wire [PIXEL_WIDTH-1:0] p12 = line0_shift[1];
    wire [PIXEL_WIDTH-1:0] p13 = line0_shift[2];
    wire [PIXEL_WIDTH-1:0] p21 = line1_shift[0];
    wire [PIXEL_WIDTH-1:0] p22 = line1_shift[1];
    wire [PIXEL_WIDTH-1:0] p23 = line1_shift[2];
    wire [PIXEL_WIDTH-1:0] p31 = line2_shift[0];
    wire [PIXEL_WIDTH-1:0] p32 = line2_shift[1];
    wire [PIXEL_WIDTH-1:0] p33 = line2_shift[2];

    wire signed [15:0] h_map;
    wire signed [15:0] v_map;
    wire signed [15:0] d1_map;
    wire signed [15:0] d2_map;
    scharr_compute_unit #(.PIXEL_WIDTH(PIXEL_WIDTH)) u_scharr (
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .h_map_out(h_map),
        .v_map_out(v_map),
        .d1_map_out(d1_map),
        .d2_map_out(d2_map)
    );

    wire signed [15:0] grad_mag = h_map + v_map;
    wire h_strong;
    wire v_strong;
    wire cluster_mask;
    wire chaos_mask;
    wire [7:0] edge_pixel_out;

    binary_mask_unit #(
        .EDGE_THRESHOLD_WEAK(16'd80),
        .EDGE_THRESHOLD_STRONG(16'd200)
    ) u_mask (
        .h_mag_in(h_map),
        .v_mag_in(v_map),
        .d1_mag_in(d1_map),
        .d2_mag_in(d2_map),
        .h_strong_out(h_strong),
        .v_strong_out(v_strong),
        .any_weak_edge(cluster_mask),
        .all_weak_edge(chaos_mask),
        .edge_binary_out(edge_pixel_out)
    );

    assign edge_pixel_out_dbg = edge_pixel_out;

    wire corner_mask = h_strong & v_strong;
    wire [SCORE_WIDTH-1:0] cluster_score;
    wire [SCORE_WIDTH-1:0] corner_score;
    wire [SCORE_WIDTH-1:0] chaos_score;
    wire [BRIGHTNESS_WIDTH-1:0] brightness_score;
    wire confusion_flag;
    wire frame_start = (state == S_IDLE) && start;

    // Pipeline Scharr-derived features before the score accumulators.
    // This breaks the long Scharr -> absolute-value/mask -> accumulator path.
    reg cluster_mask_d;
    reg corner_mask_d;
    reg chaos_mask_d;
    reg signed [15:0] grad_mag_d;
    reg counter_enable_d;

    always @(posedge clk) begin
        if (reset) begin
            cluster_mask_d <= 1'b0;
            corner_mask_d <= 1'b0;
            chaos_mask_d <= 1'b0;
            grad_mag_d <= 16'sd0;
            counter_enable_d <= 1'b0;
        end else begin
            cluster_mask_d <= cluster_mask;
            corner_mask_d <= corner_mask;
            chaos_mask_d <= chaos_mask;
            grad_mag_d <= grad_mag;
            counter_enable_d <= (state == S_READ);
        end
    end

    rule_counter_unit #(
        .SCORE_WIDTH(SCORE_WIDTH),
        .BRIGHTNESS_WIDTH(BRIGHTNESS_WIDTH)
    ) u_counter (
        .clk(clk),
        .reset(reset),
        .enable(counter_enable_d),
        .cluster_mask_in(cluster_mask_d),
        .corner_mask_in(corner_mask_d),
        .chaos_mask_in(chaos_mask_d),
        .grad_mag_in(grad_mag_d),
        .frame_start(frame_start),
        .cluster_score_out(cluster_score),
        .corner_score_out(corner_score),
        .chaos_score_out(chaos_score),
        .brightness_score_out(brightness_score),
        .confusion_flag_out(confusion_flag)
    );

    wire final_decision;
    final_vote_unit #(
        .SCORE_WIDTH(SCORE_WIDTH),
        .BRIGHTNESS_WIDTH(BRIGHTNESS_WIDTH)
    ) u_vote (
        .cluster_score_in(cluster_score),
        .corner_score_in(corner_score),
        .chaos_score_in(chaos_score),
        .brightness_score_in(brightness_score),
        .confusion_flag_in(confusion_flag),
        .thresh_cluster(thresh_cluster),
        .thresh_corner(thresh_corner),
        .thresh_chaos(thresh_chaos),
        .thresh_brightness(thresh_brightness),
        .final_diagnosis_out(final_decision),
        .dbg_cluster_score(dbg_cluster_score),
        .dbg_corner_score(dbg_corner_score),
        .dbg_chaos_score(dbg_chaos_score),
        .dbg_brightness_score(dbg_brightness_score),
        .dbg_vote_count(dbg_vote_count)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            addr <= 0;
            latency_cnt <= 0;
            output_valid <= 0;
            final_diagnosis_out <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    output_valid <= 0;
                    if (start) begin
                        addr <= 0;
                        latency_cnt <= 0;
                        state <= S_READ;
                    end
                end
                S_READ: begin
                    addr <= addr + 1'b1;
                    if (addr == IMAGE_WIDTH * IMAGE_WIDTH - 1)
                        state <= S_PIPE;
                end
                S_PIPE: begin
                    latency_cnt <= latency_cnt + 1'b1;
                    if (latency_cnt >= LATENCY_CYCLES + 512)
                        state <= S_DONE;
                end
                S_DONE: begin
                    output_valid <= 1;
                    final_diagnosis_out <= final_decision;
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

module sram #(
    parameter WIDTH = 8,
    parameter DEPTH = 65536
)(
    input  wire clk,
    input  wire cs,
    input  wire wr_en,
    input  wire rd_en,
    input  wire reset,
    input  wire [WIDTH-1:0] data_in,
    input  wire [$clog2(DEPTH)-1:0] address,
    output reg  [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (reset)
            data_out <= {WIDTH{1'b0}};
        else if (cs && wr_en)
            mem[address] <= data_in;
        else if (cs && rd_en)
            data_out <= mem[address];
    end
endmodule

module linebuffer #(
    parameter WIDTH = 8,
    parameter DEPTH = 256
)(
    input  wire clk,
    input  wire reset,
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] shift_reg [0:DEPTH-1];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < DEPTH; i = i + 1)
                shift_reg[i] <= {WIDTH{1'b0}};
            data_out <= 0;
        end else begin
            for (i = DEPTH - 1; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= data_in;
            data_out <= shift_reg[DEPTH-1];
        end
    end
endmodule

module scharr_compute_unit #(
    parameter PIXEL_WIDTH = 8
)(
    input wire [PIXEL_WIDTH-1:0] p11, p12, p13,
    input wire [PIXEL_WIDTH-1:0] p21, p22, p23,
    input wire [PIXEL_WIDTH-1:0] p31, p32, p33,
    output wire signed [15:0] h_map_out,
    output wire signed [15:0] v_map_out,
    output wire signed [15:0] d1_map_out,
    output wire signed [15:0] d2_map_out
);
    wire signed [PIXEL_WIDTH:0] dx_top =
        $signed({1'b0,p13}) - $signed({1'b0,p11});
    wire signed [PIXEL_WIDTH:0] dx_mid =
        $signed({1'b0,p23}) - $signed({1'b0,p21});
    wire signed [PIXEL_WIDTH:0] dx_bot =
        $signed({1'b0,p33}) - $signed({1'b0,p31});

    wire signed [PIXEL_WIDTH:0] dy_left =
        $signed({1'b0,p31}) - $signed({1'b0,p11});
    wire signed [PIXEL_WIDTH:0] dy_mid =
        $signed({1'b0,p32}) - $signed({1'b0,p12});
    wire signed [PIXEL_WIDTH:0] dy_right =
        $signed({1'b0,p33}) - $signed({1'b0,p13});

    wire signed [15:0] dx_top_s = {{(15-PIXEL_WIDTH){dx_top[PIXEL_WIDTH]}}, dx_top};
    wire signed [15:0] dx_mid_s = {{(15-PIXEL_WIDTH){dx_mid[PIXEL_WIDTH]}}, dx_mid};
    wire signed [15:0] dx_bot_s = {{(15-PIXEL_WIDTH){dx_bot[PIXEL_WIDTH]}}, dx_bot};
    wire signed [15:0] dy_left_s = {{(15-PIXEL_WIDTH){dy_left[PIXEL_WIDTH]}}, dy_left};
    wire signed [15:0] dy_mid_s = {{(15-PIXEL_WIDTH){dy_mid[PIXEL_WIDTH]}}, dy_mid};
    wire signed [15:0] dy_right_s = {{(15-PIXEL_WIDTH){dy_right[PIXEL_WIDTH]}}, dy_right};

    wire signed [15:0] dx_top_3 = (dx_top_s <<< 1) + dx_top_s;
    wire signed [15:0] dx_mid_10 = (dx_mid_s <<< 3) + (dx_mid_s <<< 1);
    wire signed [15:0] dx_bot_3 = (dx_bot_s <<< 1) + dx_bot_s;

    wire signed [15:0] dy_left_3 = (dy_left_s <<< 1) + dy_left_s;
    wire signed [15:0] dy_mid_10 = (dy_mid_s <<< 3) + (dy_mid_s <<< 1);
    wire signed [15:0] dy_right_3 = (dy_right_s <<< 1) + dy_right_s;

    assign h_map_out = dx_top_3 + dx_mid_10 + dx_bot_3;
    assign v_map_out = dy_left_3 + dy_mid_10 + dy_right_3;

    wire signed [PIXEL_WIDTH:0] d1a =
        $signed({1'b0,p33}) - $signed({1'b0,p11});
    wire signed [PIXEL_WIDTH:0] d1b =
        $signed({1'b0,p23}) - $signed({1'b0,p12});
    wire signed [PIXEL_WIDTH:0] d2a =
        $signed({1'b0,p11}) - $signed({1'b0,p33});
    wire signed [PIXEL_WIDTH:0] d2b =
        $signed({1'b0,p12}) - $signed({1'b0,p32});

    wire signed [15:0] d1a_s = {{(15-PIXEL_WIDTH){d1a[PIXEL_WIDTH]}}, d1a};
    wire signed [15:0] d1b_s = {{(15-PIXEL_WIDTH){d1b[PIXEL_WIDTH]}}, d1b};
    wire signed [15:0] d2a_s = {{(15-PIXEL_WIDTH){d2a[PIXEL_WIDTH]}}, d2a};
    wire signed [15:0] d2b_s = {{(15-PIXEL_WIDTH){d2b[PIXEL_WIDTH]}}, d2b};

    assign d1_map_out = (d1a_s <<< 1) + d1b_s;
    assign d2_map_out = (d2a_s <<< 1) + d2b_s;
endmodule

module binary_mask_unit #(
    parameter EDGE_THRESHOLD_WEAK   = 16'd80,
    parameter EDGE_THRESHOLD_STRONG = 16'd150
)(
    input  wire signed [15:0] h_mag_in,
    input  wire signed [15:0] v_mag_in,
    input  wire signed [15:0] d1_mag_in,
    input  wire signed [15:0] d2_mag_in,
    output wire h_strong_out,
    output wire v_strong_out,
    output wire any_weak_edge,
    output wire all_weak_edge,
    output reg  [7:0] edge_binary_out
);
    wire [15:0] abs_h  = h_mag_in[15]  ? -h_mag_in  : h_mag_in;
    wire [15:0] abs_v  = v_mag_in[15]  ? -v_mag_in  : v_mag_in;
    wire [15:0] abs_d1 = d1_mag_in[15] ? -d1_mag_in : d1_mag_in;
    wire [15:0] abs_d2 = d2_mag_in[15] ? -d2_mag_in : d2_mag_in;

    wire h_weak = (abs_h  > EDGE_THRESHOLD_WEAK);
    wire v_weak = (abs_v  > EDGE_THRESHOLD_WEAK);
    wire d1_weak = (abs_d1 > EDGE_THRESHOLD_WEAK);
    wire d2_weak = (abs_d2 > EDGE_THRESHOLD_WEAK);

    assign h_strong_out = (abs_h > EDGE_THRESHOLD_STRONG);
    assign v_strong_out = (abs_v > EDGE_THRESHOLD_STRONG);
    assign any_weak_edge = h_weak | v_weak | d1_weak | d2_weak;
    assign all_weak_edge = h_weak & v_weak & d1_weak & d2_weak;

    always @(*) begin
        if (h_strong_out || v_strong_out)
            edge_binary_out = 8'hff;
        else if (any_weak_edge)
            edge_binary_out = 8'h55;
        else
            edge_binary_out = 8'h00;
    end
endmodule

module rule_counter_unit #(
    parameter SCORE_WIDTH = 16,
    parameter BRIGHTNESS_WIDTH = 24
)(
    input  wire                       clk,
    input  wire                       reset,
    input  wire                       enable,
    input  wire                       cluster_mask_in,
    input  wire                       corner_mask_in,
    input  wire                       chaos_mask_in,
    input  wire signed [15:0]         grad_mag_in,
    input  wire                       frame_start,
    output reg  [SCORE_WIDTH-1:0]     cluster_score_out,
    output reg  [SCORE_WIDTH-1:0]     corner_score_out,
    output reg  [SCORE_WIDTH-1:0]     chaos_score_out,
    output wire [BRIGHTNESS_WIDTH-1:0] brightness_score_out,
    output reg                        confusion_flag_out
);
    reg [BRIGHTNESS_WIDTH-1:0] brightness_accum;
    wire [15:0] grad_mag_abs = grad_mag_in[15] ? (~grad_mag_in + 16'd1) : grad_mag_in;
    wire [BRIGHTNESS_WIDTH-1:0] grad_mag_ext = {{(BRIGHTNESS_WIDTH-16){1'b0}}, grad_mag_abs};

    always @(posedge clk) begin
        if (reset || frame_start) begin
            cluster_score_out <= 0;
            corner_score_out <= 0;
            chaos_score_out <= 0;
            confusion_flag_out <= 0;
            brightness_accum <= 0;
        end else if (enable) begin
            if (cluster_mask_in)
                cluster_score_out <= cluster_score_out + 1'b1;
            if (corner_mask_in)
                corner_score_out <= corner_score_out + 1'b1;
            if (chaos_mask_in)
                chaos_score_out <= chaos_score_out + 1'b1;
            brightness_accum <= brightness_accum + grad_mag_ext;
            if (chaos_score_out > {{(SCORE_WIDTH-6){1'b0}}, 6'd50})
                confusion_flag_out <= 1'b1;
        end
    end

    assign brightness_score_out = brightness_accum;
endmodule

module final_vote_unit #(
    parameter SCORE_WIDTH = 16,
    parameter BRIGHTNESS_WIDTH = 24
)(
    input  wire [SCORE_WIDTH-1:0]     cluster_score_in,
    input  wire [SCORE_WIDTH-1:0]     corner_score_in,
    input  wire [SCORE_WIDTH-1:0]     chaos_score_in,
    input  wire [BRIGHTNESS_WIDTH-1:0] brightness_score_in,
    input  wire                       confusion_flag_in,
    input  wire [SCORE_WIDTH-1:0]     thresh_cluster,
    input  wire [SCORE_WIDTH-1:0]     thresh_corner,
    input  wire [SCORE_WIDTH-1:0]     thresh_chaos,
    input  wire [BRIGHTNESS_WIDTH-1:0] thresh_brightness,
    output reg                        final_diagnosis_out,
    output reg  [SCORE_WIDTH-1:0]     dbg_cluster_score,
    output reg  [SCORE_WIDTH-1:0]     dbg_corner_score,
    output reg  [SCORE_WIDTH-1:0]     dbg_chaos_score,
    output reg  [BRIGHTNESS_WIDTH-1:0] dbg_brightness_score,
    output reg  [2:0]                 dbg_vote_count
);
    reg [2:0] votes;

    always @(*) begin
        votes = 3'd0;
        if (cluster_score_in > thresh_cluster)
            votes = votes + 1'b1;
        if (corner_score_in > thresh_corner)
            votes = votes + 1'b1;
        if (chaos_score_in > thresh_chaos)
            votes = votes + 1'b1;
        if (brightness_score_in > thresh_brightness)
            votes = votes + 1'b1;
        if (confusion_flag_in)
            votes = votes + 1'b1;

        final_diagnosis_out = (votes >= 3);
        dbg_cluster_score = cluster_score_in;
        dbg_corner_score = corner_score_in;
        dbg_chaos_score = chaos_score_in;
        dbg_brightness_score = brightness_score_in;
        dbg_vote_count = votes;
    end
endmodule

`default_nettype wire
