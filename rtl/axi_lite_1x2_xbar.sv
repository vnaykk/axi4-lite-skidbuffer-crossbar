`timescale 1ns / 1ps
module axi_lite_1x2_xbar #(parameter int ADDR_WIDTH = 32, parameter int DATA_WIDTH = 32, parameter logic [ADDR_WIDTH-1:0] SLAVE1_BASE = 32'h4000_0000) (
    input  logic clk, rst_n, s_req_valid, m0_req_ready, m1_req_ready,
    output logic s_req_ready, m0_req_valid, m1_req_valid,
    input  logic [ADDR_WIDTH-1:0] s_req_addr,
    input  logic [DATA_WIDTH-1:0] s_req_wdata,
    output logic [ADDR_WIDTH-1:0] m0_req_addr, m1_req_addr,
    output logic [DATA_WIDTH-1:0] m0_req_wdata, m1_req_wdata
);
    localparam int PACK_W = ADDR_WIDTH + DATA_WIDTH;
    logic skid_valid, skid_ready, sel_slave1;
    logic [PACK_W-1:0] skid_data;
    axi_skid_buffer #(.DATA_WIDTH(PACK_W)) u_req_skid (.clk(clk), .rst_n(rst_n), .s_valid(s_req_valid), .s_ready(s_req_ready), .s_data({s_req_addr, s_req_wdata}), .m_valid(skid_valid), .m_ready(skid_ready), .m_data(skid_data));
    assign {m0_req_addr, m0_req_wdata} = skid_data;
    assign {m1_req_addr, m1_req_wdata} = skid_data;
    assign sel_slave1 = (m0_req_addr >= SLAVE1_BASE);
    assign m0_req_valid = skid_valid & ~sel_slave1;
    assign m1_req_valid = skid_valid & sel_slave1;
    assign skid_ready = sel_slave1 ? m1_req_ready : m0_req_ready;
endmodule
