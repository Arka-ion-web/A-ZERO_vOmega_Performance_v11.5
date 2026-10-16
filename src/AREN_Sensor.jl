module AREN_Sensor

export ArenConfig, ArenReading, load_telemetry, aren_evaluate, aren_report

############################
# 1. STRUTTURE DATI
############################

struct ArenConfig
    name::String
    frametime_threshold_ms::Float64
    vram_threshold_mb::Float64
    rtt_threshold_ms::Float64
end

struct ArenReading
    frametime_ms::Vector{Float64}
    vram_mb::Vector{Float64}
    rtt_ms::Vector{Float64}
end

############################
# 2. CARICAMENTO TELEMETRIA
############################

function load_series(path::String)
    data = Float64[]
    open(path, "r") do f
        for line in eachline(f)
            v = tryparse(Float64, strip(line))
            v === nothing && continue
            push!(data, v)
        end
    end
    return data
end

function load_telemetry(ft_path::String, vram_path::String, rtt_path::String)::ArenReading
    ft   = load_series(ft_path)
    vram = load_series(vram_path)
    rtt  = load_series(rtt_path)
    return ArenReading(ft, vram, rtt)
end

############################
# 3. VALUTAZIONE AREN
############################

function aren_evaluate(cfg::ArenConfig, r::ArenReading)
    ft_ok   = all(r.frametime_ms .<= cfg.frametime_threshold_ms)
    vram_ok = all(r.vram_mb      .<= cfg.vram_threshold_mb)
    rtt_ok  = all(r.rtt_ms       .<= cfg.rtt_threshold_ms)

    return (
        frametime_ok = ft_ok,
        vram_ok      = vram_ok,
        rtt_ok       = rtt_ok,
        system_ok    = ft_ok && vram_ok && rtt_ok
    )
end

############################
# 4. REPORT
############################

function aren_report(cfg::ArenConfig, r::ArenReading)
    res = aren_evaluate(cfg, r)

    println("=== AREN SENSOR REPORT ===")
    println("Name: ", cfg.name)
    println("Frametime threshold (ms): ", cfg.frametime_threshold_ms)
    println("VRAM threshold (MB):      ", cfg.vram_threshold_mb)
    println("RTT threshold (ms):       ", cfg.rtt_threshold_ms)
    println()
    println("Frametime OK: ", res.frametime_ok)
    println("VRAM OK:      ", res.vram_ok)
    println("RTT OK:       ", res.rtt_ok)
    println("---------------------------")
    println("SYSTEM OK:    ", res.system_ok)
    println("===========================")

    return res
end

end # module
