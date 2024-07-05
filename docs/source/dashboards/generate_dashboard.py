import plotly.graph_objs as go
import plotly.io as pio

# Sample data
x = [1, 2, 3, 4, 5, 6, 7]
y = [10, 14, 12, 20, 18, 20, 22]

# Create a scatter plot
fig = go.Figure(data=go.Scatter(x=x, y=y, mode='lines+markers'))

# Save the figure as an HTML file
pio.write_html(fig, file='_static/plotly_dashboard.html', auto_open=False)
