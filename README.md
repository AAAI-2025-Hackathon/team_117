# Check-In

- Title of your submission: LungAI | AI for Healthcare
- Team Members: [Bhanu Reddy](mailto:bhanureddychada@icloud.com), [Manikanta Revuri](mailto:manikantarevuri01@gmail.com), [Leon Kipkoech](mailto:leonkipkoech00@gmail.com)
- [x] All team members agree to abide by the [Hackathon Rules](https://aaai.org/conference/aaai/aaai-25/hackathon/)
- [x] This AAAI 2025 hackathon entry was created by the team during the period of the hackathon, February 17 – February 24, 2025
- [x] The entry includes a 2-minute maximum length demo video here: [Link](https://www.youtube.com/watch?v=71LhD6EkUO8)
- [x] The entry clearly identifies the selected theme in the README and the video.

# Lung AI
 
## Inspiration  
 
![Image](https://github.com/user-attachments/assets/9f539d19-ead1-42a7-bcad-df30dfe43e0c)
 
Millions suffer from respiratory conditions like asthma and COPD, worsened by environmental pollutants. **Real-time respiratory monitoring** is crucial. We developed **Lung AI**, a **wearable device** leveraging **AI to assess respiratory health risks**, integrating **biometric data and environmental conditions** for early warnings and proactive care.  
 
---
 
## What it does  
![Image](https://github.com/user-attachments/assets/32826b99-c2ca-4ccf-a6ce-a4ffb1f4c32e)
 
Lung AI continuously monitors breathing patterns and air quality to assess respiratory risks:
 
- **MPU6050 accelerometer** tracks **Breaths Per Minute (BPM) and breath depth**.  
- **PMS5003 air quality sensor** measures **PM2.5/PM10** levels.  
- **User-inputted health data** (age, history, symptoms) via a **Flutter mobile app**.  
- Data is processed by an **AI model** that evaluates respiratory health risk levels.  
 
---
 
## How we built it  
 
### **Hardware Components**  
- **ESP32-S3** for processing & communication.  
- **MPU6050** for breathing pattern detection.  
- **PMS5003** for air quality monitoring.  
 
### **AI & System Architecture**  
1. **Breath Cycle Calculation** - Peak detection extracts breathing patterns.  
2. **AI Analysis** - Logistic Regression model predicts respiratory risk.  
3. **Mobile App Integration** - Data sent via **Bluetooth/Wi-Fi**, analyzed, and displayed.  
 
---
 
## Challenges  
- **Sensor noise & calibration** – Applied filtering techniques.  
- **Stable data transmission** – Optimized Bluetooth/Wi-Fi protocols.  
- **AI model training** – Combined simulated & medical research data.  
 
---
 
## Accomplishments  
- **Real-time AI-powered respiratory assessment**.  
- **Seamless integration of wearable & mobile app**.  
- **Optimized BPM calculations for accuracy**.  
 
---
 
## Lessons Learned  
- **AI in healthcare requires rigorous validation**.  
- **Sensor fusion improves monitoring accuracy**.  
- **Efficient real-time data transmission is critical**.  
 
---
 
## What's next?  
- **Advanced AI models (LSTM, Transformers) for deeper analysis**.  
- **Pulse oximeter integration for better diagnostics**.  
- **Cloud-based inference to optimize processing**.  
- **Accessibility features like voice alerts**.  
 
Lung AI has real-world potential in **health monitoring and disease prevention**, aiming to empower individuals and healthcare professionals with **AI-driven respiratory insights**.
