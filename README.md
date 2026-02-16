# Daredevil – Embedded Spatial Awareness System

A design-driven embedded system built to enhance human spatial awareness in high-risk or low-visibility environments using multi-directional ultrasonic sensing and adaptive haptic feedback.

This project is not just obstacle detection.  
It is engineered as a human-machine interface for intuitive spatial perception.

---

# 🧠 Design Thinking Approach

## 1️⃣ Problem Identification

Humans have limited spatial awareness outside their visual field.  
In defense, assistive mobility, and robotics applications, threats or obstacles often approach from blind zones (rear or lateral directions).

Existing solutions:
- Rely heavily on visual displays
- Create cognitive overload
- Do not provide intuitive directional feedback

The core question:
**How can we convert environmental distance data into instinctive physical awareness?**

---

## 2️⃣ Human-Centered Design Principle

The system was designed around three key ideas:

### • Directional Mapping
Each sensing direction directly maps to a physical feedback location:
- Rear sensor → Rear motor + Rear LED  
- Left sensor → Left motor + Left LED  
- Right sensor → Right motor + Right LED  

This creates spatial consistency between detection and feedback.

### • Intuitive Haptic Language
Instead of complex audio cues, vibration intensity scales with distance:
- Closer object → Stronger vibration  
- Distant object → Mild vibration  
- No object → Silence  

The user does not need training to interpret it.

### • Minimal Cognitive Load
No screens.  
No numbers.  
No constant alerts.  

Only necessary feedback when required.

---

# 🏗 System Architecture (Design Perspective)

## Sensing Layer
3× Ultrasonic Sensors placed to cover:
- Rear
- Left
- Right

Design Choice:
Ultrasonic sensing was selected for:
- Low power consumption
- Simplicity
- Cost efficiency
- Real-time measurement capability

---

## Processing Layer
ESP32 Dev Module

Design Choice:
- Real-time pulse measurement
- Fast GPIO control
- Expandable for wireless telemetry
- Sufficient processing headroom for future motion analysis

---

## Actuation Layer
ULN2003 Motor Driver + Vibration Motors

Design Rationale:
ESP32 GPIO cannot drive motors directly.
ULN2003 provides:
- Current amplification
- Electrical isolation
- Reliable switching

Motors are mapped directionally for intuitive awareness.

---

## Visual Layer
3× LEDs for directional confirmation.

Design Purpose:
- Secondary confirmation system
- Useful during testing
- Optional in final wearable form

---

# ⚙️ Functional Workflow

1. Trigger pulse sent from ESP32.
2. Echo pulse duration measured.
3. Distance calculated.
4. Threshold comparison executed.
5. Corresponding motor and LED activated.
6. Intensity adjusted proportionally.

System operates in continuous loop for real-time response.

---

# 🔋 Power Design Strategy

Battery → Charging Module → Boost Converter → 5V Rail

Design Considerations:
- Portability
- Rechargeability
- Stable voltage regulation
- Common ground architecture for signal stability

All system modules share common ground to prevent measurement noise and instability.

---

# 🛠 Key Design Decisions

| Challenge | Design Solution |
|------------|----------------|
| Limited spatial awareness | Multi-direction sensing |
| Cognitive overload | Haptic-based feedback |
| GPIO current limits | ULN2003 driver stage |
| Portability requirement | Battery-powered architecture |
| Expandability | ESP32 platform selection |

---

# 📈 Scalability Vision

The system architecture supports future enhancements:

- Motion detection using temporal derivative of distance
- Threat classification logic
- IMU integration
- Wireless telemetry
- LiDAR upgrade for higher precision
- Adaptive AI-based environment learning

The design intentionally keeps sensing, processing, and actuation modular.

---

# 🛡 Application Scope

- Assistive wearable navigation systems
- Defense blind-zone awareness
- Robotics collision prevention
- Industrial safety systems
- Autonomous navigation research platforms

---

# 🎯 Core Innovation

The innovation is not the sensor.  
It is the **conversion of spatial data into intuitive physical awareness**.

This project demonstrates:

- Embedded system architecture design
- Human-centered interface engineering
- Real-time signal processing
- Power management strategy
- Modular hardware design

---

# 👤 Design Team

T. Sharan, Anshul Bohini, Nithya Hasini, Advaitya Vora.

a bunch of engineers at Team Ketos.  

---

This project reflects applied embedded systems engineering with a strong emphasis on human-centric design and real-world usability.
