using SVR
using MLBase
using JLD
using Wavelets


Wavelets_Pos=[];
Wavelets_Neg=[];
T_Aux_Sig_Pos=[];
T_Aux_Sig_Neg=[];
Mat_To_Wavelet_Pos=[];
Mat_To_Wavelet_Neg=[];

## Generar Wavelet de Daubechies ##

xt = wavelet(WT.db7)	

## Aplicar los coeficientes Wavelet a todos los casos positivos y negativos ##

data_dictio="../Dictionaries"
list_file=readdir(data_dictio)
num_files=size(list_file,1);


for i in 51:num_files
    file_name = list_file[i];
    println("Procesando Dictionary $(file_name)")
    d = load("$(data_dictio)/$(file_name)")

    if isempty(Mat_To_Wavelet_Pos)
        Mat_To_Wavelet_Pos=d["pos_examples"];
        Mat_To_Wavelet_Neg=d["neg_examples"];
    else
        Mat_To_Wavelet_Pos=vcat(Mat_To_Wavelet_Pos,d["pos_examples"]);
        Mat_To_Wavelet_Neg=vcat(Mat_To_Wavelet_Neg,d["neg_examples"]);

    end

end

T_Aux_Sig_Pos=zeros(size(Mat_To_Wavelet_Pos));
T_Aux_Sig_Neg=zeros(size(Mat_To_Wavelet_Neg));
(Fil,Col)=size(Mat_To_Wavelet_Pos);

for k in 1:Fil
    T_Aux_Sig_Pos[k,:]=dwt(Mat_To_Wavelet_Pos[k,:],xt,3);
    T_Aux_Sig_Neg[k,:]=dwt(Mat_To_Wavelet_Neg[k,:],xt,3);
end



#### Carga el modelo del SVM

println("Entrenando Support Vector Machine")
SVM_Fetal=[];
SVM_Fetal=SVR.loadmodel("SVMfetal.model");


## Aplicar Support Vector Machine para clasificar 

labels = vcat(zeros(size(T_Aux_Sig_Pos,1)),ones(size(T_Aux_Sig_Neg,1)));
instances = vcat(T_Aux_Sig_Pos[1:end,1:64],T_Aux_Sig_Neg[1:end,1:64])

println("Predicting");

predicted_labels = round(SVR.predict(SVM_Fetal, instances'));
SVR.freemodel(SVM_Fetal)


# Compute accuracy
@printf "Accuracy: %.2f%%\n" mean((predicted_labels .== labels))*100

## Confussion Matrix
#C = confusmat(1, labels, predicted_labels)

tp = (labels.==0) & (predicted_labels.==0)
tn = (labels.==1) & (predicted_labels.==1)

fp = (labels.==1) & (predicted_labels.==0)
fn = (labels.==0) & (predicted_labels.==1)

C= [tp fp; fn tn]
 
