// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////

// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module sdx_kernel_wizard_0_example_vadd #(
  parameter integer C_M_AXI_ID_WIDTH         = 1  ,
  parameter integer C_M_AXI_ADDR_WIDTH       = 64 ,
  parameter integer C_M_AXI_DATA_WIDTH       = 512,
  parameter integer C_M_AXI_NUM_THREADS      = 1,
  parameter integer C_LENGTH_WIDTH           = 32,
  parameter integer C_ADDER_BIT_WIDTH        = 32,
  parameter integer C_NUM_CLOCKS             = 1
)
(
  // System Signals
  input wire                                    aclk               ,
  input wire                                    areset             ,
  // Extra clocks
  input wire                                    kernel_clk         ,
  input wire                                    kernel_rst         ,
  // AXI4 master interface
  output wire                                   m_axi_awvalid      ,
  input wire                                    m_axi_awready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]          m_axi_awaddr       ,
  output wire [C_M_AXI_ID_WIDTH-1:0]            m_axi_awid         ,
  output wire [8-1:0]                           m_axi_awlen        ,
  output wire [3-1:0]                           m_axi_awsize       ,
  output wire                                   m_axi_wvalid       ,
  input wire                                    m_axi_wready       ,
  output wire [C_M_AXI_DATA_WIDTH-1:0]          m_axi_wdata        ,
  output wire [C_M_AXI_DATA_WIDTH/8-1:0]        m_axi_wstrb        ,
  output wire                                   m_axi_wlast        ,
  output wire                                   m_axi_arvalid      ,
  input wire                                    m_axi_arready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]          m_axi_araddr       ,
  output wire [C_M_AXI_ID_WIDTH-1:0]            m_axi_arid         ,
  output wire [8-1:0]                           m_axi_arlen        ,
  output wire [3-1:0]                           m_axi_arsize       ,
  input wire                                    m_axi_rvalid       ,
  output wire                                   m_axi_rready       ,
  input wire [C_M_AXI_DATA_WIDTH-1:0]           m_axi_rdata        ,
  input wire                                    m_axi_rlast        ,
  input wire [C_M_AXI_ID_WIDTH-1:0]             m_axi_rid          ,
  input wire                                    m_axi_bvalid       ,
  output wire                                   m_axi_bready       ,
  input wire [C_M_AXI_ID_WIDTH-1:0]             m_axi_bid          ,
  input wire                                    ap_start           ,
  output wire                                   ap_done            ,
  input wire [C_M_AXI_ADDR_WIDTH-1:0]           ctrl_addr_offset   ,
  input wire [C_LENGTH_WIDTH-1:0]               ctrl_length,
  input wire [C_ADDER_BIT_WIDTH-1:0]            ctrl_constant
);

timeunit 1ps;
timeprecision 1ps;


///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_DW_BYTES             = C_M_AXI_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN        = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN        = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_RD_MAX_OUTSTANDING   = 3;
localparam integer LP_RD_FIFO_DEPTH        = LP_AXI_BURST_LEN*(LP_RD_MAX_OUTSTANDING + 1);
localparam integer LP_RD_FIFO_READ_LATENCY = 2;
localparam integer LP_RD_FIFO_COUNT_WIDTH  = $clog2(LP_RD_FIFO_DEPTH)+1;

localparam integer LP_WR_FIFO_DEPTH        = 32;
localparam integer LP_WR_FIFO_READ_LATENCY = 1;
localparam integer LP_WR_FIFO_COUNT_WIDTH  = $clog2(LP_WR_FIFO_DEPTH)+1;
///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////

// Control logic
logic done = 1'b0;
// AXI read master stage
logic read_done;
logic [C_M_AXI_NUM_THREADS-1:0] rd_tvalid;
logic [C_M_AXI_NUM_THREADS-1:0] rd_tready_n;
logic [C_M_AXI_NUM_THREADS-1:0] [C_M_AXI_DATA_WIDTH-1:0] rd_tdata;
logic [C_M_AXI_NUM_THREADS-1:0] rd_fifo_prog_full;
// RD fifo stage
logic [C_M_AXI_NUM_THREADS-1:0] rd_fifo_tvalid_n;
logic [C_M_AXI_NUM_THREADS-1:0] rd_fifo_tready;
logic [C_M_AXI_NUM_THREADS-1:0] [C_M_AXI_DATA_WIDTH-1:0] rd_fifo_tdata;
// Adder stage
logic [C_M_AXI_NUM_THREADS-1:0] rd_fifo_tvalid;
logic  adder_tvalid;
logic [C_M_AXI_NUM_THREADS-1:0] [C_M_AXI_DATA_WIDTH-1:0] adder_tdata;
logic [C_M_AXI_NUM_THREADS-1:0] wr_fifo_prog_full;
// WR FIFO stage
logic [C_M_AXI_NUM_THREADS-1:0] wr_fifo_tvalid_n;
logic [C_M_AXI_NUM_THREADS-1:0] wr_fifo_tready;
logic [C_M_AXI_NUM_THREADS-1:0] [C_M_AXI_DATA_WIDTH-1:0] wr_fifo_tdata;


logic [511:0] temp_data;

// AXI write master stage
logic write_done;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
sdx_kernel_wizard_0_example_axi_read_master #(
  .C_ADDR_WIDTH      ( C_M_AXI_ADDR_WIDTH    ) ,
  .C_DATA_WIDTH      ( C_M_AXI_DATA_WIDTH    ) ,
  .C_ID_WIDTH        ( C_M_AXI_ID_WIDTH      ) ,
  .C_NUM_CHANNELS    ( C_M_AXI_NUM_THREADS   ) ,
  .C_LENGTH_WIDTH    ( C_LENGTH_WIDTH        ) ,
  .C_BURST_LEN       ( LP_AXI_BURST_LEN      ) ,
  .C_LOG_BURST_LEN   ( LP_LOG_BURST_LEN      ) ,
  .C_MAX_OUTSTANDING ( LP_RD_MAX_OUTSTANDING )
)
inst_axi_read_master (
  .aclk           ( aclk              ) ,
  .areset         ( areset            ) ,
  .ctrl_start     ( ap_start          ) ,
  .ctrl_done      ( read_done         ) ,
  .ctrl_offset    ( ctrl_addr_offset  ) ,
  .ctrl_length    ( ctrl_length       ) ,
  .ctrl_prog_full ( rd_fifo_prog_full ) ,
  .arvalid        ( m_axi_arvalid     ) ,
  .arready        ( m_axi_arready     ) ,
  .araddr         ( m_axi_araddr      ) ,
  .arid           ( m_axi_arid        ) ,
  .arlen          ( m_axi_arlen       ) ,
  .arsize         ( m_axi_arsize      ) ,
  .rvalid         ( m_axi_rvalid      ) ,
  .rready         ( m_axi_rready      ) ,
  .rdata          ( m_axi_rdata       ) ,
  .rlast          ( m_axi_rlast       ) ,
  .rid            ( m_axi_rid         ) ,
  .m_tvalid       ( rd_tvalid         ) ,
  .m_tready       ( ~rd_tready_n      ) ,
  .m_tdata        ( rd_tdata          )
);

generate
if (C_NUM_CLOCKS == 1) begin : gen_sync_rd_fifo
  // xpm_fifo_sync: Synchronous FIFO
  // Xilinx Parameterized Macro, Version 2016.4+
  xpm_fifo_sync # (
    .FIFO_MEMORY_TYPE    ( "auto"                  ) , // string; "auto", "block", "distributed", or "ultra";
    .ECC_MODE            ( "no_ecc"                ) , // string; "no_ecc" or "en_ecc";
    .FIFO_WRITE_DEPTH    ( LP_RD_FIFO_DEPTH        ) , // positive integer
    .WRITE_DATA_WIDTH    ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .WR_DATA_COUNT_WIDTH ( LP_RD_FIFO_COUNT_WIDTH  ) , // positive integer, Not used
    .PROG_FULL_THRESH    ( LP_AXI_BURST_LEN-2      ) , // positive integer
    .FULL_RESET_VALUE    ( 1                       ) , // positive integer; 0 or 1
    .READ_MODE           ( "std"                   ) , // string; "std" or "fwft";
    .FIFO_READ_LATENCY   ( LP_RD_FIFO_READ_LATENCY ) , // positive integer;
    .READ_DATA_WIDTH     ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .RD_DATA_COUNT_WIDTH ( LP_RD_FIFO_COUNT_WIDTH  ) , // positive integer, not used
    .PROG_EMPTY_THRESH   ( 10                      ) , // positive integer, not used
    .DOUT_RESET_VALUE    ( "0"                     ) , // string, don't care
    .WAKEUP_TIME         ( 0                       )   // positive integer; 0 or 2;
  )
  inst_rd_xpm_fifo_sync[C_M_AXI_NUM_THREADS-1:0] (
    .sleep         ( 1'b0                 ) ,
    .rst           ( areset               ) ,
    .wr_clk        ( aclk                 ) ,
    .wr_en         ( rd_tvalid            ) ,
    .din           ( rd_tdata             ) ,
    .full          ( rd_tready_n          ) ,
    .prog_full     ( rd_fifo_prog_full    ) ,
    .wr_data_count (                      ) ,
    .overflow      (                      ) ,
    .wr_rst_busy   (                      ) ,
    .rd_en         ( fifo_rd_en/*rd_fifo_tready*/       ) ,
    .dout          ( rd_fifo_tdata        ) ,
    .empty         ( rd_fifo_tvalid_n     ) ,
    .prog_empty    (                      ) ,
    .rd_data_count (                      ) ,
    .underflow     (                      ) ,
    .rd_rst_busy   (                      ) ,
    .injectsbiterr ( 1'b0                 ) ,
    .injectdbiterr ( 1'b0                 ) ,
    .sbiterr       (                      ) ,
    .dbiterr       (                      )
  );
end
else begin : gen_async_rd_fifo
  // xpm_fifo_async: Asynchronous FIFO
  // Xilinx Parameterized Macro, Version 2016.4+
  xpm_fifo_async # (
    .FIFO_MEMORY_TYPE    ( "auto"                  ) , // string; "auto", "block", "distributed", or "ultra";
    .ECC_MODE            ( "no_ecc"                ) , // string; "no_ecc" or "en_ecc";
    .RELATED_CLOCKS      ( 0                       ) ,
    .FIFO_WRITE_DEPTH    ( LP_RD_FIFO_DEPTH        ) , // positive integer
    .WRITE_DATA_WIDTH    ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .WR_DATA_COUNT_WIDTH ( LP_RD_FIFO_COUNT_WIDTH  ) , // positive integer, Not used
    .PROG_FULL_THRESH    ( LP_AXI_BURST_LEN-2      ) , // positive integer
    .FULL_RESET_VALUE    ( 1                       ) , // positive integer; 0 or 1
    .READ_MODE           ( "std"                   ) , // string; "std" or "fwft";
    .FIFO_READ_LATENCY   ( LP_RD_FIFO_READ_LATENCY ) , // positive integer;
    .READ_DATA_WIDTH     ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .RD_DATA_COUNT_WIDTH ( LP_RD_FIFO_COUNT_WIDTH  ) , // positive integer, not used
    .PROG_EMPTY_THRESH   ( 10                      ) , // positive integer, not used
    .DOUT_RESET_VALUE    ( "0"                     ) , // string, don't care
    .WAKEUP_TIME         ( 0                       )   // positive integer; 0 or 2;
  )
  inst_rd_xpm_fifo_sync[C_M_AXI_NUM_THREADS-1:0] (
    .sleep         ( 1'b0                 ) ,
    .rst           ( areset               ) ,
    .wr_clk        ( aclk                 ) ,
    .wr_en         ( rd_tvalid            ) ,
    .din           ( rd_tdata             ) ,
    .full          ( rd_tready_n          ) ,
    .prog_full     ( rd_fifo_prog_full    ) ,
    .wr_data_count (                      ) ,
    .overflow      (                      ) ,
    .wr_rst_busy   (                      ) ,
    .rd_clk        ( kernel_clk           ) ,
    .rd_en         ( rd_fifo_tready       ) ,
    .dout          ( rd_fifo_tdata        ) ,
    .empty         ( rd_fifo_tvalid_n     ) ,
    .prog_empty    (                      ) ,
    .rd_data_count (                      ) ,
    .underflow     (                      ) ,
    .rd_rst_busy   (                      ) ,
    .injectsbiterr ( 1'b0                 ) ,
    .injectdbiterr ( 1'b0                 ) ,
    .sbiterr       (                      ) ,
    .dbiterr       (                      )
  );
end
endgenerate

assign rd_fifo_tready = ~wr_fifo_prog_full;

sdx_kernel_wizard_0_example_pipeline #(
  .C_DEPTH ( LP_RD_FIFO_READ_LATENCY )
)
inst_rd_fifo_valid_pipeline[C_M_AXI_NUM_THREADS-1:0] (
  .aclk   ( kernel_clk                             ) ,
  .areset ( kernel_rst                             ) ,
  .aclken ( 1'b1                                   ) ,
  .din    ( ~rd_fifo_tvalid_n & ~wr_fifo_prog_full ) ,
  .dout   ( rd_fifo_tvalid                         )
);

// Adder has 2 pipeline stages (1 cycle latency)
sdx_kernel_wizard_0_example_adder #(
  .C_DATA_WIDTH      ( C_M_AXI_DATA_WIDTH ) ,
  .C_ADDER_BIT_WIDTH ( C_ADDER_BIT_WIDTH  )
)
inst_adder[C_M_AXI_NUM_THREADS-1:0]  (
  .aclk          ( kernel_clk     ) ,
  .areset        ( kernel_rst     ) ,
  .ctrl_constant ( ctrl_constant  ) ,
  .s_tvalid      ( rd_fifo_tvalid ) ,
  .s_tdata       ( rd_fifo_tdata  ) ,
  .m_tvalid      (   ) ,
  .m_tdata       (   )
);
logic [127:0] key;
logic [127:0] text_in;
wire [127:0] t1_out,data_out;
wire data_valid,u0_done;
wire done_2;
logic temp_valid;
logic temp_fifo_valid;
logic [127:0] temp_data_out;
/*
***********************************************************************************************************************
************************************************ USER LOGIC************************************************************
*********************************************************************************************************************** 
*/
always @(*)
begin 
  temp_data = rd_fifo_tdata[383:0];
  key     = temp_data[383:256];
  text_in = temp_data[255:128];
  temp_fifo_valid =~rd_fifo_tvalid_n && ~wr_fifo_prog_full;
  adder_tdata = {{384{1'b0}},temp_data_out};
  
  if (~adder_tvalid && ~rd_fifo_tvalid_n && ~wr_fifo_prog_full)
        temp_valid = 1;
  else
        temp_valid = 0;
end 
aes DUT_1(
    .clk(kernel_clk),
    .reset(!kernel_rst),
    .load_i(fifo_3),
    .decrypt_i(1'b0),
    .data_i(text_in),
    .key_i(key),
    .ready_o(u0_done),
    .data_o(t1_out)
    );

aes DUT_2(
    .clk(kernel_clk),
    .reset(!kernel_rst),
    .load_i(u0_done),
    .decrypt_i(1'b1),
    .data_i(t1_out),
    .key_i(key),
    .ready_o(adder_tvalid),
    .data_o(temp_data_out)
    );
  
reg [31:0] temp_cnt;
reg fifo_1,fifo_2,fifo_3;
logic fifo_rd_en;       
always @(posedge aclk or posedge kernel_rst)
begin 
    if(kernel_rst)
       temp_cnt <= 0;
     else
     begin 
        if(temp_valid)
            temp_cnt <= temp_cnt +1;
        else
            temp_cnt <= 0;
        
        if(temp_cnt ==1)
            fifo_rd_en <= 1;
        else
            fifo_rd_en <= 0;
       fifo_1 <= fifo_rd_en;
       fifo_2 <=  fifo_1;
        fifo_3 <=  fifo_1;
     end  
end
   
    
/*
*********************************************************************************************************************************
************************************************ USER LOGIC ENDS HERE************************************************************
********************************************************************************************************************************* 
*/



generate
if (C_NUM_CLOCKS == 1) begin : gen_sync_wr_fifo
  // xpm_fifo_sync: Synchronous FIFO
  // Xilinx Parameterized Macro, Version 2016.4+
  xpm_fifo_sync # (
    .FIFO_MEMORY_TYPE    ( "auto"                  ) , // string; "auto", "block", "distributed", or "ultra";
    .ECC_MODE            ( "no_ecc"                ) , // string; "no_ecc" or "en_ecc";
    .FIFO_WRITE_DEPTH    ( LP_WR_FIFO_DEPTH        ) , // positive integer
    .WRITE_DATA_WIDTH    ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .WR_DATA_COUNT_WIDTH ( LP_WR_FIFO_COUNT_WIDTH  ) , // positive integer, Not used
    .PROG_FULL_THRESH    ( LP_WR_FIFO_DEPTH-5      ) , // positive integer
    .FULL_RESET_VALUE    ( 1                       ) , // positive integer; 0 or 1
    .READ_MODE           ( "fwft"                  ) , // string; "std" or "fwft";
    .FIFO_READ_LATENCY   ( LP_WR_FIFO_READ_LATENCY ) , // positive integer;
    .READ_DATA_WIDTH     ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .RD_DATA_COUNT_WIDTH ( LP_WR_FIFO_COUNT_WIDTH  ) , // positive integer, not used
    .PROG_EMPTY_THRESH   ( 10                      ) , // positive integer, not used
    .DOUT_RESET_VALUE    ( "0"                     ) , // string, don't care
    .WAKEUP_TIME         ( 0                       )   // positive integer; 0 or 2;
  )
  inst_wr_xpm_fifo_sync[C_M_AXI_NUM_THREADS-1:0] (
    .sleep         ( 1'b0              ) ,
    .rst           ( areset            ) ,
    .wr_clk        ( aclk              ) ,
    .wr_en         ( adder_tvalid      ) ,
    .din           ( adder_tdata       ) ,
    .full          (                   ) ,
    .prog_full     ( wr_fifo_prog_full ) ,
    .wr_data_count (                   ) ,
    .overflow      (                   ) ,
    .wr_rst_busy   (                   ) ,
    .rd_en         ( wr_fifo_tready    ) ,
    .dout          ( wr_fifo_tdata     ) ,
    .empty         ( wr_fifo_tvalid_n  ) ,
    .prog_empty    (                   ) ,
    .rd_data_count (                   ) ,
    .underflow     (                   ) ,
    .rd_rst_busy   (                   ) ,
    .injectsbiterr ( 1'b0              ) ,
    .injectdbiterr ( 1'b0              ) ,
    .sbiterr       (                   ) ,
    .dbiterr       (                   )
  );
end
else begin : gen_async_wr_fifo
  // xpm_fifo_async: Asynchronous FIFO
  // Xilinx Parameterized Macro, Version 2016.4+
  xpm_fifo_async # (
    .FIFO_MEMORY_TYPE    ( "auto"                  ) , // string; "auto", "block", "distributed", or "ultra";
    .ECC_MODE            ( "no_ecc"                ) , // string; "no_ecc" or "en_ecc";
    .RELATED_CLOCKS      ( 0                       ) ,
    .FIFO_WRITE_DEPTH    ( LP_WR_FIFO_DEPTH        ) , // positive integer
    .WRITE_DATA_WIDTH    ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .WR_DATA_COUNT_WIDTH ( LP_WR_FIFO_COUNT_WIDTH  ) , // positive integer, Not used
    .PROG_FULL_THRESH    ( LP_WR_FIFO_DEPTH-5      ) , // positive integer
    .FULL_RESET_VALUE    ( 1                       ) , // positive integer; 0 or 1
    .READ_MODE           ( "fwft"                  ) , // string; "std" or "fwft";
    .FIFO_READ_LATENCY   ( LP_WR_FIFO_READ_LATENCY ) , // positive integer;
    .READ_DATA_WIDTH     ( C_M_AXI_DATA_WIDTH      ) , // positive integer
    .RD_DATA_COUNT_WIDTH ( LP_WR_FIFO_COUNT_WIDTH  ) , // positive integer, not used
    .PROG_EMPTY_THRESH   ( 10                      ) , // positive integer, not used
    .DOUT_RESET_VALUE    ( "0"                     ) , // string, don't care
    .WAKEUP_TIME         ( 0                       )   // positive integer; 0 or 2;
  )
  inst_wr_xpm_fifo_sync[C_M_AXI_NUM_THREADS-1:0] (
    .sleep         ( 1'b0              ) ,
    .rst           ( kernel_rst        ) ,
    .wr_clk        ( kernel_clk        ) ,
    .wr_en         ( adder_tvalid      ) ,
    .din           ( adder_tdata       ) ,
    .full          (                   ) ,
    .prog_full     ( wr_fifo_prog_full ) ,
    .wr_data_count (                   ) ,
    .overflow      (                   ) ,
    .wr_rst_busy   (                   ) ,
    .rd_clk        ( aclk              ) ,
    .rd_en         ( wr_fifo_tready    ) ,
    .dout          ( wr_fifo_tdata     ) ,
    .empty         ( wr_fifo_tvalid_n  ) ,
    .prog_empty    (                   ) ,
    .rd_data_count (                   ) ,
    .underflow     (                   ) ,
    .rd_rst_busy   (                   ) ,
    .injectsbiterr ( 1'b0              ) ,
    .injectdbiterr ( 1'b0              ) ,
    .sbiterr       (                   ) ,
    .dbiterr       (                   )
  );
end
endgenerate

// AXI4 Write Master
sdx_kernel_wizard_0_example_axi_write_master #(
  .C_ADDR_WIDTH    ( C_M_AXI_ADDR_WIDTH       ) ,
  .C_DATA_WIDTH    ( C_M_AXI_DATA_WIDTH       ) ,
  .C_ID_WIDTH      ( C_M_AXI_ID_WIDTH         ) ,
  .C_LENGTH_WIDTH  ( C_LENGTH_WIDTH           ) ,
  .C_BURST_LEN     ( LP_AXI_BURST_LEN         ) ,
  .C_LOG_BURST_LEN ( LP_LOG_BURST_LEN         ) ,
  .C_NUM_THREADS   ( C_M_AXI_NUM_THREADS      )
)
inst_axi_write_master (
  .aclk        ( aclk              ) ,
  .areset      ( areset            ) ,
  .ctrl_start  ( ap_start          ) ,
  .ctrl_done   ( write_done        ) ,
  .ctrl_offset ( ctrl_addr_offset  ) ,
  .ctrl_length ( ctrl_length       ) ,
  .awvalid     ( m_axi_awvalid     ) ,
  .awready     ( m_axi_awready     ) ,
  .awaddr      ( m_axi_awaddr      ) ,
  .awid        ( m_axi_awid        ) ,
  .awlen       ( m_axi_awlen       ) ,
  .awsize      ( m_axi_awsize      ) ,
  .wvalid      ( m_axi_wvalid      ) ,
  .wready      ( m_axi_wready      ) ,
  .wdata       ( m_axi_wdata       ) ,
  .wstrb       ( m_axi_wstrb       ) ,
  .wlast       ( m_axi_wlast       ) ,
  .bvalid      ( m_axi_bvalid      ) ,
  .bready      ( m_axi_bready      ) ,
  .bid         ( m_axi_bid         ) ,
  .s_tvalid    ( ~wr_fifo_tvalid_n ) ,
  .s_tready    ( wr_fifo_tready    ) ,
  .s_tdata     ( wr_fifo_tdata     )
);

assign ap_done = write_done;

endmodule : sdx_kernel_wizard_0_example_vadd
`default_nettype wire

