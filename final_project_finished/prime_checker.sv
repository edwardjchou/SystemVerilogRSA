module prime_checker(o,i);
    output o; input [10:0]i; integer k; reg o;
    always @(i)
    begin
    k=i;
    if(i[0]==1'b0)
       begin   o=1'b0; $display("not prime");  end
       else 
       begin
       if(k==3 | k==5 | k==7 | k==11 | k==13 | k==17 | k==19)
       begin  o=1'b1; $display("prime"); end
       else if(k%3==0 | k%5==0 | k%7==0 | k%11==0 | k%13==0 | k%17==0 | k%19==0)
       begin   o=1'b0;  $display("not prime");    end 
       else
       begin   o=1'b1;  $display("prime");        end
       end
        if(i==10'b00 | i==10'b010)
        begin o=1'b1; $display("prime");  end
     end
 endmodule