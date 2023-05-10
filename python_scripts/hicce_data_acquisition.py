from udma import *
import numpy as np
import matplotlib.pyplot as plt
from time import sleep


sleep_time = 0.001


# Make conection with the borad
cb = UDMA_CLASS("140.105.17.180", 7)
cb.connect()
cb.log(0)


def initial_setup(comblock=0):
    """Initial setup for data acquisiton from HiCCE board.
    """    
    # Select comblock
    cb.select_comblock(0)
    # Reset HiCCE
    cb.write_reg(5, 0) #RESET ON
    cb.write_reg(5, 1) #RESET OFF

    #Disable Acquisiton 
    cb.write_reg(4, 0)
    cb.write_reg(7, 0)

    # FIFO Clear
    cb.select_comblock(0)
    cb.write_reg(17, 1)
    cb.write_reg(17, 0)
    cb.select_comblock(1)
    cb.write_reg(17, 1)
    cb.write_reg(17, 0)
    cb.select_comblock(0)

    # Configure INTANT (Reset Counter)
    cb.write_reg(0, 6150)
    cb.write_reg(1, 6150)
    cb.write_reg(2, 6150)
    cb.write_reg(3, 6150)
    # Configure INTANT (Cyclic Read)
    cb.write_reg(0, 6182)
    cb.write_reg(1, 6182)
    cb.write_reg(2, 6182)
    cb.write_reg(3, 6182)

def enable_acquisition(NSamples=100):
    #Set number of samples per package
    cb.write_reg(6, 32*NSamples)

    #Enable acquisition
    cb.write_reg(4, 15)
    cb.write_reg(7,1)

def read_channels(Ncomblock=0, NSamp=100, TO=10):
    cb.select_comblock(Ncomblock)
    wordsInFifo=cb.read_reg(34)[1][0]>>16
    #Wait until FIFO have enough samples to read.
    wd=0
    while wordsInFifo<(32*NSamp+4):
        wordsInFifo_new=cb.read_reg(34)[1][0]>>16
        if wordsInFifo_new == wordsInFifo:
            wd+=1
            if wd==TO: #if the value doesn't change after TO iterations return error
                return -1
        else:
            wordsInFifo=wordsInFifo_new
            wd=0
    if NSamp==1:
        dpack=cb.read_hicce((32*NSamp)+5)[1]
    else:
        dpack=cb.read_hicce((32*NSamp)+4)[1]
    return dpack

def decode(dpack):
    head=dpack[0]
    CEN=(head>>16) & 0xff
    SBT=(head>>8) & 0xff
    SAT=head & 0xff
    TS=dpack[1]<<32 | dpack[2]
    TAIL=dpack[-1]
    CENT=(TAIL>>16) & 0xff
    FLAGS=TAIL & 0xffff

    CH=[]
    for i in range(64):
        CH.append([])
    
    for i in range(len(dpack[3:-1])):
        d=dpack[i]
        CH[(i%32)].append((d>>16))
        CH[(i%32)+32].append((d&0xffff))
    
    return CH, TS, (CEN, CENT, SBT, SAT, FLAGS)
    
def get_data(chunks=10):
    # initial_setup()
    # enable_acquisition(32*chunks)
    CHAB, TSAB, FLAGSAB =decode(read_channels(0, chunks))
    CHCD, TSCD, FLAGSCD =decode(read_channels(1, chunks))
    return (TSAB, CHAB), (TSCD, CHCD)

def loop_setup(comblock=0):
    # Select comblock
    cb.select_comblock(comblock)

    # Reset HiCCE
    cb.write_reg(5, 0) #RESET ON
    cb.write_reg(5, 1) #RESET OFF

    # Disable Acquisiton 
    cb.write_reg(4, 0)
    
    # FIFO Clear
    cb.write_reg(33, 1)
    cb.write_reg(33, 0)
    
    # Configure INTANT (Enable Acquisition)
    cb.write_reg(4, 15)
    # sleep(1)
    # cb.write_reg(4, 0)  




# Number of line in comblock
num_of_lines = 32
# Number of channels ( 2 channels per line A, B) A=0-31 | B=32-63
num_of_channels = num_of_lines * 2


def all_channels_data(data, channels):       
    for i in range(len(data)):
        ls_16_bits = data[i] & 0xFFFF
        ms_16_bits = data[i] >> 16
        
        # check if the value is negative and if negative convert using tow's complement
        if ls_16_bits >= 0x8000: 
            ls_16_bits = -((~ls_16_bits & 0xFFFF) + 1)
        if ms_16_bits >= 0x8000: 
            ms_16_bits = -((~ms_16_bits & 0xFFFF) + 1)       
        
        channels[i%num_of_lines].append(ls_16_bits) # A = index range 0 to 31
        channels[(i%num_of_lines)+num_of_lines].append(ms_16_bits) # B = index range 32 to 63 



samples_per_channel = 10
fifo_chunk = num_of_lines * samples_per_channel # Read "samples_per_channel" samples for 32 lines and divide into 64 channels
repeat =  10 #  Repeat the process 
chunk_size = samples_per_channel * repeat


def data_acquisition():
    # List of lists. Each list represents a channel
    channels = []
    for i in range(num_of_channels):
        channels.append([])
        
    initial_setup()
    for i in range(repeat):   
        # Collect Data
        data = cb.read_fifo(fifo_chunk)
        print(data[0])
        
        # All channels' data
        all_channels_data(data[1], channels)
        
        # Setup for data acquisition
        loop_setup()
        
        # Wait for the next chunk.
        sleep(sleep_time)
    
    return channels
    



if __name__ == '__main__':
    i = 0
    while i < 10:
        i += 1
        sample = data_acquisition()
        print(i, " ", len(sample), " ", len(sample[0]))
    
    print(len(sample[1])) 
    
    plt.plot(sample[11])
    plt.show()

    for i in range(41, 44):
        plt.plot(sample[i], label=i)
        plt.legend()
    plt.show()
