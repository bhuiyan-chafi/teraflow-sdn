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

x = np.array([1150,
1050,
950,
850,
750,
650,
550,
450,
350,
250])

# SPFF-SAFF
y1 = np.array([0.3008,
0.2793,
0.2662,
0.2348,
0.1843,
0.1386,
0.098,
0.071,
0.0214,
0.000353])
# SPRF-SAFF
y2 = np.array([0.3045,
0.2973,
0.2363,
0.1968,
0.2123,
0.152,
0.1184,
0.0558,
0.0189,
0.000362])
# SP+1RF-SAFF
y3 = np.array([
0.2774,
0.237,
0.2041,
0.1881,
0.158,
0.1222,
0.1097,
0.0625,
0.0282,
0.0022
])
# SP+1SC-SAFF
y4 = np.array([
0.3287,
0.327,
0.2975,
0.2834,
0.2236,
0.1889,
0.1619,
0.0942,
0.0352,
0.000731
])
# SPRF-SARF
y5 = np.array([
0.3481,
0.3391,
0.3506,
0.2665,
0.2302,
0.1992,
0.1728,
0.124,
0.0717,
0.0258
])
# SP+1RF-SARF
y6 = np.array([
0.4229,
0.3658,
0.4028,
0.3039,
0.3006,
0.2925,
0.2302,
0.1688,
0.121,
0.0682
])
# -------------------------------------------------------------
# 2. FIGURE SIZE (Shrunk from 10x6 down to IEEE column width)
# -------------------------------------------------------------
# 3.5 inches is roughly the width of a standard IEEE column. 
# 2.6 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.6))

# SPFF-SAFF
plt.plot(x, y1, color="black", marker='o', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# SPRF-SAFF
plt.plot(x, y2, color="black", marker='x', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# APRF-SAFF
plt.plot(x, y3, color="black", marker='>', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# APHS-SAFF
plt.plot(x, y4, color="black", marker='<', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# SPRF-SARF
plt.plot(x, y5, color="black", marker='v', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
# SPRF-SARF
plt.plot(x, y6, color="black", marker='^', markersize=0.5, 
         linestyle='--', linewidth=0.5, alpha=0.6, 
         markeredgewidth=1.2, zorder=3)
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
    Line2D([0], [0], color='black', lw=0.8, linestyle='--', label='Overall Blocking'),
    Line2D([0], [0], color='black', lw=0, marker='o', markersize=2, label='SPFF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='x', markersize=2, label='SPRF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='>', markersize=2, label='SP+1RF-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='<', markersize=2, label='SP+1SC-SAFF'),
    Line2D([0], [0], color='black', lw=0, marker='v', markersize=2, label='SPRF-SARF'),
    Line2D([0], [0], color='black', lw=0, marker='^', markersize=2, label='SP+1RF-SARF'),
]

# Add the custom legend
plt.legend(handles=legend_elements, loc='best')

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Single.png', format='png', dpi=300, bbox_inches='tight')
print("Chart successfully saved!")