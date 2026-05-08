from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import numpy as np

# -------------------------------------------------------------
# 1. IEEE PUBLICATION SETTINGS (The "Magic" Block)
# -------------------------------------------------------------
plt.rcParams.update({
    'font.size': 8,          # Base font size
    'axes.labelsize': 8,     # Axis label size
    'xtick.labelsize': 8,     # X tick numbers
    'ytick.labelsize': 8,     # Y tick numbers
    'legend.fontsize': 8,     # Legend text size (slightly smaller to fit)
    'font.family': 'serif',   # Forces serif fonts
    # Matches IEEE template
    'font.serif': ['Times New Roman', 'Times', 'DejaVu Serif']
})

x = np.array([
    1650,
    1350,
    1050,
    750])

# SPFFPRF-SAFF
y1 = np.array([
    0.12193362,
    0.09269588,
    0.02591211,
    0.00106754])

plt.figure(figsize=(3.5, 2.7))

# SPFFPRF-SAFF
plt.plot(x, y1, color="blue",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='x', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)

# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([
    1650,
    1350,
    1050,
    750])

# Labels (Removed the empty title, let the LaTeX caption do the talking)
plt.xlabel(r'$\lambda / \mu$')
plt.ylabel('Blocking Probability', fontweight='bold')

# Set Y-axis to logarithmic scale
plt.yscale('log')
plt.ylim(1e-4, 1)

# Remove margins on X-axis
plt.xlim(x.min(), x.max())

# Make axes values (tick labels) bold
plt.xticks(fontweight='bold')
plt.yticks(fontweight='bold')

# Add grid lines
plt.grid(True, linestyle='-', alpha=0.7)

# Create custom legend entries
legend_elements = [

    Line2D([0], [0], color='green', lw=0.8,
           linestyle='-', label='Overall Blocking'),
    Line2D([0], [0], color='blue', lw=0, marker='x',
           markersize=6, markeredgewidth=0.5, markerfacecolor='none', label='SPFFPRF-SAFF'),
]

# Add the custom legend inside the plot area at the lower right
plt.legend(handles=legend_elements, loc='lower right', edgecolor='black',
           framealpha=0.9, fancybox=False, handletextpad=0.3, labelspacing=0.3)

# Remove extra margins
plt.tight_layout(pad=0.2)

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Parallel_Colored.pdf', format='pdf',
            bbox_inches='tight')
print("Chart successfully saved!")
