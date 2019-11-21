# Read data file

temp_gen = read.table("../DONNEES/geneve_homogen.txt",
  header = TRUE,
  skip=2)

temp_gen[['YEAR']]

# Temperature mois du juin

temp_gen[['JUN']]
year = temp_gen[['YEAR']]
tjuin = temp_gen[,7]

plot(year,tjuin,
     xlab='Year',
     ylab ='Temperature (C)',
     type='l',
     lwd=2,
     col=2)

tjuin[tjuin >=999] = NaN

# Temperature moyenne d apres la formule
# Nombre de donnees valide
nbvalue = length(which(!is.nan(tjuin)))
mtjformule = sum(tjuin,na.rm=TRUE) /nbvalue


Fmtj = mean(tjuin, na.rm=TRUE)
Fsdtjuin = sd(tjuin, na.rm=TRUE)
Fmintjuin = min(tjuin, na.rm=TRUE)
Fmaxtjuin = max(tjuin, na.rm=TRUE)

#histogramme
Fhist = hist(tjuin
  ,plot = FALSE)

# Calcul de la densite simulee
Fdeltatemp = diff(Fhist$breaks)
Ftempboxmids = Fhist$mids
Inbbox = length(Fdeltatemp)

plot(Ftempboxmids - Fdeltatemp/2
     ,Fhist$density
     ,type ='s'
     ,xlab ='Temperautre (C)'
     ,ylab ='Density (/C)'
     ,ylim=c(0,0.4))


Fsim_normal_dens =
  (1/(2*pi*Fsdtjuin^2))^0.5 *
  exp(
      ((Ftempboxmids - Fmtj)^2 /(-2*Fsdtjuin^2))
      )
#*  Fdeltatemp


lines(Ftempboxmids
     ,Fsim_normal_dens
     ,lwd =2
     ,col=2)


plot(tjuin[order(tjuin)],
     1:length(tjuin),
     xlab='Temperature (C)',
     ylab='Rang')
lines(tjuin[order(tjuin)],
     1:length(tjuin)
    )

#simulation d'une loi de Gauss
