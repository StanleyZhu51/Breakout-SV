`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 11:31:08 AM
// Design Name: 
// Module Name: block
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


module  block ( input logic Reset, frame_clk,
                input logic [9:0] BallX, BallY, BallS,
			    output logic blockOn, up, down, left, right,
                output logic [9:0]  blockX, blockY);
    
    
	 
    parameter [9:0] Block_X_Center=320;  // Center position on the X axis
    parameter [9:0] Block_Y_Center=100;  // Center position on the Y axis
    parameter [9:0] Block_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Block_X_Max=639;     // Rightmost point on the X axis

    parameter [9:0] BlockLen=15;      // Step size on the Y axis
    parameter [9:0] BlockWidth=7;      // Step size on the Y axis

    assign blockX = Block_X_Center;
    assign blockY = Block_Y_Center;
    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Paddle
        if (Reset)  // asynchronous Reset
        begin 
            blockOn <= 1'b1;
            up <= 1'b0;
            down <= 1'b0;
            left <= 1'b0;
            right <= 1'b0;
        end
        else 
        begin 
            if(blockOn == 1'b1)
            begin
                if(((BallY + BallS) == (Block_Y_Center - BlockWidth)) && ((BallX + BallS) >= Block_X_Center - BlockLen) && ((BallX - BallS) <= (Block_X_Center + BlockLen))) // hitting top of block
                begin
                    blockOn <= 1'b0;
                    up <= 1'b1;
                end
                else if(((BallY + BallS) == (Block_Y_Center + BlockWidth)) && ((BallX + BallS) >= Block_X_Center - BlockLen) && ((BallX - BallS) <= (Block_X_Center + BlockLen))) // hitting bottom of block
                begin
                    blockOn <= 1'b0;
                    down <= 1'b1;
                end
                else if(((BallY + BallS) >= (Block_Y_Center - BlockWidth)) && ((BallY - BallS) <= (Block_Y_Center + BlockWidth)) && ((BallX - BallS) == Block_X_Center + BlockLen)) // hitting right of block
                begin
                    blockOn <= 1'b0;
                    right <= 1'b1;
                end
                else if(((BallY + BallS) >= (Block_Y_Center - BlockWidth)) && ((BallY - BallS) <= (Block_Y_Center + BlockWidth)) && ((BallX + BallS) == Block_X_Center - BlockLen)) // hitting left of block
                begin
                    blockOn <= 1'b0;
                    left <= 1'b1;
                end
                else
                begin
                    up <= 1'b0;
                    down <= 1'b0;
                    left <= 1'b0;
                    right <= 1'b0;
                end     
            end
            else
            begin
                up <= 1'b0;
                down <= 1'b0;
                left <= 1'b0;
                right <= 1'b0;
            end
		end  
    end
      
endmodule
