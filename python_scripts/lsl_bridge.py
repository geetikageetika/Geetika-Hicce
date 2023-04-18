import time, threading
import pylsl
import numpy as np

#%% PARAMETERS

# LSL parameters
stream_name = 'HiCCE'
stream_type = 'EEG'
source_id = 'HiCCE_Version2.0_2023_April'
chunk_size = 16
format = 'float32'
n_cha = 8
l_cha = [str(i) for i in range(n_cha)]
units = 'uV'
manufacturer = 'MLab_ICTP'
sample_rate = 200

# Sine wave parameters
freq = 10  # Hz
amplitude = 50  # uV
phase = [np.pi/2, 0, np.pi/4, np.pi/3, np.pi/6, np.pi/8, np.pi/12, np.pi/16]  

# Random signal parameters
mean = 0
std = 1

#%% CREATE LSL OUTLET

# Create the stream info
lsl_info = pylsl.StreamInfo(name=stream_name,
                            type=stream_type,
                            channel_count=n_cha,
                            nominal_srate=sample_rate,
                            channel_format=format,
                            source_id=source_id)

# Modify description to include additional information (e.g., manufacturer)
lsl_info.desc().append_child_value("manufacturer", manufacturer)

# Append channel information. By default, MEDUSA© Platform expects this
# information in the "channels" section of the LSL stream description
channels = lsl_info.desc().append_child("channels")
for l in l_cha:
    channels.append_child("channel") \
        .append_child_value("label", l) \
        .append_child_value("units", units) \
        .append_child_value("type", stream_type)

# Create LSL outlet
lsl_outlet = pylsl.StreamOutlet(info=lsl_info,
                                chunk_size=chunk_size,
                                max_buffered=100*chunk_size)

#%% STREAM DATA


def send_data():
    """Function that generates random data and sends it through LSL
    """
    while io_run.is_set():
        try:
            if lsl_outlet is not None:
                # Get data
                # --------------------------------------------------------------
                # TODO: Get the data from an actual device using its API
                # For this tutorial, we will generate random data
                
                # sample = std * np.random.randn(chunk_size, n_cha) + mean
                
                sample = np.empty((chunk_size, n_cha))
                sample.fill(5)
                
                # Generating sine wave
                # t = np.arange(chunk_size) / sample_rate
                # sample = np.zeros((chunk_size, n_cha))
                # for i in range(n_cha):
                #     sample[:, i] = amplitude * np.sin(2 * np.pi * freq * t + phase[i])
                # 
                sample = sample.tolist()
                # --------------------------------------------------------------
                # Get the timestamp of the chunk
                timestamp = pylsl.local_clock()
                # Send the chunk through LSL
                lsl_outlet.push_chunk(sample, timestamp)
                # Wait for the next chunk. This timer is not particularly
                # accurate
                
                
        except Exception as e:
            raise e


# Run data source in other thread so the execution can be stopped on demand
io_run = threading.Event()
io_run.set()

lsl_thread = threading.Thread(
    name='HiCCE_Signal_Thread',
    target=send_data
)
lsl_thread.start()

# Streaming data...
print('LSL_dridge is streaming data. We can use MEDUSA to check that the '
      'stream is received correctly')

#%% STOP EXECUTION AND CLEAR

# Pause the main thread until the user presses enter
input("Press enter to finish...")

# Stop the thread and join
io_run.clear()
lsl_thread.join()

# Final message
print('Finished successfully')