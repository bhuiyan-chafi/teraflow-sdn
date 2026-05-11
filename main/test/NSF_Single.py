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
    750,
    650,
    550,
    450,
    350,
    250])

# SPFF-SAFF
y1 = np.array([
    0.17141322,
    0.14175258,
    0.12285818,
    0.07478992,
    0.02318698,
    0.0003586])
# SPRF-SAFF
y2 = np.array([
    0.17058824,
    0.14385658,
    0.11840727,
    0.05581181,
    0.01894853,
    0.00032231])
# SPSC-SAFF
y3 = np.array([
    0.160777,
    0.121147,
    0.090933,
    0.040905,
    0.008902,
    0.00001556])
# SP+1RF-SAFF
y4 = np.array([
    0.22507553,
    0.19059255,
    0.15565134,
    0.12308254,
    0.0533099,
    0.00719885])
# SP+1SC-SAFF
y5 = np.array([
    0.223635,
    0.18886199,
    0.16190476,
    0.09420682,
    0.0352126,
    0.0007311])
# SPRF-SARF
y6 = np.array([
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
# 2.7 inches height gives a nice golden ratio.
plt.figure(figsize=(3.5, 2.7))

# # SPFF-SAFF
# plt.plot(x, y1, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3, marker='x', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# # SPRF-SAFF
# plt.plot(x, y2, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3,  marker='o', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# # SPSC-SAFF
# plt.plot(x, y3, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3,  marker='^', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# # SP+1RF-SAFF
# plt.plot(x, y4, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3, marker='<', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# # SP+1SC-SAFF
# plt.plot(x, y5, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3, marker='v', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# # SPRF-SARF
# plt.plot(x, y6, color="black",
#          linestyle='-', linewidth=1.0, alpha=1,
#          zorder=3, marker='s', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)

# version with colors

# SPFF-SAFF
plt.plot(x, y1, color="blue",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='x', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# SPRF-SAFF
plt.plot(x, y2, color="brown",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3,  marker='o', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# SPSC-SAFF
plt.plot(x, y3, color="green",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3,  marker='^', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# SP+1RF-SAFF
plt.plot(x, y4, color="black",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='<', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# SP+1SC-SAFF
plt.plot(x, y5, color="violet",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='v', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
# SPRF-SARF
plt.plot(x, y6, color="red",
         linestyle='-', linewidth=1.0, alpha=1,
         zorder=3, marker='s', markersize=4, markerfacecolor='none', markeredgewidth=0.8,)
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

    # Line2D([0], [0], color='black', lw=1.0,
    #        linestyle='-', label='Overall Blocking'),

    # Line2D([0], [0], color='black', lw=0, marker='^',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-SAFF'),

    # Line2D([0], [0], color='black', lw=0, marker='o',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-SAFF'),

    # Line2D([0], [0], color='black', lw=0, marker='x',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SPFF-SAFF'),

    # Line2D([0], [0], color='black', lw=0, marker='v',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SP+1SC-SAFF'),

    # Line2D([0], [0], color='black', lw=0, marker='<',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SP+1RF-SAFF'),


    # Line2D([0], [0], color='black', lw=0, marker='s',
    #        markersize=3.5, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-SARF'),

    # Colored version

    Line2D([0], [0], color='green', lw=0.8,
           linestyle='-', label='Overall Blocking'),
    Line2D([0], [0], color='green', lw=0, marker='^',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPSC-SAFF'),
    Line2D([0], [0], color='brown', lw=0, marker='o',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-SAFF'),
    Line2D([0], [0], color='red', lw=0, marker='s',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPRF-SARF'),
    Line2D([0], [0], color='blue', lw=0, marker='x',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SPFF-SAFF'),
    Line2D([0], [0], color='violet', lw=0, marker='v',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SP+1SC-SAFF'),

    Line2D([0], [0], color='black', lw=0, marker='<',
           markersize=6, markeredgewidth=0.8, markerfacecolor='none', label='SP+1RF-SAFF'),

]

# Add the custom legend inside the plot area at the lower right
plt.legend(handles=legend_elements, loc='lower right', edgecolor='black',
           framealpha=0.9, fancybox=False, handletextpad=0.3, labelspacing=0.3)

# Remove extra margins
plt.tight_layout(pad=0.2)

# -------------------------------------------------------------
# 4. SAVE AS PDF (Crucial for LaTeX vector graphics!)
# -------------------------------------------------------------
plt.savefig('images/NSF_Single_Colored.pdf', format='pdf',
            bbox_inches='tight')
print("Chart successfully saved!")
