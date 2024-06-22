# Fir_Filter

This project demonstrates the design and implementation of a Finite Impulse Response (FIR) filter using both Verilog and MATLAB. The FIR filter is a type of digital filter used in various signal processing applications due to its linear phase response and stability.Digital filtering perform mathematical operation on sampled,discrete-time signal with the purpose of attenuating or enhancing parts of the signal.

# Overview

An FIR filter is a type of digital filter that has a finite duration of response to an impulse. The output of an FIR filter is a weighted sum of the current and previous input values. This project includes:

Verilog Implementation: Suitable for hardware design and FPGA implementation.
MATLAB Implementation: Ideal for simulation and verification of filter characteristics.


# THEORITICAL STUDY:-

Finite Impulse Response Filter has exact linear phase, highly stable, computationally intensive, less-sensitive to finite word-length effects, arbitrary amplitude-frequency characteristic and real-time stable signal processing requirements etc. Thus, it is widely used in different digital signal processing applications.

We know, a finite impulse response (FIR) filter is a filter whose impulse response or response to any finite length input is of finite duration, because it settles to zero in finite time. This is however in contrast to infinite impulse response (IIR) filters, which may have internal feedback and may continue to respond indefinitely (mostly decaying). 

The impulse response of an Nth order discrete- time FIR filter works for exactly N + 1 times, from the zeroth time to the Nth time in the time domain.

For output of an FIR filter of order N , each output of the sequence is the weighted sum of most of the recent N input values. 

These weights in the summation are coefficients we obtain upon simulation in MATLAB special toolbox FDATool by method of window function, we use Hamming window for the filter design.


# PRACTICAL STUDY:

• This Verilog module implements a simple FIR filter with order 8. The data_in input represents the input sample to be filtered, and data_out represents the filtered output. The b0-b8 parameter defines the filter coefficients generated in MATLAB XDAtool, the Filter Generator, and the x1-x8 variables store the input samples.

• The filter operation is performed by multiplying each input sample in the variable list  with its corresponding coefficient and accumulating the results to produce the output sample. The clk input is used for clocking and reset input is for resetting the filter. The DFF  is a module of D Flip- Flop which is useful for us to create time-delay.


# VERILOG CODE FOR FIR_FILTER:-


     module fir(
     input clk,
     input signed [15:0] noisy_signal,
     output signed [15:0] filtered_signal
    );
   
    integer i,j;
    reg signed [15:0] coeff [0:8]={16'h 04f6,
                                16'h 0AE4,
                                16'h 1089,
                                16'h 1496,
                                16'h 160F,
                                16'h 1496,
                                16'h 1089,
                                16'h 0AE4,
                                16'h 04F6 };
    reg signed [15:0] delayed_signal [0:8];
    reg signed [31:0] prod [0:8];                             
    reg signed [32:0] sum_0 [0:4];
    reg signed [33:0] sum_1 [0:2];
    reg signed [34:0] sum_2 [0:1];
    reg signed [35:0] sum_3;  
  
    always @(posedge clk)
    begin
     delayed_signal[0]=noisy_signal;
      for(i=1; i<=8; i=i+1) begin
     delayed_signal[i] <= delayed_signal[i+1];
      end 
     end 
    
    always @(posedge clk)
    begin
       for(j=0; j<=8; j=j+1) begin
        prod[j] <= delayed_signal[j] * coeff[j];
        end                         
      end
      
       always @(posedge clk)
       begin
          sum_0[0] <= prod[0] + prod[1];
          sum_0[1] <= prod[2] + prod[3];
          sum_0[2] <= prod[4] + prod[5];
          sum_0[3] <= prod[6] + prod[7];
          sum_0[4] <= prod[8];
        end  
       always @(posedge clk)
       begin
         sum_1[0] <= sum_0[0] + sum_0[1];
         sum_1[1] <= sum_0[2] + sum_0[3];  
         sum_1[2] <= sum_0[4]; 
        end    
        
        always @(posedge clk)
       begin
         sum_2[0] <= sum_1[0] +sum_1[1];
         sum_2[1] <= sum_1[2];
        end 
       
       always @(posedge clk)
       begin
         sum_3 <= sum_2[0] + sum_2[1];
        end 
        
       assign filtered_signal = $signed (sum_3[35:14]);
       
       endmodule 






# MATLAB CODE:-








# MATLAB SIGNAL GENERATED:-

a). Binary input generated in MATLAB to use it as an input in verilog code.






b). Sine wave generated in MATLAB before addition of noise:-







c). Sine wave generated in MATLAB after addition of noise.






# Circuit diagram to implement FIR FILTER:-


![Screenshot (128) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/6fc43e2f-eb57-4e57-b261-2c99634744be)




# RESULT:-

![Screenshot (137) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/0e30710f-cd8a-4729-a12c-7a17ed1b4da8)








