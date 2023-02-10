# 2022-23_ucl_mres_hernan_lab
bash, R, metagenomics, phylogenetic genomics

        #description
        file description:
        run* forloop for commands

        samples:

        143 samples: with the newest pipeline (r1 r2 and then combined (instead of trim and collapse since the short reads segment), with q20)

        37 samples: with newest pipeline (realgin and removal, q20 (instead of sergio's removed bam))

        scripts:
        preprocessing:
        
        1. 143 samples:
                sh: arraysub_143samples.sh & finalpipeline_143_q20_combined.sh
                output: answers/answers_143_withq20final/
                sh: forplotdata.sh & plotdatagenerate.sh
                output: tableforplot/allwithq20combined_143allqaforplot.txt #containing samplename At_percent Ps_percent unannotated Ps_atleast1read averagedepth
                R: rforbench_143.R & rforq5NM_143.R #visualization
        2. 37 samples:
                sh: arraysub_37samples.sh & finalpipeline_37_q20.sh
                output: answers/37samples/
                sh: forplotdata.sh & plotdatagenerate.sh
                output: /tableforplot/37samples_allqaforplot_withdepth.txt
                R: rforbench_143.R & rforq5NM_143.R #visualization

        check the correlation between merged reads and read molecular length (insert size) in each samples (143):
                sh: runtmreads.sh & tmreads.sh, averagereadslength.sh
                output: othertables/tmreads.txt, 4_mapping_to_A_theliana/insert_size.txt
                R: distmergedreads.R

        check strains number (143):
                sh: straincheck/straincheckforR.sh # generate initial table & runinR.R #conda activate R # calculte stats
                or: straincheck/straincheckfinal.sh & modified.sh # using awk (faster but more tmp files generated)
                sh: runstraincheck.sh #forloop
                R: straincheckimgs.R #visualization
        phylogeny:
                read2tree:
                        sh: nsortedandbamtofastq.sh & runnsortedandbamtofastq.sh #generate input fastq
                        output: read2treeinput/nsortedbam & /fastq
                        sh:  runr2tmulti.sh
                        output: r2toutputs/
                        sh: histallwith2ref1out_runr2t.sh & modernallallwith2ref1out_runr2t.sh          
                        sh: arraysubhistorical.sh & arraysubmodern.sh #forloop
                        sh: before_and_after_runr2t.sh #generate reference folder and merge all mappings
                        output: r2toutputs/r2tfinal
