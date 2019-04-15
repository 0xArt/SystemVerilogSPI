module spi_master_testbench();

	logic clk;
	logic MISO;
   logic MOSI;
	logic SS;
	logic SCK;
	
	real clock = 50e6;	
	real clockDelay = ((1/clock)/2)*(1e9);
	
	int counter = 0;
	
	logic [7:0] recievedByte;

	
	spi_master spi_master_inst(clk, MISO, MOSI, SS, SCK);
	
	always begin
		#clockDelay;
		clk = 1'b1;
		#clockDelay;
		clk = 1'b0;
	end
		
	always @(posedge SCK)begin
		if( SS == 1'b0 ) begin
			if(counter < 8) begin
					recievedByte[counter] <= MOSI;
					counter++;
			end
			else begin
				if(recievedByte == 8'h53)begin
					$display("Correct byte recieved");
					$stop;
				end
				else begin
					$display("Incorrect byte recieved");
					$stop;
				end
			end
		end
		else begin
			counter <= 0;
		end
	end
	
endmodule
	