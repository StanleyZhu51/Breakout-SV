`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 06:54:10 PM
// Design Name: 
// Module Name: paddle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  paddle ( input logic Reset, frame_clk,
			   input logic [7:0] keycode,
               output logic [9:0]  PaddleX, PaddleY);
    
    logic [9:0] Paddle_X_Motion, Paddle_Y_Motion;
	 
    parameter [9:0] Paddle_X_Center=320;  // Center position on the X axis
    parameter [9:0] Paddle_Y_Center=430;  // Center position on the Y axis
    parameter [9:0] Paddle_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Paddle_X_Max=639;     // Rightmost point on the X axis

    parameter [9:0] Paddle_X_Step=1;      // Step size on the X axis

    parameter [9:0] paddleLen=20;      // Step size on the Y axis
    parameter [9:0] paddleWidth=5;      // Step size on the Y axis


    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Paddle
        if (Reset)  // asynchronous Reset
        begin 
            Paddle_Y_Motion <= 10'd0; //Ball_Y_Step;
			Paddle_X_Motion <= 10'd0; //Ball_X_Step;
			PaddleY <= Paddle_Y_Center;
			PaddleX <= Paddle_X_Center;
        end
         
        else 
        begin 
// 0x50 = left
// 0x4f = right
                 if (PaddleX+paddleLen >= Paddle_X_Max) // right bound
				 begin
                         Paddle_X_Motion <= -10'd2;
                 end
                 else if (PaddleX-paddleLen <= Paddle_X_Min) // left bound
				 begin
                         Paddle_X_Motion <= 10'd2;
                 end
                 else if (keycode == 8'h50) // left pressed
				 begin
                         Paddle_X_Motion <= -10'd2;
                 end
                 else if (keycode == 8'h4f) // right pressed
                 begin
                         Paddle_X_Motion <= 10'd2;
                 end
  
                 else 
					  Paddle_X_Motion <= 10'd0;  // no key, stop
				 PaddleX <= (PaddleX + Paddle_X_Motion); // Update Paddle position
		end  
    end
      
endmodule
