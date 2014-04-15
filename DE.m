function [ O ] = DE( )
    %DE Summary of this function goes here
    %   Detailed explanation goes here

    % Learning rate and Threshold value optimization using DE %
    % by Adrian Newby & Hinal Gohil %

    clc;
    clear all;

    % --- initialisation of population --- %

    [indata, text, alldata] = xlsread('characters.xls');
     [output, text, alldata] = xlsread('output.xls');
     rng('shuffle')
     n = 21;
     test = zeros(100,n);
     i = 1;
     temp = 1;
    for k=1:1:n
        count = 1;
         for j=1:1:10
            for i =temp:1:temp+9
                test(count,k) = indata(i,j);
                count = count + 1;
            end
         end 
         temp = i+2;
    end
    n=input('Enter population size: ');
    itr=input('Enter no. of generations: ');

    train = input('Enter training iteration bound: ');
    Yx = zeros(n,2);
    for i=1:1:n
        Yx(i,2)=i;
        Yx(i,1) = 100;
    end
    F=rand;  % scaling factor taken
    CR=0.8; % crossover ratio defined
    train = ones(n,1)*train;

    Xa=unifrnd (-0.3 , 0.3 , n, 1); % initial population or target vectors
    Xb=unifrnd (-0.024 , 0.024 , n, 76);
    X =[Xa,Xb,train];
    O=zeros(26,21);
    Del=zeros(n,78);  % delta vector initialised
    V=zeros(n,78);    % mutant vector initialised
    T=zeros(n,78);    % trial vector initialised

    for j=1:itr

        for i=1:n
            % -- three random vectors to be chosen -- %
            r1=ceil(rand(1)*n);
            r2=ceil(rand(1)*n);
            %r3=ceil(rand(1)*n);

            for k=1:1:77
                Del(i,k)=X(r1,k)-X(r2,k);
                V(i,k)=X(r1,k)+F*Del(i,k);  % mutant vector
            end
            
            V(i,78)=train(1);
            r=rand(1);
            if r<CR
                T(i,:)=V(i,:);
            else                       % trial vector
                T(i,:)=X(i,:);
            end
        
        lb = [];
        ub = [];
        O = myFun(X(i,:),test);
        O2 = myFun(T(i,:),test);
        option = optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','Display','testing','ScaleProblem','Jacobian');%,'TolFun', 10^(-36),'TolX',10^(-39));
        [xbad,xresnormbad,xresidual,xexitflagbad,xoutputbad] = lsqcurvefit(@tempFunc,O,test,output,lb,ub,option);  % fitness of target vectors
        [tbad,tresnormbad,tresidual,texitflagbad,toutputbad] = lsqcurvefit(@tempFunc,O2,test,output,lb,ub,option);  % fitness of trial vectors
        Yx(i,1) = xoutputbad.firstorderopt;
        Yt = toutputbad.firstorderopt;
        disp(Yx);
        disp(Yt);
		if Yx(i,1)> Yt
			X(i,:)=T(i,:);
			Yx(i,1)=Yt;
		else
			X(i,:)=X(i,:);
		end
       end 
    end
    Yx=sortrows(Yx,1);
    format longE;
    disp((Yx));
    xlswrite('DEresults.xls',Yx(:,1),1);
    format short;
    for i=1:1:n
        xlswrite('DEresults.xls',[Yx(:,1),X(Yx(:,2),:)],1);
    end
    
    disp(X(Yx(1,2)));
end