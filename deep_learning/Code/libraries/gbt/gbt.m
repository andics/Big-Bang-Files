function T=gbt(x)
% input x is a vector. output T is an estimated threshold that groups x
% into 2 clusters using the algorithm of basic global thresholding
% procesures:
% 1)	Randomly select an initial estimate for T.
% 2)	Segment the signal using T, which will yield two groups, G1 consisting of all  points with values<=T and G2 consisting of points with value>T.
% 3)	Compute the average distance between points of G1 and T, and points of G2 and T. 
% 4)	Compute a new threshold value T=(M1+M2)/2
% 5)	Repeat steps 2 through 4 until the change of T is smaller enough. 

p=length(x);
T=x(randi(p-1));
T0=0;

t1=x<=T;
t2=x>T;
mean1=sum(x(t1))/sum(t1);
mean2=sum(x(t2))/sum(t2);

while abs(T-T0)>10^-8
    T0=T;
    T=(mean1+mean2)/2;
    t1=x<T;
    t2=x>T;
    mean1=sum(x(t1))/sum(t1);
    mean2=sum(x(t2))/sum(t2);
end

 
 