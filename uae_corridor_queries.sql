DROP TABLE IF EXISTS uae_shipments;
DROP TABLE IF EXISTS uae_factors;
-- 1. Create Shipments Table
CREATE TABLE IF NOT EXISTS uae_shipments (
    shipment_id VARCHAR(10),
    client_sector VARCHAR(50),
    origin_port VARCHAR(50),
    corridor_hub VARCHAR(50),
    teu_count INT,
    cargo_tonnes DECIMAL(10, 2),
    transport_mode VARCHAR(30),
    distance_km INT,
    fuel_or_powertrain VARCHAR(50)
);
-- 2. Create Emission & Cost Reference Table
CREATE TABLE IF NOT EXISTS uae_factors (
    fuel_or_powertrain VARCHAR(50),
    factor_g_co2e_per_tkm DECIMAL(10, 2),
    fuel_cost_aed_per_km DECIMAL(10, 2)
);
-- 3. Populate Reference Factors
INSERT INTO uae_factors
VALUES ('Diesel Ultra-Low Sulfur', 96.0, 3.25),
    ('Biodiesel B20', 78.5, 3.40),
    ('Solar Grid Electric', 32.0, 1.10);
-- 4. Populate UAE Corridor Hauls
INSERT INTO uae_shipments
VALUES (
        'UAE-001',
        'Pharmaceuticals',
        'Jebel Ali Port',
        'Dubai South Logistics District',
        4,
        48.0,
        'Diesel Drayage Truck',
        28,
        'Diesel Ultra-Low Sulfur'
    ),
    (
        'UAE-002',
        'Electronics',
        'Jebel Ali Port',
        'Al Maktoum Int Airport DWC',
        10,
        120.0,
        'Diesel Drayage Truck',
        32,
        'Diesel Ultra-Low Sulfur'
    ),
    (
        'UAE-003',
        'Retail & Apparel',
        'Khalifa Port',
        'Dubai South Logistics District',
        6,
        72.0,
        'Biofuel B20 Truck',
        95,
        'Biodiesel B20'
    ),
    (
        'UAE-004',
        'Cold Chain Food',
        'Jebel Ali Port',
        'Dubai South Logistics District',
        2,
        24.0,
        'Electric Heavy Truck',
        28,
        'Solar Grid Electric'
    ),
    (
        'UAE-005',
        'Aviation Spares',
        'Khalifa Port',
        'Al Maktoum Int Airport DWC',
        8,
        96.0,
        'Diesel Drayage Truck',
        105,
        'Diesel Ultra-Low Sulfur'
    );
-- 5. Baseline Carbon & Operating Cost Analysis (Relational JOIN)
SELECT s.shipment_id,
    s.origin_port,
    s.corridor_hub,
    s.fuel_or_powertrain,
    (s.cargo_tonnes * s.distance_km) AS tonne_km,
    ROUND(
        (
            (
                s.cargo_tonnes * s.distance_km * f.factor_g_co2e_per_tkm
            ) / 1000.0
        ),
        2
    ) AS emissions_kg_co2e,
    ROUND((s.distance_km * f.fuel_cost_aed_per_km), 2) AS haul_cost_aed
FROM uae_shipments s
    JOIN uae_factors f ON s.fuel_or_powertrain = f.fuel_or_powertrain;
-- 6. Scenario Modeling: What If All Diesel Hauls Switched to Solar Electric?
SELECT s.shipment_id,
    s.cargo_tonnes,
    s.distance_km,
    ROUND(
        ((s.cargo_tonnes * s.distance_km * 96.0) / 1000.0),
        2
    ) AS diesel_baseline_kg,
    ROUND(
        ((s.cargo_tonnes * s.distance_km * 32.0) / 1000.0),
        2
    ) AS electric_target_kg,
    ROUND(
        (
            ((s.cargo_tonnes * s.distance_km * 96.0) / 1000.0) - ((s.cargo_tonnes * s.distance_km * 32.0) / 1000.0)
        ),
        2
    ) AS carbon_saved_kg,
    ROUND(
        (s.distance_km * 3.25) - (s.distance_km * 1.10),
        2
    ) AS cost_saved_aed
FROM uae_shipments s
WHERE s.fuel_or_powertrain = 'Diesel Ultra-Low Sulfur';