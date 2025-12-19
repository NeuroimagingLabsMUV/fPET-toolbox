# fPET Toolbox
![fPET Banner](img/github_banner.png)

A MATLAB toolbox for the analysis of functional PET (fPET) data.

fPET enables the identification of stimulation-induced changes in glucose metabolism and neurotransmitter action as well as molecular connectivity. The toolbox offers various analysis approaches, including the General Linear Model (GLM), Independent Component Analysis (ICA) as well as molecular connectivity and covariance computation. It is optimized to handle fPET data that has been acquired using a bolus + constant infusion protocol with high temporal resolution (1–60 seconds), but other settings may be feasible.

[Visit the Neuroimaging Lab's webpage](https://www.meduniwien.ac.at/neuroimaging/fPET.html)

[Visit the fPET Toolbox webpage](https://www.meduniwien.ac.at/neuroimaging/fPET.html)

---

## Authors and Affiliation
- Andreas Hahn
- Murray B. Reed
- Rupert Lanzenberger

Neuroimaging Labs, Department of Psychiatry and Psychotherapy,
Medical University of Vienna, Austria

## Citation
When using the fPET Toolbox in your work, please cite the following paper:

__A Hahn et al. (2024) "A Unified Approach for Identifying PET-based Neuronal Activation and Molecular Connectivity with the functional PET toolbox" https://doi.org/10.1177/0271678X251370831__

In addition, when calculating percent signal change please cite:
https://doi.org/10.1007/s00259-024-06675-0

In addition, when using the spatio-temporal filter for molecular connectivity please cite:
https://doi.org/10.1038/s41597-020-00699-5

## Installation
Download the fPET Toolbox from GitHub.
Unzip the files.
Add the unzipped directory (including subdirectories) to your MATLAB path.

Ensure you have the following dependencies installed:
- [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/download/)
- [fastICA](https://research.ics.aalto.fi/ica/fastica/)

Note: SPM12 and fastICA are required for certain functions to work.

## Basic Usage

To run the toolbox, define the fpetbatch with the GUI by entering...
```matlab 
fpet_tlbx_gui
```
...or alternatively set up the fpetbatch in a script and run:
```matlab 
fpet_tlbx(fpetbatch)
```

For detailed instructions on how to use the toolbox, including data preparation and step-by-step analysis, refer to Manual.
   

## Support
We recommend reaching out to us before planning or conducting your fPET experiments. Our team has extensive experience collaborating with international labs and can assist with study design and analysis protocols.

## Contact
For any issues, bug reports, feature requests, or study design consultations, please contact the developers:

- Andreas Hahn: andreas.hahn@meduniwien.ac.at
- Murray B. Reed: murray.reed@meduniwien.ac.at


__Feel free to reach out if you'd like to explore potential collaborations or need further guidance with your fPET studies.__
