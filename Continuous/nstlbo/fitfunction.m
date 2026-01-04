function o=fitfunction(x)
o = [0, 0];

%Problem 1: SRN
%o(1)=(x(1)-2)^2+(x(2)-1)^2+2; %objective 1
%o(2)=9*x(1)-(x(2)-1)^2; %objective 2

%Problem 2: BHN
%o(1)=4*(x(1)^2)+4*(x(2)^2); %objective 1
%o(2)=(x(1)-5)^2+(x(2)-5)^2; %objective 2

%Problem 3: OSY
o(1)=-((25*(x(1)-2)^2)+((x(2)-2)^2)+((x(3)-1)^2)+((x(4)-4)^2)+((x(5)-1)^2));
o(2)=(x(1)^2)+(x(2)^2)+(x(3)^2)+(x(4)^2)+(x(5)^2)+(x(6)^2);

o=o+getnonlinear(x);

    function Z=getnonlinear(x)
        Z=0;
        % Penalty constant
        lam=10^15;

        %%Problem 1: SRN Unequality Constraints
        %g(1)=x(1)^2+x(2)^2-225; %constraint 1
        %g(2)=x(1)-(3*x(2))+10; %constraint 2

        %Problem 2: BHN Unequality Constraint
        %g(1)=(x(1)-5)^2 + x(2)^2 -25;  %constraint 1
        %g(2)=-(x(1)-8)^2-(x(2)+3)^2+7.7;  %constraint 2

       %Problem 3: OSY  
       g(1)=-x(1)-x(2)+2;
       g(2)=-6+x(1)+x(2);
       g(3)=-2+x(2)-x(1);
       g(4)=-2+x(1)-3*x(2);
       g(5)=-4+((x(3)-3)^2)+x(4);
       g(6)=-((x(5)-3)^2)-x(6)+4;

        % No equality constraint in this problem, so empty;
        geq=[];
        
        % Apply inequality constraints
        for k=1:length(g)
            Z=Z+ lam*g(k)^2*getH(g(k));
        end
        % Apply equality constraints
        for k=1:length(geq)
            Z=Z+lam*geq(k)^2*getHeq(geq(k));
        end
    end
% Test if inequalities hold
% Index function H(g) for inequalities
    function H=getH(g)
        if g<=0
            H=0;
        else
            H=1;
        end
    end
% Index function for equalities
    function H=getHeq(geq)
        if geq==0
            H=0;
        else
            H=1;
        end
    end
end
%     % ----------------- end ------------------------------
