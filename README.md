# UAE Green Freight Corridor & Decarbonization Engine (JAFZA - Khalifa Port Hub)

An enterprise-focused scope 3 logistics carbon accounting and scenario engine modeling freight emissons across Key UAE logistics corridors (Jebel Ali Port / DP World, Khalifa Port / AD Port, Dubai South, and Al Maktoum International Airport DWC).

This project aligns with the **UAE Net Zero 2050 Strategic Initiative**, the **GLEC Framework**, and the **GHG Protocol Corporate Value Chain (Scope 3 Category 4)** standard.

---

## 🎯 Business Problem & Context

Logistics operators and multinational 3PLs moving cargo across UAE free zones face growing compliance mandates to track line-haul carbon footprints and evaluate fleet transition viability.

This engine models real-world cargo movements to answer a critical executive question:  
_What are the carbon reduction and operating fuel cost impacts of transitioning regional diesel drayage fleets to solar grid-powered electric heavy haulage?_

---

## 🛠️️ Architecture & Tech Stack

- **Database:** Relational SQLite schema ('uae_corridor.db') tracking multimodal shipments and emission benchmarks.
- **Data Modeling & Analytics:** SQL queries performing relational 'JOIN' operations, activity metrics ($tkm$), and scenario modeling.
- **Automation Pipeline:** Python ('run_uae_analytics.py') orchestrating the end-to-end execution and executive summary reporting.
- **Reporting:** Structured KPIs in UAE Dirhams (AED) and kilograms of $CO_2e$.

---

## 📐 Carbon Accounting Methodology

Emissions and activity calculations follow standard GLEC formulations:

$$\text{Tonne-Kilometers (tkm)} = \text{Cargo Weight (Tonnes)} \times \text{Corridor Distance (km)}$$

$$\text{Emissions (kg } CO_2e\text{)} = \frac{\text{tkm} \times \text{Emission Factor (g } CO_2e\text{/tkm)}}{1000}$$

$$\text{Fuel Cost (AED)} = \text{Distance (km)} \times \text{Cost per km (AED)}$$

### Reference Factors Applied:

| Powertrain / Fuel           | Emission Factor ($g CO_2e / tkm$) | Fuel Cost (AED / km) |
| :-------------------------- | :-------------------------------- | :------------------- |
| **Diesel Ultra-Low Sulfur** | 96.0                              | AED 3.25             |
| **Biodiesel B20**           | 78.5                              | AED 3.40             |
| **Solar Grid Electric**     | 32.0                              | AED 1.10             |

---

## 📊 Analytical Results & Fleet Transition Scenario

### Decarbonization Impact: Diesel to Solar Electric Fleet

| Shipment ID | Cargo & Route                                     | Baseline Diesel $CO_2$ | Electric Target $CO_2$ | $CO_2$ Reduction | Fuel Savings   |
| :---------- | :------------------------------------------------ | :--------------------- | :--------------------- | :--------------- | :------------- |
| **UAE-001** | Pharma (Jebel Ali $\rightarrow$ Dubai South)      | 129.02 kg              | 43.01 kg               | **86.02 kg**     | **AED 60.20**  |
| **UAE-002** | Electronics (Jebel Ali $\rightarrow$ DWC Airport) | 368.64 kg              | 122.88 kg              | **245.76 kg**    | **AED 68.80**  |
| **UAE-005** | Spares (Khalifa Port $\rightarrow$ DWC Airport)   | 967.68 kg              | 322.56 kg              | **645.12 kg**    | **AED 225.75** |

### Strategic Findings

- **48.3% Carbon Cut:** Transitioning targeted diesel line-hauls directly eliminates **976.90 kg of $CO_2e$** along the corridor.
- **Operational Cost Advantage:** Generates **AED 354.75** in fuel cost savings across these hauls due to the high efficiency of UAE solar-powered charging relative to commercial diesel.
