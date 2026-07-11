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

x = np.array([2250, 1950, 1650, 1350, 1050])

# SPSC-PSC-SAFF
y1 = np.array([
    0.12899499,
    0.07836645,
    0.03937427,
    0.0103744,
    0.0000595
])
# SPSC-PRF-SAFF
y2 = np.array([
    0.16949153,
    0.10715401,
    0.05463005,
    0.0149684,
    0.00047106
])
# SPRF-PRF-SAFF
y3 = np.array([
    0.15851272,
    0.11945032,
    0.07734205,
    0.04025308,
    0.0094
])
# SPFF-PRF-SAFF
y4 = np.array([
    0.18708906,
    0.14474263,
    0.09417161,
    0.04461147,
    0.01350017
])
# SPSC-PSC-SARF
y5 = np.array([
    0.17562327,
    0.14897494,
    0.09539474,
    0.04414587,
    0.01503715
])

plt.figure(figsize=(3.5, 2.7))

# SPSC-PSC-SAFF
plt.plot(x, y1, color="green",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='*', markersize=4, markerfacecolor='none', markeredgewidth=0.8)
# SPSC-PRF-SAFF
plt.plot(x, y2, color="olive",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='^', markersize=4, markerfacecolor='none', markeredgewidth=0.8)
# SPRF-PRF-SAFF
plt.plot(x, y3, color="slateblue",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='>', markersize=4, markerfacecolor='none', markeredgewidth=0.8)
# SPRF-PRF-SAFF
plt.plot(x, y4, color="maroon",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='o', markersize=4, markerfacecolor='none', markeredgewidth=0.8)
# SPSC-PSC-SARF
plt.plot(x, y5, color="orangered",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='s', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

plt.xticks([2250, 1950, 1650, 1350, 1050])
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

    Line2D([0], [0], color='black', lw=0.8,
           linestyle='-', label='Overall Blocking'),
    Line2D([0], [0], color='green', lw=0, marker='*',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PSC-SAFF'),
    Line2D([0], [0], color='olive', lw=0, marker='^',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PRF-SAFF'),
    Line2D([0], [0], color='slateblue', lw=0, marker='>',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-PRF-SAFF'),
    Line2D([0], [0], color='maroon', lw=0, marker='o',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPFF-PRF-SAFF'),
    Line2D([0], [0], color='orangered', lw=0, marker='s',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PSC-SARF'),
]

# Add the custom legend inside the plot area at the lower right
plt.legend(handles=legend_elements, loc='lower right', edgecolor='black',
           framealpha=0.9, fancybox=False, handletextpad=0.3, labelspacing=0.3)

# Remove extra margins
plt.tight_layout(pad=0.2)

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/PAN_Parallel.pdf', format='pdf',
            bbox_inches='tight')
print("Chart successfully saved!")
