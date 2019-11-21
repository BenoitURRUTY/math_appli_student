# bibliothèques 
import numpy as np
import matplotlib.pyplot as plt
#-----------------------------------------------------------------------------

#Lecture des donnees dans un fichier.
temp_gen = np.loadtxt('../DONNEES/geneve_homogen.txt'
                      ,skiprows=3);

print(temp_gen[:,0] );
# Temperature mois du juin

year = temp_gen[:,0];
tjuin = temp_gen[:,6];

plt.plot(year,
         tjuin,
         marker='+',
         color='r',
         ms=3,mec='r',
         mew=2,
         linestyle='-',
         linewidth=5,
         label='Temperature Juin');
plt.xlabel("Annee [an]", fontsize=18);
plt.ylabel("Temperature (C)", fontsize=18);
plt.show(block=False)

tjuin[tjuin > 999.] = np.nan

# Temperature moyenne d apres la formule
# Nombre de donnees valide
nbvalue = tjuin.size - np.count_nonzero(np.isnan(tjuin))
mtjformule = np.nansum(tjuin) /nbvalue


Fmtj = np.nanmean(tjuin)
Fsdtjuin = np.nanstd(tjuin)
Fmintjuin = np.nanmin(tjuin)
Fmaxtjuin = np.nanmax(tjuin)

#2.7 Histrogrammes
Iind = np.where(np.isnan(tjuin) == False)
tjuin = tjuin[Iind]
year = year[Iind]

hist, bin_edges = np.histogram(tjuin, density=True)
Inbbox = np.count_nonzero(bin_edges)
Fdeltatemp =  np.diff(bin_edges)
Ftempboxmids =  bin_edges[0:Inbbox-1] + np.diff(bin_edges)/2

Fsim_normal_dens = (1/(2*np.pi*Fsdtjuin**2))**0.5 * np.exp( ((Ftempboxmids - Fmtj)**2 /(-2*Fsdtjuin**2)))

plt.hist(tjuin,
         normed=True,
         color='w',
         label='Histogramme empirique')

plt.plot(Ftempboxmids,
         Fsim_normal_dens,
         color='r',
         ms=3,
         mec='r',
         mew=2,
         linewidth=5,
         label='fonction de densite');
plt.xlabel("Temperature (C)", fontsize=18)
plt.ylabel("f(T)", fontsize=18);

plt.show()

#2.8 Temp. max

Iind = np.where(np.isnan(tjuin) == False)
tjuin = tjuin[Iind]
year = year[Iind]

Iind = np.where(tjuin >= Fmaxtjuin)
print(year[Iind])


#Rapport (t2003-tjuin)/sigma
print((tjuin[Iind] - Fmtj)/Fsdtjuin)

# Fonction de densite de la loi normale centree reduite.

Fx = [x/10.-10 for x in range(200)]
Fsim_normal_dens = (1/(2*np.pi))**0.5 * np.exp( [(x**2)/(-2) for x in Fx])

plt.plot(Fx,
         Fsim_normal_dens,
         color='r',
         ms=3,
         mec='r',
         mew=2,
         linewidth=5,
         label='fonction de densite');
plt.yscale('log')



plt.xlabel("Variable centree reduite", fontsize=18)
plt.ylabel("f(T)", fontsize=18);

plt.show()

# P(X > 4.66)
Fdeltat= 0.01
Ft0 = 4.66
Ft = [Ft0 + Fdeltat*i for i in range(200)]
Fproba = (1/(2*np.pi))**0.5 * np.exp( [(x**2)/(-2) for x in Ft])*Fdeltat
print('La probabilite que T> T2003 est ', np.sum(Fproba))

#2.9 Evolution des temperatures moyennes annuelles
Ftemp = temp_gen[:,1:13]
Iind = np.where(Ftemp >= 999.)
Ftemp[Iind] = np.nan

Ftempmoyan = np.nanmean(Ftemp
                           ,axis=1)
year = temp_gen[:,0]

plt.plot(year,
         Ftempmoyan,
         color='r',
         marker='+',
         ms=3,
         mec='r',
         mew=2,
         linewidth=2,
         label='temperature moyenne annuelle');



plt.ylabel("Temperature (C)", fontsize=18)
plt.xlabel("Annee", fontsize=18);


# Determination du modele lineaire

Fybar = np.nanmean(Ftempmoyan)
Fxbar = np.nanmean(year)
Fxybar = np.nanmean(Ftempmoyan[:] * year[:])
Fxbarybar = Fxbar * Fybar
Fx2bar = np.nanmean(year[:] * year[:])
Fxbar2 = Fxbar * Fxbar

Fa = (Fxybar - Fxbarybar) / (Fx2bar-Fxbar2)
Fb = Fybar - Fa*Fxbar

plt.plot(year,
         Fa * year[:] + Fb,
         color='b',
         linewidth=2,
         label='Regression lineaire');


plt.show()

print 'Pente  = ' , Fa
print 'Ordonnee a l origine =' , Fb

# Proportion des variation expliquees par le modele lineaire
Fr = np.nansum((Fa * year[:] + Fb-Fybar)**2) /np.nansum((Ftempmoyan - Fybar)**2)
input("PRESS ENTER TO CONTINUE.")
