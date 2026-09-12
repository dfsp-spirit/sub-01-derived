# sub-01-derived

Preprocessing output from FreeSurfer's `recon-all` pipeline, derived from the raw DICOM images in the [sub-01 repo](https://github.com/dfsp-spirit/sub-01).


## Repo Organization

The [bids/derivatives/ directory](./bids/derivatives/) contains recon-all output of the following FreeSurfer versions:

* FreeSurfer v6.0 in [bids/derivatives/freesurfer](./bids/derivatives/freesurfer/)
* FreeSurfer v7.4.1 in [bids/derivatives/freesurfer-7.4.1](./bids/derivatives/freesurfer-7.4.1/)
* FreeSurfer v8.2.0 in [bids/derivatives/freesurfer-8.2.0](./bids/derivatives/freesurfer-8.2.0/)


## Reproduction

### FreeSurfer recon-all from T1W raw data

You will need:

* FreeSurfer installed and setup. This includes copying your license file into the appropriate spot, see documentation of your FreeSurfer version.
* under Ubuntu 24 LTS you also need to manually install this for FreeSurfer 7: `sudo apt install tcsh libgomp1 libglu1-mesa`
* under Ubuntu 24 LTS you also need to manually install this for FreeSurfer 8: `sudo apt install libinsighttoolkit5-dev`

Then check the [scripts directory](./scripts/).



### Functional MRI => CIFTI Grayordinates & GIfTI (fMRIPrep)


You will need a FreeSurfer license (free) and Docker.

```shell
export FS_LIC="$FREESURFER_HOME/license.txt"   # or whereever you have your FreeSurfer license on the host
export SUB01_REPO="$HOME/develop/sub-01"
export SUB01DERIVED_REPO="$HOME/develop/sub-01-derived"

docker run --rm -it \
  -v ${SUB01_REPO}/bids:/data:ro \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/fmriprep:/out \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/freesurfer-7.4.1:/fsdir \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/fmriprep_work:/work \
  -v "$FS_LIC":/opt/freesurfer/license.txt:ro \
  nipreps/fmriprep:latest \
  /data /out participant \
  --participant-label 01 \
  --fs-subjects-dir /fsdir \
  --fs-license-file /opt/freesurfer/license.txt \
  --cifti-output 91k \
  --ignore fieldmaps \
  -w /work
```

### Diffusion

#### Step 1

```shell
export FS_LIC="$FREESURFER_HOME/license.txt"   # or whereever you have your FreeSurfer license on the host
export SUB01_REPO="$HOME/develop/sub-01"
export SUB01DERIVED_REPO="$HOME/develop/sub-01-derived"

docker run --rm -it \
  -v ${SUB01_REPO}/bids:/data:ro \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/qsiprep:/out \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/qsiprep_work:/work \
  -v "$FS_LIC":/opt/freesurfer/license.txt:ro \
  pennlinc/qsiprep:latest \
  /data /out participant \
  --participant-label 01 \
  --fs-license-file /opt/freesurfer/license.txt \
  --output-resolution 2.0 \
  --ignore fieldmaps \
  -w /work
```

#### Step 2

```shell
export FS_LIC="$FREESURFER_HOME/license.txt"   # or whereever you have your FreeSurfer license on the host
export SUB01DERIVED_REPO="$HOME/develop/sub-01-derived"

mkdir -p "$HOME/.cache/templateflow"

docker run --rm -it \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/qsiprep:/data:ro \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/qsirecon:/out \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/freesurfer-7.4.1:/fsdir \
  -v ${SUB01DERIVED_REPO}/bids/derivatives/qsirecon_work:/work \
  -v "$HOME/.cache/templateflow":/home/qsirecon/.cache/templateflow \
  -v "$FS_LIC":/opt/freesurfer/license.txt:ro \
  pennlinc/qsirecon:latest \
  /data /out participant \
  --participant-label 01 \
  --recon-spec mrtrix_singleshell_ss3t_ACT-hsvs \
  --fs-subjects-dir /fsdir \
  --fs-license-file /opt/freesurfer/license.txt \
  --atlases AAL116 \
  -w /work
```shell

## Prerequisites for Large File Cloning (Optional)

This repository uses [Git LFS](https://git-lfs.com/) to manage large binary files. This affects all files of these types currently:

* Files ending with `*.nii`
* Files ending with `*.nii.gz`
* Files ending with `*.h5`

If you need this file, read on. Otherwise ignore this.

1. **Install Git LFS** (one-time setup on your system):
   - **Ubuntu/Debian:** `sudo apt install git-lfs && git lfs install`
   - **macOS (Homebrew):** `brew install git-lfs && git lfs install`
   - **Windows:** Included with Git for Windows, or run `git lfs install`

2. **Clone normally:**

```bash
git clone https://github.com/dfsp-spirit/sub-01-derived
```

If you cloned without Git LFS installed first:
Your checkout will only contain tiny text pointer files (~130 bytes) for all LFS files. To pull the actual data:


```bash
git lfs install
git lfs pull
```

## License

These neuroimaging data are dedicated to the public domain under the **Creative Commons Zero v1.0 Universal (CC0 1.0)** dedication.

You can copy, modify, distribute, and perform the work, even for commercial purposes, all without asking permission. See the [LICENSE](LICENSE) file for the full legal text, or read the human-readable summary at [Creative Commons](https://creativecommons.org/publicdomain/zero/1.0/).