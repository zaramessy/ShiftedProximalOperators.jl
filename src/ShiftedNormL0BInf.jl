export ShiftedNormL0BInf

mutable struct ShiftedNormL0BInf <: ShiftedProximalFunction
	h::ProximableFunction
	x
	λ
    Δ
	function ShiftedNormL0BInf(n, λ)
		new(NormL0(λ), Vector{Float64}(undef, n), λ, 0.0)
	end
end

(ψ::ShiftedProximalFunction)(y) = ψ.h(ψ.x + y)

shifted(h::NormL0, x::Vector{Float64}, λ, Δ)= ShiftedNormL0BInf(h, x, λ, Δ)

function shift!(ψ::ShiftedNormL0BInf, x::Vector{Float64}, Δ)
    ψ.Δ = Δ
	ψ.x .= x
	ψ
end

function prox(ψ::ShiftedNormL0BInf,  q, σ)
    ProjB!(y) = begin
        for i ∈ eachindex(y)
            y[i] = min(max(y[i], ψ.xk[i] - ψ.Δ), ψ.xk[i] +ψ.Δ)
        end
    end 
    # @show σ/λ, λ
    c = sqrt(2*ψ.λ*σ)
    w = ψ.xk+q
    st = zeros(size(w))

    for i = 1:length(w)
        absx = abs(w[i])
        if absx <=c
            st[i] = 0
        else
            st[i] = w[i]
        end
    end
    s = ProjB(st) - xk
    return s 
end