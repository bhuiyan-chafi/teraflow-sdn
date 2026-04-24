from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import numpy as np

# -------------------------------------------------------------
# 1. IEEE PUBLICATION SETTINGS (The "Magic" Block)
# -------------------------------------------------------------
plt.rcParams.update({
    'font.size': 10,          # Base font size
    'axes.labelsize': 11,     # Axis label size
    'xtick.labelsize': 9,     # X tick numbers
    'ytick.labelsize': 9,     # Y tick numbers
    'legend.fontsize': 8,     # Legend text size (slightly smaller to fit)
    'font.family': 'serif',   # Forces serif fonts
    'font.serif': ['Times New Roman', 'Times', 'DejaVu Serif'] # Matches IEEE template
})

x = np.array([60, 70, 80, 90, 100])

# 400G - FF
y1 = np.array([0.0015, 0.0071, 0.0351, 0.0646, 0.1082])
# 400G - RF
y2 = np.array([0.0008, 0.0057, 0.0209, 0.0622, 0.1001])

# -------------------------------------------------------------
# 2. FIGURE SIZE (Shrunk from 10x6 down to IEEE column width)
# -------------------------------------------------------------
# 3.5 inches is roughly the width of a standard IEEE column. 
# 2.6 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.6))

# 3. Increased marker size slightly (from 4 to 5) since the figure is smaller
plt.plot(x, y1, color="black", marker='o', markersize=5, 
         linestyle='-', linewidth=0.8, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)

plt.plot(x, y2, color="black", marker='x', markersize=5, 
         linestyle='-', linewidth=0.8, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)

# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([60, 65, 70, 75, 80, 85, 90, 95, 100],
           [60, '', 70, '', 80, '', 90, '', 100])

# Labels (Removed the empty title, let the LaTeX caption do the talking)
plt.xlabel(r'$\lambda / \mu$')
plt.ylabel('Blocking Probability')

# Set Y-axis to logarithmic scale
plt.yscale('log')
plt.ylim(1e-4, 1)

# Remove margins on X-axis
plt.xlim(x.min(), x.max())

# Add grid lines
plt.grid(True, linestyle='-', alpha=0.7)

# Create custom legend entries
legend_elements = [
    Line2D([0], [0], color='black', lw=1.5, linestyle='-', label='Overall Blocking'),
    Line2D([0], [0], color='black', lw=0, marker='o', markersize=5, label='PARS-FF'),
    Line2D([0], [0], color='black', lw=0, marker='x', markersize=5, label='PARS-RF'),
]

# Add the custom legend
plt.legend(handles=legend_elements, loc='best')

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_PARS_400.png', format='png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")