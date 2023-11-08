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
               output logic [9:0]  PaddleX, PaddleY, PaddleS );
    
    logic [9:0] Paddle_X_Motion, Paddle_Y_Motion;
	 
    parameter [9:0] Paddle_X_Center=320;  // Center position on the X axis
    parameter [9:0] Paddle_Y_Center=430;  // Center position on the Y axis
    parameter [9:0] Paddle_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Paddle_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Paddle_X_Step=1;      // Step size on the X axis
//    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign PaddleS = 1;  // default ball size
    assign paddleLen = PaddleS*10'd20;
    assign paddleWidth = PaddleS*10'd5;
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
//				 if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
//				 else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//					  Ball_Y_Motion <= Ball_Y_Step;
					  
//				 else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
//					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
//				 else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
//					  Ball_X_Motion <= Ball_X_Step;

// 0x50 = left
// 0x4f = right
                 if (PaddleX+10'd20 >= Paddle_X_Max) 
				 begin
                         Paddle_X_Motion <= -10'd1;
                 end
                 else if (PaddleX-10'd20 <= Paddle_X_Min) // 
				 begin
                         Paddle_X_Motion <= 10'd1;
                 end
                 else if (keycode == 8'h50) // left pressed
				 begin
                         Paddle_X_Motion <= -10'd1;
                 end
                 else if (keycode == 8'h4f) // right pressed
                 begin
                         Paddle_X_Motion <= 10'd1;
                 end
  
                 else 
					  Paddle_X_Motion <= 10'd0;  // no key, stop
			
//				 BallY <= (BallY + Ball_Y_Motion);  // Update Paddle position
				 PaddleX <= (PaddleX + Paddle_X_Motion);
		end  
    end
      
endmodule
