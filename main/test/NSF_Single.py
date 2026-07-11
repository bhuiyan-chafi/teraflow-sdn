from matplotlib.lines import Line2D
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
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
    750,
    650,
    550,
    450,
    350,
    250])

# SPSC-SAFF
y1 = np.array([
    0.24032922,
    0.1902439,
    0.11537156,
    0.042197,
    0.00193893,
    0.00000186
])
######################
# SPRF-SAFF
y2 = np.array([
    0.26223453,
    0.19858156,
    0.14366812,
    0.07399709,
    0.01311973,
    0.0000155
])
######################
# SPFF-SAFF
y3 = np.array([
    0.27487685,
    0.24072547,
    0.13362761,
    0.07746018,
    0.01785124,
    0.0000171
])
######################
# SP+1RF-SAFF
y4 = np.array([
    0.315,
    0.307,
    0.22575758,
    0.1552795,
    0.06680313,
    0.00161525
])
######################
# SPSC-SARF
y5 = np.array([
    0.294,
    0.24597116,
    0.17923993,
    0.08899059,
    0.02398312,
    0.00057792
])

# -------------------------------------------------------------
# 2. FIGURE SIZE (Shrunk from 10x6 down to IEEE column width)
# -------------------------------------------------------------
# 3.5 inches is roughly the width of a standard IEEE column.
# 2.7 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.7))

# version with colors

# SPSC-SAFF
plt.plot(x, y1, color="green",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='*', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
##########################################################################################
# SPRF-SAFF
plt.plot(x, y2, color="olive",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='^', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
##########################################################################################
# SPFF-SAFF
plt.plot(x, y3, color="slateblue",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='>', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
##########################################################################################
# SP+1RF-SAFF
plt.plot(x, y4, color="violet",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker="o", markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
##########################################################################################
# SPSC-SARF
plt.plot(x, y5, color="orangered",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker="s", markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([
    750,
    650,
    550,
    450,
    350,
    250])

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
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-SAFF'),
    Line2D([0], [0], color='olive', lw=0, marker='^',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-SAFF'),
    Line2D([0], [0], color='slateblue', lw=0, marker='>',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPFF-SAFF'),
    Line2D([0], [0], color='violet', lw=0, marker="o",
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SP+1RF-SAFF'),
    Line2D([0], [0], color='orangered', lw=0, marker="s",
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-SARF'),
]

# Add the custom legend inside the plot area at the lower right
plt.legend(handles=legend_elements, loc='lower right', edgecolor='black',
           framealpha=0.9, fancybox=False, handletextpad=0.3, labelspacing=0.3)

# Remove extra margins
plt.tight_layout(pad=0.2)

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Single.pdf', format='pdf',
            bbox_inches='tight')
print("Chart successfully saved!")
