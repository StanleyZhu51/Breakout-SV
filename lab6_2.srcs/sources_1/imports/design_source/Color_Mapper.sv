//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [9:0] PaddleX, PaddleY,
                       input logic [9:0] blockX [64], 
                       input logic [9:0] blockY [64],
                       input logic [63:0] blockOn_arr,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on, paddle_on, block_on;
    logic [63:0] blockOn_local;
	parameter [9:0] paddleLen=20;      // Step size on the Y axis
    parameter [9:0] paddleWidth=5;      // Step size on the Y axis
    
    parameter [9:0] BlockLen=15;      // Step size on the Y axis
    parameter [9:0] BlockWidth=7;      // Step size on the Y axis
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
    
//    int paddleLen, paddleWidth;
//    assign paddleLen = PaddleS*10'd20;
//    assign paddleWidth = PaddleS*10'd5;
    always_comb
    begin:Paddle_on_proc
        if ((DrawX > PaddleX+paddleLen)||(DrawX < PaddleX-paddleLen)||(DrawY > PaddleY+paddleWidth)||(DrawY < PaddleY-paddleWidth))
            paddle_on = 1'b0;
        else 
            paddle_on = 1'b1;
     end
  
    always_comb
    begin:Ball_on_proc
        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
     
     
    always_comb
    begin:Block_on_proc
        for(int j = 0; j < 4; j++) begin
            for(int i = 0; i < 16; i++) begin
                if ((DrawX > blockX[16*j+i]+BlockLen)||(DrawX < blockX[16*j+i]-BlockLen)||(DrawY > blockY[16*j+i]+BlockWidth)||(DrawY < blockY[16*j+i]-BlockWidth))
                    blockOn_local[16*j+i] = 1'b0;
                else 
                begin
                    blockOn_local[16*j+i] = blockOn_arr[16*j+i];
                end
            end
        end
     end 
//    always_comb
//    begin:Block_on_proc
//        if ((DrawX > blockX+BlockLen)||(DrawX < blockX-BlockLen)||(DrawY > blockY+BlockWidth)||(DrawY < blockY-BlockWidth))
//            block_on = 1'b0;
//        else 
//        begin
//            block_on = blockOn;
//        end
//     end
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) begin 
            Red = 4'hc;
            Green = 4'hc;
            Blue = 4'hc;
        end   
        else if(paddle_on == 1'b1) begin
            Red = 4'h5;
            Green = 4'h5;
            Blue = 4'hf;
        end  
        else if(blockOn_local[15:0] > 1'b0) begin
            Red = 4'ha;
            Green = 4'h0;
            Blue = 4'h0;
        end 
        else if(blockOn_local[31:16] > 1'b0) begin
            Red = 4'hf;
            Green = 4'h5;
            Blue = 4'ha;
        end 
        else if(blockOn_local[47:32] > 1'b0) begin
            Red = 4'h0;
            Green = 4'ha;
            Blue = 4'h0;
        end 
        else if(blockOn_local[63:48] > 1'b0) begin
            Red = 4'hf;
            Green = 4'hf;
            Blue = 4'h5;
        end 
//        else if(block_on == 1'b1) begin
//            Red = 4'ha;
//            Green = 4'h0;
//            Blue = 4'h0;
//        end 
        else begin 
            Red = 4'h2; 
            Green = 4'h2;
            Blue = 4'h2;
        end      
    end 
    
endmodule
