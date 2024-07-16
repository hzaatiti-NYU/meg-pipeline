import plotly.graph_objects as go
import plotly.io as pio

# Data for the table example
status = ["Active", "Inactive", "Active", "Inactive"]
system_name = ["System A", "System B", "System C", "System D"]

# Create the table
fig = go.Figure(
    data=[
        go.Table(
            header=dict(
                values=["Status", "System Name"],
                fill_color="paleturquoise",
                align="left",
            ),
            cells=dict(
                values=[status, system_name], fill_color="lavender", align="left"
            ),
        )
    ]
)

# Update layout
fig.update_layout(title="System Status Dashboard", width=500, height=300)


# Save the figure as an HTML file
pio.write_html(
    fig,
    file="C:/Users/Admin/meg-pipeline-main/docs/source/_static/plotly_dashboard02.html",
    auto_open=False,
)
