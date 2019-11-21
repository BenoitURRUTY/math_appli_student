/// integration verticale du modele PREM pour calculer masse Terre et duree trajet
/// PREM = profils verticaux de rho et Vp (polynomes), selon Dziewonski & Anderson 1981
/// intervalle en prof : 0= centre Terre, 6471km = surface
/// IMPORTANT : travailler en unites SI !!!!!!!

/// avec dz=10km, m=5.970e24kg, g=9.8105975
/// avec dz= 1km, m=5.972e24kg, g=9.8135578, t=10.1mn

clear

//// lecture des donnees du modele PREM
/// 2 lignes d'entete
fd = file('open','PREM_table1.txt','old');
read(fd,1,1,'(A)'); read(fd,1,1,'(A)');
/// n lignes avec intervalle de prof en km, coef polynomes^2 pour rho (g/cm3) et Vp(km/s)
prem = read(fd,-1,10);  // intervalle prof1-prof2 et coeff polynome^3 de rho & Vp
file('close',fd)

/// conversion profondeurs en m
prem(:,1:2) = prem(:,1:2) *1e3;

/// rayon terrestre en m
rt = 6371e3;

/// tester valeurs de PREM
//zz=prem(:,1);
//zzr=prem(:,1)/6371;
//rho=prem(:,3)+prem(:,4).*zzr+prem(:,5).*zzr.*zzr+prem(:,6).*zzr.*zzr.*zzr;
//vp =prem(:,7)+prem(:,8).*zzr+prem(:,9).*zzr.*zzr+prem(:,10).*zzr.*zzr.*zzr; 
//plot(zz,rho); plot(zz,vp)

// initialisation masse m en kg, temps trajet en s
m = 0;
tt = 0;

/// resolution verticale dz en m
dz=1e3;

/// boucle verticale de dz a 6371km
/// compteur ii pour conserver profil de d (et m, g)
ii = 0
for zz=dz:dz:rt
 ii = ii+1;
 zzr = zz/rt;   // zz normalisee dans polynomes

 rho(ii) = 0;   /// masse vol kg/m^3
 vp(ii)  = 0;   /// vp en m/s
  for nn=1:size(prem,1)   // selection polynome selon zz
   rho(ii) = rho(ii) + (zz>=prem(nn,1) & zz<prem(nn,2))* ...
       (prem(nn,3) + prem(nn,4)*zzr + ...
        prem(nn,5)*zzr*zzr + prem(nn,6)*zzr*zzr*zzr);
   vp(ii) = vp(ii) + (zz>=prem(nn,1) & zz<prem(nn,2))* ...
       (prem(nn,7) + prem(nn,8)*zzr + ...
        prem(nn,9)*zzr*zzr + prem(nn,10)*zzr*zzr*zzr);       
  end
rho(ii) = rho(ii) * 1e3;  // conversion g/cm3 > kg/m3
vp(ii)  = vp(ii)  * 1e3;  // conversion km/s > m/s

/// masse correspondant a dz
dm = 4* %pi * zz*zz * rho(ii) * dz;
m = m + dm;

/// temps de parcours correspondant a dz
dt = dz/vp(ii);
tt = tt + dt;

end // sur zz

disp(m,'Masse de la Terre en kg : ')
disp(tt/60,'Temps de trajet en minutes : ')

/// gravite g = G.m/rt^2 avec m en kg et rt en m, G en N.m^2.kg^-2
g = 6.67e-11 * m /rt/rt
disp(g,'Gravité g en m/s^2 :')

/// plot profil d
clf();
plot(zz/1e3-[dz:dz:rt]/1e3,rho/1e3,'-b')
plot(zz/1e3-[dz:dz:rt]/1e3,vp/1e3,'-r')
xtitle('Profils verticaux de PREM','Profondeur [km]','Masse volumique [g/cm3] et vitesse [km/s]')
legend('Masse volumique','Vitesse ondes P',pos=4);
////////////////

