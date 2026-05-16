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

x = np.array([2250, 1950, 1650, 1350, 1050, 750])

# SPFFPRF-SAFF
y1 = np.array([0.19961115,
               0.15490944,
               0.11683849,
               0.08894536,
               0.02591211,
               0.00106754])
# SPRFPRF-SAFF
y2 = np.array([0.19845857,
               0.15326751,
               0.11631885,
               0.06376196,
               0.02380048,
               0.00082972])

# SPSCPSC-SAFF
y3 = np.array([0.1848146,
               0.13128931,
               0.10491003,
               0.04445518,
               0.0094473,
               0.0000001])

# SPSCPRF-SAFF
y4 = np.array([0.18586698,
               0.16166166,
               0.10416667,
               0.06027306,
               0.01689914,
               0.0001328])

# SPSCPRF-SARF
y5 = np.array([0.27744511,
               0.20157584,
               0.15632516,
               0.13702022,
               0.07821106,
               0.02617436])
plt.figure(figsize=(3.5, 2.7))

# SPFFPRF-SAFF
plt.plot(x, y1, color="blue",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='x', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

# SPRFPRF-SAFF
plt.plot(x, y2, color="brown",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='o', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

# SPSCPSC-SAFF
plt.plot(x, y3, color="black",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='s', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

# SPSCPRF-SAFF
plt.plot(x, y4, color="green",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='^', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

# SPSCPRF-SARF
plt.plot(x, y5, color="red",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='v', markersize=4, markerfacecolor='none', markeredgewidth=0.8)

plt.xticks([2250, 1950, 1650, 1350, 1050, 750])
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
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPFF-PRF-SAFF'),
    Line2D([0], [0], color='brown', lw=0, marker='o',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-PRF-SAFF'),
    Line2D([0], [0], color='green', lw=0, marker='^',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PRF-SAFF'),
    Line2D([0], [0], color='red', lw=0, marker='v',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PRF-SARF'),
    Line2D([0], [0], color='black', lw=0, marker='s',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-PSC-SAFF'),
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
