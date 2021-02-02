### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 1da946c0-2bb5-11eb-2f0f-758d25179ee1
using Plots

# ╔═╡ 19c3bd3e-2bb7-11eb-3dc6-f5b9ac4cc275
# LHS Experimental Design
using LatinHypercubeSampling

# ╔═╡ 9c4a32d0-2bb7-11eb-055d-43280267f369
using DataFrames

# ╔═╡ f335342e-2bb4-11eb-206e-0192ac43c16f
kTax = (0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)

# ╔═╡ 2fea95ee-2bb5-11eb-2d28-5de3d32f52da
kInf_perc = (0.00, 0.00, 0.00, 0.00, -4.11, -4.99, -6.57, -8.39, -10.68, -13.27, 0.94, 0.00, 0.00, 0.00, -7.09, -8.23, -10.81, -13.40, -16.13, -18.00, -18.97, -19.29, -19.41, -19.44, -19.46, -19.47, -19.48, -19.49, -19.50, -19.51, -19.52, -19.54, -19.55, -19.57, -19.58, -19.60, -19.62, -19.64, -19.66, -19.67, -19.68, -19.69, -19.68, -19.67, -19.64, -19.75, -19.88, -20.03, -20.17, -20.32, -20.47, -20.62, -20.78, -20.93, -21.08, -21.24, -21.38, -21.53, -21.67, -21.81, -21.95, -22.08, -22.20, -22.32, -22.44, -22.56, -22.66, -22.77, -22.87, -22.97, -23.06, -23.14, -23.23, -23.31, -23.39)

# ╔═╡ 2feb3230-2bb5-11eb-0999-9d88f1c6d8fd
kInf = @. kInf_perc/100

# ╔═╡ 2ff4f630-2bb5-11eb-3153-a15217c9c759
periods = 76

# ╔═╡ 300ee6d0-2bb5-11eb-0378-dfd5e805fde7
dl = Vector{Float64}(undef, periods)

# ╔═╡ 301cc97e-2bb5-11eb-2fed-eb5f23a492d0
dk = Vector{Float64}(undef, periods)

# ╔═╡ 301ddaf0-2bb5-11eb-3685-a55b6abc9851
k = Vector{Float64}(undef, periods)

# ╔═╡ 30329b70-2bb5-11eb-18da-4d88102f365e
y = Vector{Float64}(undef, periods)

# ╔═╡ 304ab750-2bb5-11eb-3140-2b5cca95c79d
g = Vector{Float64}(undef, periods)

# ╔═╡ 30682a60-2bb5-11eb-36d0-6525b4158af1
a = Vector{Float64}(undef, periods)

# ╔═╡ 307ac800-2bb5-11eb-0cc7-afb11f8a3465
pop0 = 140

# ╔═╡ 307ceae0-2bb5-11eb-2688-f7c013201148
population = Vector{Float64}(undef, periods)

# ╔═╡ 309b6f60-2bb5-11eb-05fc-c9bc501c9657
population[1] = pop0

# ╔═╡ 30c872ce-2bb5-11eb-0f65-11ce2ba15d50
begin
dpop = Vector{Float64}(undef, periods)
dpop = @. (dpop/dpop)*0.006
end

# ╔═╡ 30e01980-2bb5-11eb-273e-091266888b49
for t in 2:length(population)
  population[t] = population[t - 1] * (1 + dpop[t])
end

# ╔═╡ 30f6fce0-2bb5-11eb-077b-2718c1d254f5
Ly = 0.6

# ╔═╡ 30f83560-2bb5-11eb-0d2b-3d3845231c31
Ky = 0.4

# ╔═╡ 3100249e-2bb5-11eb-1e86-e179b77e66fb
a1 = 0.012

# ╔═╡ 31188ea0-2bb5-11eb-17a0-7ba507d7c693
k[1] = 0.03

# ╔═╡ 312f7200-2bb5-11eb-1b8f-271c40356a98
y[1] = 15000

# ╔═╡ 31308370-2bb5-11eb-2563-c71843e24aee
g[1] = 0.018 #y_t in the model

# ╔═╡ 314766d0-2bb5-11eb-3cdd-45cd6c856cca
a[1] = 0.0112

# ╔═╡ 315633e0-2bb5-11eb-1ba0-73fff7bf71ce
li = 0.2

# ╔═╡ 3164b2d0-2bb5-11eb-0c30-5ff0ea282e77
ki = 0.1

# ╔═╡ 3165c440-2bb5-11eb-2a9f-fb74715916b4
# Labor and capital parameters
dl[1] = 0.0084

# ╔═╡ 317b6f20-2bb5-11eb-162d-c569cec6e20d
dk[1] = 0.018

# ╔═╡ 0d0db852-2bb5-11eb-048a-6980cb8af058
@timev for t in 2:(periods)
        if t != 2
                dl[t] = (population[t-1]/population[t-2]) - 1
                dk[t] = dk[1]*(1 + kTax[t-1] + kInf[t-1])
        else
                dl[t] = (population[t]/pop0) - 1
                dk[t] = dk[1]*(1 + kTax[t-1] + kInf[t-1])
        end
end

# ╔═╡ 15618680-2bb5-11eb-0490-9bc138b724b7
# Model
@timev for t in 2:periods
        a[t] = a[t-1]*(1 + dk[t])
        g[t] = a[t] + (dl[t]*Ly) + (dk[t]*Ky)
        y[t] = y[t-1]*(1+g[t-1])
end

# ╔═╡ 8ff846e0-2bb5-11eb-37c5-c708fa71447b
plotlyjs()

# ╔═╡ 8ff90a30-2bb5-11eb-30bc-cf368a58a6dd
plot(y,title="GDP Projection",
      xaxis="Time",yaxis="GDP",label="GDP", lw = 2)

# ╔═╡ 900231f0-2bb5-11eb-2199-9bd5dec88f1e
plot!(twinx(), a, ls = :dash, label = "MFP", ymirror = true, color = :green, lw = 2, grid = :none)

# ╔═╡ 2e558c22-2bb7-11eb-24a5-ff97e12b4d22
plan, fitness = LHCoptim(120, 3, 100)

# ╔═╡ 42c7ec20-2bb7-11eb-073b-cd069327942e
plot(plan[:,1], plan[:,2], seriestype = :scatter, label = :none)

# ╔═╡ 4d4cf230-2bb7-11eb-2605-9f565b48ffeb
scaled_plan = scaleLHC(plan, [(0.01,0.05), (0.007, 0.01), (0.01, 0.02)])

# ╔═╡ 7df30eee-2bb8-11eb-3f08-d19e1fd7e36c
scaled_plan[:,3]

# ╔═╡ 7c734230-2bb7-11eb-3b29-d12bc7c35a5c
plot(scaled_plan[:,1], scaled_plan[:,2], seriestype = :scatter, label = :none, yaxis = "Capital Stock Growth", xaxis = "Labor Growth Rate")

# ╔═╡ 84601130-2bb7-11eb-3acb-bdd308a8cb7b
begin
	results = [(Vector{Float64}(undef, periods), Vector{Float64}(undef, periods), 		Vector{Float64}(undef, periods), Float64[], Float64[]) for _ in 1:120]


	df = [(Vector(), Vector(), Vector()) for _ in 1:120]
	for j in eachindex(view(scaled_plan, 1:5, 1:2))
			println(j[1])
	end
end

# ╔═╡ 94c74930-2bb7-11eb-17d0-7ff60c3140ca
for j in eachindex(view(scaled_plan, 1:120, 1:3))
        #println(scaled_plan[j[1]]," - ", scaled_plan[j[2]])
        dl = Vector{Float64}(undef, periods)
        dk = Vector{Float64}(undef, periods)
        k = Vector{Float64}(undef, periods)
        y = Vector{Float64}(undef, periods)
        g = Vector{Float64}(undef, periods)
        a = Vector{Float64}(undef, periods)
        dk[1] = scaled_plan[j[1]]
        dl[1] = scaled_plan[j[2]]
        y[1] = 15000
        g[1] = 0.018 #y_t in the model
        a[1] = 0.0112
        for t in 2:(periods)
                if t != 2
                        dl[t] = (population[t-1]/population[t-2]) - 1
                        dk[t] = dk[1]*(1 + kTax[t-1] + kInf[t-1])
                else
                        dl[t] = (population[t]/pop0) - 1
                        dk[t] = dk[1]*(1 + kTax[t-1] + kInf[t-1])
                end
        end

        for t in 2:periods
                a[t] = a[t-1]*(1 + dk[t])
                g[t] = a[t] + (dl[t]*Ly) + (dk[t]*Ky)
                y[t] = y[t-1]*(1+g[t-1])
        end
        #one_run = (y, g, a, scaled_plan[j[1]], scaled_plan[j[2]])
        push!(df[j[1]][1], y)
        push!(df[j[1]][2], g)
        push!(df[j[1]][3], a)

end

# ╔═╡ c2ff8fb0-2bb7-11eb-2402-b76fa5bca9a0
function plot_series(data, index, num_runs, name)
        c::AbstractString = name
        object = plot(data[1][index][1], label = :none, title = c)
        for i in 2:num_runs
                object = plot!(data[i][index][1], label = :none)
        end
        return object
end # function

# ╔═╡ ce5fda8e-2bb7-11eb-15cd-31bcda2bf457
mfpPlot = plot_series(df, 3, 120, "Multifactor Productivity Projection")

# ╔═╡ dade66b0-2bb7-11eb-05e1-39c0ebdbc30f
dGDPplot = plot_series(df, 2, 120, "Change in GDP Projection")

# ╔═╡ df7ddf70-2bb7-11eb-14da-8b10c1cbfc48
GDPplot = plot_series(df, 1, 120, "GDP Projection")

# ╔═╡ bed6a9b0-2bbb-11eb-399b-75858e517178
scaled_plan

# ╔═╡ f12961d0-2bb8-11eb-0078-b170ae4d867f
for j in eachindex(view(scaled_plan, 1:5, 1:3))
		@show scaled_plan[j[scaled_plan, 1]]
end

# ╔═╡ Cell order:
# ╠═f335342e-2bb4-11eb-206e-0192ac43c16f
# ╠═2fea95ee-2bb5-11eb-2d28-5de3d32f52da
# ╠═2feb3230-2bb5-11eb-0999-9d88f1c6d8fd
# ╠═2ff4f630-2bb5-11eb-3153-a15217c9c759
# ╠═300ee6d0-2bb5-11eb-0378-dfd5e805fde7
# ╠═301cc97e-2bb5-11eb-2fed-eb5f23a492d0
# ╠═301ddaf0-2bb5-11eb-3685-a55b6abc9851
# ╠═30329b70-2bb5-11eb-18da-4d88102f365e
# ╠═304ab750-2bb5-11eb-3140-2b5cca95c79d
# ╠═30682a60-2bb5-11eb-36d0-6525b4158af1
# ╠═307ac800-2bb5-11eb-0cc7-afb11f8a3465
# ╠═307ceae0-2bb5-11eb-2688-f7c013201148
# ╠═309b6f60-2bb5-11eb-05fc-c9bc501c9657
# ╠═30c872ce-2bb5-11eb-0f65-11ce2ba15d50
# ╠═30e01980-2bb5-11eb-273e-091266888b49
# ╠═30f6fce0-2bb5-11eb-077b-2718c1d254f5
# ╠═30f83560-2bb5-11eb-0d2b-3d3845231c31
# ╠═3100249e-2bb5-11eb-1e86-e179b77e66fb
# ╠═31188ea0-2bb5-11eb-17a0-7ba507d7c693
# ╠═312f7200-2bb5-11eb-1b8f-271c40356a98
# ╠═31308370-2bb5-11eb-2563-c71843e24aee
# ╠═314766d0-2bb5-11eb-3cdd-45cd6c856cca
# ╠═315633e0-2bb5-11eb-1ba0-73fff7bf71ce
# ╠═3164b2d0-2bb5-11eb-0c30-5ff0ea282e77
# ╠═3165c440-2bb5-11eb-2a9f-fb74715916b4
# ╠═317b6f20-2bb5-11eb-162d-c569cec6e20d
# ╠═0d0db852-2bb5-11eb-048a-6980cb8af058
# ╠═15618680-2bb5-11eb-0490-9bc138b724b7
# ╠═1da946c0-2bb5-11eb-2f0f-758d25179ee1
# ╠═8ff846e0-2bb5-11eb-37c5-c708fa71447b
# ╠═8ff90a30-2bb5-11eb-30bc-cf368a58a6dd
# ╠═900231f0-2bb5-11eb-2199-9bd5dec88f1e
# ╠═19c3bd3e-2bb7-11eb-3dc6-f5b9ac4cc275
# ╠═2e558c22-2bb7-11eb-24a5-ff97e12b4d22
# ╠═42c7ec20-2bb7-11eb-073b-cd069327942e
# ╠═4d4cf230-2bb7-11eb-2605-9f565b48ffeb
# ╠═7df30eee-2bb8-11eb-3f08-d19e1fd7e36c
# ╠═7c734230-2bb7-11eb-3b29-d12bc7c35a5c
# ╠═9c4a32d0-2bb7-11eb-055d-43280267f369
# ╠═84601130-2bb7-11eb-3acb-bdd308a8cb7b
# ╠═94c74930-2bb7-11eb-17d0-7ff60c3140ca
# ╠═c2ff8fb0-2bb7-11eb-2402-b76fa5bca9a0
# ╠═ce5fda8e-2bb7-11eb-15cd-31bcda2bf457
# ╠═dade66b0-2bb7-11eb-05e1-39c0ebdbc30f
# ╠═df7ddf70-2bb7-11eb-14da-8b10c1cbfc48
# ╠═bed6a9b0-2bbb-11eb-399b-75858e517178
# ╠═f12961d0-2bb8-11eb-0078-b170ae4d867f
