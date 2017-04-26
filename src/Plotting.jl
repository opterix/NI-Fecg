function Plotting(graph=0)
#  0  - all
# [1] - AECG
# [2] - AECG_clean
# [3] - AECG_white with QRSm_pos
# [4] - SVDrec
# [5] - AECGm
# [6] - AECGf
# [7] - AECGf with QRSf_pos, AECG_white and QRSm_pos
# diff number - none plot
# diff compositions [1 3 4] or [3 5 6], as you wish

close("all")

if findfirst(graph,1) != 0 || findfirst(graph,0) != 0
figure(1)
for i in 1:nch
subplot("$(nch)1$(i)")
#if i == 1 title("AECG data") end
    plot(t[1:ns], AECG[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    title("Original signals")
end
end

#-----------------------------------------------

if findfirst(graph,2) != 0 || findfirst(graph,0) != 0
    figure(2)

#    a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos
    
    for i in 1:nch
        #subplot("42$(2*i-1)")
        subplot("$(nch)1$(i)")
#if i == 1 title("AECG clean") end
        plot(t[1:ns], AECG_clean[1:ns,i], color="black", linewidth=1.0, linestyle="-")
        title("Filtered signals")

#        subplot("42$(2*i)")
#
 #       plot(a,abs(fftshift(fft(AECG_clean[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
        #plot(a, angle(fftshift))
 #       xlim(0, 100);
        
end
end

#-----------------------------------------------

if findfirst(graph,3) != 0 || findfirst(graph,0) != 0
figure(3)
for i in 1:nch
   subplot("$(nch)1$(i)")
   plot(t[1:ns], AECG_white[1:ns,i], color="black", linewidth=1.0, linestyle="-")
   plot(QRSm_pos[:,1]',zeros(size(QRSm_pos,1),1)', "ro")#plot(QRSm_pos[:,1]',QRSm_value[:,1]', "ro")
       title("First ICA")
end
end

#-----------------------------------------------

if findfirst(graph,4) != 0 || findfirst(graph,0) != 0
    figure(4)


    
for i in 1:nch
   subplot("41$(i)")
#if i == 1 title("SVD reconstruction") end
    #plot(t[1:ns], SVDrec[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    
    plot(t[1:ns], AECGm[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go") 

    title("residual signals")
end
end

#-----------------------------------------------

if findfirst(graph,5) != 0 || findfirst(graph,0) != 0
    figure(5)

    a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos

    for i in 1:nch
           subplot("42$(2*i-1)")
        #if i == 1 title("AECG feto (after ICA-sorted)") end
     

    plot(a,abs(fftshift(fft(AECGm[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
    #plot(a, angle(fftshift))
    xlim(0, 100);

subplot("42$(2*i)")

#   subplot("41$(i)")
#if i == 1 title("AECG subtract SVD reconstruction") end
        plot(t[1:ns], AECGm[1:ns,i], color="black", linewidth=1.0, linestyle="-")
        plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go") 
    title("Residuals signals")
end
end

#-----------------------------------------------
if findfirst(graph,6) != 0 || findfirst(graph,0) != 0
    figure(6)

a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos


for i in 1:nch
   subplot("42$(2*i-1)")
#if i == 1 title("AECG feto (after ICA-sorted)") end

    #plot(a,abs(fftshift(fft(AECGf2[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")
    #plot(a, angle(fftshift))
    #xlim(0, 100);
    plot(t[1:ns], AECGf2[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
    plot(QRSfcell_pos_smooth[i], zeros(size(QRSfcell_pos_smooth[i],1),1), "ro")
    title("Sorted Second ICA signals. SMI=$(SMI[i]). gini=$(giniMeasure[i])")

subplot("42$(2*i)")

#for i in 1:nch
#subplot("42$(i)")
#if i == 1 title("AECG feto (after ICA-sorted)") end
    plot(t[1:ns], AECGf2[1:ns,i], color="black", linewidth=1.0, linestyle="-")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
    plot(QRSfcell_pos[i]',QRSfcell_value[i]', "ro")
    title("Sorted Second ICA signals")
end
end

#-----------------------------------------------
if findfirst(graph,7) != 0 || findfirst(graph,0) != 0

figure(7)
subplot(211)
title("Ritmo cardíaco materno = $(heart_rate_mother)")
plot(t[1:ns], AECG_white[1:ns,1], color="black", 
linewidth=1.0, linestyle="-")
plot(QRSm_pos[:,1]',zeros(size(QRSm_pos,1),1)', "ro")
subplot(212)
title("Ritmo cardíaco fetal = $(heart_rate_feto)")
    #plot(QRSf_pos[:,1]',QRSf_value[:,1]', "bo")

    
plot(t[1:ns], AECGf2[1:ns,1], color="black", linewidth=1.0, linestyle="-")
     

   plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go")
   plot(QRSf_pos[:,1], zeros(size(QRSf_pos[:,1],1),1)+0.5, "bo")

end


if findfirst(graph,8) != 0 || findfirst(graph,0) != 0
figure(8)

a=collect(-999.9:0.2:999.9)/2;  #Solamente funciona en ventanas de 10segundos



for i in 1:nch
   subplot("42$(2*i-1)")
#if i == 1 title("AECG feto (after ICA-sorted)") end

    plot(a,abs(fftshift(fft(AECGf2[1:ns,i]))), color="black", linewidth=1.0, linestyle="-")

    #plot(a, angle(fftshift))

    xlim(0, 100);

subplot("42$(2*i)")

    plot(frecQ, Qfactor[:,i])  ;


#    plot(QRSfcell_pos[i]',QRSfcell_value[i]', "ro")
    plot(fetal_annot/sr,zeros(size(fetal_annot,1)),"go") 

    title("Sorted Second ICA signals")
end
end





end


#figure(2)
#for i in 1:m
#subplot("41$(i)")
#if i == 1 title("AECG notch") end
 #plot(t[1:num_sample], AECG_fnotch[1:num_sample,i], color="red", linewidth=1.0, linestyle="-")

#signal = AECG_fnotch[1:num_sample,i]

#medline=[median(signal),median(signal)]
#tmedline=[1,t[num_sample]]
#plot(tmedline[:],medline[:], color="black", linewidth=2.0, linestyle="-")


#difference = abs(signal - median(signal))
#median_difference = median(difference)

#medline1 = medline .+ median_difference; 
#medline2 = medline .- median_difference 
#plot(tmedline[:],medline1[:], color="black", linewidth=1.0, linestyle="--")
#plot(tmedline[:],medline2[:], color="black", linewidth=1.0, linestyle="--")


#s =  (difference / float(median_difference))
#plot(t[1:num_sample],s[1:num_sample], "bo", linewidth=1.0)


#median_s =  [median(s),median(s)]
#plot(tmedline[:],median_s[:], color="yellow", linewidth=1.0, linestyle="-")

#max,pos = findmax(s)
#println(max)
#println(pos)
#plot(pos/1000,max, "yo")
#end


# figure(4)
# for i in 1:k
#   subplot("$(k)1$(i)")
# if i == 1 title("ICA_sort") end
# plot(t[1:num_sample], AECG_sort[1:num_sample,i], color="blue", linewidth=1.0, linestyle="-")
# end
#