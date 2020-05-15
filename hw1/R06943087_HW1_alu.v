module alu(
             clk_p_i,
             reset_n_i,
             data_a_i,
             data_b_i,
             inst_i,
             data_o
             );
  /* ============================================ */
      input           clk_p_i;
      input           reset_n_i;
      input   [7:0]   data_a_i;
      input   [7:0]   data_b_i;
      input   [2:0]   inst_i;

      output reg  [15:0]  data_o;

      reg     [15:0]   ALU_d2_w;
      reg     [7:0]    data_a_d1_r;
      reg     [7:0]    data_b_d1_r;
      reg     [2:0]    inst_d1_r;

  /* ============================================ */
      always@(*)
      begin
          case(inst_d1_r)
            3'b000:    ALU_d2_w = {{8{data_a_d1_r[7]}},data_a_d1_r} + {{8{data_b_d1_r[7]}},data_b_d1_r}; //a+b
            3'b001:    ALU_d2_w = {{8{data_b_d1_r[7]}},data_b_d1_r} - {{8{data_a_d1_r[7]}},data_a_d1_r}; //b-a
            3'b010:    ALU_d2_w = {{8{data_a_d1_r[7]}},data_a_d1_r} * {{8{data_b_d1_r[7]}},data_b_d1_r}; //a*b
            3'b011:    ALU_d2_w = data_a_d1_r & data_b_d1_r; //a&b
            3'b100:    ALU_d2_w = data_a_d1_r ^ data_b_d1_r; //a or b
            3'b101:
            begin
                if(data_a_d1_r[7] == 1)
                    ALU_d2_w = ~({{8{data_a_d1_r[7]}},data_a_d1_r})+16'd1;
                else   
                    ALU_d2_w = {{8{data_a_d1_r[7]}},data_a_d1_r};
            end
            3'b110:    ALU_d2_w = (data_a_d1_r + data_b_d1_r) >> 1;
            3'b111:    ALU_d2_w = (data_b_d1_r % data_a_d1_r);
            default:   ALU_d2_w = ALU_d2_w;
          endcase
      end

  /* ============================================ */
      always@(posedge clk_p_i or negedge reset_n_i)
      begin
          if (reset_n_i == 1'b0)
          begin
            data_o <= 16'd0;
            data_a_d1_r <= 8'd0;
            data_b_d1_r <= 8'd0;
            inst_d1_r <= 3'd0;
          end
          else
          begin
            data_a_d1_r <= data_a_i;
            data_b_d1_r <= data_b_i;
            inst_d1_r <= inst_i;
            data_o <= ALU_d2_w;
          end
      end
  /* ============================================ */

endmodule

