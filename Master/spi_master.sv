module spi_master(
input logic clk,
input logic MISO,
output logic MOSI,
output logic SS,
output logic SCK
);
	logic [7:0] bitCounter = 0;
	logic [7:0] toSend = 8'h53;
	logic enableClock = 1'b0;
	logic [7:0] clockCounter = 0;
	logic [7:0] delayCounter = 0;
	logic [7:0] delay = 0;


	enum logic [2:0] {IDLE=3'b000, SS_ON=3'b001, SEND_BIT=3'b010, DELAY=3'b011} state;
	
	always_ff @(posedge clk) begin
	
		casex(state) 
		
			IDLE: begin
				SS <= 1'b1;
				bitCounter <= 0;
				MOSI <= 1'b1;
				state <= SS_ON;
				enableClock <= 1'b1;
			end
		
			SS_ON: begin
				SS <= 1'b0;
				MOSI <= 1'b0;
				delay <= 1;
				state <= DELAY;
			end
			
			SEND_BIT: begin
				MOSI <= toSend[bitCounter-1];
				delay <= 7;
				state <= DELAY;
			
			end
			
			DELAY: begin
			
				if(delayCounter == delay - 1) begin
					bitCounter++;
					delayCounter <= 0;
					state<=SEND_BIT;
				end
				else begin
					delayCounter++;
				end
			
			end

			
			
			
		endcase
	end
	
	
	
	
	
	always_ff @(posedge clk) begin
	
		if(enableClock == 1'b1)begin
			if(clockCounter == 0)begin
				SCK <= ~SCK;
			end

			if( clockCounter  < 3) begin
				clockCounter++;
			end
			else begin
				clockCounter <= 0;
			end
		end
		else begin
			SCK <= 1'b1;
			clockCounter <= 0;
			
		end
	
	end


endmodule 