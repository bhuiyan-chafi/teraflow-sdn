from matplotlib.ticker import AutoMinorLocator
from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import numpy as np

# Sample data using numpy arrays
# You MUST add 25 here so matplotlib knows where to plot the y-values
x = np.array([25, 30, 40, 50, 60])

# 800G - FF
y1 = np.array([0.0025, 0.0114, 0.0544, 0.1316, 0.1578])
# 800G - RF
y2 = np.array([0.0016, 0.0063, 0.0420, 0.1027, 0.1594])

# Create the plot
plt.figure(figsize=(10, 6))

# 800G - FF
plt.plot(x, y1, color="black", marker='o', markersize=4,
         linestyle='dotted')
# 800G - RF
plt.plot(x, y2, color="black", marker='x', markersize=4,
         linestyle='dotted')

# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([25, 30, 35, 40, 45, 50, 55, 60], [25, 30, '', 40, '', 50, '', 60])

# Add title and labels
plt.title('', fontsize=12)
plt.xlabel(r'$\lambda / \mu$', fontsize=10)
plt.ylabel('Blocking Probability', fontsize=10)

# Set Y-axis to logarithmic scale
plt.yscale('log')
plt.ylim(1e-4, 1)  # Set limits to stretch down to 10^-7 like the paper

# Remove margins on X-axis
plt.xlim(x.min(), x.max())

# Add grid lines for both axes (dense horizontal lines AND vertical lines at x values)
plt.grid(True, linestyle='--', alpha=0.7)

# Create custom legend entries splitting Line Styles and Markers
legend_elements = [
    Line2D([0], [0], color='black', lw=2, linestyle='dotted',
           label='Overall Blocking'),

    # The 2 datasets represented by Markers (line width set to 0 so only marker shows)
    Line2D([0], [0], color='black', lw=0, marker='o',
           markersize=4, label='FF (Filtered OCH,OMS)'),
    Line2D([0], [0], color='black', lw=0, marker='x',
           markersize=4, label='RF (Filtered OCH,OMS)'),
]

# Add the custom legend
plt.legend(handles=legend_elements, loc='best')

# Save the plot as an image file
plt.savefig('images/pan_FF_RF_OCH_OMS_800.png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")
