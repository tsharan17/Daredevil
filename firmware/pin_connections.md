# ESP32 Complete Pin Connections

---

## 1️⃣ Ultrasonic Sensors → ESP32

### Front Sensor
| Sensor Pin | Connection |
|------------|------------|
| VCC        | 5V Supply  |
| GND        | Common Ground |
| TRIG       | ESP32 GPIO 5 |
| ECHO       | ESP32 GPIO 18 |

### Left Sensor
| Sensor Pin | Connection |
|------------|------------|
| VCC        | 5V Supply |
| GND        | Common Ground |
| TRIG       | ESP32 GPIO 17 |
| ECHO       | ESP32 GPIO 16 |

### Right Sensor
| Sensor Pin | Connection |
|------------|------------|
| VCC        | 5V Supply |
| GND        | Common Ground |
| TRIG       | ESP32 GPIO 4 |
| ECHO       | ESP32 GPIO 2 |

---

## 2️⃣ ESP32 → ULN2003 Motor Driver

| ESP32 GPIO | ULN2003 Pin | Function |
|------------|------------|----------|
| GPIO 25    | IN1        | Rear Motor |
| GPIO 26    | IN2        | Left Motor |
| GPIO 27    | IN3        | Right Motor |

---

## 3️⃣ ULN2003 Power Connections

| ULN2003 Pin | Connection |
|-------------|------------|
| GND         | Common Ground |
| COM         | 5V Supply |

---

## 4️⃣ Motors → ULN2003 Outputs

| Motor | ULN2003 Output | Positive Connection |
|-------|---------------|--------------------|
| Rear Motor | OUT1 | 5V Supply |
| Left Motor  | OUT2 | 5V Supply |
| Right Motor | OUT3 | 5V Supply |

---

## 5️⃣ LED Direction Indicators → ESP32

⚠ Each LED must use a **220Ω–330Ω current limiting resistor**

| ESP32 GPIO | Connection |
|------------|------------|
| GPIO 21 | Resistor → Rear LED → GND |
| GPIO 22 | Resistor → Left LED → GND |
| GPIO 23 | Resistor → Right LED → GND |

---

## 6️⃣ Power System Connections

Battery → Charging Module → Boost Converter  
Boost Converter Output → 5V Rail  

### 5V Rail Distribution
- Sensors VCC  
- Motor Positive  
- ESP32 VIN  

---

## 7️⃣ Common Ground (CRITICAL)

All grounds must be connected together:

- ESP32 GND  
- Sensor GND  
- ULN2003 GND  
- Battery GND  
- LED GND  

---

### ✅ Notes
- Ensure stable 5V output from boost converter.
- Keep echo wires short to reduce noise.
- Verify all grounds are common before powering the system.
