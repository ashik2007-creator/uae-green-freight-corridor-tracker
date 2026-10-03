import sqlite3

# 1. Connect and initialize database
con = sqlite3.connect("uae_corridor.db")
cur = con.cursor()

# 2. Run the SQL schema and scenario queries
with open("uae_corridor_queries.sql", "r") as f:
    cur.executescript(f.read())

# 3. Print Baseline Performance
print("\n" + "="*70)
print("       UAE GREEN CORRIDOR BASELINE (JEBEL ALI & KHALIFA PORTS)")
print("="*70)
print(f"{'ID':<9} | {'Route':<36} | {'tkm':<8} | {'CO2e (kg)':<10} | {'Cost (AED)'}")
print("-" * 70)

baseline_query = """
SELECT 
    s.shipment_id,
    (s.origin_port || ' -> ' || s.corridor_hub) AS route,
    (s.cargo_tonnes * s.distance_km) AS tkm,
    ROUND(((s.cargo_tonnes * s.distance_km * f.factor_g_co2e_per_tkm) / 1000.0), 2) AS emissions,
    ROUND((s.distance_km * f.fuel_cost_aed_per_km), 2) AS cost
FROM uae_shipments s
JOIN uae_factors f ON s.fuel_or_powertrain = f.fuel_or_powertrain;
"""

total_baseline_co2 = 0
total_baseline_cost = 0

for row in cur.execute(baseline_query):
    print(f"{row[0]:<9} | {row[1]:<36} | {row[2]:<8.0f} | {row[3]:<10.2f} | AED {row[4]:<7.2f}")
    total_baseline_co2 += row[3]
    total_baseline_cost += row[4]

print("-" * 70)
print(f"TOTAL BASELINE FOOTPRINT: {total_baseline_co2:.2f} kg CO2e  |  TOTAL FUEL: AED {total_baseline_cost:.2f}")

# 4. Print Decarbonization Scenario: Diesel to Solar Grid Electric
print("\n" + "="*70)
print("     DECARBONIZATION SCENARIO: DIESEL FLEET -> SOLAR ELECTRIC TRUCKS")
print("="*70)
print(f"{'ID':<9} | {'Baseline CO2':<14} | {'Electric CO2':<14} | {'CO2 Saved':<12} | {'Cost Saved'}")
print("-" * 70)

scenario_query = """
SELECT 
    s.shipment_id,
    ROUND(((s.cargo_tonnes * s.distance_km * 96.0) / 1000.0), 2) AS diesel_kg,
    ROUND(((s.cargo_tonnes * s.distance_km * 32.0) / 1000.0), 2) AS electric_kg,
    ROUND((((s.cargo_tonnes * s.distance_km * 96.0) / 1000.0) - ((s.cargo_tonnes * s.distance_km * 32.0) / 1000.0)), 2) AS co2_saved,
    ROUND((s.distance_km * 3.25) - (s.distance_km * 1.10), 2) AS cost_saved
FROM uae_shipments s
WHERE s.fuel_or_powertrain = 'Diesel Ultra-Low Sulfur';
"""

total_saved_co2 = 0
total_saved_aed = 0

for row in cur.execute(scenario_query):
    print(f"{row[0]:<9} | {row[1]:<11.2f} kg | {row[2]:<11.2f} kg | {row[3]:<9.2f} kg | AED {row[4]:<7.2f}")
    total_saved_co2 += row[3]
    total_saved_aed += row[4]

print("-" * 70)
pct_co2_cut = (total_saved_co2 / total_baseline_co2) * 100
print(f"TOTAL CORRIDOR CO2 REDUCTION: {total_saved_co2:.2f} kg ({pct_co2_cut:.1f}% reduction)")
print(f"TOTAL CORRIDOR FUEL SAVINGS  : AED {total_saved_aed:.2f}")
print("="*70 + "\n")

con.close()