`timescale 1ns / 1ps
module axi_skid_buffer #(parameter int DATA_WIDTH = 32) (
    input  logic clk, rst_n, s_valid, m_ready,
    output logic s_ready, m_valid,
    input  logic [DATA_WIDTH-1:0] s_data,
    output logic [DATA_WIDTH-1:0] m_data
);
    logic [DATA_WIDTH-1:0] data_reg, skid_reg;
    logic valid_reg, skid_valid;
    assign s_ready = ~skid_valid; assign m_valid = valid_reg; assign m_data = data_reg;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin valid_reg <= 1'b0; skid_valid <= 1'b0; data_reg <= '0; skid_reg <= '0; end
        else if (s_ready && s_valid) begin data_reg <= s_data; valid_reg <= 1'b1; end
    end
endmodule
