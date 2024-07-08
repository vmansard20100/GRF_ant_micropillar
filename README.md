# GRF_ant_micropillar
Opensource of the code for the article "A low-cost optical sensor for measuring sub-Newtonian planar ground reaction forces in insects"

Code made for matlab

# Initial File
interfaceRUN

# ================
# Analyse in 4 Step
# ================

# Step 0 Generate an average image with no ant from images with ant for comparison and detection of forces
CreateAvgImage.m

# Step 1 Cut movie to only keep the intersting sequence and align images top and bottom
interfaceCreateMovie.m

# Step 2 Detect Ant; the pillar; the displacement of the pillar
All File Detect*.m

# Step 3 Analyse the data and generate figure
All files Analysis*.m
