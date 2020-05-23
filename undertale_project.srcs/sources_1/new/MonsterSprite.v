`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2020 04:56:58 PM
// Design Name: 
// Module Name: MonsterSprite
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


module MonsterSprite(
    input wire [9:0] xx, // current x position
    input wire [9:0] yy, // current y position
    input wire aactive, // high during active pixel drawing
    output reg MSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout, // 8 bit pixel value from Bee.mem
    input wire BR, // right button
    input wire BL, // left button
    input wire Pclk // 25MHz pixel clock
    );
    
    // instantiate BeeRom code
    reg [9:0] address; // 2^10 or 1024, need 34 x 27 = 918
    MonsterRom MonsterVRom (.i_addr(address),.i_clk2(Pclk),.o_data(dataout));
            
    // setup character positions and sizes
    reg [9:0] PlayerX = 297; // Bee X start position
    reg [8:0] PlayerY = 433; // Bee Y start position
    localparam PlayerWidth = 34; // Bee width in pixels
    localparam PlayerHeight = 27; // Bee height in pixels
  
    always @ (posedge Pclk)
    begin
        if (xx==639 && yy==479)
            begin // check for left or right button pressed
                if (BR == 1 && PlayerX<640-PlayerWidth)
                    PlayerX<=PlayerX+1;
                if (BL == 1 && PlayerX>1)
                    PlayerX<=PlayerX-1;
            end    
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (xx==PlayerX-1 && yy==PlayerY)
                    begin
                        address <= 0;
                        MSpriteOn <=1;
                    end
                if ((xx>PlayerX-1) && (xx<PlayerX+PlayerWidth) && (yy>PlayerY-1) && (yy<PlayerY+PlayerHeight))
                    begin
                        address <= address + 1;
                        MSpriteOn <=1;
                    end
                else
                    MSpriteOn <=0;
            end
    end
endmodule
