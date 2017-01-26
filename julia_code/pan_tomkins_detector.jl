function Pan_Tomkins_Detector(AECG_fnotch)

############# GLOBAL VARIABLES ################
nch=4;


#------- Normalization  ------------

PTSignal=copy(AECG_fnotch);

for i in 1:nch
    PTSignal[:,i]= (PTSignal[:,i]-mean(PTSignal[:,i]))/maximum(abs(PTSignal[:,i]));
end

#------- Passband Filter > 5Hz-15Hz

responsetypeLP = Lowpass(15,fs=sr);
prototypeLP=Butterworth(4);

responsetypeHP = Highpass(5,fs=sr);
prototypeHP = Butterworth(4);

filtroLP=digitalfilter(responsetypeLP, prototypeLP);
filtroHP=digitalfilter(responsetypeHP, prototypeHP);

PTSignal=filtfilt(filtroLP, PTSignal);
PTSignal=filtfilt(filtroHP, PTSignal);

#------- Derivative Filter

B=[-1, -2, 0 , 2, 1]/8;
salida=conv(PTSignal[:,1],B);
salida=salida[3:end-2];
salida= salida/maximum(abs(salida));
salida=salida.^2;

#--- Moving integration

h = ones(151)/151;
Delay=75;

salida=conv(salida, h);

salida= salida[Delay+1:end-Delay];
salida= salida/maximum(abs(salida));


#--- Finding QRS Points Pan-Tompkins algorithm

max_h = maximum(salida);
thra=(mean(salida));
region=Int.(salida.>thra.*max_h);

aux=diff([0; region]);
aux2=diff([region; 0]);
left = find(aux.==1);
right = find(aux2.==-1);

maximoRIndex=zeros(length(right),1);
maximoRValue=zeros(length(right),1);

for i in 1:length(right)
    maximoRIndex[i] = indmax(PTSignal[left[i]:right[i],1]);
    maximoRIndex[i] = maximoRIndex[i]-1+left[i];
        
    maximoRValue[i] = maximum(PTSignal[left[i]:right[i],1]);
end


return maximoRIndex, maximoRValue;


end
