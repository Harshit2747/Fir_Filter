module tb_fir_filter(); 

parameter N = 16;

reg clk, reset;
reg signed [N-1:0] data_in;
wire signed [N-1:0] data_out; 

fir_filter dut(clk, reset, data_in, data_out);

// input sine wave data
initial
$readmemb("signal.data", RAMM);

// Create the RAM
reg [N-1:0] RAMM [31:0]; 

// create a clock
initial 
clk = 0;
always 
#10 clk = ~ clk;  

// Read RAMM data and give to design
always@(posedge clk)
    data_in <= RAMM[Address]; 
    
// Address counter
reg [8:0] Address; 
initial
Address = 1; 
always@(posedge clk)
begin
    if (Address == 31)
        Address = 0; 
    else
        Address = Address + 1; 
end     
endmodule
