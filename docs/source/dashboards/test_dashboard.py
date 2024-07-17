from dash import dcc, html
import pandas as pd
import plotly.express as px
import plotly.io as pio

# Read the data
df = pd.read_csv("https://plotly.github.io/datasets/country_indicators.csv")


# Generate the initial figure
def generate_initial_figure():
    # Filter the data for the year 2011
    dff = df[df["Year"] == 1962]

    # Check if the DataFrame is empty
    if dff.empty:
        print("No data available for the year 2011.")
        return None  # or return an empty figure

    # Select values for x and y axes
    fertility_data = dff[
        dff["Indicator Name"] == "Fertility rate, total (births per woman)"
    ]
    life_expectancy_data = dff[
        dff["Indicator Name"] == "Life expectancy at birth, total (years)"
    ]

    if fertility_data.empty or life_expectancy_data.empty:
        print("One of the required indicators is not available for the year 2011.")
        return None  # or return an empty figure

    # Extract single values
    x_value = fertility_data["Value"].values[0]
    y_value = life_expectancy_data["Value"].values[0]
    country_name = life_expectancy_data["Country Name"].values[0]

    # Create a scatter plot with single values wrapped in lists
    fig = px.scatter(
        x=[x_value],  # Wrap in a list
        y=[y_value],  # Wrap in a list
        hover_name=[country_name],  # Wrap in a list
    )

    fig.update_xaxes(title="Fertility rate, total (births per woman)", type="linear")
    fig.update_yaxes(title="Life expectancy at birth, total (years)", type="linear")
    fig.update_layout(margin={"l": 40, "b": 40, "t": 10, "r": 0}, hovermode="closest")

    return fig


# import plotly.io as pio

# Other imports and code remain the same...

# Create the initial figure
initial_fig = generate_initial_figure()

# Save the initial figure as HTML if the figure is not None
if initial_fig is not None:
    # Call write_html correctly
    pio.write_html(
        initial_fig,
        file="C:/Users/Admin/meg-pipeline/docs/source/_static/plotly_dashboard.html",
        auto_open=False,
    )
    print(
        "File saved successfully at C:/Users/Admin/meg-pipeline/docs/source/_static/plotly_dashboard.html"
    )
else:
    print("Figure generation failed.")
