`timescale 1ns / 1ps
module stimulus;

 reg x;
 reg y;
 reg z;
 wire w;

 comp5 uut(.x(x),.y(y),.z(z),.w(w));
 
 initial begin
 x=0;
 y=0;
 z=0;
 
 #20 z = 1;
 #20 y = 1;z = 0;
 #20 y = 1;z = 1;
 #20 x = 1;y = 0;z = 0;
 #20 z = 1;
 #20 z = 0;y = 1;
 #20 z = 1;

 end
 
 initial begin
  $monitor("x = %d y = %d z = %d w = %d\n",x,y,z,w);
 end

endmodule
 
 
 
