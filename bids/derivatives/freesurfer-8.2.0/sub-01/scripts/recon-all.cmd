

#---------------------------------
# New invocation of recon-all Fri Sep  4 13:16:49 CEST 2026 

 mri_convert /home/ts/develop/sub-01/DICOM/0002_MR000004.dcm /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig/001.mgz 

#--------------------------------------------
#@# T2/FLAIR Input Fri Sep  4 13:16:51 CEST 2026

 mri_convert --no_scale 1 /home/ts/develop/sub-01/DICOM/0004_MR000388.dcm /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig/T2raw.mgz 

#--------------------------------------------
#@# MotionCor Fri Sep  4 13:16:53 CEST 2026

 cp /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig/001.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/rawavg.mgz 


 mri_info /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/rawavg.mgz 


 mri_convert /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/rawavg.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/transforms/talairach.xfm /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz 


 mri_info /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz 


 mri_synthstrip --threads 8 -i /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz -o /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/synthstrip.mgz 


 mri_synthseg --i /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz --o /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/synthseg.rca.mgz --threads 8 --vol /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/stats/synthseg.vol.csv --keepgeom --addctab --cpu 


 rca-talairach --s sub-01 --threads 8 


 fs-synthmorph-reg --s sub-01 --threads 8 --i /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig.mgz --test 

#--------------------------------------------
#@# Nu Intensity Correction Fri Sep  4 13:21:31 CEST 2026

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Fri Sep  4 13:23:23 CEST 2026

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 

#--------------------------------------

#@# MCADura Segmentation Fri Sep  4 13:24:07 CEST 2026
#--------------------------------------

#@# VSinus Segmentation Fri Sep  4 13:24:22 CEST 2026

 mri_mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/T1.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/synthstrip.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/brainmask.mgz 

#-------------------------------------
#@# EM Registration Fri Sep  4 13:24:33 CEST 2026

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /home/ts/software/freesurfer/freesurfer8.2.0/average/RB_all_2020-01-02.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Fri Sep  4 13:25:17 CEST 2026

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /home/ts/software/freesurfer/freesurfer8.2.0/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------

#@# EntoWM Segmentation Fri Sep  4 13:25:48 CEST 2026
#--------------------------------------
#@# CC Seg Fri Sep  4 13:25:56 CEST 2026

 seg2cc --s sub-01 

#--------------------------------------
#@# Merge ASeg Fri Sep  4 13:26:16 CEST 2026

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Fri Sep  4 13:26:16 CEST 2026

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Fri Sep  4 13:27:22 CEST 2026

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 


 mri_mask -oval 1 -invert brain.finalsurfs.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/mca-dura.mgz brain.finalsurfs.mgz 


 mri_mask -oval 1 -invert brain.finalsurfs.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/vsinus.mgz brain.finalsurfs.mgz 


 mri_edit_wm_with_aseg -sa-fix-ento-wm entowm.mgz 2 255 255 brain.finalsurfs.mgz brain.finalsurfs.mgz 


 mri_edit_wm_with_aseg -sa-fix-acj aseg.presurf.mgz 255 255 brain.finalsurfs.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Fri Sep  4 13:27:25 CEST 2026

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in -fix-ento-wm entowm.mgz 3 255 255 -fix-acj aseg.presurf.mgz 255 255 -fill-seg-wm -fix-scm-ha 1 wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

Fixing entowm in wm.mgz

 mri_edit_wm_with_aseg -sa-fix-ento-wm entowm.mgz 3 255 255 wm.mgz wm.mgz 

Fixing ACJ in wm.mgz

 mri_edit_wm_with_aseg -sa-fix-acj aseg.presurf.mgz 255 255 wm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Fri Sep  4 13:28:39 CEST 2026

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /home/ts/software/freesurfer/freesurfer8.2.0/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz
#--------------------------------------------
#@# Tessellate lh Fri Sep  4 13:29:11 CEST 2026

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Fri Sep  4 13:29:13 CEST 2026

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Fri Sep  4 13:29:14 CEST 2026

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Fri Sep  4 13:29:16 CEST 2026

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Fri Sep  4 13:29:17 CEST 2026

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Fri Sep  4 13:29:24 CEST 2026

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Fri Sep  4 13:29:30 CEST 2026

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Fri Sep  4 13:30:15 CEST 2026

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology lh Fri Sep  4 13:30:57 CEST 2026

 mris_fix_topology -threads 1 -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 -threads 1 sub-01 lh 

#@# Fix Topology rh Fri Sep  4 13:32:10 CEST 2026

 mris_fix_topology -threads 1 -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 -threads 1 sub-01 rh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.orig.premesh --output /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.orig 


 mris_remesh --remesh --iters 3 --input /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.orig.premesh --output /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh Fri Sep  4 13:34:37 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# AutoDetGWStats rh Fri Sep  4 13:34:39 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh Fri Sep  4 13:34:41 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --restore-255 --nsmooth 5 --rip-bg-no-annot --rip-bg --rip-bg-lof --restore-255 --outvol mrisps.wpa.mgz
#--------------------------------------------
#@# WhitePreAparc rh Fri Sep  4 13:36:17 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --restore-255 --nsmooth 5 --rip-bg-no-annot --rip-bg --rip-bg-lof --restore-255 --outvol mrisps.wpa.mgz
#--------------------------------------------
#@# CortexLabel lh Fri Sep  4 13:38:06 CEST 2026
#--------------------------------------------
#@# CortexLabel+HipAmyg lh Fri Sep  4 13:38:19 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# CortexLabel rh Fri Sep  4 13:38:30 CEST 2026
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Fri Sep  4 13:38:43 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh Fri Sep  4 13:38:53 CEST 2026

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Fri Sep  4 13:38:55 CEST 2026

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Fri Sep  4 13:38:57 CEST 2026

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Fri Sep  4 13:39:05 CEST 2026

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Fri Sep  4 13:39:12 CEST 2026

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Fri Sep  4 13:39:45 CEST 2026

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere lh Fri Sep  4 13:40:19 CEST 2026

 mris_sphere -threads 8 -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Fri Sep  4 13:42:27 CEST 2026

 mris_sphere -threads 8 -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#@# Surf Reg  Fri Sep  4 13:44:32 CEST 2026
#--------------------------------------------
#@# Jacobian white lh Fri Sep  4 13:48:51 CEST 2026

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Fri Sep  4 13:48:52 CEST 2026

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Fri Sep  4 13:48:52 CEST 2026

 mrisp_paint -a 5 /home/ts/software/freesurfer/freesurfer8.2.0/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Fri Sep  4 13:48:53 CEST 2026

 mrisp_paint -a 5 /home/ts/software/freesurfer/freesurfer8.2.0/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Fri Sep  4 13:48:53 CEST 2026

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Fri Sep  4 13:48:59 CEST 2026

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh Fri Sep  4 13:49:04 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot --restore-255 --restore-255 --outvol mrisps.white.mgz --rip-bg-lof
#--------------------------------------------
#@# WhiteSurfs rh Fri Sep  4 13:50:24 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot --restore-255 --restore-255 --outvol mrisps.white.mgz --rip-bg-lof
#--------------------------------------------
#@# T1PialSurf lh Fri Sep  4 13:51:46 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white --restore-255
#--------------------------------------------
#@# T1PialSurf rh Fri Sep  4 13:53:16 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white --restore-255
#--------------------------------------------
#@# Refine Pial Surfs w/ T2/FLAIR Fri Sep  4 13:54:50 CEST 2026

 bbregister --s sub-01 --mov /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/orig/T2raw.mgz --lta /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/transforms/T2raw.auto.lta --init-coreg --T2 --gm-proj-abs 2 --wm-proj-abs 1 --no-coreg-ref-mask 


 cp /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/transforms/T2raw.auto.lta /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/transforms/T2raw.lta 


 mri_normalize -seed 1234 -sigma 0.5 -nonmax_suppress 0 -min_dist 1 -aseg /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/aseg.presurf.mgz -surface /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white identity.nofile -surface /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white identity.nofile /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/T2.prenorm.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/T2.norm.mgz 


 mri_mask -transfer 255 -keep_mask_deletion_edits /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/T2.norm.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/brain.finalsurfs.mgz /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/T2.mgz 

#--------------------------------------------
#@# MMPialSurf lh Fri Sep  4 13:56:00 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.pial.T1 --o ../surf/lh.pial.T2 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --white-surf ../surf/lh.white --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --mmvol T2.mgz T2
#--------------------------------------------
#@# MMPialSurf rh Fri Sep  4 14:29:02 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.pial.T1 --o ../surf/rh.pial.T2 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --white-surf ../surf/rh.white --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --mmvol T2.mgz T2
#@# white curv lh Fri Sep  4 15:02:29 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh Fri Sep  4 15:02:30 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh Fri Sep  4 15:02:30 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh Fri Sep  4 15:02:31 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh Fri Sep  4 15:02:31 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh Fri Sep  4 15:02:50 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
#@# white curv rh Fri Sep  4 15:02:51 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh Fri Sep  4 15:02:52 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh Fri Sep  4 15:02:53 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh Fri Sep  4 15:02:54 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh Fri Sep  4 15:02:54 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh Fri Sep  4 15:03:14 CEST 2026
cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri

#-----------------------------------------
#@# Curvature Stats lh Fri Sep  4 15:03:15 CEST 2026

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-01 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Fri Sep  4 15:03:16 CEST 2026

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-01 rh curv sulc 

#--------------------------------------------
#@# Cortical ribbon mask Fri Sep  4 15:03:17 CEST 2026

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon --parallel sub-01 

#-----------------------------------------
#@# Cortical Parc 2 lh Fri Sep  4 15:05:47 CEST 2026

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Fri Sep  4 15:05:55 CEST 2026

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh Fri Sep  4 15:06:03 CEST 2026

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Fri Sep  4 15:06:09 CEST 2026

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/ts/software/freesurfer/freesurfer8.2.0/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh Fri Sep  4 15:06:14 CEST 2026

 pctsurfcon --s sub-01 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Fri Sep  4 15:06:17 CEST 2026

 pctsurfcon --s sub-01 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Fri Sep  4 15:06:19 CEST 2026

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Fri Sep  4 15:06:27 CEST 2026

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/mri/ribbon.mgz --threads 8 --lh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.cortex.label --lh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white --lh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.pial --rh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.cortex.label --rh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white --rh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.pial 


 mri_brainvol_stats --subject sub-01 

#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Sep  4 15:06:31 CEST 2026

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.aparc.annot 1000 --lh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.cortex.label --lh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white --lh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.pial --rh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.aparc.annot 2000 --rh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.cortex.label --rh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white --rh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Fri Sep  4 15:06:55 CEST 2026

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.cortex.label --lh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white --lh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.pial --rh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.cortex.label --rh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white --rh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Fri Sep  4 15:07:18 CEST 2026

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.cortex.label --lh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white --lh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.pial --rh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.cortex.label --rh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white --rh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.pial 

#-----------------------------------------
#@# WMParc Fri Sep  4 15:07:41 CEST 2026

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 8 --lh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.aparc.annot 3000 --lh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/lh.cortex.label --lh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.white --lh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/lh.pial --rh-annot /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.aparc.annot 4000 --rh-cortex-mask /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/label/rh.cortex.label --rh-white /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.white --rh-pial /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-01 --surf-wm-vol --ctab /home/ts/software/freesurfer/freesurfer8.2.0/WMParcStatsLUT.txt --etiv --stiv /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/stats/synthseg.tiv.dat 

#-----------------------------------------
#@# Parcellation Stats lh Fri Sep  4 15:08:38 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh white 


 mris_anatomical_stats -no-th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Fri Sep  4 15:08:41 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh white 


 mris_anatomical_stats -no-th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Sep  4 15:08:45 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Sep  4 15:08:47 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 rh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Sep  4 15:08:49 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Sep  4 15:08:50 CEST 2026

 mris_anatomical_stats -no-th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 rh white 

#--------------------------------------------
#@# ASeg Stats Fri Sep  4 15:08:52 CEST 2026

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --stiv /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/sub-01/stats/synthseg.tiv.dat --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /home/ts/software/freesurfer/freesurfer8.2.0/ASegStatsLUT.txt --subject sub-01 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir; ln -s /home/ts/software/freesurfer/freesurfer8.2.0/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh Fri Sep  4 15:09:13 CEST 2026

 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --hemi lh --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi lh --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_BA_thresh.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -no-th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 lh white 


 mris_anatomical_stats -no-th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Fri Sep  4 15:10:51 CEST 2026

 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /home/ts/develop/sub-01/derived/FreeSurfer/8.2.0/subjects_dir/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --hemi rh --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi rh --ctab /home/ts/software/freesurfer/freesurfer8.2.0/average/colortable_BA_thresh.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -no-th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 rh white 


 mris_anatomical_stats -no-th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 rh white 

