# ============================
# A-ZERO vΩ — Sensore AREN
# ============================

include("src/AREN_Sensor.jl")

# Soglia ufficiale del progetto (paletto)
cfg = AREN_Sensor.ArenConfig("A-ZERO vΩ — Default", 17.2, 8000.0, 50.0)

# Caricamento telemetria
r = AREN_Sensor.load_telemetry(
    "frametime_log.txt",
    "vram_log.txt",
    "4848_RTT_log.txt"
)

# Report
AREN_Sensor.aren_report(cfg, r)
