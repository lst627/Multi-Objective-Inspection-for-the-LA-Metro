yalmip('clear')

x=sdpvar(6,1);
u=sdpvar(3,1);
c=sdpvar(6,1);

theta=0.0;
rho=1.5;
tau=10;
fe=0.2;
alpha=20;
beta=-200;
gamma=1;
kappa=2.0;
mu=2;

obj=-(0.3*u(1)+0.4*u(2)+0.3*u(3)-theta*0.2*sum(c));

constraint=[];
constraint=[constraint, u(1)<=rho, u(1)<=tau*fe*(x(1)+x(5))];
constraint=[constraint, u(2)<=rho, u(2)<=tau*fe*(x(2)+x(4))];
constraint=[constraint, u(3)<=rho, u(3)<=tau*fe*(x(3)+x(6))];

for i = 1 : 6
    constraint=[constraint, c(i)>=0, c(i)>=fe*(beta-alpha)*x(i)+alpha, 0<=x(i)<=mu];
end

constraint=[constraint,x(1)+x(2)+x(3)<=gamma];
constraint=[constraint,x(1)+x(2)+x(3)==x(4)+x(5)+x(6)];
constraint=[constraint,x(1)+x(2)+x(3)+x(4)+x(5)+x(6)<=gamma*kappa];


ops = sdpsettings('solver','cplex','verbose',1);
ops.cplex.display='on';
ops.cplex.timelimit=600;
ops.cplex.mip.tolerances.mipgap=0.001;

disp('Start solving...')
diagnostics=optimize(constraint,obj,ops);
if diagnostics.problem==0
    disp('Solver thinks it is feasible');
    value(x)
    value(u)
    value(c)
elseif diagnostics.problem == 1
    disp('Solver thinks it is infeasible')
    pause();
else
    disp('Timeout, Display the current optimal solution');
    value(x)
    value(u)
    value(c)
end