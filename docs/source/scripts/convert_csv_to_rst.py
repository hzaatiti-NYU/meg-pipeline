import os
import csv


def read_csv(file_path):
    with open(file_path, newline="") as csvfile:
        reader = csv.reader(csvfile)
        table_data = [row for row in reader]
    return table_data


def convert_csv_to_rst(csv_file, rst_file):
    table_data = read_csv(csv_file)
    with open(rst_file, "w") as file:
        file.write(
            ".. list-table:: Metrics for assessing data quality (Noise levels)\n"
        )
        file.write("   :header-rows: 1\n\n")
        for row in table_data:
            file.write("   * - " + "\n     - ".join(row) + "\n")


if __name__ == "__main__":
    current_dir = os.path.dirname(os.path.abspath(__file__))
    csv_file = os.path.abspath(
        os.path.join(current_dir, "../9-dashboard/data/noise_metrics.csv")
    )
    rst_file = os.path.abspath(
        os.path.join(current_dir, "../9-dashboard/noise_metrics_table.rst")
    )
    convert_csv_to_rst(csv_file, rst_file)
