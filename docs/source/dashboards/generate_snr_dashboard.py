# app.py
import os
import mne
import numpy as np
import plotly.graph_objs as go
import plotly.io as pio
import pickle


def display_env_variable(variable_name):
    value = os.getenv(variable_name)
    if value is None:
        print(f"The environment variable '{variable_name}' is not set.")
    else:
        print(f"The value of the environment variable '{variable_name}' is: {value}")
    return value




# Step 1: Load the .fif file
def load_fif_data(file_path):
    raw = mne.io.read_raw_fif(file_path, preload=False)
    raw.pick_channels(raw.ch_names[:208])
    return raw



def remove_zero_channels(raw):
    data = raw.get_data()
    non_zero_indices = np.any(data != 0, axis=1)
    print(non_zero_indices)
    raw.pick_channels([raw.ch_names[i] for i in range(len(non_zero_indices)) if non_zero_indices[i]])
    return raw


# Step 2: Compute the SNR
def compute_snr(raw):
    data = raw.get_data()
    signal_power = np.mean(data ** 2, axis=1)
    noise_power = np.var(data, axis=1)
    snr = signal_power / noise_power
    return snr

# Step 3: Create the Dashboard



def create_snr_plot(snr_values, output_file):
    snr_trace = go.Scatter(
        x=np.arange(len(snr_values)),
        y=snr_values,
        mode='lines+markers',
        name='SNR'
    )

    layout = go.Layout(
        title='SNR of MEG Data',
        xaxis=dict(title='Channel'),
        yaxis=dict(title='SNR')
    )

    fig = go.Figure(data=[snr_trace], layout=layout)
    pio.write_html(fig, file=output_file, auto_open=False)


if __name__ == '__main__':

    # Path to your .fif file
    #MEG_DATA = display_env_variable('MEG_DATA')
    #file_path = '\empty-room\sub-emptyroom\meg-kit\empty-room-test_28_June_2024-raw_NO_OPM-raw.fif'
    file_path = ('dashboards/data/test-raw.fif')

    # # Load data and remove zero channels
    raw_data = load_fif_data(file_path)
    raw_data = remove_zero_channels(raw_data)

    with open('dashboards/data/empty_room_data.pkl', 'wb') as file:
        pickle.dump(raw_data, file)

    with open('dashboards/data/empty_room_data.pkl', 'rb') as file:
        raw_data = pickle.load(file)

    # Compute SNR
    snr_values = compute_snr(raw_data)

   # Create and save the SNR plot
    output_file = '_static/snr_plot.html'
    create_snr_plot(snr_values, output_file)