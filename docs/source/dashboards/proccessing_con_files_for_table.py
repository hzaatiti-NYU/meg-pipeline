import os
import numpy as np
import pandas as pd
import mne


def process_con_file(file_path):
    # Load the .con file using MNE
    raw = mne.io.read_raw_kit(file_path, preload=True)

    # Get data for all channels
    data, times = raw[:, :]

    # Calculate average and variance across all channels
    avg = np.mean(data)
    var = np.var(data)

    return avg, var


def process_all_con_files(base_folder):
    results = []

    for root, _, files in os.walk(base_folder):
        for file in files:
            if file.endswith(".con"):
                file_path = os.path.join(root, file)
                avg, var = process_con_file(file_path)
                results.append({"File Name": file, "Average": avg, "Variance": var})

    return results


def save_results_to_csv(results, output_file):
    # Ensure the directory exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    # Save results to CSV
    df = pd.DataFrame(results)
    df.to_csv(output_file, index=False)


# Set the base folder containing .con files and subfolders
base_folder = r"data"
# Set the output CSV file path
output_file = r"docs/source/9-dashboard/data/con_files_statistics.csv"

# Process all .con files and save the results
results = process_all_con_files(base_folder)
save_results_to_csv(results, output_file)

print(f"Results saved to {output_file}")
