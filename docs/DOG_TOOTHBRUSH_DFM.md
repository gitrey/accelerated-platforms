# Design for Manufacturing (DFM): Silicone Overmolding for CanineCare Pro

This document outlines the manufacturing requirements and constraints for the silicone overmolding process of the CanineCare Pro smart dog toothbrush. These specifications ensure structural integrity, IPX7 waterproofing, and efficient mass production.

## 1. Material Compatibility & Bonding

To achieve a durable, chew-resistant bond between the rigid handle and the soft grip/brush head, the following material strategies are required:

- **Substrate (Rigid Frame):** Medical-grade ABS (Acrylonitrile Butadiene Styrene). ABS provides excellent impact resistance and a stable surface for silicone adhesion.
- **Overmold (Soft Grip/Head):** Liquid Silicone Rubber (LSR), Medical-grade, 40–60 Shore A durometer.
- **Bonding Mechanism:**
    - **Chemical Bonding:** Use "self-bonding" LSR grades specifically formulated for ABS or apply a primer to the ABS substrate before overmolding.
    - **Mechanical Interlocks:** Design through-holes, dovetail slots, and wrap-around edges into the ABS frame. This ensures the silicone remains attached even if the chemical bond fails under heavy chewing.

## 2. Injection Molding Geometry

### 2.1 ABS Substrate (Primary Shot)
- **Wall Thickness:** Maintain a uniform wall thickness of 1.5mm to 2.5mm. Avoid thick sections (>3mm) to prevent sink marks and internal stresses.
- **Draft Angles:** 
    - Internal surfaces: Minimum 1.0°.
    - External surfaces (to be overmolded): 0.5° to 1.0°.
    - Cosmetic surfaces: 2.0° to 3.0° depending on texture depth.
- **Radii:** All internal corners should have a minimum radius of 0.5mm to reduce stress concentrations.

### 2.2 Silicone Overmold (Secondary Shot)
- **Wall Thickness:** Target 1.0mm to 3.0mm. Sections thinner than 0.5mm should be avoided as they are prone to tearing during demolding and have poor flow characteristics.
- **Draft Angles:** Not strictly required due to LSR's elasticity, but a 0.5° draft is recommended for automated part ejection.
- **Shut-off Land:** A minimum of 0.8mm flat "shut-off" area is required on the ABS part to prevent silicone "flash" from leaking into non-overmolded areas.

## 3. Parting Lines & Gating (IPX7 Integrity)

Maintaining an IPX7 rating (submersion up to 1m for 30 minutes) requires precise control over the overmolding interface.

- **Parting Lines:**
    - Locate parting lines away from the dog's mouth-contact areas and the primary grip surface.
    - The parting line for the silicone must be positioned to ensure a seamless seal around the power button and LED indicators.
- **Gating Locations:**
    - **ABS Gating:** Valve gates or sub-gates located at the base of the handle (covered by the charging cap).
    - **LSR Gating:** Use a "cold runner" system with valve gates to eliminate gate vestige. Gating should occur at the thickest section of the overmold, typically at the rear of the handle or the base of the brush head.
- **Flash Control:** Flash must be limited to <0.05mm to prevent peeling and bacterial growth in crevices.

## 4. Assembly Sequence for Internal Electronics

Due to the high temperatures required for LSR curing (typically 150°C–200°C), the internal electronics (especially the Lithium-ion battery) **cannot** be present during the overmolding process.

### Recommended Assembly Flow:
1.  **Stage 1: Two-Shot Molding**
    - Mold the ABS handle shell.
    - Overmold the LSR grip onto the ABS shell.
2.  **Stage 2: Internal Component Installation**
    - Slide the pre-assembled electronic chassis (containing the PCB, 1000mAh battery, and BLE module) into the handle cavity.
    - Seat the ultrasonic transducer into the neck of the handle, ensuring a tight fit against the internal ribs for optimal vibration transfer.
3.  **Stage 3: Waterproof Sealing**
    - Install the bottom charging cap (containing the Qi-inductive coil).
    - Use ultrasonic welding or a medical-grade epoxy to seal the bottom cap to the main ABS handle, achieving the IPX7 seal.
4.  **Stage 4: Brush Head Attachment**
    - The brush head is a separate consumable. It consists of a reinforced polymer core overmolded with soft silicone bristles and the treat reservoir. It snaps onto the vibrating motor shaft using a mechanical locking interface.

## 5. Tooling Considerations
- **Steel Grade:** Use H13 or S7 tool steel for LSR molds to resist the abrasive nature of some silicone fillers.
- **Surface Finish:** SPI-A2 (High Polish) for the ABS to ensure clear bonding; Mold-Tech MT-11010 or similar for the silicone grip to provide a "soft-touch" feel.
- **Venting:** Extensive vacuum venting is required in the LSR mold to prevent air entrapment and "burns" at the end of the flow path.
