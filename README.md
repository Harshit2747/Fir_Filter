# Fir_Filter

This project demonstrates the implementation of a 3rd-order moving average filter using both Verilog (for hardware) and MATLAB (for simulation & verification). A moving average filter is a simple FIR filter used in digital signal processing to remove noise and smooth out signal fluctuations.

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

     module fir_filter(clk, reset, data_in, data_out);

     parameter N = 16;

     input clk, reset;
     input signed [N-1:0] data_in;
     output reg signed  [N-1:0] data_out; 

     // coefficients defination
     // 0.25 x 128(scaling factor) = 32 = 6'b100000
        wire [5:0] b0 =  6'b000000; 
        wire [5:0] b1 =  6'b000001; 
        wire [5:0] b2 =  6'b000111; 
        wire [5:0] b3 =  6'b001111;
        wire [5:0] b4 =  6'b010011; 
        wire [5:0] b5 =  6'b001111; 
        wire [5:0] b6 =  6'b000111; 
        wire [5:0] b7 =  6'b000001;
        wire [5:0] b8 =  6'b000000; 
        wire [N-1:0] x1, x2, x3, x4,x5,x6,x7, x8; 

     // Create delays i.e x[n-1], x[n-2], .. x[n-N]
     // Instantiate D Flip Flops
     DFF DFF0(clk, 0, data_in, x1); // x[n-1]
      DFF DFF1(clk, 0, x1, x2);      // [x[n-2]]
      DFF DFF2(clk, 0, x2, x3); 
      DFF DFF3(clk, 0, x3,x4); // x[n-1]
      DFF DFF4(clk, 0, x4,x5);      // [x[n-2]]
      DFF DFF5(clk, 0,x5,x6);
     DFF DFF6(clk, 0, x6,x7); // x[n-1]
      DFF DFF7(clk, 0, x7,x8);

    //  Multiplication
     wire [N-1:0] Mul0, Mul1, Mul2, Mul3,Mul4, Mul5, Mul6, Mul7, Mul8;  
     assign Mul0 = b0; 
     assign Mul1 = data_in * b1;  
     assign Mul2 = x1 * b2;  
     assign Mul3 = x2 * b3;  
     assign Mul4 = x3 * b4;  
     assign Mul5 = x4 * b5;  
     assign Mul6 = x5 * b6;  
     assign Mul7 = x6 * b7;
     assign Mul8 = x7 * b8; 
 
    wire [N-1:0] Add_final; // Addition operation
     assign Add_final = Mul0 + Mul1 + Mul2 + Mul3+Mul4+ Mul5+ Mul6+ Mul7+Mul8; 
    always@(posedge clk) data_out <= Add_final; // Final calculation to output 

    endmodule

     module DFF(clk, reset, data_in, data_delayed);
     parameter N = 16;
     input clk, reset;   input [N-1:0] data_in;
     output reg [N-1:0] data_delayed; 
 
    always@(posedge clk)
    begin
    if (reset)
    data_delayed <= 0;
    else
    data_delayed <= data_in;    
    end
    endmodule






# MATLAB CODE:-

    % Generate a sine wave
    close all; clear all;
    fs = 5;
    Amp = 1;
    t = 0:1/fs:2*pi; % time vector
    sine_wave = Amp*sin(t);
    figure();
    plot(t, sine_wave);
    xlabel('\bf Time');
    ylabel('\bf Amplitude');
    title('\bf Sine wave');

    % Add a noise
    a = 0.1; % upper limit
    b = 0; % lower limit
    noise = (b-a).*rand(length(sine_wave),1) + a; noise = noise';
    sine_noise = (sine_wave + noise);
    sine_norm = sine_noise / max(abs(sine_noise));
    figure();plot(1:length(sine_norm), sine_norm);
    xlabel('\bf Time');
    ylabel('\bf Amplitude');
    title('\bf Sine wave + Noise');

    % Convert from real to integers
    total_wordlength = 16;
    scaling = 7;
    sine_noise_integers = round(sine_norm.*(2^scaling));
    figure();plot(1:length(sine_noise_integers), sine_noise_integers);
    xlabel('\bf Time');
    ylabel('\bf Amplitude');
    title('\bf Sine wave + Noise : Scaled Signal');

    % Convert from integers to binary
    sine_noise_in_binary_signed = 
    dec2bin(mod((sine_noise_integers),2^total_wordlength),total_wordlength);
    yy = cellstr(sine_noise_in_binary_signed);
    fid = fopen('signal.data', 'wt');
    fprintf(fid, '%8s \n', yy{:});
    disp('text file for signal finished');






# MATLAB SIGNAL GENERATED:- signal.data

a). Binary input generated in MATLAB to use it as an input in verilog code.

      0000000000000010 
      0000000000011010 
      0000000000111011 
      0000000001000111 
      0000000001011110 
      0000000001110100 
      0000000001111101 
      0000000010000000 
      0000000001111101 
      0000000001111001 
      0000000001111011 
      0000000001100101 
      0000000001010100 
      0000000001000110 
      0000000000101100 
      0000000000011100 
      0000000000000000 
      1111111111100001 
      1111111111001100 
      1111111110110101 
      1111111110100110 
      1111111110100000 
      1111111110001100 
      1111111110000101 
      1111111110001000 
      1111111110001100 
      1111111110010101 
      1111111110101000 
      1111111110110110 
      1111111111010001 
      1111111111100001 
      0000000000000010 



 


b). Sine wave generated in MATLAB before addition of noise:-





![Screenshot (134) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/3331c93f-5dee-46e4-8a40-f89f97894b71)





c). Sine wave generated in MATLAB after addition of noise.



![Screenshot (133) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/07dd7bc0-1737-4d74-a8a9-0f6f3c873cd2)





# Circuit diagram to implement FIR FILTER:-


![Screenshot (128) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/6fc43e2f-eb57-4e57-b261-2c99634744be)




# RESULT:-

![Screenshot (137) 1](https://github.com/Harshit2747/Fir_Filter/assets/167745025/0e30710f-cd8a-4729-a12c-7a17ed1b4da8)








