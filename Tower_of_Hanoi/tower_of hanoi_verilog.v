
	
module dflip(q,q1,d,clock,enable,adj);
    output q,q1;
	input d,clock;
	input enable;
	input adj;

	reg q,q1;
	reg temp;

	initial
		begin
			if (adj==1'b1)
				q<=1;
			else
				q<=0;
		end

	always @(posedge clock)
		begin
			
			if(enable)
				begin
			 		q<=adj;
					q<=d;
				end
			else
				q<=q;
		end
		
endmodule

module tflip(q,q1,t,clock,enable);
	output q,q1;
	input t,clock;
	input enable;
	reg q,q1;
	initial 
   		begin 
			q<=1'b0;
			q1<=1'b1;
   		end
	always @ (posedge clock)
		begin
			if(clock & enable)
			 	begin
					if (t==1'b0) begin q<=q; q1<=q1; end
			   		else begin q<=~q; q1<=~q1; end
			 	end
			else
				q<=0;
		end
endmodule

		

module counter
	( 	input wire clock,
	    
	    input wire high,
	    output reg row1,
	    output reg row2,
	    output reg row3,
	    output reg row4
	);
	wire temp[3:0];//as temp is connected to an output port it should always be of type wire
	
    reg tempinp[2:0];
	reg andu[2:0];
	reg andb[6:0];
    reg or1=1;                                //innnitially giving enable as high
	reg one=1;
	
	tflip t1(temp[0],,one,clock,or1); 
    tflip t2(temp[1],,andu[0],clock,or1); 
	tflip t3(temp[2],,andu[1],clock,or1);
	tflip t4(temp[3],,andu[2],clock,or1);
	
	always @(*)
		begin 
			
	
			andu[0]<=high&temp[0];
			
			tempinp[0]<=andu[0];
			
			andu[1]<=andu[0]&temp[1];
			tempinp[1]<=andu[1];
			
			andu[2]<=andu[1]&temp[2];
			tempinp[2]<=andu[2];
			
			
	        
			or1<=~temp[3]|temp[0]|temp[1]|temp[2];
		    
			
			andb[0]<=high&temp[0];
			andb[1]<=high&~temp[0];
			
			andb[2]<=andb[1]&temp[1];
			andb[3]<=andb[1]&~temp[1];
			
			andb[4]<=andb[3]&temp[2];
			andb[5]<=andb[3]&~temp[2];
			
			andb[6]<=andb[5]&temp[3];
			
			row1<=andb[0];
			row2<=andb[2];
			row3<=andb[4];
			row4<=andb[6];
			 
			
		end
      
endmodule
        
module memory1
	
	( input wire clock,
	  input wire rowd,
	  //input wire adjust,
	 output reg topeg0,
	 output reg topeg1,
	 output reg frompeg0,
	 output reg frompeg1
	);
	
	wire temp[3:0];                            //as temp is connected to an output port it should always be of type wire
	reg tempinp[3:0];

	
	
		
	dflip d1(temp[0],,tempinp[0],clock,rowd,0);  //for to peg lsb 
	dflip d2(temp[1],,tempinp[1],clock,rowd,1);     // for from peg lsb
	dflip d3(temp[2],,tempinp[2],clock,rowd,1);   //for to peg msb
	dflip d4(temp[3],,tempinp[3],clock,rowd,0);    //for form peg msb
	
	
	
		
	 
    

	always @(*)
		begin
			tempinp[0]<=~(temp[0]&temp[1]);
			tempinp[1]<=temp[0];
			
			tempinp[2]<=~(temp[2]&temp[3]);
			tempinp[3]<=temp[2];
			
			
			topeg1<=temp[2]&rowd;
			topeg0<=temp[0]&rowd;
			frompeg1<=temp[3]&rowd;
			frompeg0<=temp[1]&rowd;
			
		end
endmodule			

module memory
	
	( input wire clock,
	  input wire rowd,
	  //input wire adjust,
	 output reg topeg0,
	 output reg topeg1,
	 output reg frompeg0,
	 output reg frompeg1
	);
	
    wire temp[3:0];                            //as temp is connected to an output port it should always be of type wire
	reg tempinp[3:0];
	
	
			
	dflip d1(temp[0],,tempinp[0],clock,rowd,1);  //for to peg lsb 
	dflip d2(temp[1],,tempinp[1],clock,rowd,1);   // for from peg lsb
	dflip d3(temp[2],,tempinp[2],clock,rowd,1);   //for to peg msb
	dflip d4(temp[3],,tempinp[3],clock,rowd,0);    //for form peg msb
	
    
	always @(*)
		begin
			
			topeg1<=temp[2]&rowd;
			topeg0<=temp[0]&rowd;
			frompeg1<=temp[3]&rowd;
			frompeg0<=temp[1]&rowd;
			
			tempinp[0]<=~(temp[0]&temp[1]);
			
			tempinp[1]<=temp[0];
			
			tempinp[2]<=~(temp[2]&temp[3]);
			tempinp[3]<=temp[2];
			
		end
endmodule


`timescale 1ns/1ps
module main
	( input wire high,
	  input wire [3:0]tempout,
	  input wire clock,
	  output reg [1:0]finaltp,
	  output reg [1:0]finalfp
	 
	);
	//wire tempout[3:0];
	
	wire temp1tp[1:0];
	wire temp1fp[1:0];
	
	wire temp2tp[1:0];
	wire temp2fp[1:0];
	
	wire temp3tp[1:0];
	wire temp3fp[1:0];
	
	wire temp4tp[1:0];
	wire temp4fp[1:0];
	//reg or1=1;
	//reg or2[3:0];
	//wire rowout[3:0]=4'b1000;
	
	counter c1(clock,high,tempout[0],tempout[1],tempout[2],tempout[3]);

	
	memory m1(clock,tempout[0],temp1tp[0],temp1tp[1],temp1fp[0],temp1fp[1]);
	
	memory1 m2(clock,tempout[1],temp2tp[0],temp2tp[1],temp2fp[0],temp2fp[1]);
	
	memory m3(clock,tempout[2],temp3tp[0],temp3tp[1],temp3fp[0],temp3fp[1]);
	
	memory m4(clock,0,temp4tp[0],temp4tp[1],temp4fp[0],temp4fp[1]);
	
	
	
	always @(*)
		begin
			
			finaltp[1]<=temp1tp[1]|temp2tp[1]|temp3tp[1]|temp4tp[1];     //for to peg
			finaltp[0]<=temp1tp[0]|temp2tp[0]|temp3tp[0]|temp4tp[0];
			
			
			finalfp[1]<=temp1fp[1]|temp2fp[1]|temp3fp[1]|temp4fp[1];      //for from peg
			finalfp[0]<=temp1fp[0]|temp2fp[0]|temp3fp[0]|temp4fp[0];
		end
	
endmodule

`timescale 1ns/1ps
module stimulus;
	reg high;
	//reg [3:0]tempout;
	reg clock;
	wire [1:0]finaltp;
	wire [1:0]finalfp;
	
	main uut(.high(high),.clock(clock),.finaltp(finaltp),.finalfp(finalfp));
	
	initial 
		begin
			$display("Tower of Hanoi problem - Hardware implementation");
			$display("Pegs = 3 disks = 3");
			$dumpfile("test.vcd");
			$dumpvars(0,stimulus);
			high<=1;
			
			
		end
	
	integer i;
	
	initial
		begin
			clock=0;
			for (i=0;i<=13;i=i+1)
				#10 clock=~clock;
			    
		
		end

	
	
	initial
		begin
			#10;
			$monitor("Frompeg: %d,Topeg: %d",finalfp,finaltp);
		end
endmodule		
			
			
			
			
			
			
			
			
			
			
			
			
	 
	
	
	
	
