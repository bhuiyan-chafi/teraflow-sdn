from matplotlib.ticker import AutoMinorLocator
from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import numpy as np

x = np.array([100, 110, 120, 140, 160, 180, 200, 220])

# 100G - FF
y1 = np.array([0.0004, 0.0011, 0.0019, 0.0079, 0.0168, 0.0397, 0.0619, 0.0994])
# 100G - RF
y2 = np.array([0.0003, 0.0013, 0.0025, 0.0053, 0.0177, 0.0396, 0.0581, 0.1108])

# Create the plot
plt.figure(figsize=(10, 6))

# 400G - FF
plt.plot(x, y1, color="black", marker='o', markersize=4,
         linestyle='dotted')
# 400G - RF
plt.plot(x, y2, color="black", marker='x', markersize=4,
         linestyle='dotted')

# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220],
           [100, '', 120, '', 140, '', 160, '', 180, '', 200, '', 220])

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
plt.savefig('images/pan_FF_RF_OCH_OMS_100.png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")
