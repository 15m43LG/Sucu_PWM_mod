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


logic [7:0] control;
logic [7:0] out;
logic clk1, clk2, clk4, clk8, clk16, en1, en2, en4, en8;
logic [7:0] tempcontrol1, tempcontrol2, tempcontrol4, tempcontrol8;
logic [7:0] lim1, lim2, lim4, lim8;
logic [7:0] cont1, cont2, cont4, cont8; 

always_comb begin
    control = ui_in;
    assign uo_out = out;
end

initial begin
    cont1 = 0;
    cont2 = 0;
    cont4 = 0;
    cont8 = 0;
    clk1 = 0;
    clk2 = 0;
    clk4 = 0;
    clk8 = 0;
    clk16 = 0;
end

always_comb begin
    tempcontrol1 = control;
    tempcontrol2 = control;
    tempcontrol4 = control;
    tempcontrol8 = control;

    tempcontrol1 = (tempcontrol1 >> 1) + 'b1;
    tempcontrol2 = (tempcontrol2 >> 2) + 'b1;
    tempcontrol4 = (tempcontrol4 >> 3) + 'b1;
    tempcontrol8 = (tempcontrol8 >> 4) + 'b1;

    lim1 = tempcontrol1;
    lim2 = tempcontrol2; 
    lim4 = tempcontrol4;
    lim8 = tempcontrol8;
end


always_comb begin
    clk1 = clk;
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


always_ff @(posedge clk1) begin
    if (cont1 >= 'b10000) begin
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
    if (cont2 >= 'b1000) begin
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
    if (cont4 >= 'b100) begin
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
    if (cont8 >= 'b10) begin
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
      out [0] = ((clk1 & control[0] & en1) | (clk2 & control[1] & en2) | (clk4 & control[2] & en4) | (clk8 & control[3] & en8) | (clk16 & control[4]));
    end
    
end
    
endmodule
