%% Zitzler1 function (ZDT3)
function f = zdt3 (x)
% Number of objective is 2.
% Number of variables is 30. Range x [0,1]

%%ZDT3
f = [];
n=length(x);
g=1+9*sum(x(2:n))/(n-1);
f(1)=x(1);
f(2)=1-sqrt(x(1)/g)-(x(1)/g)*sin(10*pi*x(1));

%%ZDT1
%f = [0, 0];
%dim = length(x);
%g = 1 + 9*sum(x(2:dim))/(dim-1);
%f(1) = x(1);
%f(2) = g*(1-sqrt(x(1)/g));

%%Customized
%x1=x(1);
%x2=x(2);
%x3=x(3);
%x4=x(4);
%Z2=-33.4550+(7.2650*x1)+(12.1910*x2)+(1.8114*x3)-(0.2813*(x1^2))-(0.0726*(x3^2))-(0.0055*x4*x4)-(1.7719*x1*x2);
%Z1 =(8.567-(2.528*x1)+(0.2093*(x1^2))+(2.1318*x2^2 )-(0.0371*(x3^2))-(0.7193*x1*x2)+(0.0108*x3*x4)+(0.0752*x1*x3));
%f(1)=Z1;
%f(2)=Z2;
