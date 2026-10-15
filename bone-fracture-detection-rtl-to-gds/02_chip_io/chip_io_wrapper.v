module chip_io_wrapper (
    inout wire pad_clk,
    inout wire pad_reset,
    inout wire pad_spi_sclk,
    inout wire pad_spi_cs_n,
    inout wire pad_spi_mosi,
    inout wire pad_spi_miso,

    // External I/O supply rails
    inout wire vddio,
    inout wire vddio_q,
    inout wire vdda,
    inout wire vccd,
    inout wire vcchib,
    inout wire vswitch,
    inout wire vssio,
    inout wire vssio_q,
    inout wire vssd,
    inout wire vssa
);

    wire clk_i, reset_i, sclk_i, cs_i, mosi_i;
    wire miso_o;

    wire [5:0] tie_hi;
    wire [5:0] tie_lo;

    // Constant logic levels, powered by the core supply.
    wire logic_hi, logic_lo;

    sky130_fd_sc_hd__conb_1 u_tie (
        .HI(logic_hi),
        .LO(logic_lo),
        .VPWR(vccd),
        .VGND(vssd),
        .VPB(vccd),
        .VNB(vssd)
    );

    top_level_final_decision u_core (
        .clk      (clk_i),
        .reset    (reset_i),
        .spi_sclk (sclk_i),
        .spi_cs_n (cs_i),
        .spi_mosi (mosi_i),
        .spi_miso (miso_o)
    );

    // Input GPIO: clock
    sky130_ef_io__gpiov2_pad_wrapped u_pad_clk (
        .PAD(pad_clk), .IN_H(clk_i), .IN(),
        .OUT(logic_lo), .OE_N(logic_hi), .DM(3'b000),
        .HLD_H_N(tie_hi[0]), .TIE_HI_ESD(tie_hi[0]),
        .TIE_LO_ESD(tie_lo[0]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[0]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[0]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

    // Input GPIO: reset
    sky130_ef_io__gpiov2_pad_wrapped u_pad_reset (
        .PAD(pad_reset), .IN_H(reset_i), .IN(),
        .OUT(logic_lo), .OE_N(logic_hi), .DM(3'b000),
        .HLD_H_N(tie_hi[1]), .TIE_HI_ESD(tie_hi[1]),
        .TIE_LO_ESD(tie_lo[1]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[1]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[1]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

    // Input GPIO: SPI clock
    sky130_ef_io__gpiov2_pad_wrapped u_pad_sclk (
        .PAD(pad_spi_sclk), .IN_H(sclk_i), .IN(),
        .OUT(logic_lo), .OE_N(logic_hi), .DM(3'b000),
        .HLD_H_N(tie_hi[2]), .TIE_HI_ESD(tie_hi[2]),
        .TIE_LO_ESD(tie_lo[2]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[2]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[2]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

    // Input GPIO: SPI chip select
    sky130_ef_io__gpiov2_pad_wrapped u_pad_cs (
        .PAD(pad_spi_cs_n), .IN_H(cs_i), .IN(),
        .OUT(logic_lo), .OE_N(logic_hi), .DM(3'b000),
        .HLD_H_N(tie_hi[3]), .TIE_HI_ESD(tie_hi[3]),
        .TIE_LO_ESD(tie_lo[3]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[3]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[3]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

    // Input GPIO: SPI MOSI
    sky130_ef_io__gpiov2_pad_wrapped u_pad_mosi (
        .PAD(pad_spi_mosi), .IN_H(mosi_i), .IN(),
        .OUT(logic_lo), .OE_N(logic_hi), .DM(3'b000),
        .HLD_H_N(tie_hi[4]), .TIE_HI_ESD(tie_hi[4]),
        .TIE_LO_ESD(tie_lo[4]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[4]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[4]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

    // Output GPIO: SPI MISO
    sky130_ef_io__gpiov2_pad_wrapped u_pad_miso (
        .PAD(pad_spi_miso), .IN_H(), .IN(),
        .OUT(miso_o), .OE_N(logic_lo), .DM(3'b110),
        .HLD_H_N(tie_hi[5]), .TIE_HI_ESD(tie_hi[5]),
        .TIE_LO_ESD(tie_lo[5]),
        .ENABLE_H(logic_lo), .ENABLE_INP_H(tie_lo[5]),
        .ENABLE_VDDA_H(logic_lo), .ENABLE_VSWITCH_H(tie_lo[5]),
        .ENABLE_VDDIO(logic_hi), .INP_DIS(logic_lo),
        .IB_MODE_SEL(logic_lo), .VTRIP_SEL(logic_lo),
        .SLOW(logic_lo), .HLD_OVR(logic_lo),
        .ANALOG_EN(logic_lo), .ANALOG_SEL(logic_lo),
        .ANALOG_POL(logic_lo),
        .PAD_A_NOESD_H(), .PAD_A_ESD_0_H(), .PAD_A_ESD_1_H(),
        .AMUXBUS_A(), .AMUXBUS_B(),
        .VDDIO(vddio), .VDDIO_Q(vddio_q), .VDDA(vdda),
        .VCCD(vccd), .VCCHIB(vcchib), .VSWITCH(vswitch),
        .VSSIO(vssio), .VSSIO_Q(vssio_q), .VSSD(vssd), .VSSA(vssa)
    );

endmodule

