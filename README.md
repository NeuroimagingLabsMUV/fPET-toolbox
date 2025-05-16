# fPET Toolbox
![fPET Banner](img/github_banner.png)

<!-- Meta Tags for SEO -->
<!-- 
<meta name="description" content="The fPET Toolbox is a MATLAB-based software for analyzing functional PET (fPET) data, providing advanced methods such as GLM and ICA for stimulation-induced changes and molecular connectivity analysis. Optimized for bolus + constant infusion protocols.">
<meta name="keywords" content="fPET, functional PET, MATLAB toolbox, neuroimaging, molecular connectivity, glucose metabolism, General Linear Model, GLM, Independent Component Analysis, ICA, bolus infusion, PET imaging">
<meta name="author" content="Andreas Hahn, Murray B. Reed, Rupert Lanzenberger">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
-->

A MATLAB toolbox for the analysis of functional PET (fPET) data.

fPET enables the identification of stimulation-induced changes in glucose metabolism and neurotransmitter action as well as molecular connectivity. The toolbox offers various analysis approaches, including the General Linear Model (GLM), Independent Component Analysis (ICA) as well as molecular connectivity and covariance computation. It is optimized to handle fPET data that has been acquired using a bolus + constant infusion protocol with high temporal resolution (1–60 seconds), but other settings may be feasible.

[Visit the fPET Toolbox webpage](https://www.meduniwien.ac.at/neuroimaging/fPET.html)

---

## Topics and Tags
`#fPET` `#functionalPET` `#neuroimaging` `#MATLABToolbox`  
`#PETImaging` `#GLMAnalysis` `#ICAAnalysis` `#MolecularConnectivity`  
`#GlucoseMetabolism` `#NeurotransmitterAnalysis` `#BolusInfusion`  

---

## Authors and Affiliation
- Andreas Hahn
- Murray B. Reed
- Rupert Lanzenberger

Neuroimaging Labs, Department of Psychiatry and Psychotherapy,
Medical University of Vienna, Austria

## Key Features
Capture stimulation-induced changes in glucose metabolism as well as dopamine and serotonin synthesis.

Apply both hypothesis-driven (GLM) and data-driven (ICA) methods for analysis.

Compute individual-level molecular connectivity and group-level molecular covariance.

Supports a variety of imaging systems, radioligands, stimuli and species, providing flexibility for both task-based and connectivity-based PET studies.

## Citation
If you use the fPET Toolbox in your work, please cite the following paper:

__A Hahn et al. (2024) "A Unified Approach for Identifying PET-based Neuronal Activation and Molecular Connectivity with the functional PET toolbox" BioRxiv https://www.biorxiv.org/content/10.1101/2024.11.13.623377v1__


## Installation
Download the fPET Toolbox from GitHub.
Unzip the files.
Add the unzipped directory to your MATLAB path.

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
    
## Testing & Application
The fPET Toolbox has been rigorously tested in various experimental settings, including different

stimuli:
- visual
- motor
- Tetris
- working memory
- monetary incentive delay
- optogenetic

species:
- humans
- non-human primates
- rodents

scanners:
- GE Advance
- Siemens Biograph mMR 3T
- Siemens Biograph Vision 600 Edge
- Siemens Biograph Quadra
- Brain Biosciences CerePET
- Bruker small-animal PET insert for 7T ClinScan

and radioligands: 
- [¹⁸F]FDG
- 6-[¹⁸F]FDOPA
- [¹¹C]AMT

Our toolbox has been successfully used in numerous studies, demonstrating its reliability in analyzing stimulation-induced changes and connectivity measures.

## Support
We recommend reaching out to us before planning or conducting your fPET experiments. Our team has extensive experience collaborating with international labs and can assist with study design and analysis protocols.

## Contact
For any issues, bug reports, feature requests, or study design consultations, please contact the developers:

- Andreas Hahn: andreas.hahn@meduniwien.ac.at
- Murray B. Reed: murray.reed@meduniwien.ac.at


## Collaborations
We have successfully collaborated with various labs worldwide in Sweden, Finland, Norway, Germany, Australia, USA, Denmark and Spain, contributing to the field of fPET imaging. For example:

- [Stiernman et al. (2020)](https://www.pnas.org/doi/full/10.1073/pnas.2021913118)
- [Hahn et al. (2020)](https://elifesciences.org/articles/52443)
- [Godbersen et al. (2023)](https://elifesciences.org/articles/84683)
- [Haas, Bravo et al. (2024)](https://www.science.org/doi/10.1126/sciadv.adn2776)


__Feel free to reach out if you'd like to explore potential collaborations or need further guidance with your fPET studies.__