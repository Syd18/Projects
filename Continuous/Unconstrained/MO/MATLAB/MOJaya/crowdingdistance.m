function [d]=crowdingdistance(fmin,fmax,f)
[row,col]=size(f);
d=zeros(row,1);
for i=1:col
[~,t]=sort(f(:,i));
%disp(t);
d(t(1))=Inf;
d(t(row))=Inf;
for j=2:row-1
d(t(j))=d(t(j))+(f(t(j+1),i)-f(t(j-1),i))/(fmax(i)-fmin(i));
end
end
d(d>Inf)=Inf;
end