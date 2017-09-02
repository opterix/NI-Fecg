function quantile_filt1(x,s,q)
n=length(x); 
r=floor(Int64, s/2); 
indr=collect(0:s-1); 
indc=collect(1:n);
#print(indr)
#print(indc)
ind=[k+indr for k in indc];
ind=vcat(ind...)
#print(ind)

#x0=x[ones(Int64, r, 1)]; 
#print(r)
x0 = x[ones(Int64, r,1)];
xend = x[ones(Int64, r,1)*n];

X=[x0; x; xend];
X=reshape(X[ind],s,n); 
y=[quantile(X[:,k],q) for k in 1:size(X,2)];
return y
end




function medfilt1(x,s)
n=length(x); 
r=floor(Int64, s/2); 
indr=collect(0:s-1); 
indc=collect(1:n);
#print(indr)
#print(indc)
ind=[k+indr for k in indc];
ind=vcat(ind...)
#print(ind)

#x0=x[ones(Int64, r, 1)]; 
#print(r)
x0 = x[ones(Int64, r,1)];
xend = x[ones(Int64, r,1)*n];

X=[x0; x; xend];
X=reshape(X[ind],s,n); 
y=median(X,1);
return y
end

function median_spectre(A,s)
    # Es mejor si s es impar
    filter=vec(ones(1,s)/s);
    r=floor(s/2);

    signalFFT = fft(A,1);
    absFFT = abs(signalFFT);
    unitFFT = signalFFT./absFFT
    
    out=zeros(size(A))

    #Ap=

    #for kch in 1:size(signalFFT,2)
    #    aux=conv(filter, absFFT[:,kch]);
    #    out[:,kch] = aux[Int(r):end-Int(r+1)];
    #end

    medFFT= absFFT-out;
    signalFFT[medFFT.<=0]=0;

    sig_rec = ifft(unitFFT,1);
    
    return sig_rec;
end
