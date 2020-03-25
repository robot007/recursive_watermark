# Recursive Watermark
Protect hard real-time channels of Industrial Control Systems with recursive watermark (RWM) methods.

This page includes supporting materials of the following paper

Z. Song, A. Skuric. K. Ji, "A Recursive Watermark Method for Hard Real-Time Industrial Control System Cyber-Resilience Enhancement", IEEE
Transactions on Automation Science and Engineering, pp 1-14, 2020.
```
@Article{SongRWM2020,
  author   = {Z. {Song} and A. {Skuric} and K. {Ji}},
  title    = {A Recursive Watermark Method for Hard Real-Time Industrial Control System Cyber-Resilience Enhancement},
  journal  = {IEEE Transactions on Automation Science and Engineering},
  year     = {2020},
  pages    = {1-14},
  issn     = {1558-3783},
  doi      = {10.1109/TASE.2019.2963257},
  abstract = {Cybersecurity is of vital importance to industrial control systems (ICSs), such as ship automation, manufacturing, building, and energy automation systems. Many control applications require hard real-time channels, where the delay and jitter are in the levels of milliseconds or less. To the best of our knowledge, no encryption algorithm is fast enough for hard real-time channels of existing industrial fieldbuses and, therefore, made mission-critical applications vulnerable to cyberattacks, e.g., delay and data injection attacks. In this article, we propose a novel recursive watermark (RWM) algorithm for hard real-time control system data integrity validation. Using a watermark key, a transmitter applies watermark noise to hard real-time signals and sends through the unencrypted hard real-time channel. The same key is transferred to the receiver by the encrypted nonreal-time channel. With the same key, the receiver can detect if the data have been modified by the attackers and take action to prevent catastrophic damages. We provide analysis and methods to design proper watermark keys to ensure reliable attack detection. We use a ship propulsion control system for the simulation-based case study, where our algorithm smoothly shuts down the system after attacks. We also evaluated the algorithm speed on a Siemens S7-1500 programmable logic controller (PLC). This hardware experiment demonstrated that the RWM algorithm takes about 2.8 μs to add or validate the watermark noise on one sample data point. As a comparison, common cryptic hashing algorithms can hardly process a small data set under 100 ms. The proposed RWM is about 32 to 1375 times faster than the standard approaches.},
  keywords = {Cyber resilience;cyber security;delay attack;industrial control system (ICSs);Internet of Things (IoT);watermark.},
}
```
