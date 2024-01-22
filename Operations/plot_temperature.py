import matplotlib.pyplot as plt
import numpy as np

T_subsolar = 407
T_terminator = 110
r =10 
T_subsolar = 407+(8/r**0.5) # K
phi =0
if phi <=90:
    T = T_subsolar*(np.cos(phi))^(1/4) + T_terminator*(phi/90)^3
else:
    T = T_terminator                                                            




plt.rcParams["figure.figsize"] = [7.00, 3.50]
plt.rcParams["figure.autolayout"] = True
fig = plt.figure()
ax = fig.add_subplot(projection='3d')
r = 0.05
u, v = np.mgrid[0:2 * np.pi:30j, 0:np.pi:20j]
x = np.cos(u) * np.sin(v)
y = np.sin(u) * np.sin(v)
z = np.cos(v)
ax.plot_surface(x, y, z, cmap=plt.cm.YlGnBu_r)
plt.show()