function MFMTestWindow(filename,ti,tf,sr,f)
	# f = number of partitions
	# ti =  time signal in seconds (Uint32)	
	# tf =  time signal in seconds (Uint32)
	# sr =  sample rate (UInt64)
	# filename = name of csv file (without csv extension, "filename") (String)
		# Notes:# - The module detects automaticly the headers.
			# - Specify the directory of data in the filename ("dir/filename")
			#   or the module searchs into the current directory.
			# - If you have annotations, put into the same directory.  
			# - The annotations and csv file must be the same name,
			#   (filename.fqrs.txt => filename.csv),
			#   otherwise the module will not detected the file.
	
	#------------------------------------ GLOBAL VARIABLES 
	ns = (tf-ti) * sr # number of samples

	#------------------------------------------- LOAD DATA
	(nch,t,AECG,fetal_annot) = loadData(filename,ns,sr,ti,tf)	
	(nsLimits)=divideSignal(AECG,ns,nch,f)
	println(nsLimits)
	for i = 1 : f
		println("i= $i")
		bw = Int64(nsLimits[i,1]);
		fw = Int64(nsLimits[i,2]);

		nsd = Int64(nsLimits[i,2]-nsLimits[i,1]+1);	
		(AECGd) = loadDataWindow(AECG,bw,fw);

		#---------------------------------------- PREPROCESING
		(AECG_clean) = preProcessing(AECGd,sr,nch,nsd);

		#----------------- MOTHER SUBSTRACTION AND COMPUTATION
		(heart_rate_mother,AECGm_ica,SVDrec,AECGm_sort,AECG_residual,QRSm_pos,QRSm_value) = motherSubstraction(AECG_clean,nch,sr,nsd,bw/sr,fw/sr);

		#------------------ FETAL SUBSTRACTION AND COMPUTATION 
		(AECGf_sort,QRSf_pos,QRSf_value,QRSfcell_pos,QRSfcell_value,heart_rate_feto, QRSfcell_pos_smooth, SMI, gini_measure) = fetalSubstraction(AECG_residual,heart_rate_mother,nch,sr,bw/sr,fw/sr);

		if i == 1
			global AECGAcum = AECGd; 
			global AECG_cleanAcum = AECG_clean; 
			global AECGm_icaAcum = AECGm_ica; 
			global SVDrecAcum = SVDrec; 
			global AECGm_sortAcum = AECGm_sort; 
			global AECG_residualAcum = AECG_residual;
			global heart_rate_motherAcum = zeros(f,1); heart_rate_motherAcum[i,1] = heart_rate_mother;
			global QRSm_valueAcum = QRSm_value; 
			global QRSm_posAcum = QRSm_pos;
			global AECGf_sortAcum = AECGf_sort;
			global QRSf_posAcum = QRSf_pos;
			global QRSf_valueAcum = QRSf_value;
			global QRSfcell_posAcum = QRSfcell_pos;
			global QRSfcell_valueAcum = QRSfcell_value; 
			global heart_rate_fetoAcum = zeros(f,1); heart_rate_fetoAcum[i,1] =  heart_rate_feto;
			global QRSfcell_pos_smoothAcum = QRSfcell_pos_smooth;
			global SMIAcum = zeros(nch,f); SMIAcum[:,i] = SMI;
			global gini_measureAcum = zeros(nch,f); gini_measureAcum[:,i] = gini_measure;
		else
			AECGAcum = vcat(AECGAcum,AECGd); 
			AECG_cleanAcum = vcat(AECG_cleanAcum,AECG_clean); 
			AECGm_icaAcum = vcat(AECGm_icaAcum,AECGm_ica); 
			SVDrecAcum = vcat(SVDrecAcum,SVDrec); 
			AECGm_sortAcum = vcat(AECGm_sortAcum,AECGm_sort); 
			AECG_residualAcum = vcat(AECG_residualAcum,AECG_residual);
			heart_rate_motherAcum[i,1] = heart_rate_mother;
			QRSm_valueAcum = vcat(QRSm_valueAcum,QRSm_value); 
			QRSm_posAcum = vcat(QRSm_posAcum,QRSm_pos+bw/sr);
			AECGf_sortAcum = vcat(AECGf_sortAcum,AECGf_sort);
			QRSf_posAcum = vcat(QRSf_posAcum,QRSf_pos+bw/sr);
			QRSf_valueAcum = vcat(QRSf_valueAcum,QRSf_value);
			for idx=1:nch; QRSfcell_posAcum[idx] = vcat(QRSfcell_posAcum[idx],QRSfcell_pos[idx]+bw/sr);end
			for idx=1:nch; QRSfcell_valueAcum[idx] = vcat(QRSfcell_valueAcum[idx],QRSfcell_value[idx]);end 
			heart_rate_fetoAcum[i,1] = heart_rate_feto;
			for idx=1:nch; QRSfcell_pos_smoothAcum[idx] = vcat(QRSfcell_pos_smoothAcum[idx],QRSfcell_pos_smooth[idx]+bw/sr);end
			SMIAcum[:,i] = SMI;
			gini_measureAcum[:,i] = gini_measure;
		end
		println("heart_rate_mother=$heart_rate_mother")
		println("heart_rate_feto=$heart_rate_feto")

		if i == f
			println("heart_rate_motherAcum=$heart_rate_motherAcum")
			println("heart_rate_fetoAcum=$heart_rate_fetoAcum")
			heart_rate_motherAcum = mean(heart_rate_motherAcum,1)
			heart_rate_fetoAcum = mean(heart_rate_fetoAcum,1)
			gini_measureAcum = mean(gini_measureAcum,2)
			SMIAcum = mean(SMIAcum,2)

			(inputVar,motherVar,fetalVar)=groupVar(nch,ns,ti,tf,sr,t,fetal_annot,AECGAcum,AECG_cleanAcum,	AECGm_icaAcum,AECGm_sortAcum,AECG_residualAcum,QRSm_posAcum,QRSm_valueAcum,heart_rate_motherAcum,SVDrecAcum,	AECGf_sortAcum,QRSf_posAcum,QRSf_valueAcum,QRSfcell_posAcum,QRSfcell_valueAcum,heart_rate_fetoAcum, QRSfcell_pos_smoothAcum, SMIAcum, gini_measureAcum)

			return inputVar,motherVar,fetalVar;
		end
	end

end




