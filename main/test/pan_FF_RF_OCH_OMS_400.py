from matplotlib.ticker import AutoMinorLocator
from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import numpy as np

x = np.array([65, 70, 80, 90, 100, 120, 130, 150])

# 400G - FF
y1 = np.array([0.0008, 0.0028, 0.0127, 0.0272, 0.0444, 0.0967, 0.1183, 0.1964])
# 400G - RF
y2 = np.array([0.0006, 0.0010, 0.0091, 0.0195,
              0.0395, 0.0851, 0.1150, 0.1826])

# Create the plot
plt.figure(figsize=(10, 6))

# 400G - FF
plt.plot(x, y1, color="black", marker='o', markersize=4,
         linestyle='dotted')
# 400G - RF
plt.plot(x, y2, color="black", marker='x', markersize=4,
         linestyle='dotted')

# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([65, 70, 80, 90, 100, 110, 120, 130, 140, 150],
           [65, 70, 80, 90, 100, 110, 120, 130, 140, 150])

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
plt.savefig('images/pan_FF_RF_OCH_OMS_400.png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")
