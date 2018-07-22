/*
Building a 32 bit alu from 32 one bit alus.
*/
 
module fulladder(input a,input b,input cin,output sum,output cout);

 assign sum = (a ^ b ^ cin);
 assign cout = (a & b)|(b & cin)|(cin & a);
 


endmodule

module onebitalu(input a,input b,input ainv,input binv,input carryin,output carryout,input less,input [1:0]operation,output set,output OUTPUT);

 wire A,B,set,a_and_b,a_or_b,overflow;
 
 fulladder f(A,B,carryin,a_plus_b,carryout);
 
 
 
  assign A = (a & ~ainv) | (~a & ainv);
  assign B = (b & ~binv) | (~b & binv);
  assign set = a_plus_b;
  assign a_and_b = (A & B);
  assign a_or_b = (A | B);
  assign overflow = (~binv & a & b & ~a_plus_b)|(binv &~a & ~b & a_plus_b);
  assign OUTPUT = (~operation[0] & ~operation[1] & a_and_b)|(operation[0] & ~operation[1] & a_or_b)|(~operation[0] & operation[1] & a_plus_b)|(operation[0] & operation[1] & less);
    
endmodule

module _32bitalu(input [31:0]a,input [31:0]b,input ainv,input binv,input [1:0]operation,output [31:0]res);

 wire cin;
 wire [31:0]cout;
 wire forslt;
 wire [31:0]nouse;
 wire [31:0]set;
 wire [31:0]res;
 wire q;
 
 assign q = (res[31] & operation[0] & operation[1]);
 assign cin = binv;
 assign nouse = 32'b0;
 
 genvar i;
 
 generate
 
  for(i = 1;i<=30;i = i+1)
   begin: gen_name
    onebitalu oa(a[i],b[i],ainv,binv,cout[i-1],cout[i],nouse[i],operation,set[i],res[i]);
   end

 endgenerate
 
 onebitalu oa1(a[0],b[0],ainv,binv,cin,cout[0],set[31],operation,set[0],res[0]);
 onebitalu oa2(a[31],b[31],ainv,binv,cout[30],cout[31],nouse[31],operation,set[31],res[31]);
 
endmodule

module stimulus;

 reg [31:0]a;
 reg [31:0]b;
 reg ainv;
 reg binv;
 reg [1:0]operation;
 wire [31:0]res;
 
 _32bitalu uut(a,b,ainv,binv,operation,res); 
 
 initial begin
  $display("Ainv Binv Operation                  Register A                     Register B                       Result \n");
  #0 ainv = 0;binv = 0;operation = 0;a = 0;b = 0;
  
  #10 ainv = 1;binv = 1;operation = 0;a = 4500;b = 32678;
  #10 ainv = 0;operation = 1;
  #10 ainv = 0;binv = 0;operation = 2;
  #10 ainv = 0;binv = 1;operation = 2;
  #10 ainv = 0;binv = 1;operation = 3;
  #10;
  
 end
 
 initial begin
  $monitor("%d     %d      %2b        %32b %32b %32b",ainv,binv,operation,a,b,res);
 end
 
endmodule  








        
      
