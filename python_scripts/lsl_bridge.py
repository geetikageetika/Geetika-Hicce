import time, threading
import pylsl
import numpy as np
from hicce_data_acquisition import get_data, chunk_size, initial_setup, enable_acquisition


#%% PARAMETERS

# LSL parameters
stream_name = 'HiCCE'
stream_type = 'EEG'
source_id = 'HiCCE_Version2.0_2023_April'
chunk_size = chunk_size
format = 'int16'
n_cha = 64
l_cha = [str(i) for i in range(n_cha)]
units = 'uV'
manufacturer = 'MLab_ICTP'
sample_rate = 250


 

# CREATE LSL OUTLET

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

# STREAM DATA

def send_data():
    """Function that generates random data and sends it through LSL
    """
    while io_run.is_set():
        try:
            if lsl_outlet is not None:
                # Get data
                # sample = data_acquisition()
                # sample=np.random.rand(n_cha,chunk_size)
                initial_setup()
                enable_acquisition(chunk_size)
                (TSAB, CHAB), (TSCD, CHCD)=get_data(chunk_size)
                if TSAB>0:
                    # for d in CHAB[0:8]:
                        # print(len(d))
                    # print(CHAB[0])
                    # print(CHAB[0:8])
                    sample=CHAB
                
                # Get the timestamp of the chunk
                # timestamp = pylsl.local_clock()
                    timestamp=TSAB*4e-9
                # Send the chunk through LSL
                    lsl_outlet.push_chunk(sample, timestamp)
                # Wait for the next chunk.
                # time.sleep(chunk_size / sample_rate)
    
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

# STOP EXECUTION AND CLEAR

# Pause the main thread until the user presses enter
input("Press enter to finish...")

# Stop the thread and join
io_run.clear()
lsl_thread.join()

# Final message
print('Finished successfully')