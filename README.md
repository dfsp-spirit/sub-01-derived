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


## Prerequisites for Large File Cloning (Optional)

This repository uses [Git LFS](https://git-lfs.com/) to manage large binary files. This affects only 1 file currently:

* bids/derivatives/freesurfer-8.2.0/sub-01/mri/transforms/synthmorph.1.0mm.1.0mm/warp.to.mni152.1.0mm.1.0mm.inv.nii.gz

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
Your checkout will only contain tiny text pointer files (~130 bytes for all LFS files). To pull the actual data:


```bash
git lfs install
git lfs pull
```
