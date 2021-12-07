#-------------------------------------------
#how I generated the fai index file for the ref fasta-s

 bwa index {reference in fasta format}    
 samtools faidx {reference in fasta format}

#--------------------------------------------
#filtering the bam files and marking duplicates
    java -jar /home/local/molbio/java/picard.jar MarkDuplicates \
       I={input bam file} \
        O={output bam file} \
        M={duplicate metrics .txt file}

java -Xmx50G -jar /home/local/molbio/java/picard.jar AddOrReplaceReadGroups \
    I=${workdir}bam/"${filename}"x.bam \
    O=${workdir}bam/"${filename}".bam \
    RGPL=illumina \
    CREATE_INDEX=True \
    RGID=vitis \
    RGLB=lib1 \
    RGPU=unit1 \
    RGSM=na
#-------------------------------------------
#haplotypecalling


for c in {input bam files}


    do
     
           gatk HaplotypeCaller -I {input bam file} -O {output vcf file} -R ${reference fasta}


    done

#-------------------------------------------
#creating the sorted bam file

        bwa mem  -U 20 -t 6  {reference} {input file in fasta.gz format} {the second file of the sample}   |
        samtools view -Sb -t {the fai index file} -   |
        samtools sort - >{output bam}  
        
#-------------------------------------------
#indexing the bam files

      samtools index {the sorted bam file}  {the bai index file, that goes int he same directory as the bam file itself}

#-------------------------------------------
#using etandem

     etandem -sequence sample_amplikon_region.fasta -minrepeat 3 -maxrepeat 10 -outfile output.etandem
        
