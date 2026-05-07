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
    'legend.fontsize': 6,     # Legend text size (slightly smaller to fit)
    'font.family': 'serif',   # Forces serif fonts
    # Matches IEEE template
    'font.serif': ['Times New Roman', 'Times', 'DejaVu Serif']
})

x = np.array([
    850,
    750,
    650,
    550,
    450,
    350,
    250])

# SPFF-SAFF
y1 = np.array([
    0.2348,
    0.1843,
    0.1386,
    0.098,
    0.071,
    0.0214,
    0.000353])
# SPRF-SAFF
y2 = np.array([
    0.19681529,
    0.21233357,
    0.15205224,
    0.11840727,
    0.05581181,
    0.01894853,
    0.00032231])
# SPSC-SAFF
y3 = np.array([
    0.19375,
    0.160777,
    0.121147,
    0.090933,
    0.040905,
    0.008902,
    0.00000672])
# SP+1RF-SAFF
y4 = np.array([
    0.30787037,
    0.22507553,
    0.19059255,
    0.15565134,
    0.12308254,
    0.0533099,
    0.00719885])
# SP+1SC-SAFF
y5 = np.array([
    0.28336756,
    0.223635,
    0.18886199,
    0.16190476,
    0.09420682,
    0.0352126,
    0.0007311])
# SPRF-SARF
y6 = np.array([
    0.26654064,
    0.23017107,
    0.1992238,
    0.17282609,
    0.12398823,
    0.07171555,
    0.02580334])
# -------------------------------------------------------------
# 2. FIGURE SIZE (Shrunk from 10x6 down to IEEE column width)
# -------------------------------------------------------------
# 3.5 inches is roughly the width of a standard IEEE column.
# 2.6 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.6))

# SPFF-SAFF
plt.plot(x, y1, color="black", marker='o', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# SPRF-SAFF
plt.plot(x, y2, color="black", marker='x', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# SPSC-SAFF
plt.plot(x, y3, color="black", marker='>', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# SP+1RF-SAFF
plt.plot(x, y4, color="black", marker='<', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# SP+1SC-SAFF
plt.plot(x, y5, color="black", marker='v', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# SPRF-SARF
plt.plot(x, y6, color="black", marker='^', markersize=2.5, markerfacecolor='none',
         linestyle='--', linewidth=0.5, alpha=0.6,
         markeredgewidth=0.5, zorder=3)
# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([1150,
            1050,
            950,
            850,
            750,
            650,
            550,
            450,
            350,
            250])

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
    Line2D([0], [0], color='black', lw=0.8,
           linestyle='--', label='Overall Blocking'),
    Line2D([0], [0], color='black', lw=0, marker='o',
           markersize=2.5, label='SPFF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='x',
           markersize=2.5, label='SPRF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='>',
           markersize=2.5, label='SPSC-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='<',
           markersize=2.5, label='SP+1RF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='v',
           markersize=2.5, label='SP+1SC-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='^',
           markersize=2.5, label='SPRF-SARF'),
]

# Add the custom legend
plt.legend(handles=legend_elements, loc='best')

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Single.png', format='png',
            dpi=300, bbox_inches='tight')
print("Chart successfully saved!")
