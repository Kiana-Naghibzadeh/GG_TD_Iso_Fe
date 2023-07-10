grains=timestep{1,1};
id=timestep{1,3};
%%
grain0=cell(1,3);
grain0{1,1}=rmlist;
grain0{1,2}=ones(size(rmlist,1),1);
grain0{1,3}=zeros(size(rmlist,1),1);
grains=[grain0;grains];
id=[0;id];

%%
P = -ones(dims);
N = size(grains,1); % Number of grains.    
for k=1:N % Loop over grains.
    ind = grains{k,1};
    val = grains{k,2}; % Lev. set. vals. at those pixels.
    posind = ind(val>0); % Pixels in the interior of grain.
    P(posind) = id(k);        
end
dataid=zeros([1,dims],'int32');


dataid(1,:,:,:)=P;
h5write('C:\Users\k_nag\Box Sync\DMREF-NEW\Fe\Fe\Data\Output\FeAn0_An1IsotropicSimulation7-9-2023.dream3d',...
    '/DataContainers/ImageDataContainer/CellData/FeatureIds',dataid);

