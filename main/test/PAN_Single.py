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
    350])

# SPSC-SAFF
y1 = np.array([
    0.11643836,
    0.05961792,
    0.03317578,
    0.00527534,
    0.0004213
])
######################
# SPRF-SAFF
y2 = np.array([
    0.14379371,
    0.10686549,
    0.06204881,
    0.03004963,
    0.00297346
])
######################
# SPFF-SAFF
y3 = np.array([
    0.16117764,
    0.11454484,
    0.08111824,
    0.03494725,
    0.00387346
])
######################
# SP+1RF-SAFF
y4 = np.array([
    0.22213967,
    0.16420194,
    0.11050081,
    0.05173636,
    0.00690416
])
######################
# SPSC-SARF
y5 = np.array([
    0.15483564,
    0.12017371,
    0.08746991,
    0.0420502,
    0.00440108
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
    350])

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
plt.savefig('images/PAN_Single.pdf', format='pdf',
            bbox_inches='tight')
print("Chart successfully saved!")
