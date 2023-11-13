//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input logic Reset, frame_clk,
			   input logic [7:0] keycode,
			   input logic up, down, left, right,
               input logic [9:0]  PaddleX, PaddleY, 
               output logic [9:0]  BallX, BallY, BallS );
    
    logic [9:0] Ball_X_Motion, Ball_Y_Motion;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] paddleLen=20;      // Step size on the Y axis
    parameter [9:0] paddleWidth=5;      // Step size on the Y axis


    
    assign BallS = 8;  // default ball size
   
    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)  // asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd1; //Ball_Y_Step;
			Ball_X_Motion <= 10'd1; //Ball_X_Step;
			BallY <= Ball_Y_Center;
			BallX <= Ball_X_Center;
        end
        // bounds check
        else 
        begin 
				 if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
				 begin
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  Ball_X_Motion <= Ball_X_Motion;
//					  Ball_Y_Motion <= Ball_Y_Motion;
				 end  
				 else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
				 begin
					  Ball_Y_Motion <= Ball_Y_Step;
					  Ball_X_Motion <= Ball_X_Motion;
			     end
				 else if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
				 begin
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  Ball_Y_Motion <= Ball_Y_Motion;
			     end		  
				 else if ( (BallX - BallS) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
				 begin
					  Ball_X_Motion <= Ball_X_Step;
					  Ball_Y_Motion <= Ball_Y_Motion;
			     end
                 else if(((BallY + BallS) == (PaddleY - paddleWidth)) && ((BallX + BallS) >= PaddleX - paddleLen) && ((BallX - BallS) <= (PaddleX + paddleLen)))
//                 else if(((BallY + BallS) == (PaddleY - 10'd5)) && ((BallX + BallS) >= PaddleX - paddleLen) && ((BallX - BallS) <= (PaddleX + paddleLen)))
                 begin
                      Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  
					  Ball_X_Motion <= Ball_X_Motion;
                 end
                 else if(up == 1'b1) // block up edge
                 begin
                      Ball_Y_Motion <= Ball_Y_Step;
					  Ball_X_Motion <= Ball_X_Motion;
					  
                 end
                 else if(down == 1'b1) // block down edge
                 begin
                      Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  Ball_X_Motion <= Ball_X_Motion;
                 end
                 else if(left == 1'b1) // block left edge
                 begin
                      Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  Ball_Y_Motion <= Ball_Y_Motion;
                 end
                 else if(right == 1'b1) // block right edge
                 begin
                      Ball_X_Motion <= Ball_X_Step;
					  Ball_Y_Motion <= Ball_Y_Motion;
                 end
                 else 
                 begin
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  Ball_X_Motion <= Ball_X_Motion;
				 end
			
				 BallY <= (BallY + Ball_Y_Motion);  // Update ball position
				 BallX <= (BallX + Ball_X_Motion);
			
		end  
    end
      
endmodule
