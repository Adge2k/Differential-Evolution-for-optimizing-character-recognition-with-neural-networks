function [ O ] = myFun( x, xdata )
%MYFUN Summary of this function goes here
%   Detailed explanation goes here
    %[expected, text, alldata] = xlsread('output.xls');
    expected = [[ 1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1];
                [ 0     1     1     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0];
                [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0]];


    m = size(xdata,1);
    n = size(xdata,2);
    O = zeros(26,n);
    alpha = x(1,1);
    threshold = zeros(76,1);
    for i=1:1:76
        threshold(i,1)=x(1,i+1);
    end
    H = zeros(m,1);
    h_weights = zeros(50,m);
    o_weights = zeros(26,50);
    for i=1:1:50
        for j=1:1:m
            h_weights(i,j) = ((0.024*2)*rand-0.024);
        end
    end
    for i=1:1:26
        for j=1:1:50
            o_weights(i,j) = ((0.024*2)*rand-0.024);
        end
    end
    %  for training=1:1:x(1,4)
    for t=1:1:x(1,78)
        o_error = 0;
        for i=1:1:n
            h_egrad = 0;
            o_egrad = 0;
            for k=1:1:50
                hidden = 0;
                for j=1:1:m
                hidden = hidden + xdata(j,i)*h_weights(k,j);
                end
                H(k,1) = 1/(1+exp(-(hidden - threshold(k,1))));%sigmf(hidden - threshold,x);        
            end
            % h_out = sigmf(hidden,x);
            for k=1:1:26
               out = 0;
               for j=1:1:50
                   out = out + H(j,1)*o_weights(k,j);
               end
               O(k,i) = 1/(1+exp(-(out - threshold(50+k,1))));%sigmf(hidden - threshold2,x);
            end
            for l=1:1:26
                o_error = o_error + ((expected(l,i)-O(l,i))^2);
            end
            o_error = o_error/26;
            for l=1:1:26
                o_egrad = o_egrad + (expected(l,i)*(1-expected(l,i))*o_error);
            end
            o_egrad = o_egrad/26;
            for l=1:1:50
                for j=1:1:m
                h_egrad = h_egrad + (H(l,1)*(1-H(l,1))*o_egrad)*h_weights(l,j);
                end
            end
            
            h_egrad = (h_egrad/50);
            for k=1:1:26
                for j=1:1:50
                    o_weights(k,j) = o_weights(k,j)+alpha*H(k,1)*o_egrad;
                end
            end
            for k=1:1:50
                for j=1:1:n
                    h_weights(k,j)=h_weights(k,j)+alpha*xdata(k,j)*h_egrad;
                end
            end
            for j=1:1:50
                threshold(j,1) = threshold(j,1)+alpha*(-1)*h_egrad;
            end
            for j=51:1:76
                threshold(j,1) = threshold(j,1)+alpha*(-1)*o_egrad;
            end
        end
    end
    %display(o_error);
end


