module tt_um_15m43LG(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


  logic  out;
  logic clk2, clk4, clk8, clk16, en1, en2, en4, en8;
  logic [7:0] lim1, lim2, lim4, lim8;
  logic [7:0] cont1, cont2, cont4, cont8; 


  always_ff @(posedge clk) begin
      lim1 <= (ui_in >> 1) + 'b1;
      lim2 <= (ui_in >> 2) + 'b1;
      lim4 <= (ui_in >> 3) + 'b1;
      lim8 <= (ui_in >> 4) + 'b1;
  end


  always_ff @(posedge clk) begin
      clk2 <= !clk2;
  end 

  always_ff @(posedge clk2) begin
      clk4 <= !clk4;
  end 

  always_ff @(posedge clk4) begin
      clk8 <= !clk8;
  end 

  always_ff @(posedge clk8) begin
      clk16 <= !clk16;
  end


  always_ff @(posedge clk) begin
    if ((cont1 >= 'b10000) | rst_n) begin
          cont1 <= 'b1;
      end else begin
          cont1 <= cont1 + 'b1;
      end
  end
  
  always_comb begin
      if (cont1 > lim1) begin
          en1 = 0;
      end else begin
          en1 = 1;
      end
  end 

  always_ff @(posedge clk2) begin
    if ((cont2 >= 'b1000) | rst_n) begin
          cont2 <= 'b1;
      end else begin
          cont2 <= cont2 + 'b1;
      end
  end
  always_comb begin
      if (cont2 > lim2) begin
          en2 = 0;
      end else begin
          en2 = 1;
      end
  end 

  always_ff @(posedge clk4) begin
    if ((cont4 >= 'b100) | rst_n) begin
          cont4 <= 'b1;
      end else begin
          cont4 <= cont4 + 'b1;
      end
  end
  always_comb begin
      if (cont4 > lim4) begin
          en4 = 0;
      end else begin
          en4 = 1;
      end
  end 

  always_ff @(posedge clk8) begin
    if ((cont8 >= 'b10) | rst_n) begin
          cont8 <= 'b1;
      end else begin
          cont8 <= cont8 + 'b1;
      end
  end
  always_comb begin
      if (cont8 > lim8) begin
          en8 = 0;
      end else begin
          en8 = 1;
      end
  end 

  always_comb begin
      if (!ena) begin
          out  = 0;
      end else begin
        out  = ((clk & ui_in[0] & en1) | (clk2 & ui_in[1] & en2) | (clk4 & ui_in[2] & en4) | (clk8 & ui_in[3] & en8) | (clk16 & ui_in[4]));
      end

  end

  always_comb begin
    uo_out[0] = out;
    uo_out[1] = out;
    uo_out[2] = out;
    uo_out[3] = out;
    uo_out[4] = out;
    uo_out[5] = out;
    uo_out[6] = out;
    uo_out[7] = out;
  end

endmodule
