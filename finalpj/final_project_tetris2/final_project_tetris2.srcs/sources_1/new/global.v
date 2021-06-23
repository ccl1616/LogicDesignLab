`define TRUE 1'b1
`define FALSE 1'b0

// Frequency divider
`define SSD_SCAN_CTL_BIT_WIDTH 2 // number of bits for ftsd scan control
`define FREQ_DIV_BIT 27
`define DIV_BY_50M 50_000_000
`define DIV_BY_50M_BIT_WIDTH 27
`define DIV_BY_100_BIT_WIDTH 8

// `define DEBUG 
`ifdef DEBUG 
    `define DIV_BY_500K 4
    `define DIV_BY_6250K 4
    `define DIV_BY_12500K 2
    `define DIV_BY_50M 16
    `define DIV_BY_25M 8
    `define DIV_BY_100 2
`else 
    `define DIV_BY_500K 500_000
    `define DIV_BY_6250K 6250_000
    `define DIV_BY_12500K 12500_000
    `define DIV_BY_50M 50_000_000
    `define DIV_BY_25M 25_000_000
    `define DIV_BY_100 100
`endif
`define DIV_BY_500K_BIT_WIDTH 20
`define DEBOUNCE_WINDOW_SIZE 4

// SSD scan
`define SSD_DIGIT_NUM 4 // number of SSD digit
`define SSD_SCAN_CTL_DISP1 4'b0111 // set the value of SSD 1
`define SSD_SCAN_CTL_DISP2 4'b1011 // set the value of SSD 2
`define SSD_SCAN_CTL_DISP3 4'b1101 // set the value of SSD 3
`define SSD_SCAN_CTL_DISP4 4'b1110 // set the value of SSD 4
`define SSD_SCAN_CTL_DISPALL 4'b0000 // set the value of SSD to ALL

// 7-segment display
`define SSD_BIT_WIDTH 8 // 7-segment display control
`define SSD_NUM 4 //number of 7-segment display
`define BCD_BIT_WIDTH 4 // BCD bit width
`define SSD_ZERO   `SSD_BIT_WIDTH'b0000_0011 // 0
`define SSD_ONE    `SSD_BIT_WIDTH'b1001_1111 // 1
`define SSD_TWO    `SSD_BIT_WIDTH'b0010_0101 // 2
`define SSD_THREE  `SSD_BIT_WIDTH'b0000_1101 // 3
`define SSD_FOUR   `SSD_BIT_WIDTH'b1001_1001 // 4
`define SSD_FIVE   `SSD_BIT_WIDTH'b0100_1001 // 5
`define SSD_SIX    `SSD_BIT_WIDTH'b0100_0001 // 6
`define SSD_SEVEN  `SSD_BIT_WIDTH'b0001_1111 // 7
`define SSD_EIGHT  `SSD_BIT_WIDTH'b0000_0001 // 8
`define SSD_NINE   `SSD_BIT_WIDTH'b0000_1001 // 9
`define SSD_A   `SSD_BIT_WIDTH'b0000_0101 // a
`define SSD_B   `SSD_BIT_WIDTH'b1100_0001 // b
`define SSD_C   `SSD_BIT_WIDTH'b1110_0101 // c
`define SSD_D   `SSD_BIT_WIDTH'b1000_0101 // d
`define SSD_E   `SSD_BIT_WIDTH'b0110_0001 // e
`define SSD_F   `SSD_BIT_WIDTH'b0111_0001 // f
`define SSD_DEF    `SSD_BIT_WIDTH'b0000_0000 // default, all LEDs being lighted

// BCD counter
`define BCD_BIT_WIDTH 4 // BCD bit width 
`define ENABLED 1'b1 // ENABLE indicator
`define DISABLED 1'b0 // EIDABLE indicator
`define INCREMENT 1'b1 // increase by 1
`define BCD_ZERO 4'd0 // 1 for BCD
`define BCD_ONE 4'd1 // 1 for BCD
`define BCD_TWO 4'd2 // 2 for BCD
`define BCD_THREE 4'd3 // 2 for BCD
`define BCD_FOUR 4'd4 // 2 for BCD
`define BCD_FIVE 4'd5 // 5 for BCD
`define BCD_SIX 4'd6 // 2 for BCD
`define BCD_SEVEN 4'd7 // 2 for BCD
`define BCD_EIGHT 4'd8 // 2 for BCD
`define BCD_NINE 4'd9 // 9 for BCD
`define BCD_DEF 4'd15 // all 1

// FSM
`define STAT_COUNT 1'b1
`define STAT_PAUSE 1'b0

// sound
`define MID_DO 22'd191112
`define MID_RE 22'd170262
`define MID_MI 22'd151686
`define MID_FA 22'd143172

`define MID_SO 22'd127552
`define MID_LA 22'd113636
`define MID_SI 22'd101238

`define HIGH_DO 22'd95556
`define HIGH_RE 22'd85131
`define HIGH_MI 22'd75843
`define HIGH_FA 22'd71586

`define HIGH_SO 22'd63776
`define HIGH_LA 22'd56818
`define HIGH_SI 22'd50619
`define SILENT 22'd2