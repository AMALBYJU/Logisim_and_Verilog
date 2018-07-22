/*
The following is the verilog code for a 1 bit ALU that can perform the following logical and arithmetic operations - AND,OR,NOR,NAND,ADD and SUBTRACT. There are 2 additional flags - zero and a flag to check whether the first input is greater than the second input.
*/

module fullbitadder(input A,input B,input carryin,output sum,output carryout); 

 assign sum = (A ^ B ^ carryin);
 assign carryout = ((A ^ B) & carryin)|(A & B);

endmodule

module mux2input(input x,input y,input signal,output OUTPUT);

 assign OUTPUT = (x & ~signal)|(y & signal);

endmodule

module mux3input(input x1,input x2,input x3,input [1:0]signal,output OUTPUT);

 assign OUTPUT = (~signal[0] & ~signal[1] & x1)|(signal[0] & ~signal[1] & x2)|(~signal[0] & signal[1] & x3); 

endmodule
 
module onebitalu(input a,input b,input ainv,input binv,input carryin,input [1:0]operation,output carryout,output result,output zero,output sgt);

 wire A;
 wire B;
 wire sum; // This wire carries (a+b) when ainv = 0,binv = 0 and carryin = 0. The wire carries (a-b) when ainv = 0, binv = 1 and carryin = 1
 wire a_and_b; // This wire carries value (a and b) when ainv = 0 and binv = 0. The wire carries (a nor b) when ainv = 1 and binv = 1
 wire a_or_b;  // This wire carries value (a or b) when ainv = 0 and binv = 0. The wire carries (a nand b) when ainv = 1 and binv = 1
 
 
 fullbitadder f(A,B,carryin,sum,carryout);  //1 bit adder to compute a+b or a-b
 
 mux2input m1(a,~a,ainv,A);  //Output of this 2 to 1 mux depends on ainv signal 
 mux2input m2(b,~b,binv,B);  //Output of this 2 to 1 mux depends on binv signal
 
 mux3input M(a_and_b,a_or_b,sum,operation,result);
 
 assign zero = ~result;     //Zero flag
 assign sgt = (a & ~b);     //Set greater than flag : When a = 1 and b = 0,its output is 1
 assign a_and_b = A & B;    
 assign a_or_b = A | B;

endmodule

module stimulus;

 reg a;
 reg b;
 reg ainv;
 reg binv;
 reg carryin;
 wire carryout;
 reg [1:0]operation;  
 wire zero;
 wire result;
 wire sgt;
 
 /*
 
 Input code
 
 ainv  binv  carryin operation   
 
  0     0      X        00     -- AND  
  0     0      X        01     -- OR
  1     1      X        00     -- NOR
  1     1      X        01     -- NAND
  0     0      0        00     -- ADD
  0     1      1        00     -- SUBTRACT
  
  */
  
 
 onebitalu uut(a,b,ainv,binv,carryin,operation,carryout,result,zero,sgt);
 
 initial begin
 
 $dumpfile("onebitalu.vcd");
 $dumpvars(0,stimulus);
 
 $display("A  B  Ainvert  Binvert  Carry_In  Operation  Carry_Out  Result  Zero  Set_greater_than\n");
 
 #0 a=0;b=0;ainv=0;binv=0;carryin=0;operation=0;
 #10 a=0;b=1;ainv=0;binv=0;carryin=0;operation=1;
 #10 a=0;b=1;ainv=0;binv=0;carryin=0;operation=2;
 #10 a=1;b=1;ainv=0;binv=1;carryin=1;operation=2;
 #10 a=1;b=0;ainv=0;binv=1;carryin=1;operation=2;
 #10 a=1;b=1;ainv=0;binv=0;carryin=0;operation=2;
 #10 a=1;b=1;ainv=0;binv=0;carryin=0;operation=0;
 #10 a=0;b=1;ainv=1;binv=1;carryin=0;operation=1;
 #10 a=0;b=0;ainv=1;binv=1;carryin=0;operation=0;
 #10 a=1;b=1;ainv=0;binv=0;carryin=0;operation=2;
 #10 a=1;b=1;ainv=0;binv=1;carryin=1;operation=2;
 #10 a=1;b=0;ainv=0;binv=1;carryin=1;operation=2;
 #10;
 
 end
 
 initial begin
 
   $monitor("%d  %d     %d        %d        %d         %2b          %d        %d      %d          %d",a,b,ainv,binv,carryin,operation,carryout,result,zero,sgt);
   
 end
 
endmodule

 
