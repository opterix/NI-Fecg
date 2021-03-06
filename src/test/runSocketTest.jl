function MFMSocket(AECG,ti,tf,sr)
	
	#------------------------------------ GLOBAL VARIABLES 
	ns = (tf-ti) * sr # number of samples

	#------------------------------------------- LOAD DATA
	# Load data according global varaibles
	AECG = AECG[ti*sr+1:tf*sr,:]
	#t = t[ti*sr+2:tf*sr+1,1]
	nch = size(AECG,2) # nch - number of channels

	#---------------------------------------- PREPROCESING
	(AECG_clean) = preProcessing(AECG,sr,nch,ns)

	#----------------- MOTHER SUBSTRACTION AND COMPUTATION
	(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstraction(AECG_clean,nch,sr,ns,ti,tf)

	#------------------ FETAL SUBSTRACTION AND COMPUTATION 
	(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,ti,tf)

	concatArray = zeros((2*ns),1);
	finalArray = zeros((2*ns),1);
	acum = 1;
	for i = 2:2:(2*ns)
		println(i)
		println(acum)
		concatArray[i-1]=AECGm_sort[acum,1];
		concatArray[i]=AECGf_sort[acum,1];
		acum += 1;
	end
	min=minimum(concatArray);
	max=maximum(concatArray);
	
	for ii = 1:(2*ns)
		finalArray[ii] = ((concatArray[ii]-min)/(max-min)*255);
	end
	return finalArray;
end




