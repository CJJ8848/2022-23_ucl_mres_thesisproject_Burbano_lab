# 2022-23_ucl_mres_Burbano_lab
bash, R, metagenomics, phylogenetic

        
        file description:
        run* forloop for commands
        
        samples:

        143 samples: with the newest pipeline (r1 r2 and then combined collapse and r1r2 (after trim) (instead of trim and collapse since the short reads segment), with q20)
	#collapse_At.sam is from collapsed sai
	#r1r2_At.sam is merged from r1.sai and r2.sai
	#combined_At.sam is combined from the above two sam files


        37 samples: with newest pipeline (realgin and removal, q20 (instead of sergio's removed bam))

        scripts:
        Task1: preprocessing (conda dataprepython3.10):
                1. 143 samples:
                        sh: arraysub_143samples.sh & trimedpipeline_143_q20_combined_all.sh (all is ok, but you can run part1 and part2 separately as well)
	        	output: /jiajucui/trim143answers/
                        sh: forplotdata.sh & plotdatagenerate.sh
		        output: tableforplot/allwithq20combined_143allqaforplot.txt #containing samplename At_percent Ps_percent unannotated Ps_atleast1read averagedepth
		        R: rforbench_143.R & rforq5NM_143.R #visualization
                2. 37 samples:
                        sh: arraysub_37samples.sh & 2023final_37_q20.sh
	        	    arraysub_2Africans.sh & 2023_2Africans_q20.sh 
                        output: /jiajucui/answers2023_37HB/
		        sh: forplotdata.sh & plotdatagenerate.sh
		        output: /tableforplot/37samples_allqaforplot_withdepth.txt
		        R: rforbench_180.R & rforq5NMmerge_5.25.R #visualization
	
	        quality control: 
		        37 samples: wd 3_quality_control/ & sh 37collapsedqc.sh, arraysub_37samples.sh (two Africans manually fastqc) & output h37qc
		        143 samples: wd 3_quality_control/ & sh AR_trimns_trimqualities143samples.sh, arraysub_143samples.sh & output trimnsqs143 (three html including collapsed.gz, truncated pair 1 and 2)
		        output: /2_trimmed_merged/trimnstrimqualities143/
	        Adapterremoval and overrepresented seq trimming:
		        #quality control of 143 samples after adapterremoval collpase
		        #for three files of each sample (collapsed, truncated1 truncated2)
		        #fastqc for those files and then check one by one to collect the overrepresented seq for r1 r2 and collapsed
		        #perform adapterremoval again with --adapter-list filename
		        #Read one or more adapter sequences from a table. The first two columns (separated by whitespace) of each line in the file are expected to correspond to values passed to --adapter1 and --adapter2. In single-end mode, only column one is required. Lines starting with '#' are ignored. When multiple rows are found in the table, AdapterRemoval will try each adapter (pair), and select the best aligning adapters for each FASTQ read processed.
		        # the first column contains r1 and collapsed adapters
		        # the second column contains r2 and collapsed adapters
		        # when the two cols have different number of line, error will occur. I supply the missed tail lines in collumn1/2 with N
		        sh: arraysub_143samples.sh & secondadapterremovallist.sh
		        txt: all overrepresentedseq after first trim (no trimns and trimqualities at first): aftertrim143overrepresent_seq.txt & adapter list: overrepresented_143_adapterlist.txt
		        output: secondtrim143qc & 2_trimmed_merged/trim143
		
		        sh: arraysub_10samples.sh & AR_trimns_trimqualities10samples.sh for the 10 samples, do qc again and do specific triming of adapter again (bad mapdamage of At). #64 has an overrepresented seq hitted as truseq adapter, need additional removal with --adapter1 sh: /trimnsqs10/64rmadapter1.sh
		        output: trimnsqs10 & /2_trimmed_merged/trimnstrimqualities10/

	        check the correlation between merged reads and read molecular length (insert size) in each samples (143):
		        sh: runtmreads.sh & tmreads.sh, averagereadslength.sh
		        output: othertables/tmreads.txt, 4_mapping_to_A_theliana/insert_size.txt
		        R: distmergedreads.R
	

	        After filtration -> 17:
	        check strains number (17):
                        sh: straincheck/straincheckforR.sh # generate initial table & runinR.R #conda activate R # calculte stats
                        or: straincheck/straincheckfinal.sh & modified.sh # using awk (faster but more tmp files generated)
	        	sh: runstraincheck.sh #forloop
	        	R: straincheckimgs.R #visualization
		        output: tmp_in_out_commandline (old) and aftertrim_cl (new)
			#R input and output are contained in old_inputforR & outputfromR but not used (slower even produced less tmp files)
  	
                check mapdamge (17) (conda mapdamager4.1):
	        	wd: /SAN/ugi/plant_genom/jiajucui/phylogeny/phylogeny_snp/mapdamage/mapdamagemanual17samplesplot
	        	sh: mapdamagemanual.R & forloop.sh
	        	output: plots for pseudomonas to identify the two gray lines near CtoT and GtoA (from 5 end (left), using miscoorpration.txt given by mapDamge)

	

	 Task2: phylogeny:
                       1. read2tree (need to be run with r2ttry conda env (issue log in github)):
		        	sh: nsortedandbamtofastq.sh & runnsortedandbamtofastq.sh #generate input fastq
        	    		output: read2treeinput/nsortedbam & /fastq
		        	sh:  runr2tmulti.sh
			        output: r2toutputs/
			        sh: histallwith2ref1out_runr2t.sh & modernallallwith2ref1out_runr2t.sh 		sh: arraysubhistorical.sh & arraysubmodern.sh #forloop
			        sh: before_and_after_runr2t.sh #generate reference folder and merge all mappings
			        output: r2toutputs/r2tfinal
			
		        	r2tAt:
		        	wd:/SAN/ugi/plant_genom/jiajucui/phylogeny/phylogeny_read2tree/r2tAt/r2tAt
		        	sh: beforer2t.sh & 17samples_7ref_At.sh & afterr2t.sh
		        	output: outputtry/
			
		        	originfq.sh:
		        	sh: originfq.sh # choose 5 origin fq file (no mapped to pseudomonas ref) to infer the tree, look at the performance of read2tree in a unmapped raw fq
		        	output: r2tfinal
		        	
		        	#iqtree
		        	wd: r2toutputs/r2t25ref/iqtreeresult & iqtreeresultLG
		        	sh: r2tiqtree.sh
		        	output: iqtree MFP and iqtree LG 
		        2. genome_wide_snp (conda phylogene_snp):
			
		        	check tstv:
		        	wd:/SAN/ugi/plant_genom/jiajucui/phylogeny/phylogeny_snp/tstv/
		        	sh: forlooptstv71.sh & tstv71.sh #only tstv rate and number
		        	sh: plot71substitution.sh #using statsvcf (or manuallly /manually71/tstvnumbermanualvcf.R) #for all substitutions
			
		        	whole-genome snp matrix:
		        	wd: /SAN/ugi/plant_genom/jiajucui/phylogeny/phylogeny_snp
		        	#generate bam files
		        	sh: modern_bam.sh # generate onlymappedq20.bam files for modern samples 
		        	output: wd/bams
		        	#generate vcf
		        	sh: all_vcfs.sh #generate vcf and sort and index -t, arraysubmodern.sh #array sub for modern bam and vcf generation, forloopvcfs.sh #forloop to run vcf generation, arraysuballvcfs.sh # array sub for all vcfs
			            all_vcfs_withindelnofilter.sh #old one with indel no filter with qual>20
		        	output: wd/vcfs
		        	#merge vcfs and convert vcf to phy
		        	sh: ./v1/v1mergeandconvert.sh ./v2/v2mergeandconvert.sh # merge vcf and translate to phy and iqtree
		        	output: wd/phy/v1/v1merge72snp_filtered.vcf.gz, v1bialleliconly_72filtered.vcf.gz, v1bialleliconly_72filtered.min72.phy v2/v2mergesnp_filtered.vcf.gz,v2mergesnp_filtered.min82.phy 
		        	#VCF filtration version 1&2 check
		        	wd:/phylogeny_snp/phy/VCFfiltration/ # reported on 3.27 2023# R file vcfplot.R to draw the histograms and spreading of snp across the genome
			        sh: vcfplot.R #for all the plots but after remove 30 the next script is better and more clear
			        sh: sample71vcfplotpipe_for0.01.R # remove 31 and plot the spreading of SNP , give the core site and non core site, and calculate the core SNP matrix after CFML (the newest is VCFdistribution/sample70vcfplotpipe_for0.01.R locally)
			
		        	#iqtree
		        	sh: /phy/v1/v1iqtree.sh phy/v2/v2iqtree.sh #iqtree
		        	output: v1/v1iqtree v2/v2iqtree #v1.1 remove HB0863 as well
			
		        	#ClonalFrameML
		        	wd:/phylogeny_snp/tryclonalframeml/aftertrimnsqs_72bi
		        	sh: phytofastmanual.sh #convert phylip to fasta, qsubclonalframeml.sh #CFML
		        	output: strategy1/2 (threshold 1 / 0.9)
		        	sh: cfml_results.R # the data visualization code provided by CFML
		        	sh: qsubclonalframeml.sh  & v1.1/qsubclonalframeml_withallgenome.sh #the script to run CFML with the standard models
		        	output: std71/...
			
		        	#Bactdating
		        	#temporal signal
		        	wd:/phylogeny_snp/bactdatingafterCFML/
		        	sh: copy the output files of CFML to the directory and then run v1bactdating.R
		        	output: two png files about the dated tree and temporal test
		        	#model compare
		        	sh: Bactdating.sh
			
			        #tstv & mapdamage for 16 ancient samples
			        wd:/phylogeny_snp/tstv /phylogeny_snp/mapdamage
		        	sh: forlooptstv71.sh & 16mapdamage.sh & arraysub16mapdamage.sh 
		        	output: /phylogeny_snp/mapdamage/ /phylogeny_snp/tableforplot_tstv.txt 
			
