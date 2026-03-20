import shrike
from machine import Pin, SPI
import time


shrike.flash("FPGA_bitstream_MCU.bin")
time.sleep(2)

# Working Config 
#baudrate=50_000
#cs delay = 10ms
#send each frame 3 times
#3 short bursts

cs  = Pin(1, Pin.OUT, value=1)
spi = SPI(0, baudrate=50_000, polarity=0, phase=0, bits=8,
          firstbit=SPI.MSB, sck=Pin(2), mosi=Pin(3), miso=Pin(0))

HOT  = [0x32]*16 + [0xB4]*16 + [0xC8]*16 + [0x32]*16 # High heat
COLD = [0x28]*64 # Empty room

def send_frame(pixels):
    cs.value(0)
    time.sleep_ms(10)
    spi.write(bytes(pixels))
    time.sleep_ms(10)
    cs.value(1)
    time.sleep_ms(100)

# Continuously alternate HOT and COLD every 3 seconds
# LED should blink ON/OFF/ON/OFF repeatedly
print("Starting loop - LED should blink ON then OFF every 3 seconds")
while True:
    send_frame(HOT)
    send_frame(HOT)   # send twice to make sure it registers
    send_frame(HOT)
    print("HOT - LED should be ON")
    time.sleep(1)

    send_frame(COLD)
    send_frame(COLD)
    send_frame(COLD)
    print("COLD - LED should be OFF")
    time.sleep(1)

