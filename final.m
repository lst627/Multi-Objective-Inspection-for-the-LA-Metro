yalmip('clear')

x=sdpvar(73,10,3);
xx=sdpvar(4,10,5);
u=sdpvar(12,1);
% 1-10  15-24  61-70    long, distant, 0.2
% 39-36  73-49  60-55    short, distant, 0.1
% 10-28  45-8  36-41    long, center, 0.3
% 41-10  31-13  9-12    short, center, 0.4
c=sdpvar(10,1);
% 11-12  11-10  11-40  14-13  14-33  center
% 61-62  15-16  60-59  39-38  73-72  distant

fe_center=0.1;
fe_distant=0.8;
fe_suburb=0.5;
theta=0.0;
rho=1.5;
tau=10;
alpha=20;
beta=-200;
gamma=2.0;
mu=5;
%unused
kappa=100; 

% obj=-(0.3*u(1)+0.4*u(2)+0.3*u(3)-theta*0.2*sum(c));
obj=-(0.2*(u(1)+u(2)+u(3))+0.1*(u(4)+u(5)+u(6))+0.3*(u(7)+u(8)+u(9))+0.4*(u(10)+u(11)+u(12)))/3+theta*0.1*sum(c);

constraint=[];

% rider
constraint=[constraint, u(1)<=rho, u(1)<=tau*(fe_distant*(x(1,1,2)+x(1,2,3)+x(2,3,3)+x(3,4,3))+fe_suburb*(x(4,5,3)+x(5,6,3)+x(6,7,3)+x(7,8,3)+x(8,9,3))+fe_center*(x(9,10,3)))];
constraint=[constraint, u(2)<=rho, u(2)<=tau*(fe_distant*(x(15,1,2)+x(15,2,3)+x(16,3,3)+x(17,4,3)+x(18,5,3)+x(19,6,3)+x(20,7,3)+x(21,8,3)+x(22,9,3)+x(23,10,3)))];
constraint=[constraint, u(3)<=rho, u(3)<=tau*(fe_distant*(x(61,1,2)+x(61,2,3)+x(62,3,3)+x(63,4,3)+x(64,5,3)+x(65,6,3)+x(66,7,3)+x(67,8,3)+x(68,9,3)+x(69,10,3)))];
constraint=[constraint, u(4)<=rho, u(4)<=tau*(fe_distant*(x(39,1,2)+x(39,2,3)+x(38,3,3)+x(37,4,3)))];
constraint=[constraint, u(5)<=rho, u(5)<=tau*(fe_suburb*(x(73,1,2)+x(73,2,3)+x(72,3,3)+x(71,4,3)))];
constraint=[constraint, u(6)<=rho, u(6)<=tau*(fe_suburb*(x(60,1,2)+x(60,2,3)+x(59,3,3)+xx(4,4,3)))];
constraint=[constraint, u(7)<=rho, u(7)<=tau*(fe_center*(x(10,1,2)+x(10,2,3)+xx(1,3,3)+x(12,4,1)+x(13,5,1))+fe_suburb*(xx(2,6,1)+x(32,7,1)+x(31,8,1)+x(30,9,1)+x(29,10,1)))];
constraint=[constraint, u(8)<=rho, u(8)<=tau*(fe_suburb*(x(45,1,2)+x(45,2,3)+x(44,3,3)+x(43,4,3))+fe_center*(x(42,5,3)+x(41,6,3)+x(40,7,3)+xx(1,8,1)+x(10,9,1)+x(9,10,1)))];
constraint=[constraint, u(9)<=rho, u(9)<=tau*(fe_suburb*(x(36,1,2)+x(36,2,3)+x(35,3,3)+x(34,4,3)+x(33,5,3))+fe_center*(xx(2,6,4)+x(13,7,3)+x(12,8,3)+xx(1,9,4)+x(40,10,1)))];
constraint=[constraint, u(10)<=rho, u(10)<=tau*(fe_center*(x(41,1,2)+x(41,2,3)+x(40,3,3)+xx(1,4,1)))];
constraint=[constraint, u(11)<=rho, u(11)<=tau*(fe_suburb*(x(31,1,2)+x(31,2,3)+x(32,3,3))+fe_center*(xx(2,4,4)))];
constraint=[constraint, u(12)<=rho, u(12)<=tau*(fe_center*(x(9,1,2)+x(9,2,3)+x(10,3,3)+xx(1,4,3)))];

% criminal
constraint=[constraint, c(1)>=0, c(1)>=fe_center*(beta-alpha)*xx(1,4,3)+alpha];
constraint=[constraint, c(2)>=0, c(2)>=fe_center*(beta-alpha)*xx(1,4,1)+alpha];
constraint=[constraint, c(3)>=0, c(3)>=fe_center*(beta-alpha)*xx(1,4,4)+alpha];
constraint=[constraint, c(4)>=0, c(4)>=fe_center*(beta-alpha)*xx(2,4,4)+alpha];
constraint=[constraint, c(5)>=0, c(5)>=fe_center*(beta-alpha)*xx(2,4,3)+alpha];
constraint=[constraint, c(6)>=0, c(6)>=fe_distant*(beta-alpha)*x(61,4,3)+alpha];
constraint=[constraint, c(7)>=0, c(7)>=fe_distant*(beta-alpha)*x(15,4,3)+alpha];
constraint=[constraint, c(8)>=0, c(8)>=fe_distant*(beta-alpha)*x(60,4,3)+alpha];
constraint=[constraint, c(9)>=0, c(9)>=fe_distant*(beta-alpha)*x(39,4,3)+alpha];
constraint=[constraint, c(10)>=0, c(10)>=fe_distant*(beta-alpha)*x(73,4,3)+alpha];

% map and police
for i = 1 : 73
    constraint=[constraint, x(i,1,1)==0, x(i,1,2)==0, x(i,1,3)==0];
    for j = 2 : 10
        constraint=[constraint, 0<=x(i,j,1)<=mu, 0<=x(i,j,2)<=mu, 0<=x(i,j,3)<=mu];
    end
end

constraint=[constraint, xx(2,1,1)==0, xx(2,1,2)==0, xx(2,1,3)==0, xx(2,1,4)==0, xx(2,1,5)==0];
constraint=[constraint, xx(4,1,1)==0, xx(4,1,2)==0, xx(4,1,3)==0, xx(4,1,4)==0, xx(4,1,5)==0];
for j = 1 : 10
    for i = 1 : 4
        constraint=[constraint, 0<=xx(i,j,1)<=mu, 0<=xx(i,j,2)<=mu, 0<=xx(i,j,3)<=mu, 0<=xx(i,j,4)<=mu, 0<=xx(i,j,5)<=mu];
    end
end

constraint=[constraint, xx(1,1,1)+xx(1,1,2)+xx(1,1,3)+xx(1,1,4)+xx(1,1,5)+xx(3,1,1)+xx(3,1,2)+xx(3,1,3)+xx(3,1,4)+xx(3,1,5)<=gamma];

% flow balance
for j = 2 : 10
    constraint=[constraint, x(1,j,1)+x(1,j,2)+x(1,j,3)==x(1,j-1,2)+x(2,j-1,1)];
    for i = 2 : 9
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i+1,j-1,1)+x(i-1,j-1,3)];
    end
    constraint=[constraint, x(10,j,1)+x(10,j,2)+x(10,j,3)==x(10,j-1,2)+xx(1,j-1,1)+x(9,j-1,3)];
    constraint=[constraint, xx(1,j,1)+xx(1,j,2)+xx(1,j,3)+xx(1,j,4)==xx(1,j-1,2)+x(10,j-1,3)+x(12,j-1,3)+x(40,j-1,3)];
    constraint=[constraint, x(12,j,1)+x(12,j,2)+x(12,j,3)==x(12,j-1,2)+xx(1,j-1,3)+x(13,j-1,3)];
    constraint=[constraint, x(13,j,1)+x(13,j,2)+x(13,j,3)==x(13,j-1,2)+x(12,j-1,1)+xx(2,j-1,4)];
    constraint=[constraint, xx(2,j,1)+xx(2,j,2)+xx(2,j,3)+xx(2,j,4)==xx(2,j-1,2)+x(32,j-1,3)+x(33,j-1,3)+x(13,j-1,1)];
    constraint=[constraint, x(15,j,1)+x(15,j,2)+x(15,j,3)==x(15,j-1,2)+x(16,j-1,1)];
    for i = 16 : 31
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i+1,j-1,1)+x(i-1,j-1,3)];
    end
    constraint=[constraint, x(32,j,1)+x(32,j,2)+x(32,j,3)==x(32,j-1,2)+xx(2,j-1,1)+x(31,j-1,3)];
    constraint=[constraint, x(33,j,1)+x(33,j,2)+x(33,j,3)==x(33,j-1,2)+xx(2,j-1,3)+x(34,j-1,3)];
    for i = 34 : 38
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i-1,j-1,1)+x(i+1,j-1,3)];
    end
    constraint=[constraint, x(39,j,1)+x(39,j,2)+x(39,j,3)==x(39,j-1,2)+x(38,j-1,1)];
    constraint=[constraint, x(40,j,1)+x(40,j,2)+x(40,j,3)==x(40,j-1,2)+xx(1,j-1,4)+x(41,j-1,3)];
    for i = 41 : 47
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i-1,j-1,1)+x(i+1,j-1,3)];
    end
    constraint=[constraint, x(48,j,1)+x(48,j,2)+x(48,j,3)==x(48,j-1,2)+x(47,j-1,1)+xx(3,j-1,3)];
    constraint=[constraint, xx(3,j,1)+xx(3,j,2)+xx(3,j,3)+xx(3,j,4)+xx(3,j,5)==xx(3,j-1,2)+x(70,j-1,3)+x(71,j-1,3)+x(50,j-1,3)+x(48,j-1,1)];
    constraint=[constraint, x(50,j,1)+x(50,j,2)+x(50,j,3)==x(50,j-1,2)+xx(3,j-1,1)+x(51,j-1,3)];
    for i = 51 : 54
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i-1,j-1,1)+x(i+1,j-1,3)];
    end
    constraint=[constraint, x(55,j,1)+x(55,j,2)+x(55,j,3)==x(55,j-1,2)+x(54,j-1,1)+xx(4,j-1,3)];
    constraint=[constraint, xx(4,j,1)+xx(4,j,2)+xx(4,j,3)+xx(4,j,4)==xx(4,j-1,2)+x(57,j-1,3)+x(59,j-1,3)+x(55,j-1,1)];
    constraint=[constraint, x(57,j,1)+x(57,j,2)+x(57,j,3)==x(57,j-1,2)+xx(4,j-1,1)+x(58,j-1,3)];
    constraint=[constraint, x(58,j,1)+x(58,j,2)+x(58,j,3)==x(58,j-1,2)+x(57,j-1,1)+x(60,j-1,1)];
    constraint=[constraint, x(59,j,1)+x(59,j,2)+x(59,j,3)==x(59,j-1,2)+xx(4,j-1,4)+x(60,j-1,3)];
    constraint=[constraint, x(60,j,1)+x(60,j,2)+x(60,j,3)==x(60,j-1,2)+x(58,j-1,1)+x(59,j-1,1)];
    constraint=[constraint, x(61,j,1)+x(61,j,2)+x(61,j,3)==x(61,j-1,2)+x(62,j-1,1)];
    for i = 62 : 69
        constraint=[constraint, x(i,j,1)+x(i,j,2)+x(i,j,3)==x(i,j-1,2)+x(i+1,j-1,1)+x(i-1,j-1,3)];
    end
    constraint=[constraint, x(70,j,1)+x(70,j,2)+x(70,j,3)==x(70,j-1,2)+x(69,j-1,3)+xx(3,j-1,4)];
    constraint=[constraint, x(71,j,1)+x(71,j,2)+x(71,j,3)==x(71,j-1,2)+x(72,j-1,3)+xx(3,j-1,5)];
    constraint=[constraint, x(72,j,1)+x(72,j,2)+x(72,j,3)==x(72,j-1,2)+x(73,j-1,3)+x(71,j-1,1)];
    constraint=[constraint, x(73,j,1)+x(73,j,2)+x(73,j,3)==x(73,j-1,2)+x(72,j-1,1)];
end

ops = sdpsettings('solver','cplex','verbose',1);
ops.cplex.display='on';
ops.cplex.timelimit=1000;
ops.cplex.mip.tolerances.mipgap=0.001;

disp('Start solving...')
diagnostics=optimize(constraint,obj,ops);
if diagnostics.problem==0
    disp('Solver thinks it is feasible');
    value(u)
    value(c)
    value((u(1)+u(2)+u(3))/3)
    value((u(4)+u(5)+u(6))/3)
    value((u(7)+u(8)+u(9))/3)
    value((u(10)+u(11)+u(12))/3)
    value((c(1)+c(2)+c(3)+c(4)+c(5))/5)
    value((c(6)+c(7)+c(8)+c(9)+c(10))/5)
    value((0.2*(u(1)+u(2)+u(3))+0.1*(u(4)+u(5)+u(6))+0.3*(u(7)+u(8)+u(9))+0.4*(u(10)+u(11)+u(12)))/3)
    value(0.1*sum(c)/20)
elseif diagnostics.problem == 1
    disp('Solver thinks it is infeasible')
    pause();
else
    disp('Timeout, Display the current optimal solution');
    value(u)
    value(c)
end