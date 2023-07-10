no=35;
do=1;
grain_number =size(grains,1);

dt=1e-6;

ori = 2*pi*rand(grain_number,1); %orientation generate
evol=cell(no,3);
evol{1,1}=grains;
evol{1,2}=ori;
evol{1,3}=id;
avegrainsize = zeros(no,1); 
avegrainsize(1) = (dims(1)*dims(2)*dims(3) - size(rmlist,1))/(size(grains,1));
avegrainsize_goal = 609.5622; 

%% iteration
for i=2:no
    i
    [evol{i,1},evol{i,2},evol{i,3}] = gbm3diso(do,dt,grains,dims,ori,id,rmlist);    
    grains=evol{i,1};
    id=evol{i,3};
    avegrainsize(i) = (dims(1)*dims(2)*dims(3) - size(rmlist,1))/(size(grains,1));
    (size(grains,1))
    if avegrainsize(i)>=avegrainsize_goal
        display('Done!');
        pause
    end
    
    
    fname = sprintf('timestep%d.mat', i);
    MyFile=strcat(fname);
    timestep=evol(i,:);
    save(MyFile,'timestep', '-v7.3');
    evol{i,1}=[]; evol{i,2}=[]; evol{i,3}=[]; 
    
end
