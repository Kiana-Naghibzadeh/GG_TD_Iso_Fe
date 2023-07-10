clear
clc
%% read dream3D data
%Iron data--------------------------------------
dataid= h5read('C:\Users\k_nag\Box Sync\DMREF-NEW\Fe\Fe\Data\Output\FeAn0_An1IsotropicSimulation.dream3d',...
    '/DataContainers/ImageDataContainer/CellData/FeatureIds');
dataori= h5read('C:\Users\k_nag\Box Sync\DMREF-NEW\Fe\Fe\Data\Output\FeAn0_An1IsotropicSimulation.dream3d',...
    '/DataContainers/ImageDataContainer/CellFeatureData/AvgEulerAngles');

dataori=dataori';


%% Create
createMet = 0; 
N=size(dataori,1)-1;
id=(1:N)';
dims=[size(dataid,2),size(dataid,3),size(dataid,4)];
if createMet == 1
    % create fstate for metric.dat    
    grains = cell(N,1);
    rmlist=find(dataid == 0);
    for i=1:N
        ind=find(dataid == id(i));
        grains{i}=ind;
    end
    fstate = grains;
%     inistate = grains;
else
    
    % create grains for simu input
    grains = cell(N,3);
    rmlist=find(dataid == 0);
    for i=1:N
        ind=find(dataid == id(i));
        grains{i,1}=ind;
        grains{i,2}=ones(size(grains{i,1},1),1);
        grains{i,3}=zeros(size(grains{i,1},1),1);
    end
    % dilation for input
    tic
    label = -1e10 * ones(dims);
    W = int32(-ones(dims));
    L = int32(zeros(120000000,1));
    for k=1:N % Loop over the grains.
        ind = grains{k,1};
        [x,y,z] = ind2sub(dims,ind);
        [x2,y2,z2] = dilation_fixedbd(int32(x),int32(y),int32(z),5,W,L);
        ind2 = sub2ind(dims,x2,y2,z2);
        ind3 = rmdilation1(ind2,rmlist );
        label(ind3) = -1;
        label(ind) = 1;
        grains{k,1} = ind3;
        grains{k,2} = label(ind3);
        grains{k,3} = 0*ind3;       % Convolution vals. init to 0. 
    end % (for k). Loop over grains ends.
    t1=toc;
    display(t1)
end

