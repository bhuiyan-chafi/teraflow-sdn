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

x = np.array([250,300,350,400,450,500, 600,700, 750, 900, 1050, 1100, 1200, 1300, 1350, 1500 ])

# PFF-SAFF
y1 = np.array([
0.0077, 
0.0346, 
0.0625, 
0.0874, 
0.1060, 
0.1532, np.nan,np.nan,np.nan,np.nan,np.nan,np.nan,np.nan,np.nan,np.nan,np.nan])
# PRF-SAFF
y2 = np.array([
0.0008,
0.0069, 
0.0143, 
0.0355, 
0.0713, 
0.0843, 
0.1073, 
0.1190, 
0.1271, 
0.0141 
])
# PFF-SARF
y3 = np.array([
0.0630, 
0.0863, 
0.1345, 
0.1540, 
0.1655, 
0.1966
])
# PRF-SARF
y4 = np.array([
0.0831, 
0.1086, 
0.1507, 
0.1652, 
0.2031, 
0.2017 
])
# SPRF-SARF
y5 = np.array([
0.0208, 
0.0486, 
0.0870, 
0.0853, 
0.1244,
0.1431 
])
# -------------------------------------------------------------
# 2. FIGURE SIZE (Shrunk from 10x6 down to IEEE column width)
# -------------------------------------------------------------
# 3.5 inches is roughly the width of a standard IEEE column. 
# 2.6 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.6))

# SPFF-SAFF
plt.plot(x, y1, color="black", marker='o', markersize=1, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# SPRF-SAFF
plt.plot(x, y2, color="black", marker='x', markersize=2, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# APRF-SAFF
plt.plot(x, y3, color="black", marker='>', markersize=1, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# APHS-SAFF
plt.plot(x, y4, color="black", marker='<', markersize=1, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# SPRF-SARF
plt.plot(x, y5, color="black", marker='v', markersize=1, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# Set specific X-axis ticks to hide the label for 25 while keeping its grid line
plt.xticks([250,300,350,400,450,500])

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
    Line2D([0], [0], color='black', lw=0.8, linestyle='--', label='Overall Blocking'),
    Line2D([0], [0], color='black', lw=0, marker='o', markersize=2, label='SPFF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='x', markersize=2, label='SPRF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='>', markersize=2, label='APRF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='<', markersize=2, label='APHS-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='v', markersize=2, label='SPRF-SARF'),
]

# Add the custom legend
plt.legend(handles=legend_elements, loc='best')

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Single.png', format='png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")