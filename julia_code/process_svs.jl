function process_svs(filepath)

    a=readcsv("../data/"*filepath*".csv") #read file

    t=a[3:end,1]
    b=a[3:end, 2:end] #Extract one channel information

    f(x) = typeof(x)==Float64 #function to test if elements are float

    bool_floats = broadcast(f,b)
    bool_floats = convert(Array{Bool,2}, bool_floats) #Convert array to boolean appropiate for logical indexing
    b[~bool_floats]=0 #Convert all non-number strings to NaN
    b=convert(Array{Float64,2}, b) #Convert to Float array

    return t, b
end

# Ejemplo de uso:
# filepath="../data/a01.csv"
# (ecgtime,ecg)=process_svs(filepath)
# #Resultado de la operación:
# # ecgtime-> tiempo ecg
# # ecg -> Matriz de 60000x4
