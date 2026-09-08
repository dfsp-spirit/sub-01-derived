
Preprocessing was performed using *QSIPrep* 26.0.0 [@cieslak2021qsiprep],
which is based on *Nipype* 1.11.0
[@nipype1; @nipype2; RRID:SCR_002502] and follows *NiPreps* framework [@nipreps].



#### Anatomical data preprocessing

The T1-weighted (T1w) image was corrected for intensity non-uniformity (INU)
using `N4BiasFieldCorrection` [@n4, ANTs 2.4.3],
and used as an anatomical reference throughout the workflow.
The anatomical reference image was reoriented into AC-PC alignment via
a 6-DOF transform extracted from a full Affine registration to the
MNI152NLin2009cAsym template. A full nonlinear registration to the template from AC-PC space was
estimated via symmetric nonlinear registration (SyN) using antsRegistration (@ants). Brain extraction was performed on the T1w image using
SynthStrip [@synthstrip] and automated segmentation was
performed using SynthSeg [@synthseg1; @synthseg2] from
FreeSurfer version 7.3.1. 

#### Diffusion data preprocessing



DWI data were denoised using the Marchenko-Pastur PCA method implemented in dwidenoise [@mrtrix3; @dwidenoise1; @dwidenoise2; @cordero2019complex] with an automatically-determined window size of 5 voxels. Any images with a b-value less than 100 s/mm^2 were treated as a *b*=0 image. The mean intensity of the DWI series was adjusted so all the mean intensity of the b=0 images matched across eachseparate DWI scanning sequence. B1 field inhomogeneity was corrected using `dwibiascorrect` from MRtrix3 with the N4 algorithm [@n4] after corrected images were resampled.

FSL (version None)'s eddy was used for head motion correction and Eddy current correction [@anderssoneddy]. Eddy was configured with a $q$-space smoothing factor of 10, a total of 5 iterations, and 1000 voxels used to estimate hyperparameters. A quadratic first level model and a linear second level model were used to characterize Eddy current-related spatial distortion. $q$-space coordinates were forcefully assigned to shells. Field offset was attempted to be separated from subject movement. Shells were aligned post-eddy. Eddy's outlier replacement was run [@eddyrepol]. Data were grouped by slice, only including values from slices determined to contain at least 250 intracerebral voxels. Groups deviating by more than 4 standard deviations from the prediction had their data replaced with imputed values.  Final interpolation was performed using the `jac` method. 

Several confounding time-series were calculated based on the
preprocessed DWI: framewise displacement (FD) using the
implementation in *Nipype* [following the definitions by @power_fd_dvars].
The head-motion estimates calculated in the correction step were also
placed within the corresponding confounds file. Slicewise cross correlation
was also calculated.
The DWI time-series were resampled to ACPC,
generating a *preprocessed DWI run in ACPC space* with 2mm isotropic voxels.


Many internal operations of *QSIPrep* use
*Nilearn* 0.10.1 [@nilearn, RRID:SCR_001362] and
*Dipy* [@dipy].
For more details of the pipeline, see [the section corresponding
to workflows in *QSIPrep*'s documentation](https://qsiprep.readthedocs.io/en/latest/workflows.html "QSIPrep's documentation").


### References

