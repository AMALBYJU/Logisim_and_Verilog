module jkflipflop(input j,input k,input clk,input clear,output q,output _q);

 wire s,t,u,v,w,x;
 
 assign s = ~(j & clk & _q);
 assign t = ~(k & clk & q);
 
 assign w = ~(~clk & u);
 assign x = ~(~clk & v);
 assign q = ~(w & _q);
 assign _q = ~(x & q);
 
 assign u = ~(s & v);
 assign v = ~(t & u & clear);
 
endmodule

module stimulus;

 reg j;
 reg k;
 reg clk;
 reg clear;
 wire q;
 wire _q;
 
 jkflipflop uut(j,k,clk,clear,q,_q);
 
 initial begin
 
 $display("J  K  clk q  ~q\n");
 
 #0 j = 0;k = 0;clk = 0;clear = 0;
 #10 j = 1;clk = 1;clear = 1;
 #10 clk = 0;
 #10 k = 1;j = 0;clk = 1;
 #10 j = 0;k = 0;clk = 0;
 #10 j = 1;clk = 1;
 #10 clk = 0;
 #10 k = 1;j = 0;clk = 1;
 #10;
 
 end
 
  always @(negedge clk)
   begin
    $display("%d  %d  %d  %d  %d",j,k,clk,q,_q);
   end
   
endmodule  

